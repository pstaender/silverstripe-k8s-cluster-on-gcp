#!/bin/bash

echo "Builds and pushes the docker image (as latest) to registry"

docker build -t gcr.io/silverstripe-k8s/silverstripe-test:latest .
docker push gcr.io/silverstripe-k8s/silverstripe-test:latest

