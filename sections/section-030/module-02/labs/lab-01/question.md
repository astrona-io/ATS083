---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Record The Service Path Of probe

Solve this question on: `terminal`

The Service `probe` in the namespace `starfleet` sends traffic to a backend pod. The platform team wants a short report of the path of a request: the virtual address, the backend address, the node of the backend and the number of kube-proxy pods that write the Service rules. Read the values from the live cluster. Do not guess them.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-030-02-01)"
```

Create the ConfigMap `cni-evidence` in the namespace `starfleet` with these four keys:

1. `service-ip`: the cluster IP of the Service `probe`.
2. `endpoint-ip`: the pod address that the EndpointSlice of `probe` lists.
3. `probe-node`: the name of the node that runs the pod with the label `app=probe`.
4. `kube-proxy-pods`: the number of pods with the label `k8s-app=kube-proxy` in the namespace `kube-system`.

The grader reads the same values from the live API and compares them with your ConfigMap. Do not change any other object.
