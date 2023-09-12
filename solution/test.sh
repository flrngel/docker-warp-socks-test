#!/bin/bash

docker-compose up -d --build
sleep 20

assert() {
  if ! "$@"; then
    echo "Assertion failed: $*"
    exit 1
  fi
}

echo "Testing with proxy"
with_proxy=`docker-compose exec -it curl curl static-file-server:8080`
echo "with proxy: $with_proxy"; echo ""; echo ""

echo "Testing without proxy"
without_proxy=`docker-compose exec -it curl curl -x socks5h://warp-socks:9091 static-file-server:8080`
echo "without proxy: $without_proxy"; echo ""; echo ""

assert [ "$with_proxy" = "$without_proxy" ]

docker-compose down
