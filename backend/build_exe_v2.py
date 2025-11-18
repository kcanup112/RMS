"""
Improved build script for KEC Routine Scheduler Backend
This version uses PyInstaller with proper module collection
"""
import PyInstaller.__main__
import sys
from pathlib import Path

print("="*70)
print("KEC ROUTINE SCHEDULER - BACKEND BUILD")
print("="*70)
print()

current_dir = Path(__file__).parent

# Clean previous builds
print("Cleaning previous builds...")
import shutil
for folder in ['build', 'dist']:
    folder_path = current_dir / folder
    if folder_path.exists():
        shutil.rmtree(folder_path)
        print(f"  Removed {folder}/")

print()
print("Building executable with PyInstaller...")
print("This will take 5-10 minutes...")
print()

# PyInstaller arguments
pyinstaller_args = [
    'run.py',                                      # Entry point
    '--name=KEC_Routine_Backend',                  # Executable name
    '--onedir',                                    # Create one directory with all files
    '--console',                                   # Show console window
    '--noconfirm',                                 # Don't ask for confirmation
    '--clean',                                     # Clean cache
    
    # Add app directory as data
    '--add-data=app;app',
    
    # Collect all submodules for critical packages
    '--collect-all=fastapi',
    '--collect-all=uvicorn',
    '--collect-all=starlette',
    '--collect-all=pydantic',
    '--collect-all=sqlalchemy',
    
    # Additional hidden imports
    '--hidden-import=uvicorn.logging',
    '--hidden-import=uvicorn.loops',
    '--hidden-import=uvicorn.loops.auto',
    '--hidden-import=uvicorn.protocols',
    '--hidden-import=uvicorn.protocols.http',
    '--hidden-import=uvicorn.protocols.http.auto',
    '--hidden-import=uvicorn.protocols.http.h11_impl',
    '--hidden-import=uvicorn.protocols.websockets',
    '--hidden-import=uvicorn.protocols.websockets.auto',
    '--hidden-import=uvicorn.lifespan',
    '--hidden-import=uvicorn.lifespan.on',
    '--hidden-import=aiosqlite',
    '--hidden-import=multipart',
    '--hidden-import=python_multipart',
    '--hidden-import=email_validator',
    '--hidden-import=dotenv',
    '--hidden-import=pydantic_settings',
]

# Run PyInstaller
try:
    PyInstaller.__main__.run(pyinstaller_args)
    
    # Copy database file to dist if it exists
    db_source = current_dir / 'kec_routine.db'
    db_dest = current_dir / 'dist' / 'KEC_Routine_Backend' / 'kec_routine.db'
    
    if db_source.exists():
        print()
        print("Copying database file...")
        shutil.copy2(db_source, db_dest)
        print(f"  ✓ Copied kec_routine.db")
    
    # Copy .env if it exists
    env_source = current_dir / '.env'
    env_dest = current_dir / 'dist' / 'KEC_Routine_Backend' / '.env'
    
    if env_source.exists():
        print("Copying environment file...")
        shutil.copy2(env_source, env_dest)
        print(f"  ✓ Copied .env")
    
    print()
    print("="*70)
    print("BUILD SUCCESSFUL!")
    print("="*70)
    print()
    print(f"Executable location:")
    print(f"  {current_dir / 'dist' / 'KEC_Routine_Backend' / 'KEC_Routine_Backend.exe'}")
    print()
    print("To test the executable:")
    print("  1. cd dist\\KEC_Routine_Backend")
    print("  2. .\\KEC_Routine_Backend.exe")
    print()
    print("The API will be available at: http://localhost:8000")
    print()
    
except Exception as e:
    print()
    print("="*70)
    print("BUILD FAILED!")
    print("="*70)
    print(f"Error: {e}")
    print()
    sys.exit(1)
