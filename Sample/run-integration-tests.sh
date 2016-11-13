#!/bin/bash

eval "$(aws ecr get-login --region us-east-1 --registry-id 137112412989)"
docker run --rm -v "$(pwd):/lambda" -w /src 137112412989.dkr.ecr.us-east-1.amazonaws.com/amazonlinux:2016.09 /bin/bash -c 'LD_LIBRARY_PATH=/lambda/.build/lambda/native/LinuxLibraries /lambda/.build/lambda/native/Lambda < /lambda/session_start.json'