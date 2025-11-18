@echo off
echo ============================================================
echo KEC ROUTINE SCHEDULER - ONE-CLICK BUILD
echo ============================================================
echo.
echo This script will:
echo  1. Build the backend executable
echo  2. Build the frontend production files
echo  3. Create a complete deployment package
echo.
echo This may take 5-10 minutes...
echo.
pause

echo.
echo Starting build process...
echo.

powershell -ExecutionPolicy Bypass -File ".\BUILD_ALL.ps1"

echo.
echo ============================================================
echo BUILD COMPLETE!
echo ============================================================
echo.
echo Check the 'deployment' folder for the final package.
echo.
pause
