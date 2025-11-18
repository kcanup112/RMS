# KEC Routine Scheduler - Deployment Guide

## Building Executable Files

This guide will help you create standalone executable files for deployment.

---

## Prerequisites

### For Backend (Python)
- Python 3.11 or higher
- Virtual environment activated
- All dependencies installed

### For Frontend (React)
- Node.js 18 or higher
- npm installed

---

## Step 1: Build Backend Executable

### 1.1 Install Build Dependencies

```powershell
cd backend
pip install -r requirements-build.txt
```

### 1.2 Run Build Script

```powershell
python build_exe.py
```

This will:
- Create a standalone executable in `backend/dist/KEC_Routine_Backend/`
- Include the database and all necessary files
- Bundle Python runtime and dependencies

**Output Location:** `backend/dist/KEC_Routine_Backend/KEC_Routine_Backend.exe`

### 1.3 Test the Backend Executable

```powershell
cd dist\KEC_Routine_Backend
.\KEC_Routine_Backend.exe
```

The API should be running at http://localhost:8000

---

## Step 2: Build Frontend for Production

### 2.1 Install Dependencies (if not already installed)

```powershell
cd ../../frontend
npm install
```

### 2.2 Build Production Version

```powershell
npm run build
```

This creates an optimized production build in `frontend/dist/`

**Output Location:** `frontend/dist/` (contains index.html, assets/, etc.)

---

## Step 3: Create Complete Deployment Package

### Option A: Manual Packaging

Create a folder structure like this:

```
KEC_Routine_Scheduler/
├── Backend/
│   └── KEC_Routine_Backend.exe
│   └── kec_routine.db
│   └── (other files from backend/dist/KEC_Routine_Backend/)
├── Frontend/
│   └── index.html
│   └── assets/
│   └── (all files from frontend/dist/)
├── START_BACKEND.bat
├── START_FRONTEND.bat
├── START_ALL.bat
└── README.txt
```

### Option B: Use PowerShell Script (Recommended)

Run the deployment packaging script:

```powershell
# From the root directory
.\create_deployment_package.ps1
```

This automatically creates a complete deployment package.

---

## Step 4: Deployment Package Contents

The final deployment package will include:

### Backend Executable
- `KEC_Routine_Backend.exe` - Main backend server
- `kec_routine.db` - SQLite database
- All bundled dependencies

### Frontend Static Files
- `index.html` - Main entry point
- `assets/` - JavaScript, CSS, and other assets
- All compiled React components

### Startup Scripts
- `START_BACKEND.bat` - Starts the backend server
- `START_FRONTEND.bat` - Serves the frontend (using Python's HTTP server)
- `START_ALL.bat` - Starts both backend and frontend
- `STOP_ALL.bat` - Stops all running services

---

## Step 5: Running the Application

### On the Deployment Machine:

1. **Extract the deployment package** to any folder

2. **Start the application:**
   - Double-click `START_ALL.bat`
   - Or run backend and frontend separately

3. **Access the application:**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8000
   - Student View (after deployment): http://localhost:3001

---

## Alternative: Single Executable with Embedded Frontend

For a truly portable single-file solution, you can create a self-contained executable:

```powershell
# From root directory
.\build_single_executable.ps1
```

This creates a single .exe file that includes both backend and frontend.

---

## Troubleshooting

### Backend Issues

**Problem:** Executable won't start
- Check if port 8000 is already in use
- Make sure `kec_routine.db` is in the same directory
- Check Windows Firewall settings

**Problem:** Database not found
- Ensure `kec_routine.db` is copied to the executable's directory
- Check file permissions

### Frontend Issues

**Problem:** API calls failing
- Verify backend is running on port 8000
- Check `vite.config.js` proxy settings
- Ensure CORS is properly configured

**Problem:** Blank page
- Check browser console for errors
- Verify all files from `dist/` were copied
- Clear browser cache

---

## Distribution

### For Internal Use:
1. Share the complete deployment package folder
2. Include the README.txt with instructions
3. Users just need to run START_ALL.bat

### For External Distribution:
1. Create a ZIP file of the deployment package
2. Include installation instructions
3. Consider creating an installer using tools like:
   - Inno Setup
   - NSIS (Nullsoft Scriptable Install System)
   - WiX Toolset

---

## Production Considerations

### Security
- Change default ports in `.env` file
- Update database credentials
- Enable HTTPS for production
- Use a production database (PostgreSQL instead of SQLite)

### Performance
- Backend handles ~1000 concurrent users (SQLite limitation)
- Consider PostgreSQL for larger deployments
- Frontend is fully static and can be served via CDN

### Updates
- Keep the database file when updating
- Replace executable and frontend files
- Test in staging environment first

---

## File Size Estimates

- Backend Executable: ~50-80 MB
- Frontend Build: ~2-5 MB
- Database: ~1-10 MB (depending on data)
- **Total Package: ~55-95 MB**

---

## System Requirements

### Minimum:
- Windows 10 or higher
- 2 GB RAM
- 100 MB disk space
- Internet connection for initial setup

### Recommended:
- Windows 11
- 4 GB RAM
- 500 MB disk space
- LAN connection for multi-user access

---

## Support

For issues or questions:
- Check the troubleshooting section above
- Review log files in the executable directory
- Contact system administrator

---

**Last Updated:** November 2025
**Version:** 1.0.0
