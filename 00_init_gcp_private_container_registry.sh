#!/bin/bash

echo "Setup Container Registry in gcp (Google Cloud Platform)"

export PROJECT=silverstripe-k8s # set here your own project id
export KEY_NAME=gcp-silverstripe-k8s-key
export KEY_DISPLAY_NAME="$PROJECT gcp key"

gcloud iam service-accounts create ${KEY_NAME} --display-name="${KEY_DISPLAY_NAME}"
gcloud iam service-accounts list
gcloud iam service-accounts keys create ${KEY_NAME}.json --iam-account=${KEY_NAME}@${PROJECT}.iam.gserviceaccount.com
gcloud projects add-iam-policy-binding ${PROJECT} --member="serviceAccount:${KEY_NAME}@${PROJECT}.iam.gserviceaccount.com" --role='roles/storage.admin'

echo "Using the credentials to access the registry"
docker login -u _json_key --password-stdin https://gcr.io < ${KEY_NAME}.json

echo "Now you can push via"
echo "docker push gcr.io/${PROJECT}/example-image"
