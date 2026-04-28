const admin = require('firebase-admin');
const path = require('path');

// Initialize Firebase Admin SDK
try {
  const serviceAccountPath = path.join(__dirname, './serviceAccountKey.json');
  const serviceAccount = require(serviceAccountPath);

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    projectId: serviceAccount.project_id,
  });

  console.log('✅ Firebase Admin SDK initialized successfully');
} catch (error) {
  console.warn('⚠️ Firebase Admin SDK initialization warning:', error.message);
  console.warn('Ensure serviceAccountKey.json exists in backend/config/ for full Firebase integration');
}

module.exports = admin;
