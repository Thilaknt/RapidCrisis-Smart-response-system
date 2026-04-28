# 📍 EXACT FILE LOCATIONS & API KEY POSITIONS

## THE ONE FILE YOU NEED TO EDIT:

```
d:\rapid-response-system\backend\.env
```

---

## INSIDE THAT FILE - ADD YOUR 4 API KEYS HERE:

### Line 2: Google Gemini API Key
```env
GEMINI_API_KEY="YOUR_GOOGLE_API_KEY_HERE"
                ↑
        Replace this part
        (Keep the quotes)
```

**Get from:** https://aistudio.google.com/app/apikey

---

### Line 3: Twilio Account SID
```env
TWILIO_ACCOUNT_SID="YOUR_TWILIO_ACCOUNT_SID_HERE"
                   ↑
           Replace this part
           (Keep the quotes)
```

**Get from:** https://www.twilio.com/console
(Look in the dashboard)

---

### Line 4: Twilio Auth Token
```env
TWILIO_AUTH_TOKEN="YOUR_TWILIO_AUTH_TOKEN_HERE"
                   ↑
           Replace this part
           (Keep the quotes)
```

**Get from:** https://www.twilio.com/console
(Below the Account SID)

---

### Line 5: Twilio Phone Number
```env
TWILIO_PHONE_NUMBER="YOUR_TWILIO_PHONE_NUMBER_HERE"
                     ↑
             Replace this part
             (Keep the quotes)
```

**Get from:** https://www.twilio.com/console → Phone Numbers
(Format: +14155552671)

---

## COMPLETE EXAMPLE (What It Should Look Like):

```env
PORT=3000
GEMINI_API_KEY="AIzaSyC_L9dH4p9fK2mQ8rT1wX3yN4vB5cD6"
TWILIO_ACCOUNT_SID="ACa1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p"
TWILIO_AUTH_TOKEN="abcd1234efgh5678ijkl9012mnop3456"
TWILIO_PHONE_NUMBER="+14155552671"
```

---

## STEP-BY-STEP TO EDIT THE FILE:

### Step 1: Open File Explorer
- Windows + E

### Step 2: Navigate to Backend Folder
```
d:\rapid-response-system\backend\
```

### Step 3: Find .env File
- Look for a file named `.env`
- (It should be there - no extension shown)

### Step 4: Open with Notepad
- Right-click on `.env`
- Choose "Open With"
- Select "Notepad"

### Step 5: Replace the 4 Values
- Replace Line 2: Your Gemini API Key
- Replace Line 3: Your Twilio Account SID
- Replace Line 4: Your Twilio Auth Token
- Replace Line 5: Your Twilio Phone Number

### Step 6: Save
- Press Ctrl+S
- Close the file

---

## THEN RUN THESE 2 COMMANDS:

### Terminal 1 (KEEP OPEN):
```powershell
cd d:\rapid-response-system\backend
node server.js
```

### Terminal 2 (NEW WINDOW):
```powershell
cd d:\rapid-response-system\mobile\mobile_app
flutter run
```

---

## THAT'S IT! 🎉

The prototype is now fully functional with:
- ✅ Firebase initialized
- ✅ Backend running
- ✅ Mobile app active
- ✅ All APIs connected
- ✅ Ready to test

**Click the SOS button to start testing!**

---

## REMEMBER:

1. **EDIT:** `d:\rapid-response-system\backend\.env` (Add 4 keys)
2. **RUN:** `node server.js` (Terminal 1)
3. **RUN:** `flutter run` (Terminal 2)
4. **TEST:** Click SOS in app

That's all you need to do! 🚀
