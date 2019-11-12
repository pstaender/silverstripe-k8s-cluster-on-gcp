#!/bin/bash

SERVICE='silverstripe-test' # optional: replace with your own service name
PROJECT='silverstripe-k8s' # replace with your own project

echo "This script automatic builds, pushes and applies the latest image"

docker build -t gcr.io/$PROJECT/$SERVICE:latest .
docker push gcr.io/$PROJECT/$SERVICE:latest > docker_image_build.log
DOCKER_COMMIT=$(cat docker_image_build.log|tail -n1|sed 's/.*digest: //g'|sed 's/ .*//g')

kubectl set image deploy/$SERVICE $SERVICE=gcr.io/silverstripe-k8s/silverstripe-test@$DOCKER_COMMIT
