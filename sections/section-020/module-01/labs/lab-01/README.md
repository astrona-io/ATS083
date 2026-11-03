---
estimated_duration: 20m
---

# Lab: Record The Pod Ranges Of The Nodes

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-020/module-01/labs/lab-01
astrona submit -c sections/section-020/module-01/labs/lab-01
astrona destroy ats-083-lab-020-01-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-cluster-cidr-recorded.sh` | The report holds the live cluster pod network |
| `validate-node-count-recorded.sh` | The report holds the live number of nodes |
| `validate-worker-pod-cidr-recorded.sh` | The report holds the live pod CIDR of the worker node |
| `validate-shuttle-node-recorded.sh` | The report holds the live node of the shuttle pod |
