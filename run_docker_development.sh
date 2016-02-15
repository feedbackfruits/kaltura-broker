#!/bin/bash
CURRENT_DIR=`pwd`

if [ -f .env ]; then
  export $(cat .env)
fi

echo 'Starting Kaltura broker in local development mode...'
echo ''
if [[ "Z$FBF_TOKEN" == 'Z' ]]; then
  echo 'Aborting, make sure you have configured the following environment variables first:'
  echo ''
  echo ' - KALTURA_SESSION_EXPIRY - The expiration time of the created sessions, in seconds'
  echo ' - KALTURA_SECRET - The secret used by the university'
  echo ' - KALTURA_USER_ID - The user ID that is attached to the Kaltura secret'
  echo ' - KALTURA_PARTNER_ID - The partner ID that is attached to the Kaltura secret'
  echo ' - FBF_TOKEN - A hidden secret that is only known to FeedbackFruits, in order to lock down this service.'
  echo ''
  exit 1
fi
echo "Mounting current directory: $CURRENT_DIR to /usr/src/app..."
echo ""
echo 'Environment configured to:'
echo "KALTURA_SESSION_EXPIRY: $KALTURA_SESSION_EXPIRY"
echo "KALTURA_SESSION_PRIVILEGES: $KALTURA_SESSION_PRIVILEGES"
echo "KALTURA_SECRET: $KALTURA_SECRET"
echo "KALTURA_USER_ID: $KALTURA_USER_ID"
echo "KALTURA_PARTNER_ID: $KALTURA_PARTNER_ID"
echo "FBF_TOKEN: $FBF_TOKEN"
echo "SSL_KEY=$SSL_KEY"
echo "SSL_CERT=$SSL_CERT"
echo ''
echo 'Connect to: http://localhost:3000'

docker run \
  --rm -it \
  --name kaltura-broker-local \
  -v "$CURRENT_DIR":/usr/src/app \
  -e "KALTURA_SESSION_EXPIRY=$KALTURA_SESSION_EXPIRY" \
  -e "KALTURA_SESSION_PRIVILEGES=$KALTURA_SESSION_PRIVILEGES" \
  -e "KALTURA_SECRET=$KALTURA_SECRET" \
  -e "KALTURA_USER_ID=$KALTURA_USER_ID" \
  -e "KALTURA_PARTNER_ID=$KALTURA_PARTNER_ID" \
  -e "FBF_TOKEN=$FBF_TOKEN" \
  -e "SSL_KEY=$SSL_KEY" \
  -e "SSL_CERT=$SSL_CERT" \
  -p $HTTP_PORT:3000 \
  -p $HTTPS_PORT:3001 \
  kaltura-broker $@
