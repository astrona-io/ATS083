---
estimated_duration: 45m
---

# Lab: Multi-interface Capstone

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-050/capstone/labs/lab-01
astrona submit -c sections/section-050/capstone/labs/lab-01
astrona destroy ats-083-lab-050-cap
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-relay-repaired.sh` | The pod relay in starfleet runs and has net1 inside 192.168.80.0/24 |
| `validate-backend-net-defined.sh` | The NetworkAttachmentDefinition backend-net in outpost describes a bridge network with the range 192.168.90.0/24 |
| `validate-gateway-interface.sh` | The pod gateway in outpost runs with the interface back0 inside 192.168.90.0/24 and keeps eth0 |
| `validate-default-network-intact.sh` | The pod shuttle still reaches the probe Service over the default network |
