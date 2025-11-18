@echo off
echo ============================================================
echo Building KEC Routine Scheduler - Frontend
echo ============================================================
echo.

cd frontend

echo Step 1: Building production bundle...
echo This may take 1-2 minutes...
echo.

call npm run build

echo.
echo ============================================================
if exist "dist\index.html" (
    echo SUCCESS: Frontend built!
    echo Location: frontend\dist\
    echo.
    echo To serve the frontend:
    echo   1. Copy the 'dist' folder contents
    echo   2. Serve using any web server
    echo   3. Or use: python -m http.server 3000
) else (
    echo ERROR: Build failed!
)
echo ============================================================
echo.
pause
