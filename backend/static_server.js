const express = require('express');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = 3001;

// Serve static files from deploy directory
const deployDir = path.join(__dirname, 'deploy');

// Create deploy directory if it doesn't exist
if (!fs.existsSync(deployDir)) {
    fs.mkdirSync(deployDir, { recursive: true });
}

// Serve the index.html file
app.get('/', (req, res) => {
    const indexPath = path.join(deployDir, 'index.html');
    if (fs.existsSync(indexPath)) {
        res.sendFile(indexPath);
    } else {
        res.status(404).send(`
            <!DOCTYPE html>
            <html>
            <head>
                <title>Routine Not Deployed</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        height: 100vh;
                        margin: 0;
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                    }
                    .message {
                        text-align: center;
                        padding: 40px;
                        background: rgba(255,255,255,0.1);
                        border-radius: 15px;
                        backdrop-filter: blur(10px);
                    }
                    h1 { font-size: 3em; margin-bottom: 20px; }
                    p { font-size: 1.2em; }
                </style>
            </head>
            <body>
                <div class="message">
                    <h1>📅 No Routine Deployed Yet</h1>
                    <p>Please deploy a routine from the admin panel first.</p>
                    <p style="margin-top: 20px; font-size: 0.9em; opacity: 0.8;">
                        Go to Class Routine → Day-wise Export → Deploy for Students
                    </p>
                </div>
            </body>
            </html>
        `);
    }
});

// Serve the routine data as JSON
app.get('/data', (req, res) => {
    const dataPath = path.join(deployDir, 'routine_data.json');
    if (fs.existsSync(dataPath)) {
        res.sendFile(dataPath);
    } else {
        res.status(404).json({ error: 'Routine data not found. Please deploy first.' });
    }
});

app.listen(PORT, '0.0.0.0', () => {
    const os = require('os');
    const networkInterfaces = os.networkInterfaces();
    let localIP = 'localhost';
    
    // Find the first non-internal IPv4 address
    for (const interfaceName in networkInterfaces) {
        for (const iface of networkInterfaces[interfaceName]) {
            if (iface.family === 'IPv4' && !iface.internal) {
                localIP = iface.address;
                break;
            }
        }
        if (localIP !== 'localhost') break;
    }
    
    console.log(`\n🚀 Student Routine Server running on port ${PORT}`);
    console.log(`📁 Serving from: ${deployDir}`);
    console.log(`\n✨ Access the routine at:`);
    console.log(`   - Local: http://localhost:${PORT}`);
    console.log(`   - Network: http://${localIP}:${PORT}`);
    console.log(`\n📱 Share the network URL with students on the same network!\n`);
});
