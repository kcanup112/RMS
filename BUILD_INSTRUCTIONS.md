# KEC ROUTINE SCHEDULER - BUILD INSTRUCTIONS

## 🚀 Quick Build (Easiest Method)

### One-Command Build:
```powershell
.\BUILD_ALL.ps1
```

This single command will:
1. Build the backend executable
2. Build the frontend production files
3. Create a complete deployment package
4. Generate a ZIP file ready for distribution

**Output:** `deployment/KEC_Routine_Scheduler_v1.0_[timestamp].zip`

---

## 📦 What Gets Built

### Backend Executable
- **File:** `KEC_Routine_Backend.exe`
- **Size:** ~50-80 MB
- **Includes:** Python runtime, FastAPI, SQLite database, all dependencies
- **Portable:** No Python installation required on target machine

### Frontend Build
- **Type:** Static HTML/CSS/JavaScript files
- **Size:** ~2-5 MB
- **Optimized:** Minified and compressed for production
- **Framework:** React + Vite build

### Complete Package Structure
```
KEC_Routine_Scheduler_v1.0_[timestamp]/
├── Backend/
│   ├── KEC_Routine_Backend.exe    ← Main backend executable
│   ├── kec_routine.db              ← SQLite database
│   └── [other bundled files]
├── Frontend/
│   ├── index.html                  ← Main entry point
│   └── assets/                     ← JS, CSS, images
├── START_ALL.bat                   ← Start both servers
├── START_BACKEND.bat               ← Start backend only
├── START_FRONTEND.bat              ← Start frontend only
├── STOP_ALL.bat                    ← Stop all servers
└── README.txt                      ← User instructions
```

---

## 🔧 Manual Build Process

If you prefer to build components separately:

### Step 1: Build Backend

```powershell
cd backend
pip install -r requirements-build.txt
python build_exe.py
```

**Output:** `backend/dist/KEC_Routine_Backend/`

### Step 2: Build Frontend

```powershell
cd frontend
npm install
npm run build
```

**Output:** `frontend/dist/`

### Step 3: Create Deployment Package

```powershell
cd ..
.\create_deployment_package.ps1
```

---

## ✅ Pre-Build Checklist

Before building, ensure:

- [ ] Python virtual environment is activated
- [ ] All backend dependencies installed: `pip install -r requirements.txt`
- [ ] Frontend dependencies installed: `npm install`
- [ ] Backend server tested and working
- [ ] Frontend tested and working
- [ ] Database file exists: `backend/kec_routine.db`
- [ ] No uncommitted changes (optional, but recommended)

---

## 🧪 Testing the Build

### Test Locally First:

1. **Navigate to deployment package:**
   ```powershell
   cd deployment/KEC_Routine_Scheduler_v1.0_[timestamp]
   ```

2. **Start the application:**
   ```powershell
   .\START_ALL.bat
   ```

3. **Test in browser:**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8000/docs
   - Student View: http://localhost:3001 (after deploying from admin)

4. **Verify functionality:**
   - [ ] Login works
   - [ ] Can create class routines
   - [ ] Can assign subjects and teachers
   - [ ] Multi-subject labs work correctly
   - [ ] Export to Excel works
   - [ ] Deploy for students works
   - [ ] Student view displays correctly

---

## 📤 Distribution

### For Internal Network:

1. **Share the folder directly:**
   - Copy the deployment folder to a network share
   - Users can run START_ALL.bat from the network location

2. **Or distribute the ZIP:**
   - Send `KEC_Routine_Scheduler_v1.0_[timestamp].zip`
   - Users extract and run START_ALL.bat

### For External Distribution:

1. **Use the ZIP file:**
   ```
   deployment/KEC_Routine_Scheduler_v1.0_[timestamp].zip
   ```

2. **Include instructions:**
   - The README.txt is already included in the package
   - Users just extract and run START_ALL.bat

---

## 🔒 Production Build Notes

### Security Considerations:

1. **Database:**
   - The SQLite database is included
   - For production, consider PostgreSQL
   - Update connection strings in `.env`

2. **Ports:**
   - Default ports: 8000 (backend), 3000 (frontend), 3001 (student view)
   - Can be changed in backend/.env file

3. **CORS:**
   - Currently configured for localhost
   - Update for production domain in `backend/app/core/config.py`

### Performance:

- **Backend:** Can handle ~500-1000 concurrent users (SQLite limitation)
- **Frontend:** Fully static, can be served via CDN
- **Scaling:** For large deployments, use PostgreSQL and separate servers

---

## 🐛 Troubleshooting Build Issues

### Backend Build Fails:

**Error:** "Module not found"
```powershell
# Install missing dependencies
pip install [missing-module]
# Rebuild
python build_exe.py
```

**Error:** "PyInstaller not found"
```powershell
pip install pyinstaller==6.3.0
```

### Frontend Build Fails:

**Error:** "Command not found: vite"
```powershell
# Reinstall dependencies
rm -r node_modules
npm install
npm run build
```

**Error:** "Out of memory"
```powershell
# Increase Node memory
$env:NODE_OPTIONS="--max-old-space-size=4096"
npm run build
```

### Deployment Script Fails:

**Error:** "Execution policy"
```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 📊 Build Size Optimization

Current sizes:
- Backend: ~50-80 MB
- Frontend: ~2-5 MB
- Total: ~55-95 MB

### To reduce size:

1. **Backend:**
   - Use `--onefile` instead of `--onedir` (already configured)
   - Exclude unnecessary modules in build_exe.py

2. **Frontend:**
   - Already optimized with Vite
   - Using code splitting and tree shaking

---

## 🔄 Updating Builds

### For Bug Fixes:

1. Fix the code
2. Test thoroughly
3. Increment version number
4. Rebuild: `.\BUILD_ALL.ps1`
5. Distribute new package

### For Database Schema Changes:

1. Update models
2. Create migration script
3. Include migration in deployment
4. Document upgrade procedure

---

## 💾 Backup Recommendations

Before building for production:

1. **Backup database:**
   ```powershell
   copy backend\kec_routine.db backend\kec_routine.db.backup
   ```

2. **Tag the release:**
   ```powershell
   git tag -a v1.0 -m "Production release 1.0"
   git push --tags
   ```

3. **Archive old deployments:**
   - Keep previous versions for rollback
   - Store in `deployment/archive/`

---

## 🎯 Deployment Checklist

Before distributing:

- [ ] All tests pass
- [ ] Build completed without errors
- [ ] Tested on clean Windows machine
- [ ] README.txt is accurate
- [ ] Version number updated
- [ ] Database is included and working
- [ ] All startup scripts work
- [ ] Documentation is up to date

---

## 📞 Support

For build issues:
1. Check error messages in terminal
2. Review build logs in `backend/build/` and `backend/dist/`
3. Ensure all prerequisites are met
4. Try clean build (delete dist/ folders first)

---

**Last Updated:** November 2025
**Build Script Version:** 1.0.0
