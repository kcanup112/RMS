#!/bin/bash

# ============================================================================
# KEC Routine Scheduler - Auto Deployment Script
# ============================================================================
# This script automatically pulls code from GitHub and deploys the application
# Usage: ./deploy.sh [--fresh] [--skip-frontend] [--skip-backend]
#
# If npm is not found, install Node.js first:
#   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
#   sudo apt-get install -y nodejs
#   source ~/.bashrc
# ============================================================================

set -e  # Exit on any error

# Update PATH to include common npm locations
export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.npm-global/bin:$PATH"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/your-username/kec-routine-scheduler.git"  # CHANGE THIS
DEPLOY_DIR="/var/www/kec-routine"
BACKUP_DIR="/var/backups/kec-routine"
PYTHON_VERSION="3.9"
NODE_VERSION="18"

# Service names
BACKEND_SERVICE="kec-backend"
STUDENT_SERVICE="kec-student"

# Parse command line arguments
FRESH_INSTALL=false
SKIP_FRONTEND=false
SKIP_BACKEND=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --fresh)
            FRESH_INSTALL=true
            shift
            ;;
        --skip-frontend)
            SKIP_FRONTEND=true
            shift
            ;;
        --skip-backend)
            SKIP_BACKEND=true
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root or with sudo"
        exit 1
    fi
}

# ============================================================================
# Pre-deployment Checks
# ============================================================================

print_header "Pre-deployment Checks"

# Check if running as root
check_root

# Check Python version
if command_exists python3; then
    CURRENT_PYTHON=$(python3 --version | cut -d ' ' -f 2 | cut -d '.' -f 1,2)
    print_success "Python $CURRENT_PYTHON detected"
else
    print_error "Python 3 not found. Please install Python $PYTHON_VERSION or higher"
    exit 1
fi

# Check Node.js version
if command_exists node; then
    CURRENT_NODE=$(node --version | cut -d 'v' -f 2 | cut -d '.' -f 1)
    print_success "Node.js v$CURRENT_NODE detected"
else
    print_error "Node.js not found. Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
    if command_exists node; then
        print_success "Node.js installed successfully"
    else
        print_error "Failed to install Node.js. Please install manually"
        exit 1
    fi
fi

# Check npm
if command_exists npm; then
    NPM_VERSION=$(npm --version)
    print_success "npm v$NPM_VERSION detected"
else
    print_error "npm not found. Please install npm"
    exit 1
fi

# Check Git
if ! command_exists git; then
    print_error "Git not found. Installing..."
    apt-get update && apt-get install -y git
fi

# Check systemd
if ! command_exists systemctl; then
    print_warning "systemd not found. Services will need to be managed manually"
fi

# ============================================================================
# Backup Current Deployment
# ============================================================================

if [[ -d "$DEPLOY_DIR" ]] && [[ "$FRESH_INSTALL" = false ]]; then
    print_header "Creating Backup"
    
    BACKUP_NAME="kec-routine-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    # Backup database
    if [[ -f "$DEPLOY_DIR/backend/kec_routine.db" ]]; then
        print_info "Backing up database..."
        cp "$DEPLOY_DIR/backend/kec_routine.db" "$BACKUP_DIR/$BACKUP_NAME.db"
        print_success "Database backed up to $BACKUP_DIR/$BACKUP_NAME.db"
    fi
    
    # Backup .env file
    if [[ -f "$DEPLOY_DIR/backend/.env" ]]; then
        print_info "Backing up .env file..."
        cp "$DEPLOY_DIR/backend/.env" "$BACKUP_DIR/$BACKUP_NAME.env"
        print_success ".env file backed up"
    fi
    
    print_success "Backup completed"
fi

# ============================================================================
# Stop Running Services
# ============================================================================

print_header "Stopping Services"

if command_exists systemctl; then
    if systemctl is-active --quiet "$BACKEND_SERVICE"; then
        print_info "Stopping $BACKEND_SERVICE..."
        systemctl stop "$BACKEND_SERVICE" || true
        print_success "$BACKEND_SERVICE stopped"
    fi
    
    if systemctl is-active --quiet "$STUDENT_SERVICE"; then
        print_info "Stopping $STUDENT_SERVICE..."
        systemctl stop "$STUDENT_SERVICE" || true
        print_success "$STUDENT_SERVICE stopped"
    fi
elif command_exists pm2; then
    print_info "Stopping PM2 processes..."
    pm2 stop all || true
    print_success "PM2 processes stopped"
fi

# ============================================================================
# Clone or Pull Repository
# ============================================================================

print_header "Fetching Latest Code"

if [[ "$FRESH_INSTALL" = true ]] && [[ -d "$DEPLOY_DIR" ]]; then
    print_warning "Fresh install requested. Removing existing directory..."
    rm -rf "$DEPLOY_DIR"
fi

if [[ ! -d "$DEPLOY_DIR" ]]; then
    print_info "Cloning repository from $REPO_URL..."
    mkdir -p "$(dirname "$DEPLOY_DIR")"
    git clone "$REPO_URL" "$DEPLOY_DIR"
    print_success "Repository cloned"
else
    print_info "Pulling latest changes..."
    cd "$DEPLOY_DIR"
    git fetch origin
    git reset --hard origin/main
    git pull origin main
    print_success "Repository updated"
fi

cd "$DEPLOY_DIR"

# ============================================================================
# Backend Deployment
# ============================================================================

if [[ "$SKIP_BACKEND" = false ]]; then
    print_header "Deploying Backend"
    
    cd "$DEPLOY_DIR/backend"
    
    # Create virtual environment if not exists
    if [[ ! -d ".venv" ]]; then
        print_info "Creating Python virtual environment..."
        python3 -m venv .venv
        print_success "Virtual environment created"
    fi
    
    # Activate virtual environment
    source .venv/bin/activate
    
    # Upgrade pip
    print_info "Upgrading pip..."
    pip install --upgrade pip
    
    # Install dependencies
    print_info "Installing Python dependencies..."
    pip install -r ../requirements.txt
    print_success "Python dependencies installed"
    
    # Restore .env file if backed up
    if [[ -f "$BACKUP_DIR/$BACKUP_NAME.env" ]]; then
        print_info "Restoring .env file..."
        cp "$BACKUP_DIR/$BACKUP_NAME.env" .env
        print_success ".env file restored"
    elif [[ ! -f ".env" ]]; then
        print_warning ".env file not found. Creating template..."
        cat > .env << 'EOF'
DATABASE_URL=sqlite:///./kec_routine.db
SECRET_KEY=change-this-to-a-random-secret-key
CORS_ORIGINS=http://localhost:3000,https://your-domain.com
DEBUG=False
HOST=0.0.0.0
PORT=8000
EOF
        print_warning "Please edit .env file with your configuration"
    fi
    
    # Restore database if backed up
    if [[ -f "$BACKUP_DIR/$BACKUP_NAME.db" ]]; then
        print_info "Restoring database..."
        cp "$BACKUP_DIR/$BACKUP_NAME.db" kec_routine.db
        print_success "Database restored"
    fi
    
    # Set proper permissions
    chown -R www-data:www-data "$DEPLOY_DIR/backend"
    chmod 600 .env
    
    print_success "Backend deployment completed"
    
    deactivate
fi

# ============================================================================
# Frontend Deployment
# ============================================================================

if [[ "$SKIP_FRONTEND" = false ]]; then
    print_header "Deploying Frontend"
    
    cd "$DEPLOY_DIR/frontend"
    
    # Install Node.js dependencies
    print_info "Installing Node.js dependencies..."
    npm install --production=false
    print_success "Node.js dependencies installed"
    
    # Build frontend
    print_info "Building frontend for production..."
    npm run build
    print_success "Frontend built successfully"
    
    # Set proper permissions
    chown -R www-data:www-data "$DEPLOY_DIR/frontend"
    
    print_success "Frontend deployment completed"
fi

# ============================================================================
# Student View Server Deployment
# ============================================================================

print_header "Deploying Student View Server"

cd "$DEPLOY_DIR/backend"

if [[ ! -f "package.json" ]]; then
    print_info "Creating package.json for student server..."
    cat > package.json << 'EOF'
{
  "name": "kec-routine-student-server",
  "version": "1.0.0",
  "description": "Static server for student routine view",
  "main": "static_server.js",
  "scripts": {
    "start": "node static_server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
EOF
fi

print_info "Installing student server dependencies..."
npm install
print_success "Student server dependencies installed"

# ============================================================================
# Configure Systemd Services
# ============================================================================

if command_exists systemctl; then
    print_header "Configuring Systemd Services"
    
    # Backend service
    print_info "Creating backend service..."
    cat > /etc/systemd/system/$BACKEND_SERVICE.service << EOF
[Unit]
Description=KEC Routine Scheduler Backend
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=$DEPLOY_DIR/backend
Environment="PATH=$DEPLOY_DIR/backend/.venv/bin"
ExecStart=$DEPLOY_DIR/backend/.venv/bin/python run.py
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
    
    # Student server service
    print_info "Creating student server service..."
    cat > /etc/systemd/system/$STUDENT_SERVICE.service << EOF
[Unit]
Description=KEC Routine Student View Server
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=$DEPLOY_DIR/backend
ExecStart=/usr/bin/node static_server.js
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
    
    # Reload systemd
    print_info "Reloading systemd daemon..."
    systemctl daemon-reload
    
    # Enable services
    print_info "Enabling services..."
    systemctl enable $BACKEND_SERVICE
    systemctl enable $STUDENT_SERVICE
    
    print_success "Systemd services configured"
fi

# ============================================================================
# Configure Nginx (if installed)
# ============================================================================

if command_exists nginx; then
    print_header "Configuring Nginx"
    
    NGINX_CONF="/etc/nginx/sites-available/kec-routine"
    
    if [[ ! -f "$NGINX_CONF" ]]; then
        print_info "Creating Nginx configuration..."
        cat > "$NGINX_CONF" << 'EOF'
server {
    listen 80;
    server_name _;  # Change this to your domain

    # Admin Panel (Frontend)
    location / {
        root /var/www/kec-routine/frontend/dist;
        try_files $uri $uri/ /index.html;
        
        # Cache static assets
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
            expires 1y;
            add_header Cache-Control "public, immutable";
        }
    }

    # Backend API
    location /api {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    # Student View
    location /student {
        proxy_pass http://127.0.0.1:3001;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/json application/javascript;
}
EOF
        
        # Enable site
        ln -sf "$NGINX_CONF" /etc/nginx/sites-enabled/kec-routine
        
        # Test Nginx configuration
        if nginx -t; then
            print_success "Nginx configuration created"
        else
            print_error "Nginx configuration has errors"
        fi
    else
        print_info "Nginx configuration already exists at $NGINX_CONF"
    fi
fi

# ============================================================================
# Start Services
# ============================================================================

print_header "Starting Services"

if command_exists systemctl; then
    print_info "Starting $BACKEND_SERVICE..."
    systemctl start $BACKEND_SERVICE
    
    if systemctl is-active --quiet $BACKEND_SERVICE; then
        print_success "$BACKEND_SERVICE started successfully"
    else
        print_error "$BACKEND_SERVICE failed to start"
        systemctl status $BACKEND_SERVICE --no-pager
    fi
    
    print_info "Starting $STUDENT_SERVICE..."
    systemctl start $STUDENT_SERVICE
    
    if systemctl is-active --quiet $STUDENT_SERVICE; then
        print_success "$STUDENT_SERVICE started successfully"
    else
        print_error "$STUDENT_SERVICE failed to start"
        systemctl status $STUDENT_SERVICE --no-pager
    fi
    
    # Reload Nginx
    if command_exists nginx; then
        print_info "Reloading Nginx..."
        systemctl reload nginx
        print_success "Nginx reloaded"
    fi
elif command_exists pm2; then
    print_info "Starting services with PM2..."
    cd "$DEPLOY_DIR"
    
    # Create PM2 ecosystem file if not exists
    if [[ ! -f "ecosystem.config.js" ]]; then
        cat > ecosystem.config.js << EOF
module.exports = {
  apps: [
    {
      name: 'kec-backend',
      script: 'run.py',
      cwd: '$DEPLOY_DIR/backend',
      interpreter: '$DEPLOY_DIR/backend/.venv/bin/python',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'kec-student',
      script: 'static_server.js',
      cwd: '$DEPLOY_DIR/backend',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '500M',
      env: {
        NODE_ENV: 'production',
        PORT: 3001
      }
    }
  ]
}
EOF
    fi
    
    pm2 start ecosystem.config.js
    pm2 save
    print_success "Services started with PM2"
fi

# ============================================================================
# Post-deployment Checks
# ============================================================================

print_header "Post-deployment Checks"

sleep 3  # Wait for services to start

# Check backend
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/api/docs | grep -q "200"; then
    print_success "Backend API is responding"
else
    print_warning "Backend API is not responding on port 8000"
fi

# Check student server
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3001 | grep -q "200\|404"; then
    print_success "Student server is responding"
else
    print_warning "Student server is not responding on port 3001"
fi

# ============================================================================
# Cleanup Old Backups
# ============================================================================

print_header "Cleanup"

if [[ -d "$BACKUP_DIR" ]]; then
    print_info "Removing backups older than 30 days..."
    find "$BACKUP_DIR" -name "kec-routine-*.db" -mtime +30 -delete
    find "$BACKUP_DIR" -name "kec-routine-*.env" -mtime +30 -delete
    print_success "Old backups cleaned"
fi

# ============================================================================
# Deployment Summary
# ============================================================================

print_header "Deployment Summary"

echo -e "${GREEN}Deployment completed successfully!${NC}\n"

echo -e "${BLUE}Service Status:${NC}"
if command_exists systemctl; then
    systemctl status $BACKEND_SERVICE --no-pager | head -n 3
    systemctl status $STUDENT_SERVICE --no-pager | head -n 3
fi

echo -e "\n${BLUE}Access URLs:${NC}"
echo -e "  • Backend API: http://localhost:8000/api/docs"
echo -e "  • Student View: http://localhost:3001"
echo -e "  • Admin Panel: http://localhost (if Nginx is configured)"

echo -e "\n${BLUE}Logs:${NC}"
if command_exists systemctl; then
    echo -e "  • Backend: journalctl -u $BACKEND_SERVICE -f"
    echo -e "  • Student: journalctl -u $STUDENT_SERVICE -f"
elif command_exists pm2; then
    echo -e "  • All services: pm2 logs"
fi

echo -e "\n${BLUE}Useful Commands:${NC}"
if command_exists systemctl; then
    echo -e "  • Restart backend: systemctl restart $BACKEND_SERVICE"
    echo -e "  • Restart student: systemctl restart $STUDENT_SERVICE"
    echo -e "  • View logs: journalctl -u $BACKEND_SERVICE -f"
elif command_exists pm2; then
    echo -e "  • Restart all: pm2 restart all"
    echo -e "  • View logs: pm2 logs"
fi

echo -e "\n${YELLOW}Next Steps:${NC}"
echo -e "  1. Update .env file with your configuration: $DEPLOY_DIR/backend/.env"
echo -e "  2. Update Nginx server_name with your domain: /etc/nginx/sites-available/kec-routine"
echo -e "  3. Set up SSL certificate: certbot --nginx -d your-domain.com"
echo -e "  4. Configure firewall: ufw allow 80/tcp && ufw allow 443/tcp"

echo -e "\n${GREEN}Happy deploying! 🚀${NC}\n"
