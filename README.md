# Config Sync Repro

This repo tries to capture a bunch of issues we're currently having with Config Sync, in a way that can be used to reproduce and troubleshoot them.

To run, please follow these instructions:

## 1. Set up a local kind environment

This can be done manually, or using this helper script

```sh
./setup-env.sh # or just kind create cluster
```
which does all of the below setup steps for you.

1.1 Set up a kind cluster:
    ```sh
    kind create cluster
    ```

1.2 Install Config Sync 1.12
    ```sh
    gsutil cat gs://config-management-release/released/1.12.0/config-management-operator.yaml | kubectl apply -f -
    ```
