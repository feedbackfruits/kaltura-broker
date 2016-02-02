# Kaltura broker in order to set-up Kaltura sessions without exposing the Kaltura Secrets to FeedbackFruits
#
# VERSION 1.0.0

FROM node:5-slim
MAINTAINER FeedbackFruits<we@feedbackfruits.com>

LABEL Description="Kaltura broker in order to set-up Kaltura sessions without exposing the Kaltura Secrets to FeedbackFruits" Vendor="FeedbackFruits BV" Version="1.0"

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY ./package.json /usr/src/app/

RUN npm install

COPY ./*.js /usr/src/app/

# Please set the following environment variables in
# order to run the Kaltura Broker server:
# - KALTURA_SECRET - The secret used by the university
# - KALTURA_USER_ID - The user ID that is attached to the Kaltura secret
# - KALTURA_PARTNER_ID - The partner ID that is attached to the Kaltura secret
# - FBF_TOKEN - A hidden secret that is only known to FeedbackFruits, in order to lock down this service.

ENV PORT=3000

CMD ["node", "index.js"]

EXPOSE 3000
