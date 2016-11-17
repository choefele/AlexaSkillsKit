#!/bin/bash

# Build Swift executable
docker run \
    --rm \
    --volume "$(pwd):/app" \
    --workdir /app \
    smithmicro/swift:3.0 \
    swift build -c release --build-path .build/native

# Copy libraries necessary to run Swift executable
mkdir -p .build/lambda/native/LinuxLibraries
docker run \
    --rm \
    --volume "$(pwd):/app" \
    --workdir /app \
    smithmicro/swift:3.0 \
    /bin/bash -c "ldd .build/native/release/Lambda | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' | xargs -i% cp % .build/lambda/native/LinuxLibraries"

# Zip Swift executable, libraries and shim
cp Shim/index.js .build/lambda
cp .build/native/release/Lambda .build/lambda/native
cd .build/lambda
rm lambda.zip
zip -r lambda.zip *
cd ../..