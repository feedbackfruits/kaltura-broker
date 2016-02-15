// Load .env file to provide environment variables, usually for development
// purposes. If not provided, will silently continue.
require('dotenv').config({silent: true});

const http       = require('http'),
      https      = require('https'),
      request    = require('request'),
      express    = require('express');

if (typeof process.env.FBF_TOKEN === 'undefined' || process.env.FBF_TOKEN.length < 32) {
  console.error("Should set environment variable FBF_TOKEN of a length of at least 32 characters");
  process.exit(1);
}

if (typeof process.env.KALTURA_SESSION_EXPIRY === 'undefined') {
  console.warn("No KALTURA_SESSION_EXPIRY set, sessions will not expire!");
}

if (typeof process.env.KALTURA_SESSION_PRIVILEGES === 'undefined') {
  console.warn("No KALTURA_SESSION_PRIVILEGES set, sessions will be unrestricted!");
}

const JSON_FORMAT = 1;
const server = express();

// Add route to /session. This will do a post request to the Kaltura API to
// obtain a valid Kaltura Session Token. Will forward the response to the
// client. The client should provide the valid `x-fbf-token` in the headers. If
// it does not, the connection will be terminated.
server.get('/session', (req, res) => {
  if (req.headers['x-fbf-token'] !== process.env.FBF_TOKEN) return res.status(403).end();

  request.post({
    url: 'http://www.kaltura.com/api_v3/',
    form: {
      service:    'session',
      action:     'start',
      format:     JSON_FORMAT,
      expiry:     process.env.KALTURA_SESSION_EXPIRY,
      privileges: process.env.KALTURA_SESSION_PRIVILEGES,
      secret:     process.env.KALTURA_SECRET,
      userId:     process.env.KALTURA_USER_ID,
      partnerId:  process.env.KALTURA_PARTNER_ID
    }
  }).pipe(res);
});

// Listen on HTTP if provided.
if (typeof process.env.HTTP_PORT === 'undefined') {
  console.warn("No HTTP_PORT set, HTTP will not work!")
} else {
  http.createServer(server).listen(process.env.HTTP_PORT);
  console.info("Listening on", process.env.HTTP_PORT, "for HTTP");
}

// Listen on HTTPS if provided.
if (typeof process.env.HTTPS_PORT === 'undefined' ||
    typeof process.env.SSL_KEY === 'undefined' ||
    typeof process.env.SSL_CERT === 'undefined') {
  console.warn("No valid HTTPS parameters (HTTPS_PORT, SSL_KEY, SSL_CERT) set, HTTPS will not work!");
} else {
  https.createServer({
    key: process.env.SSL_KEY,
    cert: process.env.SSL_CERT
  }, server).listen(process.env.HTTPS_PORT);
  console.info("Listening on", process.env.HTTPS_PORT, "for HTTPS");
}

console.info("Server started");
