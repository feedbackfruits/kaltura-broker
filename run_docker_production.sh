#!/bin/bash
CURRENT_DIR=`pwd`

echo 'Starting Kaltura broker in production...'
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
echo 'Environment configured.'
echo ''
echo 'Connect to: http://localhost:3000'

docker run \
  --rm \
  --name kaltura-broker \
  -e "KALTURA_SESSION_EXPIRY=$KALTURA_SESSION_EXPIRY" \
  -e "KALTURA_SECRET=$KALTURA_SECRET" \
  -e "KALTURA_USER_ID=$KALTURA_USER_ID" \
  -e "KALTURA_PARTNER_ID=$KALTURA_PARTNER_ID" \
  -e "FBF_TOKEN=$FBF_TOKEN" \
  --publish=3000:3000 \
  kaltura-broker $@
