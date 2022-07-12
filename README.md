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

  In order to observe this error, you'll have to modify the git config in the sync resources to point to a repo you control, e.g. by [forking this repo](https://github.com/tomasaschan/config-sync-repro/fork) and replacing the repo url with the url to your own:
  ```bash
  # this works with bash on linux. adjust to your os, or manually replace the git url everywhere in the repo to test
  export URL_TO_YOUR_CLONE=https://github.com/your-username/config-sync-repro
  git grep --files-with-matches  https://github.com | xargs -n1 sed -i "s%https://github.com/tomasaschan/config-sync-repro%$URL_TO_YOUR_CLONE%"
  ```
  Once you have done that, push a commit and observe the logs in the `reconciler-manager` pod: there are error logs about not being able to apply a sync resource, which shouldn't happen since there's no overlapping config:
  ```sh
  kubectl logs -n config-management-system -lapp=reconciler-manager -c reconciler-manager -f
  ```
