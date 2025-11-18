# Student Routine Deployment

This feature allows you to deploy a read-only view of the class routine that students can access.

## Setup

1. **Install Node.js dependencies for the static server:**
   ```powershell
   cd backend
   npm install
   ```

2. **Start the Student View Server:**
   
   **Option 1: Using VS Code Tasks**
   - Press `Ctrl+Shift+P`
   - Type "Tasks: Run Task"
   - Select "Run Student View Server"

   **Option 2: Using Terminal**
   ```powershell
   cd backend
   node static_server.js
   ```

   **Option 3: Run everything together**
   - Press `Ctrl+Shift+P`
   - Type "Tasks: Run Task"
   - Select "Run Full Stack + Student View"

## How to Deploy

1. Make sure the Student View Server is running on port 6000
2. Go to the Class Routine page in the admin panel
3. Navigate to the "Day-wise Export" tab
4. Click the "🚀 Deploy for Students" button
5. The system will generate a static HTML page with all routine data
6. Students can now access the routine at: **http://localhost:6000**

## Features

- **Read-only access**: Students can only view, not edit
- **Interactive filters**: Students can select Programme → Semester → Class
- **Beautiful UI**: Modern, gradient-based design matching the admin panel
- **Print-friendly**: Students can print the routine
- **Auto-refresh**: Updates when you click Deploy again

## For Network Access

To make the student view accessible on your local network:

1. Find your local IP address:
   ```powershell
   ipconfig
   ```
   Look for "IPv4 Address" (e.g., 192.168.1.100)

2. Students can access using:
   ```
   http://YOUR_IP_ADDRESS:6000
   ```
   Example: `http://192.168.1.100:6000`

3. Make sure Windows Firewall allows port 6000:
   - Open Windows Defender Firewall
   - Click "Advanced settings"
   - Click "Inbound Rules" → "New Rule"
   - Select "Port" → "TCP" → Specific port: 6000
   - Allow the connection

## Troubleshooting

**Port already in use:**
If port 6000 is already in use, you can change it in `backend/static_server.js`:
```javascript
const PORT = 6000; // Change this to another port like 6001
```

**Routine not showing:**
- Make sure you've clicked the "Deploy for Students" button
- Check that the backend server is running
- Refresh the student view page

**Cannot access from other computers:**
- Verify the Student View Server is running
- Check firewall settings
- Make sure all computers are on the same network
