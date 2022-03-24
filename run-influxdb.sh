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
    --network="influxdb_k6" \
    -e K6_OUT=xk6-influxdb=http://influxdb:8086 \
    -e K6_INFLUXDB_ORGANIZATION=k6io \
    -e K6_INFLUXDB_BUCKET=demo \
    -e K6_INFLUXDB_INSECURE=true \
    -e K6_INFLUXDB_TOKEN=EEKpryGZk8pVDXmIuy484BKUxM5jOEDv7YNoeNZUbsNbpbPbP6kK_qY9Zsyw7zNnlZ7pHG16FYzNaqwLMBUz8g== \
     $IMAGE_NAME \
    run /scripts/$SCRIPT_NAME --tag testid=$TAG_NAME
