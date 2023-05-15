#!/bin/sh -l

/go/src/github.com/tidbyt/pixlet/pixlet render /whistle.star email=$3 password=$4 pet=$5 && /go/src/github.com/tidbyt/pixlet/pixlet push --api-token $1 --installation-id Whistle $2 -b /whistle.webp
/go/src/github.com/tidbyt/pixlet/pixlet render /fi.star email=$6 password=$7 pet=$8 && /go/src/github.com/tidbyt/pixlet/pixlet push --api-token $1 --installation-id Fi $2 -b /fi.webp