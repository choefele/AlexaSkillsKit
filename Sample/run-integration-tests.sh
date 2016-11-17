#!/bin/bash

eval "$(aws ecr get-login --region us-east-1 --registry-id 137112412989)"
docker run --rm -v "$(pwd):/app" -w /app 137112412989.dkr.ecr.us-east-1.amazonaws.com/amazonlinux:2016.09 /bin/bash -c '.build/lambda/native/LinuxLibraries/ld-linux-x86-64.so.2 --library-path .build/lambda/native/LinuxLibraries .build/lambda/native/Lambda < session_start.json'