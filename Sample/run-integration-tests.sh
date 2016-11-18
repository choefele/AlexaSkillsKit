#!/bin/bash

docker build -t lambda .
docker run --rm -v "$(pwd):/app" -w /app/.build/lambda lambda node -e 'var fs = require("fs");require("./").handler(JSON.parse(fs.readFileSync("../../session_start.json", "utf8")), {}, function(e, r) {if (e) {console.error(e);} else {console.log(r);}});'