"""
Build script to create Windows executable for KEC Routine Scheduler Backend
"""
import PyInstaller.__main__
import os
import shutil
from pathlib import Path

# Get the current directory
current_dir = Path(__file__).parent

# Create spec file content
spec_content = """
# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
    ['run.py'],
    pathex=[],
    binaries=[],
    datas=[
        ('app', 'app'),
    ],
    hiddenimports=[
        # FastAPI and dependencies
        'fastapi',
        'fastapi.routing',
        'fastapi.responses',
        'fastapi.encoders',
        'fastapi.exceptions',
        'fastapi.middleware',
        'fastapi.middleware.cors',
        'starlette',
        'starlette.applications',
        'starlette.routing',
        'starlette.middleware',
        'starlette.middleware.cors',
        'starlette.responses',
        'starlette.requests',
        'pydantic',
        'pydantic.fields',
        'pydantic.main',
        'pydantic.schema',
        'pydantic_settings',
        # Uvicorn
        'uvicorn',
        'uvicorn.logging',
        'uvicorn.loops',
        'uvicorn.loops.auto',
        'uvicorn.protocols',
        'uvicorn.protocols.http',
        'uvicorn.protocols.http.auto',
        'uvicorn.protocols.http.h11_impl',
        'uvicorn.protocols.websockets',
        'uvicorn.protocols.websockets.auto',
        'uvicorn.protocols.websockets.wsproto_impl',
        'uvicorn.lifespan',
        'uvicorn.lifespan.on',
        # SQLAlchemy
        'sqlalchemy',
        'sqlalchemy.ext',
        'sqlalchemy.ext.declarative',
        'sqlalchemy.ext.baked',
        'sqlalchemy.orm',
        'sqlalchemy.sql',
        'sqlalchemy.sql.default_comparator',
        'aiosqlite',
        # Other dependencies
        'dotenv',
        'multipart',
        'email_validator',
    ],
    hookspath=['hooks'],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='KEC_Routine_Backend',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=None,
)

coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='KEC_Routine_Backend',
)
"""

# Write spec file
spec_file = current_dir / 'backend.spec'
with open(spec_file, 'w') as f:
    f.write(spec_content)

print("Building Windows executable...")
print("This may take several minutes...")

# Run PyInstaller
PyInstaller.__main__.run([
    str(spec_file),
    '--clean',
    '--noconfirm',
])

print("\n" + "="*60)
print("Build complete!")
print("="*60)
print(f"\nExecutable location: {current_dir / 'dist' / 'KEC_Routine_Backend'}")
print("\nTo run the backend server, execute:")
print("  dist\\KEC_Routine_Backend\\KEC_Routine_Backend.exe")
print("\n" + "="*60)
