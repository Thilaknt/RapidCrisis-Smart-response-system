const express = require('express');
const router = express.Router();
const geminiService = require('../services/geminiService');
const twilioService = require('../services/twilioService');

// POST /api/alerts/analyze
router.post('/analyze', async (req, res) => {
    try {
        const { message } = req.body;
        if (!message) return res.status(400).json({ error: 'Message requires payload' });
        
        const analysis = await geminiService.analyzeEmergency(message);
        return res.json(analysis);
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
});

// POST /api/alerts/notify
router.post('/notify', async (req, res) => {
    try {
        const { phone, body } = req.body;
        if (!phone || !body) return res.status(400).json({ error: 'Phone and body missing' });
        
        const success = await twilioService.sendSMS(phone, body);
        return res.json({ success });
    } catch (error) {
        return res.status(500).json({ error: error.message });
    }
});

// POST /api/alerts/ (Standard app submit logic with inline AI analysis)
router.post('/', async (req, res) => {
    try {
        const alertData = req.body;
        
        // Enhance incoming alert with local severity scoring via backend AI
        const analysis = await geminiService.analyzeEmergency(alertData.message || 'Emergency trigger without context.');
        alertData.severity = analysis.severity || 5;

        alertData.id = 'api_' + Date.now();
        res.status(201).json(alertData);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
