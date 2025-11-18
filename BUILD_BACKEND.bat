@echo off
echo ============================================================
echo Building KEC Routine Scheduler - Backend
echo ============================================================
echo.

cd backend

echo Step 1: Activating virtual environment...
call .venv\Scripts\activate.bat

echo.
echo Step 2: Installing PyInstaller (if not already installed)...
pip install pyinstaller --quiet

echo.
echo Step 3: Building backend executable...
echo This may take 3-5 minutes...
echo.

pyinstaller --clean --noconfirm backend.spec

echo.
echo ============================================================
if exist "dist\KEC_Routine_Backend\KEC_Routine_Backend.exe" (
    echo SUCCESS: Backend executable created!
    echo Location: backend\dist\KEC_Routine_Backend\
    echo.
    echo Files included:
    echo   - KEC_Routine_Backend.exe
    echo   - kec_routine.db ^(database^)
    echo   - _internal\ ^(dependencies^)
) else (
    echo ERROR: Build failed!
)
echo ============================================================
echo.
pause
