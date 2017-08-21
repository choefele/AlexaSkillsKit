#!/bin/bash 

set -e

SWIFT_VERSION=$(<.swift-version)

docker run \
    --rm \
    --volume "$(pwd):/app" \
    --workdir /app \
    swift:$SWIFT_VERSION \
    swift test --build-path /.build