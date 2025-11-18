# ============================================================================
# KEC Routine Scheduler - Auto Deployment Script (Windows)
# ============================================================================
# This script automatically pulls code from GitHub and deploys the application
# Usage: .\deploy.ps1 [-Fresh] [-SkipFrontend] [-SkipBackend]
# ============================================================================

param(
    [switch]$Fresh,
    [switch]$SkipFrontend,
    [switch]$SkipBackend
)

# Configuration
$RepoUrl = "https://github.com/your-username/kec-routine-scheduler.git"  # CHANGE THIS
$DeployDir = "C:\inetpub\kec-routine"
$BackupDir = "C:\Backups\kec-routine"

# Colors for output
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Header($message) {
    Write-Host "`n========================================" -ForegroundColor Blue
    Write-Host $message -ForegroundColor Blue
    Write-Host "========================================`n" -ForegroundColor Blue
}

function Write-Success($message) {
    Write-Host "✓ $message" -ForegroundColor Green
}

function Write-Error($message) {
    Write-Host "✗ $message" -ForegroundColor Red
}

function Write-Warning($message) {
    Write-Host "⚠ $message" -ForegroundColor Yellow
}

function Write-Info($message) {
    Write-Host "ℹ $message" -ForegroundColor Cyan
}

# ============================================================================
# Pre-deployment Checks
# ============================================================================

Write-Header "Pre-deployment Checks"

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator"
    exit 1
}

# Check Python
try {
    $pythonVersion = python --version 2>&1
    Write-Success "Python detected: $pythonVersion"
} catch {
    Write-Error "Python not found. Please install Python 3.9 or higher"
    exit 1
}

# Check Node.js
try {
    $nodeVersion = node --version
    Write-Success "Node.js detected: $nodeVersion"
} catch {
    Write-Error "Node.js not found. Please install Node.js 18 or higher"
    exit 1
}

# Check Git
try {
    $gitVersion = git --version
    Write-Success "Git detected: $gitVersion"
} catch {
    Write-Error "Git not found. Please install Git"
    exit 1
}

# ============================================================================
# Backup Current Deployment
# ============================================================================

if ((Test-Path $DeployDir) -and (-not $Fresh)) {
    Write-Header "Creating Backup"
    
    $backupName = "kec-routine-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
    
    # Backup database
    if (Test-Path "$DeployDir\backend\kec_routine.db") {
        Write-Info "Backing up database..."
        Copy-Item "$DeployDir\backend\kec_routine.db" "$BackupDir\$backupName.db"
        Write-Success "Database backed up to $BackupDir\$backupName.db"
    }
    
    # Backup .env file
    if (Test-Path "$DeployDir\backend\.env") {
        Write-Info "Backing up .env file..."
        Copy-Item "$DeployDir\backend\.env" "$BackupDir\$backupName.env"
        Write-Success ".env file backed up"
    }
    
    Write-Success "Backup completed"
}

# ============================================================================
# Stop Running Services
# ============================================================================

Write-Header "Stopping Services"

# Stop backend process
Get-Process -Name "python" -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "*kec-routine*" } | Stop-Process -Force
Write-Success "Backend processes stopped"

# Stop node processes
Get-Process -Name "node" -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "*kec-routine*" } | Stop-Process -Force
Write-Success "Node processes stopped"

# ============================================================================
# Clone or Pull Repository
# ============================================================================

Write-Header "Fetching Latest Code"

if ($Fresh -and (Test-Path $DeployDir)) {
    Write-Warning "Fresh install requested. Removing existing directory..."
    Remove-Item -Path $DeployDir -Recurse -Force
}

if (-not (Test-Path $DeployDir)) {
    Write-Info "Cloning repository from $RepoUrl..."
    $parentDir = Split-Path $DeployDir -Parent
    New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
    git clone $RepoUrl $DeployDir
    Write-Success "Repository cloned"
} else {
    Write-Info "Pulling latest changes..."
    Set-Location $DeployDir
    git fetch origin
    git reset --hard origin/main
    git pull origin main
    Write-Success "Repository updated"
}

Set-Location $DeployDir

# ============================================================================
# Backend Deployment
# ============================================================================

if (-not $SkipBackend) {
    Write-Header "Deploying Backend"
    
    Set-Location "$DeployDir\backend"
    
    # Create virtual environment if not exists
    if (-not (Test-Path ".venv")) {
        Write-Info "Creating Python virtual environment..."
        python -m venv .venv
        Write-Success "Virtual environment created"
    }
    
    # Activate virtual environment and install dependencies
    Write-Info "Installing Python dependencies..."
    & ".venv\Scripts\Activate.ps1"
    pip install --upgrade pip
    pip install -r ..\requirements.txt
    Write-Success "Python dependencies installed"
    
    # Restore .env file if backed up
    if (Test-Path "$BackupDir\$backupName.env") {
        Write-Info "Restoring .env file..."
        Copy-Item "$BackupDir\$backupName.env" ".env"
        Write-Success ".env file restored"
    } elseif (-not (Test-Path ".env")) {
        Write-Warning ".env file not found. Creating template..."
        @"
DATABASE_URL=sqlite:///./kec_routine.db
SECRET_KEY=change-this-to-a-random-secret-key
CORS_ORIGINS=http://localhost:3000,https://your-domain.com
DEBUG=False
HOST=0.0.0.0
PORT=8000
"@ | Out-File -FilePath ".env" -Encoding UTF8
        Write-Warning "Please edit .env file with your configuration"
    }
    
    # Restore database if backed up
    if (Test-Path "$BackupDir\$backupName.db") {
        Write-Info "Restoring database..."
        Copy-Item "$BackupDir\$backupName.db" "kec_routine.db"
        Write-Success "Database restored"
    }
    
    Write-Success "Backend deployment completed"
    
    deactivate
}

# ============================================================================
# Frontend Deployment
# ============================================================================

if (-not $SkipFrontend) {
    Write-Header "Deploying Frontend"
    
    Set-Location "$DeployDir\frontend"
    
    # Install Node.js dependencies
    Write-Info "Installing Node.js dependencies..."
    npm install --production=false
    Write-Success "Node.js dependencies installed"
    
    # Build frontend
    Write-Info "Building frontend for production..."
    npm run build
    Write-Success "Frontend built successfully"
    
    Write-Success "Frontend deployment completed"
}

# ============================================================================
# Student View Server Deployment
# ============================================================================

Write-Header "Deploying Student View Server"

Set-Location "$DeployDir\backend"

if (-not (Test-Path "package.json")) {
    Write-Info "Creating package.json for student server..."
    @"
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
"@ | Out-File -FilePath "package.json" -Encoding UTF8
}

Write-Info "Installing student server dependencies..."
npm install
Write-Success "Student server dependencies installed"

# ============================================================================
# Start Services
# ============================================================================

Write-Header "Starting Services"

# Start backend in new window
Write-Info "Starting backend service..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$DeployDir\backend'; .venv\Scripts\Activate.ps1; python run.py" -WindowStyle Minimized
Write-Success "Backend service started"

# Wait for backend to start
Start-Sleep -Seconds 3

# Start student server in new window
Write-Info "Starting student view server..."
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$DeployDir\backend'; node static_server.js" -WindowStyle Minimized
Write-Success "Student view server started"

# ============================================================================
# Post-deployment Checks
# ============================================================================

Write-Header "Post-deployment Checks"

Start-Sleep -Seconds 3

# Check backend
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/api/docs" -UseBasicParsing -ErrorAction SilentlyContinue
    if ($response.StatusCode -eq 200) {
        Write-Success "Backend API is responding"
    }
} catch {
    Write-Warning "Backend API is not responding on port 8000"
}

# Check student server
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3001" -UseBasicParsing -ErrorAction SilentlyContinue
    Write-Success "Student server is responding"
} catch {
    Write-Warning "Student server is not responding on port 3001"
}

# ============================================================================
# Cleanup Old Backups
# ============================================================================

Write-Header "Cleanup"

if (Test-Path $BackupDir) {
    Write-Info "Removing backups older than 30 days..."
    Get-ChildItem -Path $BackupDir -Filter "kec-routine-*.db" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item
    Get-ChildItem -Path $BackupDir -Filter "kec-routine-*.env" | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-30) } | Remove-Item
    Write-Success "Old backups cleaned"
}

# ============================================================================
# Deployment Summary
# ============================================================================

Write-Header "Deployment Summary"

Write-Host "Deployment completed successfully!`n" -ForegroundColor Green

Write-Host "Access URLs:" -ForegroundColor Blue
Write-Host "  • Backend API: http://localhost:8000/api/docs"
Write-Host "  • Student View: http://localhost:3001"
Write-Host "  • Admin Panel: Serve frontend/dist folder with IIS or another web server"

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "  1. Update .env file with your configuration: $DeployDir\backend\.env"
Write-Host "  2. Configure IIS to serve the frontend/dist folder"
Write-Host "  3. Set up reverse proxy in IIS for API requests"
Write-Host "  4. Configure Windows Firewall to allow ports 80, 443, 8000, 3001"
Write-Host "  5. Consider using NSSM to run backend and student server as Windows services"

Write-Host "`nTo install as Windows services (using NSSM):" -ForegroundColor Cyan
Write-Host "  nssm install kec-backend `"$DeployDir\backend\.venv\Scripts\python.exe`" `"$DeployDir\backend\run.py`""
Write-Host "  nssm install kec-student `"C:\Program Files\nodejs\node.exe`" `"$DeployDir\backend\static_server.js`""
Write-Host "  nssm start kec-backend"
Write-Host "  nssm start kec-student"

Write-Host "`nHappy deploying! 🚀`n" -ForegroundColor Green
