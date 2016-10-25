#!/bin/bash 

docker run \
    --rm \
    --volume "$(pwd):/app" \
    --workdir /app \
    smithmicro/swift:3.0 \
    swift test --build-path /.build