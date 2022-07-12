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
   kubectl apply -f setup/config-management.yaml
   ```

4. Once Config Sync has created the `RootSync` CRD in the cluster, create one that points to the `resources/level-1` folder of this repo. That will create a chain of resources, and start reproducing some of the errors.
   ```sh
   kubectl apply -f setup/root-sync.yaml
   ```

## Observing errors

* Resource fights about nested syncs happen whenever there is a new commit.
  After running for a while, Config Sync apparently starts fighting with itself over resources. Observe the logs in the `reconciler-manager` pod: there are error logs about not being able to apply a sync resource, which shouldn't happen since there's no overlapping config:
  ```sh
  kubectl logs -n config-management-system -lapp=reconciler-manager -c reconciler-manager -f
  ```
