# 🔧 BUILD TROUBLESHOOTING GUIDE

## Issue: "ModuleNotFoundError: No module named 'fastapi'"

### Problem
PyInstaller didn't bundle FastAPI and its dependencies properly.

### Solution
Use the improved build script that uses `--collect-all` flags:

```powershell
cd backend
python build_exe_v2.py
```

This script uses:
- `--collect-all=fastapi` - Collects all FastAPI modules
- `--collect-all=uvicorn` - Collects all Uvicorn modules
- `--collect-all=starlette` - Collects Starlette framework
- `--collect-all=pydantic` - Collects Pydantic validation
- `--collect-all=sqlalchemy` - Collects SQLAlchemy ORM

---

## Alternative: Manual PyInstaller Command

If the script doesn't work, run PyInstaller directly:

```powershell
pyinstaller run.py `
  --name=KEC_Routine_Backend `
  --onedir `
  --console `
  --clean `
  --noconfirm `
  --add-data="app;app" `
  --collect-all=fastapi `
  --collect-all=uvicorn `
  --collect-all=starlette `
  --collect-all=pydantic `
  --collect-all=sqlalchemy `
  --hidden-import=aiosqlite `
  --hidden-import=dotenv
```

---

## After Building

### 1. Copy Required Files

The build script should automatically copy these, but if not:

```powershell
# Copy database
copy kec_routine.db dist\KEC_Routine_Backend\

# Copy environment file (if exists)
copy .env dist\KEC_Routine_Backend\
```

### 2. Test the Executable

```powershell
cd dist\KEC_Routine_Backend
.\KEC_Routine_Backend.exe
```

Expected output:
```
INFO:     Started server process [####]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8000
```

### 3. Test the API

Open browser to: http://localhost:8000/docs

You should see the FastAPI Swagger documentation.

---

## Common Build Issues

### Issue: "No module named 'app'"

**Cause:** App directory not included in build

**Fix:**
```powershell
# Rebuild with explicit app inclusion
pyinstaller run.py --add-data="app;app" --collect-all=fastapi --collect-all=uvicorn
```

### Issue: "Database not found"

**Cause:** Database file not copied to dist

**Fix:**
```powershell
copy backend\kec_routine.db backend\dist\KEC_Routine_Backend\
```

### Issue: "ImportError: cannot import name 'X' from 'Y'"

**Cause:** Missing hidden import

**Fix:** Add to build script:
```python
'--hidden-import=module.name',
```

### Issue: Build takes forever or freezes

**Cause:** Large dependency tree

**Solutions:**
1. Use `--onedir` instead of `--onefile` (faster)
2. Exclude unnecessary packages:
   ```python
   '--exclude-module=matplotlib',
   '--exclude-module=numpy',
   '--exclude-module=pandas',
   ```

---

## Build Script Comparison

### Old Script (build_exe.py)
- ❌ Missing critical hidden imports
- ❌ Doesn't use `--collect-all`
- ❌ May miss FastAPI submodules

### New Script (build_exe_v2.py)
- ✅ Uses `--collect-all` for all major packages
- ✅ Includes all FastAPI dependencies
- ✅ Automatically copies database and .env
- ✅ Better error messages

**Recommendation:** Always use `build_exe_v2.py`

---

## Verifying the Build

### Check if all modules are included:

```powershell
cd dist\KEC_Routine_Backend
dir _internal\  # Check for fastapi, uvicorn, etc.
```

Look for folders:
- `fastapi/`
- `uvicorn/`
- `starlette/`
- `pydantic/`
- `sqlalchemy/`
- `app/`

### Test import manually:

```powershell
# In dist\KEC_Routine_Backend directory
python
>>> import sys
>>> sys.path.insert(0, '_internal')
>>> import fastapi
>>> fastapi.__version__
'0.104.1'  # Should show version, not error
```

---

## Build Size Optimization

Current build is ~80-100 MB. To reduce:

### 1. Use --onefile (smaller but slower startup)
```python
'--onefile',  # Instead of --onedir
```

### 2. Exclude unused modules
```python
'--exclude-module=test',
'--exclude-module=unittest',
'--exclude-module=tkinter',
```

### 3. Use UPX compression
```python
'--upx-dir=path/to/upx',
```

Download UPX from: https://upx.github.io/

---

## Production Build Checklist

Before distributing:

- [ ] Build completes without errors
- [ ] Executable runs and starts server
- [ ] Can access http://localhost:8000/docs
- [ ] Database file is included
- [ ] .env file is included (or use defaults)
- [ ] All API endpoints work
- [ ] Tested on clean Windows machine (no Python installed)
- [ ] File size is acceptable (<150 MB)
- [ ] Startup time is acceptable (<10 seconds)

---

## Quick Commands Reference

```powershell
# Clean old builds
Remove-Item -Recurse -Force build, dist

# Build with new script
python build_exe_v2.py

# Test executable
cd dist\KEC_Routine_Backend
.\KEC_Routine_Backend.exe

# Check size
Get-ChildItem -Recurse dist\KEC_Routine_Backend | Measure-Object -Property Length -Sum

# Create ZIP for distribution
Compress-Archive -Path dist\KEC_Routine_Backend -DestinationPath KEC_Backend_v1.0.zip
```

---

## Getting Help

1. **Check PyInstaller logs:**
   - Location: `build\KEC_Routine_Backend\warn-KEC_Routine_Backend.txt`
   - Shows all warnings and missing modules

2. **Enable debug mode:**
   ```python
   '--debug=all',  # Add to build script
   ```

3. **Test with Python directly first:**
   ```powershell
   # Make sure it works without PyInstaller
   python run.py
   ```

4. **Check PyInstaller version:**
   ```powershell
   pyinstaller --version  # Should be 6.3.0 or higher
   ```

---

**Last Updated:** November 2025
**Tested On:** Windows 10/11, Python 3.11
