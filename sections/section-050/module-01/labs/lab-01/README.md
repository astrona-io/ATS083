---
estimated_duration: 25m
---

# Lab: Attach A Second Interface To A Pod

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-050/module-01/labs/lab-01
astrona submit -c sections/section-050/module-01/labs/lab-01
astrona destroy ats-083-lab-050-01-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-side-net-defined.sh` | The NetworkAttachmentDefinition side-net in starfleet describes a bridge network with the range 192.168.50.0/24 |
| `validate-tender-running.sh` | The pod tender in starfleet runs and names side-net in its networks annotation |
| `validate-tender-second-interface.sh` | The pod tender has net1 inside 192.168.50.0/24 and keeps eth0 in the pod network |
