// Load .env file
require('dotenv').config({silent: true});

const request    = require('request'),
      express    = require('express');

const JSON_FORMAT = 1;
const server = express();

if (typeof process.env.FBF_TOKEN === 'undefined' || process.env.FBF_TOKEN.length < 32) {
  console.error("Should set environment variable FBF_TOKEN of a length of at least 32 characters");
  process.exit(1);
}

if (typeof process.env.KALTURA_SESSION_EXPIRY === 'undefined') {
  console.warn("No KALTURA_SESSION_EXPIRY set, sessions will not expire!")
}

server.get('/session', (req, res) => {
  if (req.headers['x-fbf-token'] !== process.env.FBF_TOKEN) return res.status(403).end();

  request.post({
    url: 'http://www.kaltura.com/api_v3/',
    form: {
      service: 'session',
      action: 'start',
      format: JSON_FORMAT,
      expiry: process.env.KALTURA_SESSION_EXPIRY,
      secret: process.env.KALTURA_SECRET,
      userId: process.env.KALTURA_USER_ID,
      partnerId: process.env.KALTURA_PARTNER_ID
    }
  }).pipe(res);
});

server.listen(process.env.PORT);
console.info("Server started, listening on port", process.env.PORT);
