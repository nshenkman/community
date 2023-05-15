#!/bin/sh -l

/go/src/github.com/tidbyt/pixlet/pixlet render /fi.star email=$6 password=$7 pet=$8 && /go/src/github.com/tidbyt/pixlet/pixlet push --api-token $1 --installation-id Fi $2 -b /fi.webp