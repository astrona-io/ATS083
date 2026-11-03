---
draft: true
exam_objectives:
- Installing and Configuring CNI Plugins
---
# CNI Installation Capstone: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-010-cap)"
```

## Step 1: Install flannel and wait for the nodes

The DaemonSet pods use the node network, so they run on `NotReady` nodes and copy the CNI file. The nodes become `Ready` afterwards.

```sh
kubectl apply -f https://github.com/flannel-io/flannel/releases/download/v0.28.10/kube-flannel.yml
kubectl -n kube-flannel rollout status daemonset/kube-flannel-ds --timeout=300s
kubectl wait --for=condition=Ready nodes --all --timeout=180s
```

## Step 2: Read the values

The init container `install-cni` runs `cp -f <source> <target>`, so the target is the argument with index 2. The backend type is the `"Type"` line in `net-conf.json`. The node count comes from the `Ready` condition of each node.

```sh
conf_file="$(kubectl -n kube-flannel get daemonset kube-flannel-ds -o jsonpath='{.spec.template.spec.initContainers[?(@.name=="install-cni")].args[2]}')"
conf_file="${conf_file##*/}"
backend_type="$(kubectl -n kube-flannel get configmap kube-flannel-cfg -o jsonpath='{.data.net-conf\.json}' | grep '"Type"' | sed 's/.*"Type": *"\([^"]*\)".*/\1/')"
ready_nodes="$(kubectl get nodes -o jsonpath='{range .items[*]}{.status.conditions[?(@.type=="Ready")].status}{"\n"}{end}' | grep -c '^True$')"
```

## Step 3: Save the report

```sh
kubectl -n default create configmap cni-evidence \
  --from-literal=conf-file-name="$conf_file" \
  --from-literal=backend-type="$backend_type" \
  --from-literal=ready-nodes="$ready_nodes"
```

## Step 4: Start the pod

```sh
kubectl -n default run probe-a --image=ghcr.io/stefanprodan/podinfo:6.15.0 --restart=Never
kubectl -n default wait --for=condition=Ready pod/probe-a --timeout=120s
kubectl -n default get pod probe-a -o wide
```

The address in the output starts with `10.244.`.

Submit with `astrona submit -c sections/section-010/capstone/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-010-cap`.

## Common pitfalls

> [!WARNING]
> Count the nodes after they are `Ready`, not before, or `ready-nodes` will not match the live value. Do not type `vxlan` from memory: read it from the ConfigMap. If the ConfigMap `cni-evidence` already exists, `kubectl create` fails: delete the old one first.
