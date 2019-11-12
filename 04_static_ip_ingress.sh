#!/bin/bash

echo "Setting up ingress with static IP"
echo "Source: https://github.com/kelseyhightower/ingress-with-static-ip"

gcloud compute addresses create kubernetes-ingress --global

export INGRESS_IP_ADDRESS=$(gcloud compute addresses describe kubernetes-ingress --global --format='value(address)')

echo "Ingress public IP Address: $INGRESS_IP_ADDRESS"
