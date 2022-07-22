#!/bin/bash

docker build --platform linux/amd64 -t ghcr.io/peterforeman/domaincheck . && \
  docker push ghcr.io/peterforeman/domaincheck