# PyInstaller hook for FastAPI
# This ensures all FastAPI modules are properly bundled

from PyInstaller.utils.hooks import collect_all

datas, binaries, hiddenimports = collect_all('fastapi')

# Additional hidden imports that might be missed
hiddenimports += [
    'fastapi.routing',
    'fastapi.responses',
    'fastapi.encoders',
    'fastapi.exceptions',
    'fastapi.middleware',
    'fastapi.middleware.cors',
    'fastapi.staticfiles',
    'starlette.applications',
    'starlette.routing',
    'starlette.middleware',
    'starlette.middleware.cors',
    'starlette.responses',
    'starlette.requests',
    'starlette.staticfiles',
    'pydantic',
    'pydantic.fields',
    'pydantic.main',
]
