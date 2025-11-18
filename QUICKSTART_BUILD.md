# 🚀 KEC ROUTINE SCHEDULER - DEPLOYMENT QUICK START

## Option 1: One-Click Build (Easiest!)

Just double-click:
```
BUILD.bat
```

That's it! The script will automatically:
- ✅ Build backend executable
- ✅ Build frontend production files  
- ✅ Create deployment package
- ✅ Generate ZIP file

**Result:** Ready-to-distribute package in `deployment/` folder

---

## Option 2: PowerShell Command

```powershell
.\BUILD_ALL.ps1
```

---

## Option 3: Manual Steps

### 1. Build Backend
```powershell
cd backend
pip install -r requirements-build.txt
python build_exe.py
```

### 2. Build Frontend
```powershell
cd ../frontend
npm run build
```

### 3. Create Package
```powershell
cd ..
.\create_deployment_package.ps1
```

---

## What You Get

A complete deployment package containing:

```
KEC_Routine_Scheduler_v1.0_[timestamp]/
├── Backend/
│   └── KEC_Routine_Backend.exe    ← Standalone executable
├── Frontend/
│   └── [static files]              ← Production build
├── START_ALL.bat                   ← Double-click to run
├── STOP_ALL.bat                    ← Stop servers
└── README.txt                      ← User guide
```

**Package Size:** ~55-95 MB (compressed to ~30-50 MB ZIP)

---

## Testing the Package

1. Navigate to deployment folder:
   ```powershell
   cd deployment\KEC_Routine_Scheduler_v1.0_[timestamp]
   ```

2. Run the application:
   ```
   START_ALL.bat
   ```

3. Open browser:
   - Frontend: http://localhost:3000
   - API Docs: http://localhost:8000/docs
   - Student View: http://localhost:3001

---

## Distribution

### Give to Users:
- The ZIP file: `KEC_Routine_Scheduler_v1.0_[timestamp].zip`
- Users extract it
- Users double-click `START_ALL.bat`
- Done! ✅

### No Installation Needed:
- Backend includes Python runtime
- Frontend is just HTML/JS/CSS
- Database included (SQLite)
- Works on any Windows 10+ machine

---

## Requirements

### For Building:
- Python 3.11+ with venv
- Node.js 18+
- npm

### For Running (End Users):
- Windows 10 or higher
- **No Python needed!**
- **No Node.js needed!**
- Just double-click START_ALL.bat

---

## Troubleshooting

### Build Fails?
```powershell
# Make sure dependencies are installed
cd backend
pip install -r requirements.txt
pip install -r requirements-build.txt

cd ../frontend
npm install
```

### Can't Run PowerShell Scripts?
```powershell
# Run as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## Files Created

After running BUILD.bat or BUILD_ALL.ps1:

```
deployment/
├── KEC_Routine_Scheduler_v1.0_[timestamp]/    ← Folder
└── KEC_Routine_Scheduler_v1.0_[timestamp].zip ← ZIP file
```

Distribute the **ZIP file** to users.

---

## Support

📖 **Detailed Guides:**
- BUILD_INSTRUCTIONS.md - Complete build guide
- DEPLOYMENT.md - Deployment guide
- README.md - Project overview

🐛 **Issues:**
- Check build logs in `backend/build/`
- Ensure all prerequisites installed
- Try clean build (delete dist folders)

---

## Version

**Current Version:** 1.0.0
**Build Date:** November 2025
**Platform:** Windows 10+

---

**Happy Deploying! 🎉**
