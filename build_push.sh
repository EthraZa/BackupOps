#!/bin/bash

if [ -z "$1" ]; then
    echo " Usage: build_push.sh user/build [tag=latest] "
    echo ""
    echo "  ie. build_push.sh ethraza/backops 1.0.0 "
    exit 1
fi

if [ -z "$2" ]; then
    2="latest"
fi

docker login
docker build . --pull --compress -t ethraza/backops:$1 -t ethraza/backops:latest
docker push ethraza/backops:$1
docker push ethraza/backops:latest
