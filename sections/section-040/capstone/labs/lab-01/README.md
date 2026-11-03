---
estimated_duration: 45m
---

# Lab: Connectivity Capstone

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-040/capstone/labs/lab-01
astrona submit -c sections/section-040/capstone/labs/lab-01
astrona destroy ats-083-lab-040-cap
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-coredns-zone-fixed.sh` | The Corefile serves the zone cluster.local and CoreDNS is ready |
| `validate-probe-has-endpoints.sh` | The Service probe selects the probe pods and has endpoints |
| `validate-shuttle-uses-cluster-dns.sh` | The pod shuttle runs with the default cluster DNS policy |
| `validate-shuttle-reaches-probe.sh` | The pod shuttle reaches probe by its short name |
| `validate-drifter-reaches-probe.sh` | The pod drifter reaches probe by its cross-namespace name |
