#!/bin/bash

set -Eueo pipefail

if ! kind get clusters | grep ^config-sync-repro$ >/dev/null; then
  kind create cluster --name config-sync-repro
fi

gsutil cat gs://config-management-release/released/1.12.0/config-management-operator.yaml | kubectl apply -f -

kubectl apply -f config-management-setup
