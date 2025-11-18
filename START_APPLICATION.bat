@echo off
echo ============================================================
echo KEC ROUTINE SCHEDULER
echo Starting Application...
echo ============================================================
echo.

REM Check if backend executable exists
if not exist "backend\dist\KEC_Routine_Backend\KEC_Routine_Backend.exe" (
    echo ERROR: Backend not built yet!
    echo Please run BUILD_BACKEND.bat first
    echo.
    pause
    exit /b 1
)

REM Check if frontend build exists
if not exist "frontend\dist\index.html" (
    echo ERROR: Frontend not built yet!
    echo Please run BUILD_FRONTEND.bat first
    echo.
    pause
    exit /b 1
)

echo Starting Backend Server...
start "KEC Backend Server" cmd /k "%~dp0START_BACKEND.bat"

echo Waiting for backend to start...
timeout /t 3 /nobreak >nul

echo.
echo Starting Frontend Server...
start "KEC Frontend Server" cmd /k "%~dp0START_FRONTEND.bat"

echo.
echo ============================================================
echo Application Started Successfully!
echo ============================================================
echo.
echo Access the application at: http://localhost:3000
echo.
echo Two console windows have opened:
echo   1. Backend Server (http://localhost:8000)
echo   2. Frontend Server (http://localhost:3000)
echo.
echo Keep both windows open while using the application
echo Close this window or press any key to continue...
echo ============================================================
pause >nul
