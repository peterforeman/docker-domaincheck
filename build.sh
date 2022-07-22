#!/bin/bash

docker build -t ghcr.io/peterforeman/domaincheck . && \
  docker push ghcr.io/peterforeman/domaincheck