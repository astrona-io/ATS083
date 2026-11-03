---
estimated_duration: 25m
---

# Lab: Trace A Pod Address To Its Node Range

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-020/module-02/labs/lab-01
astrona submit -c sections/section-020/module-02/labs/lab-01
astrona destroy ats-083-lab-020-02-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-shuttle-ip-recorded.sh` | The report holds the live address of the shuttle pod |
| `validate-shuttle-node-cidr-recorded.sh` | The report holds the live pod CIDR of the node that runs shuttle |
| `validate-crew-on-worker-recorded.sh` | The report holds the live number of crew pods inside the worker range |
| `validate-crew-total-recorded.sh` | The report holds the live number of crew pods |
