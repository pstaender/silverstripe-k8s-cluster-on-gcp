#!/bin/bash

echo "Initial setup of helm on local machine"

curl -L https://git.io/get_helm.sh | bash
helm init --service-account tiller --history-max 200

echo "Apply authentication for helm/tiller on the k8s cluster"

kubectl apply -f k8s/helm-rbac.yml

echo "check tiller"
kubectl get deployment tiller-deploy -n kube-system

echo "install redis for example"
helm repo update
helm install stable/redis --set usePassword=false
