---
estimated_duration: 25m
---

# Lab: Restore Cluster DNS

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-040/module-01/labs/lab-01
astrona submit -c sections/section-040/module-01/labs/lab-01
astrona destroy ats-083-lab-040-01-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-corefile-zone-fixed.sh` | The Corefile serves the zone cluster.local again |
| `validate-coredns-ready.sh` | All CoreDNS pods are ready |
| `validate-full-name-resolves.sh` | The pod shuttle reaches probe by its full Service name |
| `validate-short-name-resolves.sh` | The pod shuttle reaches probe by its short name |
