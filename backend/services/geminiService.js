const axios = require('axios');

class GeminiService {
  constructor() {
    this.apiKey = process.env.GEMINI_API_KEY;
  }

  async analyzeEmergency(message) {
    if (!this.apiKey) {
      console.warn("No Gemini API Key provided, returning mocked response");
      return { severity: 5, analysis: "Mocked analysis due to missing API key." };
    }

    try {
      const apiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${this.apiKey}`;
      const payload = {
        contents: [{
          parts: [{
            text: `Analyze this emergency message and return a severity score from 1-5 (where 5 is highest severity): "${message}". Return strictly a JSON format like: {"severity": 4, "analysis": "brief explanation"}`
          }]
        }]
      };

      const response = await axios.post(apiUrl, payload);
      const textResponse = response.data.candidates[0].content.parts[0].text;
      
      try {
        // Strip out markdown code blocks if gemini returns them
        const cleanedStr = textResponse.replace(/```json/g, '').replace(/```/g, '').trim();
        return JSON.parse(cleanedStr);
      } catch (err) {
        return { severity: 5, analysis: textResponse };
      }

    } catch (error) {
      console.error('Gemini API Error:', error.message);
      return { severity: 5, analysis: "Failed to analyze, assuming worst-case severity." };
    }
  }
}

module.exports = new GeminiService();
