@echo off
REM ============================================================================
REM KEC Routine Scheduler - Start All Services
REM ============================================================================
REM This script starts Backend, Frontend, and Student Server simultaneously
REM ============================================================================

title KEC Routine Scheduler - Launcher
color 0A

echo.
echo ========================================
echo   KEC Routine Scheduler Launcher
echo ========================================
echo.
echo Starting all services...
echo.

REM Get the directory where this script is located
set "ROOT_DIR=%~dp0"
cd /d "%ROOT_DIR%"

REM Start Backend (FastAPI)
echo [1/3] Starting Backend API Server...
start "KEC Backend (Port 8000)" cmd /k "cd /d "%ROOT_DIR%backend" && .venv\Scripts\activate && python run.py"
timeout /t 2 /nobreak > nul

REM Start Frontend (React Dev Server)
echo [2/3] Starting Frontend Dev Server...
start "KEC Frontend (Port 3000)" cmd /k "cd /d "%ROOT_DIR%frontend" && npm run dev"
timeout /t 2 /nobreak > nul

REM Start Student Server (Express Static Server)
echo [3/3] Starting Student View Server...
start "KEC Student View (Port 3001)" cmd /k "cd /d "%ROOT_DIR%backend" && node static_server.js"
timeout /t 2 /nobreak > nul

echo.
echo ========================================
echo   All Services Started Successfully!
echo ========================================
echo.
echo Services are running in separate windows:
echo.
echo   [1] Backend API      : http://localhost:8000
echo       API Docs         : http://localhost:8000/api/docs
echo.
echo   [2] Frontend (Admin) : http://localhost:3000
echo.
echo   [3] Student View     : http://localhost:3001
echo.
echo ========================================
echo.
echo Press any key to open services in browser...
pause > nul

REM Open services in default browser
start http://localhost:8000/api/docs
timeout /t 1 /nobreak > nul
start http://localhost:3000
timeout /t 1 /nobreak > nul
start http://localhost:3001

echo.
echo Services opened in browser!
echo.
echo To stop all services, close all the terminal windows.
echo.
pause
