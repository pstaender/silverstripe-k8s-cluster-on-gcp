#!/bin/bash

gcloud config set project silverstripe-k8s
gcloud config set compute/zone europe-west3
gcloud config set compute/region europe-west3-a

gcloud container clusters create example --machine-type g1-small --num-nodes=2 --region europe-west3 --node-locations europe-west3-a

echo "Setting up a k8s cluster in gcp"
echo "Hint: creating a cluster with nodes adds costs to your gcp account; please be aware of that"

CLUSTER_NAME="example"
REGION="europe-west3"
MACHINE_TYPE="n1-standard-1" # choose at least n1-standard-1, otherwise the k8s cluster will be unstable
LOCATION="europe-west3-a" # if no location is set, gcp will set up a multizone by default; this may results in > 2x nodes. Thus, set location is recommend to avoid that
NUM_OF_NODES="2"

gcloud container clusters create $CLUSTER_NAME --machine-type $MACHINE_TYPE --num-nodes=$NUM_OF_NODES --region $REGION --node-locations $LOCATIONS

gcloud container clusters list
gcloud container clusters describe $CLUSTER_NAME

echo "To delete the cluster: gcloud container clusters delete $CLUSTER_NAME"

echo "Please ensure that kubectl is installed (https://kubernetes.io/docs/tasks/tools/install-kubectl/)"

kubectl cluster-info
kubectl get nodes

kubectl get all --all-namespaces

kubectl config current-context

echo "Cluster up and running… Now start setup your services and deployments"
