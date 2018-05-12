#!/bin/bash
set -ex
USERNAME=kj54321
# image name
IMAGE=forticlient
docker build -t $USERNAME/$IMAGE:latest .
