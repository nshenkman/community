#!/bin/sh -l

/go/src/github.com/tidbyt/pixlet/pixlet render /whistle.star email=${WHISTLE_EMAIL} password=${WHISTLE_PASSWORD} pet=${WHISTLE_PET} && /go/src/github.com/tidbyt/pixlet/pixlet push --api-token ${TIDBYT_API_TOKEN} --installation-id Whistle ${TIDBYT_DEVICE_ID} /whistle.webp