---
estimated_duration: 45m
---

# Lab: IPAM Capstone

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-020/capstone/labs/lab-01
astrona submit -c sections/section-020/capstone/labs/lab-01
astrona destroy ats-083-lab-020-cap
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-node-cidrs-recorded.sh` | The report holds the live pod CIDR of each node |
| `validate-pods-outside-ranges-recorded.sh` | The report holds the live number of pods outside the range of their node |
| `validate-latecomer-placed.sh` | The pod latecomer runs on the worker node with an address inside its range |
