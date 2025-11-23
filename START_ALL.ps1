# ============================================================================
# KEC Routine Scheduler - Start All Services (PowerShell)
# ============================================================================
# This script starts Backend, Frontend, and Student Server simultaneously
# ============================================================================

$Host.UI.RawUI.WindowTitle = "KEC Routine Scheduler - Launcher"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  KEC Routine Scheduler Launcher" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan
Write-Host "Starting all services...`n" -ForegroundColor Yellow

# Get script directory
$RootDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Start Backend (FastAPI)
Write-Host "[1/3] Starting Backend API Server..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$RootDir\backend'; .venv\Scripts\Activate.ps1; python run.py" -WindowStyle Normal
Start-Sleep -Seconds 2

# Start Frontend (React Dev Server)
Write-Host "[2/3] Starting Frontend Dev Server..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$RootDir\frontend'; npm run dev" -WindowStyle Normal
Start-Sleep -Seconds 2

# Start Student Server (Express Static Server)
Write-Host "[3/3] Starting Student View Server..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "Set-Location '$RootDir\backend'; node static_server.js" -WindowStyle Normal
Start-Sleep -Seconds 2

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  All Services Started Successfully!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Services are running in separate windows:`n" -ForegroundColor White

Write-Host "  [1] Backend API      : " -NoNewline -ForegroundColor White
Write-Host "http://localhost:8000" -ForegroundColor Yellow
Write-Host "      API Docs         : " -NoNewline -ForegroundColor White
Write-Host "http://localhost:8000/api/docs`n" -ForegroundColor Yellow

Write-Host "  [2] Frontend (Admin) : " -NoNewline -ForegroundColor White
Write-Host "http://localhost:3000`n" -ForegroundColor Yellow

Write-Host "  [3] Student View     : " -NoNewline -ForegroundColor White
Write-Host "http://localhost:3001`n" -ForegroundColor Yellow

Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Press any key to open services in browser..." -ForegroundColor White
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Open services in default browser
Write-Host "`nOpening services in browser...`n" -ForegroundColor Yellow
Start-Process "http://localhost:8000/api/docs"
Start-Sleep -Seconds 1
Start-Process "http://localhost:3000"
Start-Sleep -Seconds 1
Start-Process "http://localhost:3001"

Write-Host "Services opened in browser!`n" -ForegroundColor Green
Write-Host "To stop all services, close all the PowerShell windows.`n" -ForegroundColor Yellow

Write-Host "Press any key to exit this launcher..." -ForegroundColor White
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
