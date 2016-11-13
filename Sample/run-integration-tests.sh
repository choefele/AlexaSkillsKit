#!/bin/bash

eval "$(aws ecr get-login --region us-east-1 --registry-id 137112412989)"
docker run --rm -v "$(pwd):/lambda" -w /lambda 137112412989.dkr.ecr.us-east-1.amazonaws.com/amazonlinux:2016.09 /bin/bash -c 'LD_LIBRARY_PATH=.build/lambda/native/LinuxLibraries .build/lambda/native/Lambda < session_start.json'