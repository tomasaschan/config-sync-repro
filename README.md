# Config Sync Repro

This repo tries to capture a bunch of issues we're currently having with Config Sync, in a way that can be used to reproduce and troubleshoot them.

To run, please follow these instructions:

## Running this repro

This can be done manually, or using this helper script
```sh
./repro.sh
```
which does all of the below setup steps for you.

1. Set up a kind cluster:
   ```sh
   kind create cluster
   ```
   This will automatically switch your kubecontext to the new local cluster.

2. Install Config Sync 1.12
   ```sh
   gsutil cat gs://config-management-release/released/1.12.0/config-management-operator.yaml | kubectl apply -f -
   ```

3. Activate Config Sync
   ```sh
   kubectl apply -f config-management-setup
   ```
