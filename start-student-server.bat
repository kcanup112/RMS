@echo off
echo ========================================
echo Starting Student Routine Server
echo ========================================
echo.
echo Server will run on http://localhost:6000
echo.
echo Press Ctrl+C to stop the server
echo.
cd /d "%~dp0backend"
node static_server.js
pause
