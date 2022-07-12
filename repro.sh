#!/bin/bash

set -Eueo pipefail

if ! kind get clusters | grep ^config-sync-repro$ >/dev/null; then
  kind create cluster --name config-sync-repro
fi

gsutil cat gs://config-management-release/released/1.12.0/config-management-operator.yaml | kubectl apply -f -

kubectl apply -f setup/config-management.yaml
while ! kubectl get crd rootsyncs.configsync.gke.io >/dev/null 2>&1; do sleep 1; done
kubectl wait crd rootsyncs.configsync.gke.io --for condition=established
kubectl apply -f setup/root-sync.yaml
