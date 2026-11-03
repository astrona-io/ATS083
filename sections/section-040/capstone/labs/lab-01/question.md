---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Connectivity Capstone

Solve this question on: `terminal`

Applications in the cluster cannot reach the Service `probe` in the namespace `starfleet`. More than one thing is wrong. Use an ordered set of checks to find every fault and repair it.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-040-cap)"
```

Requirements:

1. CoreDNS serves the zone `cluster.local` and all its pods are ready.
2. The Service `probe` selects the pods of the Deployment `probe` and has at least one endpoint address.
3. The pod `shuttle` in `starfleet` is Running, uses the default cluster DNS policy and reaches `http://probe:9898/` with status 200. The pod must keep its name, its namespace and the image `curlimages/curl:8.22.0` with a command that keeps it running.
4. The pod `drifter` in `outpost` reaches `http://probe.starfleet.svc.cluster.local:9898/` with status 200.

Do not change the Deployment `probe` or the pod `drifter`.
