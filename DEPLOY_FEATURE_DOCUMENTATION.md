# 🚀 Deploy Button Feature - Complete Guide

## Overview
The deploy button creates a static, read-only web page that runs on port 6000, allowing students to view class routines without being able to edit them.

## Files Created/Modified

### Frontend Changes
**File:** `frontend/src/pages/ClassRoutine.jsx`
- Added "🚀 Deploy for Students" button in the Day-wise Export tab
- Added `handleDeploy()` function that:
  - Fetches all classes, subjects, teachers, routines, days, and periods
  - Sends data to backend `/api/deploy/static-page` endpoint
  - Shows success message with link to student view
  - Auto-opens the student page in a new tab

### Backend Changes
**File:** `backend/app/api/routes/deploy.py` (NEW)
- Created FastAPI router for deployment
- `/api/deploy/static-page` endpoint that:
  - Receives routine data
  - Creates `deploy/` directory
  - Saves data as `routine_data.json`
  - Generates beautiful HTML page with interactive filters
  - Returns success response

**File:** `backend/app/main.py`
- Added import for deploy router
- Registered deploy router at `/api/deploy`

### Static Server
**File:** `backend/static_server.js` (NEW)
- Express.js server running on port 6000
- Serves index.html from deploy directory
- Provides `/data` endpoint for routine JSON
- Shows friendly message if no routine deployed yet

**File:** `backend/package.json` (NEW)
- Node.js dependencies (express)
- Start script for static server

### Setup Files
**File:** `.vscode/tasks.json`
- Added "Run Student View Server" task
- Added "Run Full Stack + Student View" task

**File:** `start-student-server.bat` (NEW)
- Windows batch file for easy server startup
- Double-click to start the student server

**File:** `STUDENT_DEPLOYMENT.md` (NEW)
- Complete setup and usage instructions
- Troubleshooting guide
- Network access configuration

## How It Works

### 1. Deployment Flow
```
Admin clicks Deploy → Frontend gathers data → Backend receives data → 
Backend creates HTML + JSON → Saves to deploy/ folder → 
Server serves to students on port 6000
```

### 2. Student View Features
- **Interactive Filters**: Programme → Semester → Class selection
- **Beautiful UI**: Gradient design matching admin panel
- **Color Coding**: 
  - Lab sessions: Light blue background with LAB badge
  - Break: Yellow background
  - Library Consultation: Light blue background
- **Responsive**: Works on desktop and mobile
- **Print-friendly**: Students can print the routine
- **Real-time**: Updates immediately when admin clicks Deploy

### 3. Technology Stack
- **Frontend**: React (admin) + Vanilla JavaScript (student view)
- **Backend API**: FastAPI (Python)
- **Static Server**: Express.js (Node.js)
- **Data Format**: JSON for data transfer, HTML for display

## Setup Instructions

### Quick Start
1. **Install Node.js dependencies:**
   ```powershell
   cd backend
   npm install
   ```

2. **Start the student server:**
   - **Easy way**: Double-click `start-student-server.bat`
   - **Manual way**: `cd backend && node static_server.js`
   - **VS Code way**: Run Task → "Run Student View Server"

3. **Deploy the routine:**
   - Open admin panel (http://localhost:3000)
   - Go to Class Routine → Day-wise Export tab
   - Click "🚀 Deploy for Students"
   - Student view opens automatically at http://localhost:6000

### Network Access (for students on local network)

1. Find your computer's IP address:
   ```powershell
   ipconfig
   ```
   Look for "IPv4 Address" (e.g., 192.168.1.100)

2. Share this URL with students:
   ```
   http://YOUR_IP:6000
   ```
   Example: `http://192.168.1.100:6000`

3. Configure Windows Firewall (if needed):
   - Windows Security → Firewall & network protection
   - Advanced settings → Inbound Rules → New Rule
   - Port → TCP → Port 6000 → Allow connection

## Usage for Admin

1. **First time setup:**
   - Run `npm install` in backend folder
   - Start student server using `start-student-server.bat`

2. **Daily usage:**
   - Make changes to routine in admin panel
   - Click "🚀 Deploy for Students" when ready
   - Students see updated routine immediately

3. **Running all servers:**
   - VS Code → Run Task → "Run Full Stack + Student View"
   - This starts backend + frontend + student server

## Usage for Students

1. **Access the page:**
   - Open browser
   - Go to `http://localhost:6000` (or network IP)

2. **View routine:**
   - Select Programme (e.g., BCE)
   - Select Year/Part (e.g., I/I)
   - Select Class (e.g., BCE I/I A)
   - Routine table appears automatically

3. **Features available:**
   - View all subjects with timings
   - See teacher assignments
   - Check room numbers
   - Identify lab sessions (blue highlight)
   - Print the routine (Ctrl+P)

## Architecture

### Directory Structure
```
backend/
├── app/
│   └── api/
│       └── routes/
│           └── deploy.py          # Deployment endpoint
├── deploy/                         # Auto-created
│   ├── index.html                 # Student view page
│   └── routine_data.json          # Routine data
├── static_server.js               # Express server (port 6000)
└── package.json                   # Node dependencies

frontend/
└── src/
    └── pages/
        └── ClassRoutine.jsx       # Deploy button + handler
```

### API Endpoints

**POST /api/deploy/static-page**
- Request: JSON with classes, subjects, teachers, routines, days, periods
- Response: `{ success: true, message: "...", url: "http://localhost:6000" }`
- Action: Creates HTML + JSON files in deploy/ folder

**GET http://localhost:6000/**
- Serves index.html (student view)

**GET http://localhost:6000/data**
- Serves routine_data.json

## Security Considerations

1. **Read-only Access**: Student view is pure HTML/JS, no editing capability
2. **No Authentication**: Currently open access (suitable for local network)
3. **Port Isolation**: Student server (6000) separate from admin (3000)
4. **Data Validation**: Backend validates data before deployment

## Future Enhancements (Optional)

- [ ] Add password protection for student view
- [ ] Allow students to export their class routine as PDF
- [ ] Add search functionality for teachers/subjects
- [ ] Show teacher availability/schedule
- [ ] Add dark mode toggle
- [ ] Cache student selections in localStorage
- [ ] Add QR code for easy mobile access
- [ ] Deploy to cloud (Vercel, Netlify) for external access

## Troubleshooting

### Port 6000 already in use
**Error:** `EADDRINUSE: address already in use :::6000`
**Solution:** Change PORT in `static_server.js` to 6001 or kill existing process

### Cannot access from other computers
**Check:**
1. Student server is running (`node static_server.js`)
2. Windows Firewall allows port 6000
3. All computers on same network
4. Using correct IP address

### Routine not showing
**Check:**
1. Deployed at least once using "Deploy for Students" button
2. Backend server is running
3. `deploy/routine_data.json` exists
4. Refresh student page (Ctrl+F5)

### Import errors in VS Code
**Ignore:** Python import errors in `deploy.py` - packages exist in virtual environment

## Testing Checklist

- [✓] npm install completes successfully
- [✓] Static server starts on port 6000
- [✓] Deploy button appears in UI
- [✓] Deploy creates index.html and routine_data.json
- [✓] Student view loads at localhost:6000
- [✓] Filters work (Programme → Semester → Class)
- [✓] Routine displays correctly
- [✓] Lab sessions show blue background
- [✓] Print functionality works
- [✓] Accessible from local network

## Support

For issues or questions:
1. Check STUDENT_DEPLOYMENT.md
2. Review console logs (F12 in browser)
3. Check terminal output for errors
4. Verify all servers are running

---

**Deployment is now complete!** 🎉
Students can access the routine at **http://localhost:6000**
