@echo off
echo ============================================================
echo Starting KEC Routine Scheduler - Frontend Server
echo ============================================================
echo.

set FRONTEND_DIR=%~dp0frontend\dist

if not exist "%FRONTEND_DIR%\index.html" (
    echo ERROR: Frontend build not found!
    echo.
    echo Please build the frontend first by running:
    echo   BUILD_FRONTEND.bat
    echo.
    pause
    exit /b 1
)

echo Starting frontend server...
echo Frontend will run on: http://localhost:3000
echo.
echo Opening browser in 3 seconds...
echo.
echo Keep this window open while using the application
echo Press Ctrl+C to stop the server
echo.
echo ============================================================
echo.

cd "%FRONTEND_DIR%"

timeout /t 3 /nobreak >nul
start http://localhost:3000

python -m http.server 3000

pause
