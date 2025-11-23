@echo off
REM ============================================================================
REM KEC Routine Scheduler - Stop All Services
REM ============================================================================
REM This script stops all running services (Backend, Frontend, Student Server)
REM ============================================================================

title KEC Routine Scheduler - Stop Services
color 0C

echo.
echo ========================================
echo   Stopping All Services
echo ========================================
echo.

REM Kill Python processes (Backend)
echo [1/3] Stopping Backend API Server...
taskkill /F /FI "WINDOWTITLE eq KEC Backend*" 2>nul
taskkill /F /IM python.exe /T 2>nul
echo Backend stopped.

REM Kill Node processes (Frontend and Student Server)
echo [2/3] Stopping Frontend Dev Server...
taskkill /F /FI "WINDOWTITLE eq KEC Frontend*" 2>nul
echo Frontend stopped.

echo [3/3] Stopping Student View Server...
taskkill /F /FI "WINDOWTITLE eq KEC Student View*" 2>nul
echo Student server stopped.

REM Clean up any remaining node processes (optional - be careful)
REM Uncomment the line below if you want to force kill ALL node processes
REM taskkill /F /IM node.exe /T 2>nul

echo.
echo ========================================
echo   All Services Stopped Successfully!
echo ========================================
echo.
echo All server processes have been terminated.
echo.
pause
