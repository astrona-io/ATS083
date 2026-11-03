---
draft: true
exam_objectives:
- Installing and Configuring CNI Plugins
---
# Record The CNI Configuration Of The Nodes: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-010-01-01)"
```

## Step 1: Read the file name

The init container `install-cni` runs `cp -f <source> <target>`. The arguments are `-f`, the source path and the target path, so the target is the third argument (index 2). A jsonpath filter selects the container by name. The shell then removes the directory part.

```sh
conf_file="$(kubectl -n kube-flannel get daemonset kube-flannel-ds -o jsonpath='{.spec.template.spec.initContainers[?(@.name=="install-cni")].args[2]}')"
conf_file="${conf_file##*/}"
echo "$conf_file"
```

## Step 2: Read the network name and the plugin types

Both values are in the JSON text of the key `cni-conf.json`. The name is the first `"name"` line. The plugin types are the `"type"` lines, which appear once for each plugin.

```sh
cni_conf="$(kubectl -n kube-flannel get configmap kube-flannel-cfg -o jsonpath='{.data.cni-conf\.json}')"
printf '%s\n' "$cni_conf" | grep -m1 '"name"' | sed 's/.*"name": *"\([^"]*\)".*/\1/'
printf '%s\n' "$cni_conf" | grep '"type"' | sed 's/.*"type": *"\([^"]*\)".*/\1/' | paste -sd, -
```

## Step 3: Save the report

Use the three values as printed. This command reads them again and writes the ConfigMap in one step.

```sh
network_name="$(printf '%s\n' "$cni_conf" | grep -m1 '"name"' | sed 's/.*"name": *"\([^"]*\)".*/\1/')"
plugin_types="$(printf '%s\n' "$cni_conf" | grep '"type"' | sed 's/.*"type": *"\([^"]*\)".*/\1/' | paste -sd, -)"
kubectl -n starfleet create configmap cni-evidence \
  --from-literal=conf-file-name="$conf_file" \
  --from-literal=network-name="$network_name" \
  --from-literal=plugin-types="$plugin_types"
```

Submit with `astrona submit -c sections/section-010/module-01/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-010-01-01`.

## Common pitfalls

> [!WARNING]
> Do not type the values from memory: copy them from the live objects. The `delegate` object inside the first plugin has no `type` field, so only the entries of `plugins` count. If the ConfigMap already exists, `kubectl create` fails: delete the old one first.
