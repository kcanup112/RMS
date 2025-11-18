# PowerShell script to create complete deployment package
# Run this from the root directory of the project

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "KEC Routine Scheduler - Deployment Builder" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ErrorActionPreference = "Stop"
$rootDir = Get-Location
$deployDir = Join-Path $rootDir "deployment"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$packageName = "KEC_Routine_Scheduler_v1.0_$timestamp"
$packageDir = Join-Path $deployDir $packageName

# Clean up old deployment folder
if (Test-Path $deployDir) {
    Write-Host "Cleaning up old deployment folder..." -ForegroundColor Yellow
    Remove-Item -Path $deployDir -Recurse -Force
}

# Create deployment directory structure
Write-Host "Creating deployment directory structure..." -ForegroundColor Green
New-Item -ItemType Directory -Path $packageDir -Force | Out-Null
New-Item -ItemType Directory -Path "$packageDir\Backend" -Force | Out-Null
New-Item -ItemType Directory -Path "$packageDir\Frontend" -Force | Out-Null

# ===== BUILD BACKEND =====
Write-Host ""
Write-Host "===== Building Backend Executable =====" -ForegroundColor Cyan
Set-Location "$rootDir\backend"

# Check if virtual environment exists
if (Test-Path ".venv") {
    Write-Host "Activating virtual environment..." -ForegroundColor Yellow
    & ".venv\Scripts\Activate.ps1"
    
    # Install build dependencies
    Write-Host "Installing build dependencies..." -ForegroundColor Yellow
    pip install -q pyinstaller==6.3.0
    
    # Build executable
    Write-Host "Building backend executable (this may take a few minutes)..." -ForegroundColor Yellow
    python build_exe.py
    
    if (Test-Path "dist\KEC_Routine_Backend") {
        Write-Host "Backend build successful!" -ForegroundColor Green
        
        # Copy backend files
        Write-Host "Copying backend files to deployment package..." -ForegroundColor Yellow
        Copy-Item -Path "dist\KEC_Routine_Backend\*" -Destination "$packageDir\Backend" -Recurse -Force
        
        # Ensure database is included
        if (Test-Path "kec_routine.db") {
            Copy-Item -Path "kec_routine.db" -Destination "$packageDir\Backend" -Force
        }
    } else {
        Write-Host "ERROR: Backend build failed!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "ERROR: Virtual environment not found! Please run setup first." -ForegroundColor Red
    exit 1
}

# ===== BUILD FRONTEND =====
Write-Host ""
Write-Host "===== Building Frontend =====" -ForegroundColor Cyan
Set-Location "$rootDir\frontend"

# Check if node_modules exists
if (Test-Path "node_modules") {
    Write-Host "Building production frontend..." -ForegroundColor Yellow
    npm run build
    
    if (Test-Path "dist") {
        Write-Host "Frontend build successful!" -ForegroundColor Green
        
        # Copy frontend files
        Write-Host "Copying frontend files to deployment package..." -ForegroundColor Yellow
        Copy-Item -Path "dist\*" -Destination "$packageDir\Frontend" -Recurse -Force
    } else {
        Write-Host "ERROR: Frontend build failed!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "ERROR: node_modules not found! Run 'npm install' first." -ForegroundColor Red
    exit 1
}

# ===== CREATE STARTUP SCRIPTS =====
Write-Host ""
Write-Host "===== Creating Startup Scripts =====" -ForegroundColor Cyan
Set-Location $packageDir

# START_BACKEND.bat
@"
@echo off
echo ========================================
echo KEC Routine Scheduler - Backend Server
echo ========================================
echo.
echo Starting backend server...
echo API will be available at: http://localhost:8000
echo.

cd Backend
start "KEC Backend Server" KEC_Routine_Backend.exe

echo.
echo Backend server started in a new window.
echo Press any key to close this window...
pause > nul
"@ | Out-File -FilePath "START_BACKEND.bat" -Encoding ASCII

# START_FRONTEND.bat
@"
@echo off
echo =========================================
echo KEC Routine Scheduler - Frontend Server
echo =========================================
echo.
echo Starting frontend server...
echo Application will be available at: http://localhost:3000
echo.

cd Frontend
echo Starting simple HTTP server...
python -m http.server 3000

pause
"@ | Out-File -FilePath "START_FRONTEND.bat" -Encoding ASCII

# START_ALL.bat
@"
@echo off
echo ========================================
echo KEC Routine Scheduler - Full Stack
echo ========================================
echo.
echo Starting backend and frontend servers...
echo.

start "" "%~dp0START_BACKEND.bat"
timeout /t 3 /nobreak > nul
start "" "%~dp0START_FRONTEND.bat"

echo.
echo Both servers are starting...
echo.
echo Access the application at:
echo   Frontend: http://localhost:3000
echo   Backend API: http://localhost:8000
echo   Student View: http://localhost:3001 (after deployment)
echo.
echo Press any key to exit...
pause > nul
"@ | Out-File -FilePath "START_ALL.bat" -Encoding ASCII

# STOP_ALL.bat
@"
@echo off
echo Stopping all KEC Routine Scheduler processes...

taskkill /FI "WINDOWTITLE eq KEC Backend Server*" /F 2>nul
taskkill /IM KEC_Routine_Backend.exe /F 2>nul
taskkill /IM python.exe /FI "WINDOWTITLE eq *http.server*" /F 2>nul

echo All servers stopped.
pause
"@ | Out-File -FilePath "STOP_ALL.bat" -Encoding ASCII

# README.txt
@"
=====================================
KEC ROUTINE SCHEDULER - DEPLOYMENT
=====================================

Version: 1.0
Build Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

=====================================
QUICK START
=====================================

1. Double-click "START_ALL.bat" to start both backend and frontend servers

2. Open your web browser and go to:
   http://localhost:3000

3. To stop the servers, double-click "STOP_ALL.bat"

=====================================
MANUAL START
=====================================

If you want to start servers individually:

1. Backend Server:
   - Double-click "START_BACKEND.bat"
   - API will be available at http://localhost:8000

2. Frontend Server:
   - Double-click "START_FRONTEND.bat"
   - Application will be available at http://localhost:3000

=====================================
SYSTEM REQUIREMENTS
=====================================

- Windows 10 or higher
- 2 GB RAM minimum (4 GB recommended)
- 100 MB disk space
- Python 3.x (for frontend HTTP server)

=====================================
PORTS USED
=====================================

- Backend API: 8000
- Frontend: 3000
- Student View: 3001

Make sure these ports are not in use by other applications.

=====================================
TROUBLESHOOTING
=====================================

Problem: "Port already in use" error
Solution: Close any applications using ports 8000, 3000, or 3001
         Or change ports in the .env file (Backend folder)

Problem: Backend won't start
Solution: Make sure kec_routine.db is in the Backend folder
         Check Windows Firewall settings

Problem: Frontend shows blank page
Solution: Make sure Backend is running first
         Clear browser cache and refresh

=====================================
FEATURES
=====================================

- Create and manage class routines
- Assign teachers and subjects
- Multi-subject lab support
- Teacher conflict detection
- Export to Excel (day-wise, class-wise)
- Student view deployment
- Drag-and-drop scheduling

=====================================
SUPPORT
=====================================

For support or questions, contact your system administrator.

Database Location: Backend\kec_routine.db
Logs: Check the Backend folder for error logs

=====================================
"@ | Out-File -FilePath "README.txt" -Encoding UTF8

Write-Host "Startup scripts created successfully!" -ForegroundColor Green

# ===== CREATE ZIP PACKAGE =====
Write-Host ""
Write-Host "===== Creating ZIP Package =====" -ForegroundColor Cyan

$zipPath = Join-Path $deployDir "$packageName.zip"
Compress-Archive -Path $packageDir -DestinationPath $zipPath -Force

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "DEPLOYMENT PACKAGE CREATED SUCCESSFULLY!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Package Location:" -ForegroundColor Yellow
Write-Host "  Folder: $packageDir" -ForegroundColor White
Write-Host "  ZIP:    $zipPath" -ForegroundColor White
Write-Host ""
Write-Host "Package Size:" -ForegroundColor Yellow
$folderSize = (Get-ChildItem -Path $packageDir -Recurse | Measure-Object -Property Length -Sum).Sum / 1MB
$zipSize = (Get-Item $zipPath).Length / 1MB
Write-Host "  Uncompressed: $([math]::Round($folderSize, 2)) MB" -ForegroundColor White
Write-Host "  Compressed:   $([math]::Round($zipSize, 2)) MB" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Test the deployment package:" -ForegroundColor White
Write-Host "     cd `"$packageDir`"" -ForegroundColor Cyan
Write-Host "     .\START_ALL.bat" -ForegroundColor Cyan
Write-Host ""
Write-Host "  2. Distribute the ZIP file to users" -ForegroundColor White
Write-Host "  3. Users extract and run START_ALL.bat" -ForegroundColor White
Write-Host ""

# Return to root directory
Set-Location $rootDir

Write-Host "Done!" -ForegroundColor Green
