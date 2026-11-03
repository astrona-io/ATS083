---
estimated_duration: 30m
---

# Lab: Repair A Pod With A Failed Attachment

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-050/module-02/labs/lab-01
astrona submit -c sections/section-050/module-02/labs/lab-01
astrona destroy ats-083-lab-050-02-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-ferry-running.sh` | The pod ferry in outpost runs and has net1 inside 192.168.60.0/24 |
| `validate-dock-net-type-fixed.sh` | The NetworkAttachmentDefinition dock-net uses the bridge plugin |
| `validate-cutter-running.sh` | The pod cutter in starfleet runs and has net1 inside 192.168.70.0/24 |
| `validate-default-network-intact.sh` | The pod shuttle still reaches the probe Service over the default network |
