---
estimated_duration: 45m
---

# Lab: CNI Installation Capstone

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-010/capstone/labs/lab-01
astrona submit -c sections/section-010/capstone/labs/lab-01
astrona destroy ats-083-lab-010-cap
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-flannel-installed.sh` | flannel runs on every node with the pinned image and the nodes are Ready |
| `validate-conf-file-recorded.sh` | The report names the file that flannel writes into the CNI configuration directory |
| `validate-backend-recorded.sh` | The report holds the backend type from the flannel network configuration |
| `validate-ready-nodes-recorded.sh` | The report holds the live number of Ready nodes |
| `validate-probe-a-ready.sh` | The pod probe-a in default is Ready and has an address from the pod network |
