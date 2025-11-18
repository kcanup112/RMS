# Quick Build Script - Creates deployment package in one command

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "KEC Routine Scheduler - Quick Builder" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Build Backend
Write-Host "[1/3] Building Backend..." -ForegroundColor Yellow
cd backend
if (Test-Path ".venv\Scripts\Activate.ps1") {
    & .venv\Scripts\Activate.ps1
    pip install -q pyinstaller==6.3.0
    python build_exe.py
} else {
    Write-Host "ERROR: Virtual environment not found!" -ForegroundColor Red
    exit 1
}

# Step 2: Build Frontend
Write-Host ""
Write-Host "[2/3] Building Frontend..." -ForegroundColor Yellow
cd ..\frontend
npm run build

# Step 3: Create Package
Write-Host ""
Write-Host "[3/3] Creating Deployment Package..." -ForegroundColor Yellow
cd ..
.\create_deployment_package.ps1

Write-Host ""
Write-Host "Build complete! Check the 'deployment' folder." -ForegroundColor Green
