# Kaltura Broker
A session broker to create and pass on Kaltura Sessions (KSs) in order to avoid exposing the Kaltura secret to third parties.

Licensed under the MIT License, see License file.

## Configuration
The service needs a number of configuration options to work correctly. For starters, the following parameters must be set for the broker to work.
- `KALTURA_SECRET` - The secret used by the university
- `KALTURA_USER_ID` - The user ID that is attached to the Kaltura secret
- `KALTURA_PARTNER_ID` - The partner ID that is attached to the Kaltura secret
- `FBF_TOKEN` - A hidden secret that is only known to FeedbackFruits, in order to lock down this service. Must be at least 32 characters.

### HTTP
To support HTTP, set the `HTTP_PORT` environment variable.

### HTTPS
To support HTTPS, set the `HTTPS_PORT`, `SSL_KEY` and `SSL_CERT` environment variables.

### Session limiting
#### Expiration
To set the expiration time of the session token, set `KALTURA_SESSION_EXPIRY`. For example: `86400` for 24 hours.

#### Privileges
To only allow the created session tokens a limited amount of functionality, set `KALTURA_SESSION_PRIVILEGES`. See http://knowledge.kaltura.com/kalturas-api-authentication-and-security#privileges. For example: `list:*,download:*,sview:*,sviewplaylist:*` to only allow downloading, listing and viewing.

## Building
Run `./build_docker.sh`

## Running
Run `./run_docker_production.sh` in production, or `./run_docker_development.sh` for development purposes.

## Usage
Do a `GET` on `http://SERVICE_URL:3000/session` with the `X-FBF-TOKEN` header set to the configured `FBF_TOKEN`.
If the provided token is incorrect, the service will respond with a 403 (Forbidden).
If all is well, the service will `POST` to `http://www.kaltura.com/api_v3/?service=session&action=start&format=1&secret=KALTURA_SECRET&userId=KALTURA_USER_ID&partnerId=KALTURA_PARTNER_ID`, and pass on the response.
