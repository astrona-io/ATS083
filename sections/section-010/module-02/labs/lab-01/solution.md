---
draft: true
exam_objectives:
- Installing and Configuring CNI Plugins
---
# Install Flannel On A Cluster Without A Network Plugin: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-010-02-01)"
```

## Step 1: Install flannel

The manifest creates the namespace `kube-flannel`, the roles, the ConfigMap and the DaemonSet. The DaemonSet pods use the node network, so they start even though the nodes are `NotReady`.

```sh
kubectl apply -f https://github.com/flannel-io/flannel/releases/download/v0.28.10/kube-flannel.yml
kubectl -n kube-flannel rollout status daemonset/kube-flannel-ds --timeout=300s
```

## Step 2: Wait for the nodes and CoreDNS

When the init container `install-cni` has written the configuration file, the runtime reports a ready network and the nodes become `Ready`. CoreDNS then starts.

```sh
kubectl wait --for=condition=Ready nodes --all --timeout=180s
kubectl -n kube-system rollout status deployment/coredns --timeout=300s
```

## Step 3: Start the check pod

The pod runs on the worker node and receives an address from the range of that node.

```sh
kubectl -n default run check-a --image=curlimages/curl:8.22.0 --restart=Never --command -- sleep 3600
kubectl -n default wait --for=condition=Ready pod/check-a --timeout=120s
kubectl -n default get pod check-a -o wide
```

The address in the output starts with `10.244.`.

Submit with `astrona submit -c sections/section-010/module-02/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-010-02-01`.

## Common pitfalls

> [!WARNING]
> If `kubectl get nodes` still shows `NotReady` right after the apply, wait: the nodes change after the init container has copied the file. If the pod `check-a` stays `Pending`, a node is still `NotReady`. If you edit the manifest, the grader fails the image check.
