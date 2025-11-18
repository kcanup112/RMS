@echo off
echo ============================================================
echo KEC Routine Scheduler - Windows Executable Builder
echo ============================================================
echo.

echo Step 1: Installing PyInstaller...
call .venv\Scripts\activate
pip install pyinstaller

echo.
echo Step 2: Building Backend Executable...
python build_exe.py

echo.
echo ============================================================
echo Build Complete!
echo ============================================================
echo.
echo The backend executable is located in:
echo   dist\KEC_Routine_Backend\
echo.
echo To run the backend server:
echo   1. Navigate to: dist\KEC_Routine_Backend\
echo   2. Run: KEC_Routine_Backend.exe
echo.
echo The server will start on http://localhost:8000
echo ============================================================
pause
