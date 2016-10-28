#!/bin/bash

docker run \
    --rm \
    --volume "$(pwd):/app" \
    --workdir /app \
    choefele/swift \
    swift build -c release --build-path .build/native

mkdir -p .build/lambda/native/LinuxLibraries
cp Shim/index.js .build/lambda
cp .build/native/release/Lambda .build/lambda/native
cp -R Shim/LinuxLibraries .build/lambda/native
cd .build/lambda
zip -r lambda.zip *
cd ../..