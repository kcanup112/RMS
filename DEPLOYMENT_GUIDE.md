# Auto Deployment Guide

This guide explains how to use the automated deployment scripts to deploy KEC Routine Scheduler on your server.

## Available Scripts

- **`deploy.sh`** - Linux/Unix deployment script (Ubuntu, Debian, CentOS)
- **`deploy.ps1`** - Windows deployment script

---

## Linux/Unix Deployment

### Prerequisites

1. **Ubuntu 20.04+, Debian 11+, or CentOS 8+**
2. **Root or sudo access**
3. **Internet connection**

### First Time Setup

1. **Update GitHub repository URL in the script:**
   ```bash
   nano deploy.sh
   # Change: REPO_URL="https://github.com/your-username/kec-routine-scheduler.git"
   ```

2. **Make script executable:**
   ```bash
   chmod +x deploy.sh
   ```

3. **Run fresh installation:**
   ```bash
   sudo ./deploy.sh --fresh
   ```

### Regular Updates

Simply run the script to pull latest code and redeploy:

```bash
sudo ./deploy.sh
```

### Script Options

- `--fresh` - Fresh installation (removes existing deployment)
- `--skip-frontend` - Skip frontend build (faster deployment)
- `--skip-backend` - Skip backend deployment

**Examples:**

```bash
# Full deployment with fresh install
sudo ./deploy.sh --fresh

# Deploy only backend changes
sudo ./deploy.sh --skip-frontend

# Deploy only frontend changes
sudo ./deploy.sh --skip-backend
```

### What the Script Does

1. ✅ Checks system requirements (Python, Node.js, Git)
2. ✅ Creates backup of database and .env file
3. ✅ Stops running services
4. ✅ Pulls latest code from GitHub
5. ✅ Installs Python dependencies in virtual environment
6. ✅ Installs Node.js dependencies
7. ✅ Builds frontend for production
8. ✅ Configures systemd services
9. ✅ Configures Nginx reverse proxy
10. ✅ Starts all services
11. ✅ Verifies deployment
12. ✅ Cleans up old backups

### Post-Deployment

After first deployment, complete these steps:

1. **Edit environment file:**
   ```bash
   sudo nano /var/www/kec-routine/backend/.env
   ```
   Update:
   - `SECRET_KEY` - Generate a random secret key
   - `CORS_ORIGINS` - Add your domain

2. **Update Nginx server name:**
   ```bash
   sudo nano /etc/nginx/sites-available/kec-routine
   ```
   Change `server_name _` to your domain

3. **Install SSL certificate:**
   ```bash
   sudo certbot --nginx -d your-domain.com
   ```

4. **Configure firewall:**
   ```bash
   sudo ufw allow 22/tcp    # SSH
   sudo ufw allow 80/tcp    # HTTP
   sudo ufw allow 443/tcp   # HTTPS
   sudo ufw enable
   ```

### Monitoring Services

**Check service status:**
```bash
sudo systemctl status kec-backend
sudo systemctl status kec-student
```

**View logs:**
```bash
# Backend logs
sudo journalctl -u kec-backend -f

# Student server logs
sudo journalctl -u kec-student -f

# All logs
sudo journalctl -u kec-backend -u kec-student -f
```

**Restart services:**
```bash
sudo systemctl restart kec-backend
sudo systemctl restart kec-student
sudo systemctl reload nginx
```

### Troubleshooting

**npm command not found:**
```bash
# Install Node.js with npm
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version
npm --version

# Update PATH and run script again
source ~/.bashrc
sudo ./deploy.sh
```

**Services not starting:**
```bash
# Check service status
sudo systemctl status kec-backend

# View detailed logs
sudo journalctl -u kec-backend -n 50 --no-pager
```

**Port conflicts:**
```bash
# Check what's using port 8000
sudo lsof -i :8000

# Check what's using port 3001
sudo lsof -i :3001
```

**Nginx errors:**
```bash
# Test Nginx configuration
sudo nginx -t

# Check Nginx error logs
sudo tail -f /var/log/nginx/error.log
```

---

## Windows Deployment

### Prerequisites

1. **Windows Server 2019+ or Windows 10+**
2. **Administrator privileges**
3. **Python 3.9+** - [Download](https://www.python.org/downloads/)
4. **Node.js 18+** - [Download](https://nodejs.org/)
5. **Git** - [Download](https://git-scm.com/download/win)

### First Time Setup

1. **Update GitHub repository URL:**
   - Open `deploy.ps1` in notepad
   - Change: `$RepoUrl = "https://github.com/your-username/kec-routine-scheduler.git"`

2. **Run PowerShell as Administrator**

3. **Enable script execution:**
   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

4. **Run fresh installation:**
   ```powershell
   .\deploy.ps1 -Fresh
   ```

### Regular Updates

```powershell
.\deploy.ps1
```

### Script Options

- `-Fresh` - Fresh installation
- `-SkipFrontend` - Skip frontend build
- `-SkipBackend` - Skip backend deployment

**Examples:**

```powershell
# Full deployment with fresh install
.\deploy.ps1 -Fresh

# Deploy only backend
.\deploy.ps1 -SkipFrontend

# Deploy only frontend
.\deploy.ps1 -SkipBackend
```

### Install as Windows Services (Recommended)

Use NSSM (Non-Sucking Service Manager) to run as services:

1. **Download NSSM:**
   - Download from: https://nssm.cc/download
   - Extract to `C:\nssm`

2. **Install backend service:**
   ```powershell
   C:\nssm\nssm.exe install kec-backend "C:\inetpub\kec-routine\backend\.venv\Scripts\python.exe" "C:\inetpub\kec-routine\backend\run.py"
   C:\nssm\nssm.exe set kec-backend AppDirectory "C:\inetpub\kec-routine\backend"
   C:\nssm\nssm.exe start kec-backend
   ```

3. **Install student server service:**
   ```powershell
   C:\nssm\nssm.exe install kec-student "C:\Program Files\nodejs\node.exe" "C:\inetpub\kec-routine\backend\static_server.js"
   C:\nssm\nssm.exe set kec-student AppDirectory "C:\inetpub\kec-routine\backend"
   C:\nssm\nssm.exe start kec-student
   ```

### Configure IIS (Optional)

1. Install IIS with URL Rewrite and ARR modules
2. Create website pointing to `C:\inetpub\kec-routine\frontend\dist`
3. Configure reverse proxy for `/api` to `http://localhost:8000`
4. Configure reverse proxy for `/student` to `http://localhost:3001`

### Monitoring

**Check service status:**
```powershell
Get-Service kec-backend, kec-student
```

**View running processes:**
```powershell
Get-Process python, node
```

**Stop services:**
```powershell
Stop-Service kec-backend
Stop-Service kec-student
```

**Start services:**
```powershell
Start-Service kec-backend
Start-Service kec-student
```

---

## Manual Deployment (Without Scripts)

If you prefer manual deployment:

### Linux

```bash
# 1. Clone repository
git clone https://github.com/your-username/kec-routine-scheduler.git
cd kec-routine-scheduler

# 2. Backend setup
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r ../requirements.txt

# 3. Frontend setup
cd ../frontend
npm install
npm run build

# 4. Student server setup
cd ../backend
npm install

# 5. Start services
# Terminal 1: Backend
cd backend
source .venv/bin/activate
python run.py

# Terminal 2: Student server
cd backend
node static_server.js
```

### Windows

```powershell
# 1. Clone repository
git clone https://github.com/your-username/kec-routine-scheduler.git
cd kec-routine-scheduler

# 2. Backend setup
cd backend
python -m venv .venv
.venv\Scripts\Activate.ps1
pip install -r ..\requirements.txt

# 3. Frontend setup
cd ..\frontend
npm install
npm run build

# 4. Student server setup
cd ..\backend
npm install

# 5. Start services (in separate terminals)
# Terminal 1: Backend
cd backend
.venv\Scripts\Activate.ps1
python run.py

# Terminal 2: Student server
cd backend
node static_server.js
```

---

## Scheduled Auto-Updates

### Linux (Cron)

Add to crontab for automatic daily updates at 2 AM:

```bash
sudo crontab -e
```

Add line:
```
0 2 * * * /var/www/kec-routine/deploy.sh >> /var/log/kec-deploy.log 2>&1
```

### Windows (Task Scheduler)

1. Open Task Scheduler
2. Create Basic Task
3. Set trigger (e.g., Daily at 2:00 AM)
4. Action: Start a program
5. Program: `powershell.exe`
6. Arguments: `-File C:\inetpub\kec-routine\deploy.ps1`
7. Run with highest privileges

---

## Backup and Restore

### Backups are Automatic

The deployment scripts automatically backup:
- Database (`kec_routine.db`)
- Environment file (`.env`)

**Backup location:**
- Linux: `/var/backups/kec-routine/`
- Windows: `C:\Backups\kec-routine\`

### Manual Backup

```bash
# Linux
sudo sqlite3 /var/www/kec-routine/backend/kec_routine.db ".backup '/path/to/backup.db'"

# Windows
Copy-Item "C:\inetpub\kec-routine\backend\kec_routine.db" "C:\Backups\backup.db"
```

### Restore from Backup

```bash
# Linux
sudo cp /var/backups/kec-routine/kec-routine-YYYYMMDD-HHMMSS.db /var/www/kec-routine/backend/kec_routine.db
sudo systemctl restart kec-backend

# Windows
Copy-Item "C:\Backups\kec-routine\kec-routine-YYYYMMDD-HHMMSS.db" "C:\inetpub\kec-routine\backend\kec_routine.db"
Restart-Service kec-backend
```

---

## Support

For issues or questions:

1. Check logs for error messages
2. Verify all prerequisites are installed
3. Ensure correct permissions on files/folders
4. Check firewall settings
5. Verify database file exists and is readable

Happy deploying! 🚀
