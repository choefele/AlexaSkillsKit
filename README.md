# SwiftServer
Server app with Swift and Docker

[![Build Status](https://travis-ci.org/choefele/swift-server-app.svg?branch=master)](https://travis-ci.org/choefele/swift-server-app)

## Tools
- Xcode
 - Download from [Xcode 8](https://developer.apple.com/download/)
 - Select Xcode 8 as default `sudo xcode-select -s /Applications/Xcode-beta.app/Contents/Developer/`
- `swiftenv` (optional since Swift built into Xcode 8 is the currently the latest version)
 - Install `swiftenv` via [Homebrew](https://swiftenv.fuller.li/en/latest/installation.html#via-homebrew)
 - `swiftenv rehash`, `swiftenv install <version>` (see `.swift-version`)
- Docker
 - Install from [Docker website](https://www.docker.com/products/overview)
 - Consider installing [Kitematic](https://www.docker.com/products/docker-kitematic) to simplify Docker management

## Build & Run with Swift Package Manager
- Run `swift build` in root folder, wait until dependencies have been downloaded and server has been built
- Run dependent services `docker-compose -f docker-compose-dev.yml up`
- Run server `./.build/debug/SwiftServer`
- Test server by executing `curl http://localhost:8090/ping`
- Test DB with `curl -X POST localhost:8090/items`, `curl http://localhost:8090/items`
- Run unit tests with `swift test`

## Build & Run with Xcode
- Run `swift package fetch` in root folder to update dependencies
- Generate Xcode project with `swift package generate-xcodeproj`
- Run dependent services `docker-compose -f docker-compose-dev.yml up`
- Open `SwiftServer.xcodeproj` in Xcode and Run `SwiftServer` scheme
- Test server by executing `curl http://localhost:8090/ping`
- Test DB with `curl -X POST localhost:8090/items`, `curl http://localhost:8090/items`
- Run unit tests with CMD-U

## Build & Run in Docker
- Build image with `docker-compose -f docker-compose-ci.yml build`; tests a run as part of the build process
- Run with `docker-compose -f docker-compose-ci.yml up [-d]` (stop: `docker-compose down [-v]`, logs: `docker-compose logs -f`)
- Test server by executing `curl http://localhost:8090/ping`
- Test DB with `curl -X POST localhost:8090/items`, `curl http://localhost:8090/items`

### Connect `mongo` to database server
- `docker-compose run --rm db mongo mongodb://db` to connect to database
-- `use test`, `db.items.insert({})`, `db.items.find()` to create sample data
- Restart db instance to see that data persists in volume container

### Handle managed volumes
- `docker inspect -f "{{json .Mounts}}" swiftserver_db_1` to find out mount point
- `docker volume ls -f dangling=true` to find orphaned managed volumes
- `docker volume rm $(docker volume ls -qf dangling=true)` to remove orphaned volumes

### Provision on Digital Ocean
- `docker-machine create --driver digitalocean --digitalocean-access-token <token> SwiftServer`
- `eval "$(docker-machine env SwiftServer)"`, `eval "$(docker-machine env -u)"`
- `docker-machine ssh SwiftServer` to ssh into new machine
- Export/import ssh setup: `https://github.com/bhurlow/machine-share`
- `docker compose -f docker-compose-prod.yml up` to start services

## Integration tests
- Install `newman` with `npm install newman --global`
- Run `./run-integration-tests.sh`
