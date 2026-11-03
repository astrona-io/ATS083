---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Restore Cluster DNS

Solve this question on: `terminal`

Applications in the cluster report that they cannot find the Service `probe`. The pod `shuttle` in the namespace `starfleet` cannot open `http://probe:9898/`. The Service itself, the pods behind it and the CoreDNS pods are all running. Find the cause and repair it.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-040-01-01)"
```

Requirements:

1. The name `probe.starfleet.svc.cluster.local` resolves from `shuttle`, and `http://probe.starfleet.svc.cluster.local:9898/` returns status 200.
2. The short name `probe` works from `shuttle`, and `http://probe:9898/` returns status 200.
3. All CoreDNS pods are ready after your change.

Do not change the Service `probe`, the Deployment `probe` or the pods `shuttle` and `drifter`.
