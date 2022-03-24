#!/usr/bin/env zsh

set -e

if [ $# -ne 1 ]; then
    echo "Usage: ${0} <SCRIPT_NAME>"
    exit 1
fi

# By default, we're assuming you created the extended k6 image as "k6-extended:latest".
# If not, override the name on the command-line with `IMAGE_NAME=...`.
IMAGE_NAME=${IMAGE_NAME:="k6-extended:latest"}

# Each execution is provided a unique `testid` tag to differentiate discrete test runs.
# (Not required, but provided for convenience)
SCRIPT_NAME=$1
TAG_NAME="$(basename -s .js $SCRIPT_NAME)-$(date +%s)"

# This is a basic wrapper to run a clean docker container
#   -v   : we're allowing scripts to be located in the current directory, or any of its children
#   -it  : running interactively
#   --rm : once the script completes, the container will be removed (good housekeeping, you'll thank me)
#
# Anything after the $IMAGE_NAME are passed along for the k6 binary.
docker run -v $PWD:/scripts -it --rm \
    --network="prometheus_k6" \
    -e K6_OUT=output-prometheus-remote \
    -e K6_PROMETHEUS_REMOTE_URL=http://prometheus:9090/api/v1/write \
     $IMAGE_NAME \
    run /scripts/$SCRIPT_NAME --tag testid=$TAG_NAME
