---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Repair The probe Service

Solve this question on: `terminal`

Clients cannot reach the Service `probe` in the namespace `starfleet`. The Deployment `probe` runs a healthy pod, and the cluster DNS works. Find why the Service does not forward traffic and repair it.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-040-02-01)"
```

Requirements:

1. The Service `probe` has at least one endpoint address.
2. The pod `shuttle` reaches `http://probe:9898/` and gets status 200.
3. The pod `drifter` in `outpost` reaches `http://probe.starfleet:9898/` and gets status 200.

Repair the Service. Do not change the Deployment `probe` or its pods. The container listens on port 9898, and the pods have the label `app=probe`.
