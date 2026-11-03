---
estimated_duration: 45m
---

# Lab: Packet-level Capstone

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-030/capstone/labs/lab-01
astrona submit -c sections/section-030/capstone/labs/lab-01
astrona destroy ats-083-lab-030-cap
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-drifter-settings-recorded.sh` | The report holds the live address and MTU of eth0 in the drifter pod |
| `validate-probe-service-data-recorded.sh` | The report holds the live cluster IP and backend address of probe |
| `validate-netcheck-host-network.sh` | The pod netcheck uses the host network and has the address of its node |
| `validate-netcheck-reaches-probe.sh` | The pod netcheck reaches the probe Service by its cluster IP |
