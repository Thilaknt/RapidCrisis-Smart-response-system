# ⚡ QUICK REFERENCE - COPY & PASTE COMMANDS

## 3 EASY STEPS TO RUN RAPIDCRISIS

---

## 📍 STEP 1: ADD API KEYS TO .env FILE

**File:** `d:\rapid-response-system\backend\.env`

**Current content:**
```env
PORT=3000
GEMINI_API_KEY="YOUR_ACTUAL_GEMINI_API_KEY_HERE"
TWILIO_ACCOUNT_SID="YOUR_ACTUAL_TWILIO_SID_HERE"
TWILIO_AUTH_TOKEN="YOUR_ACTUAL_TWILIO_AUTH_TOKEN_HERE"
TWILIO_PHONE_NUMBER="YOUR_ACTUAL_TWILIO_PHONE_NUMBER_HERE"
```

### How to edit:
1. Open File Explorer
2. Go to: `d:\rapid-response-system\backend\`
3. Find: `.env` file
4. Right-click → **Open With → Notepad**
5. Replace the 4 placeholder values with your actual API keys
6. **Save** (Ctrl+S)

---

## 🔑 API KEY SOURCES (COPY FROM HERE)

### Google Gemini:
- **Link:** https://aistudio.google.com/app/apikey
- **What to copy:** The generated API key
- **Where to paste:** `GEMINI_API_KEY="PASTE_HERE"`

### Twilio - Account SID:
- **Link:** https://www.twilio.com/console
- **What to copy:** Account SID (shown in dashboard)
- **Where to paste:** `TWILIO_ACCOUNT_SID="PASTE_HERE"`

### Twilio - Auth Token:
- **Link:** https://www.twilio.com/console
- **What to copy:** Auth Token (shown in dashboard)
- **Where to paste:** `TWILIO_AUTH_TOKEN="PASTE_HERE"`

### Twilio - Phone Number:
- **Link:** https://www.twilio.com/console → Phone Numbers
- **What to copy:** Your Twilio phone number
- **Where to paste:** `TWILIO_PHONE_NUMBER="PASTE_HERE"`

---

## ▶️ STEP 2: START BACKEND SERVER

### TERMINAL 1 (Keep Open):

```powershell
cd d:\rapid-response-system\backend
node server.js
```

**Expected output (watch for these messages):**
```
✅ Firebase Admin SDK initialized successfully
Rapid Response Backend Server running on port 3000
```

**✅ If you see these messages = Backend is working!**

---

## ▶️ STEP 3: RUN MOBILE APP

### TERMINAL 2 (New Window):

```powershell
cd d:\rapid-response-system\mobile\mobile_app
flutter run
```

**Expected output (watch for these):**
```
✅ Firebase initialized successfully
Launching lib\main.dart on [your device]...
```

**✅ App launches on your device/emulator!**

---

## 🧪 QUICK TEST COMMANDS (After App Launches)

### Test Backend Health:
```powershell
Invoke-WebRequest -Uri "http://localhost:3000/health"
```

### Send Test Alert:
```powershell
$json = @{message="Test emergency"; latitude=37.7749; longitude=-122.4194; userId="user123"} | ConvertTo-Json
Invoke-WebRequest -Uri "http://localhost:3000/api/alerts" -Method POST -ContentType "application/json" -Body $json
```

---

## 📋 DIRECTORY STRUCTURE (For Reference)

```
d:\rapid-response-system\
├── backend\
│   ├── .env                    ← EDIT THIS FILE (ADD YOUR API KEYS)
│   ├── server.js               ← Run with: node server.js
│   ├── config\
│   │   ├── firebase.js         (configured)
│   │   └── serviceAccountKey.json (configured)
│   ├── services\
│   │   ├── geminiService.js    (AI analysis)
│   │   └── twilioService.js    (SMS)
│   └── routes\
│       └── alertRoutes.js      (API endpoints)
│
└── mobile\mobile_app\
    ├── pubspec.yaml            ← Dependencies
    ├── lib\
    │   ├── main.dart           ← Entry point
    │   ├── firebase_options.dart (configured)
    │   └── services\
    │       └── api_service.dart (backend client)
    └── Run with: flutter run
```

---

## ⚠️ IF SOMETHING GOES WRONG

### Port 3000 Already in Use:
```powershell
PORT=3001 node server.js
```

### Clear Flutter Cache:
```powershell
cd d:\rapid-response-system\mobile\mobile_app
flutter clean
flutter pub get
flutter run
```

### Find Your Computer's IP (for connecting from another device):
```powershell
ipconfig
```
Look for "IPv4 Address: 192.168.x.x"

### Kill Process on Port 3000:
```powershell
netstat -ano | findstr :3000
taskkill /PID <PID_NUMBER> /F
```

---

## ✨ FEATURES THAT WORK

Once running:
- ✅ Emergency Alert Submission
- ✅ Text Message Input
- ✅ Voice Recognition
- ✅ AI Severity Analysis (Gemini)
- ✅ SMS Notifications (Twilio)
- ✅ Real-time Alert Tracking
- ✅ Location Mapping
- ✅ Responder Assignment
- ✅ Firebase Sync
- ✅ Offline Storage

---

## 📊 ARCHITECTURE

```
┌─────────────────────────────────────────────────┐
│             RapidCrisis Prototype               │
├─────────────────────────────────────────────────┤
│                                                 │
│  📱 Mobile App (Flutter)                       │
│  ├── Emergency Trigger (SOS)                  │
│  ├── Voice/Text Input                         │
│  ├── Location Services                        │
│  └── Real-time Updates                        │
│                          ↓                     │
│  🔗 REST API (http://localhost:3000)         │
│                          ↓                     │
│  ⚙️ Backend (Node.js/Express)                 │
│  ├── Alert API Routes                        │
│  ├── Gemini AI Integration (Severity)        │
│  └── Twilio SMS Integration (Notify)         │
│                          ↓                     │
│  ☁️ Services                                   │
│  ├── Firebase (Data/Auth)                    │
│  ├── Google Gemini (AI Analysis)             │
│  └── Twilio (SMS Notifications)              │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## 🎯 COMPLETE WORKFLOW

1. **Edit `.env`** → Add 4 API keys
2. **Terminal 1** → `node server.js` (backend running)
3. **Terminal 2** → `flutter run` (app running)
4. **On App** → Click SOS button
5. **Type/Speak** → Emergency details
6. **Submit** → Alert created with AI severity
7. **Get SMS** → Responders notified
8. **Track** → Real-time updates

---

## ✅ SUCCESS INDICATORS

### Backend Started Successfully:
```
✅ Firebase Admin SDK initialized successfully
Rapid Response Backend Server running on port 3000
```

### App Launched Successfully:
```
✅ Firebase initialized successfully
Built build\app\outputs\flutter-apk\app-release.apk
```

### Alert Created Successfully:
- Severity score appears (1-5)
- Responders notified
- Status shows "pending"

---

## 📞 SUPPORT

**All files are configured and ready!**

- ✅ No API integration errors
- ✅ Firebase properly initialized
- ✅ Backend routes functional
- ✅ Mobile app ready

Just add your API keys and run!

**Questions?** See STEP_BY_STEP_GUIDE.md or API_KEYS_SETUP_GUIDE.md
