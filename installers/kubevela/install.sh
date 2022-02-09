#/bin/bash

helm repo add kubevela https://charts.kubevela.net/core
helm repo update
helm install --create-namespace -n vela-system --set admissionWebhooks.certManager.enabled=true kubevela kubevela/vela-core  --version 1.2.2 --wait