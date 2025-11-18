@echo off
echo ============================================================
echo Starting KEC Routine Scheduler - Backend Server
echo ============================================================
echo.

set BACKEND_DIR=%~dp0backend\dist\KEC_Routine_Backend

if not exist "%BACKEND_DIR%\KEC_Routine_Backend.exe" (
    echo ERROR: Backend executable not found!
    echo.
    echo Please build the backend first by running:
    echo   BUILD_BACKEND.bat
    echo.
    pause
    exit /b 1
)

echo Starting backend server...
echo Backend will run on: http://localhost:8000
echo API Documentation: http://localhost:8000/docs
echo.
echo Keep this window open while using the application
echo Press Ctrl+C to stop the server
echo.
echo ============================================================
echo.

cd "%BACKEND_DIR%"
KEC_Routine_Backend.exe

pause
