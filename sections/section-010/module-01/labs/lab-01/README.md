---
estimated_duration: 20m
---

# Lab: Record The CNI Configuration Of The Nodes

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-010/module-01/labs/lab-01
astrona submit -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-083-lab-010-01-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-conf-file-recorded.sh` | The report names the file that flannel writes into the CNI configuration directory |
| `validate-network-name-recorded.sh` | The report holds the network name from the flannel CNI configuration |
| `validate-plugin-types-recorded.sh` | The report lists the plugin types of the chain in order |
