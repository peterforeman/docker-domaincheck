#!/bin/bash

docker build --platform linux/amd64 -t ghcr.io/peterforeman/docker-domaincheck . && \
  docker push ghcr.io/peterforeman/docker-domaincheck