#!/bin/bash

docker run \
    --rm \
    --volume "$(pwd):/app" \
    --workdir /app \
    smithmicro/swift:3.0 \
    swift build -c release --build-path .build/native

#rm -R Shim/LinuxLibraries/* 
#docker run \
#    --rm \
#    --volume "$(pwd):/app" \
#    smithmicro/swift:3.0 \
#    /bin/bash -c "ldd /app/.build/native/release/Lambda | grep so | sed -e '/^[^\t]/ d' | sed -e 's/\t//' | sed -e 's/.*=..//' | sed -e 's/ (0.*)//' | xargs -i% cp % /app/Shim/LinuxLibraries"

mkdir -p .build/lambda/native/LinuxLibraries
rm -R .build/lambda/native/LinuxLibraries/*
cp Shim/index.js .build/lambda
cp .build/native/release/Lambda .build/lambda/native
cp -R Shim/LinuxLibraries .build/lambda/native
cd .build/lambda
rm lambda.zip
zip -r lambda.zip *
cd ../..