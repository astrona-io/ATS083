---
estimated_duration: 25m
---

# Lab: Install Flannel On A Cluster Without A Network Plugin

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-010/module-02/labs/lab-01
astrona submit -c sections/section-010/module-02/labs/lab-01
astrona destroy ats-083-lab-010-02-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-nodes-ready.sh` | Both nodes report the Ready condition |
| `validate-flannel-running.sh` | The flannel DaemonSet runs on every node with the pinned image |
| `validate-coredns-available.sh` | CoreDNS is available after the network plugin starts |
| `validate-pod-address-in-range.sh` | The pod check-a in default runs and has an address from the pod network |
