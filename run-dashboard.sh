#!/usr/bin/env zsh

set -e

if [ $# -ne 1 ]; then
    echo "Usage: ${0} <SCRIPT_NAME>"
    exit 1
fi

# Each execution is provided a unique `testid` tag to differentiate discrete test runs.
# (Not required, but provided for convenience)
SCRIPT_NAME=$1
TAG_NAME="$(basename -s .js $SCRIPT_NAME)-$(date +%s)"

# Unlike our other examples, we're running a native binary we built. ¿Por que? 
# Unfortunately, with Docker, I was encountering some network issues with the 
# built-in url that I was being too lazy to dig into. :)
open http://localhost:5665/
./k6 run $SCRIPT_NAME \
    --tag testid=$TAG_NAME \
    --out dashboard
