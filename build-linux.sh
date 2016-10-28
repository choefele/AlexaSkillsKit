#!/bin/bash 

docker run \
    --rm \
    --volume "$(pwd):/app" \
    --workdir /app \
    choefele/swift \
    swift test --build-path /.build