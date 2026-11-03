---
estimated_duration: 20m
---

# Lab: Record The Network Settings Of A Pod

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-030/module-01/labs/lab-01
astrona submit -c sections/section-030/module-01/labs/lab-01
astrona destroy ats-083-lab-030-01-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-shuttle-ip-recorded.sh` | The report holds the live address of the shuttle pod |
| `validate-shuttle-mac-recorded.sh` | The report holds the live MAC address of eth0 in the shuttle pod |
| `validate-shuttle-mtu-recorded.sh` | The report holds the live MTU of eth0 in the shuttle pod |
| `validate-shuttle-gateway-recorded.sh` | The report holds the live default gateway of the shuttle pod |
