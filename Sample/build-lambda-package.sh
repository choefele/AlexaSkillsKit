#!/bin/bash

SWIFT_VERSION=3.0.1

# Build Swift executable
docker run \
    --rm \
    --volume "$(pwd):/app" \
    --workdir /app \
    smithmicro/swift:$SWIFT_VERSION \
    swift build -c release --build-path .build/native

# Copy libraries necessary to run Swift executable
mkdir -p .build/lambda/native/LinuxLibraries
docker run \
    --rm \
    --volume "$(pwd):/app" \
    --workdir /app \
    smithmicro/swift:$SWIFT_VERSION \
    /bin/bash -c "ldd .build/native/release/Lambda | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' | xargs -i% cp % .build/lambda/native/LinuxLibraries"

# Zip Swift executable, libraries and Node.js shim
cp Shim/index.js .build/lambda
cp .build/native/release/Lambda .build/lambda/native
cd .build/lambda
rm lambda.zip
zip -r lambda.zip *
cd ../..