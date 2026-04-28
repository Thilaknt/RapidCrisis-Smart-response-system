const axios = require('axios');

class TwilioService {
  constructor() {
    this.accountSid = process.env.TWILIO_ACCOUNT_SID;
    this.authToken = process.env.TWILIO_AUTH_TOKEN;
    this.fromNumber = process.env.TWILIO_PHONE_NUMBER;
  }

  async sendSMS(to, body) {
    if (!this.accountSid || !this.authToken) {
      console.warn("No Twilio credentials provided, skipping SMS transmission.");
      return false;
    }

    try {
      const url = `https://api.twilio.com/2010-04-01/Accounts/${this.accountSid}/Messages.json`;
      const params = new URLSearchParams({
        To: to,
        From: this.fromNumber,
        Body: body
      });

      const response = await axios.post(url, params.toString(), {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Basic ' + Buffer.from(`${this.accountSid}:${this.authToken}`).toString('base64')
        }
      });
      console.log(`SMS Sent. ID: ${response.data.sid}`);
      return true;
    } catch (error) {
      console.error('Twilio Error:', error.response ? error.response.data : error.message);
      return false;
    }
  }
}

module.exports = new TwilioService();
