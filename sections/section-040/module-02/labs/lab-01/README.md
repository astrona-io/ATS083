---
estimated_duration: 25m
---

# Lab: Repair The probe Service

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-040/module-02/labs/lab-01
astrona submit -c sections/section-040/module-02/labs/lab-01
astrona destroy ats-083-lab-040-02-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-selector-fixed.sh` | The Service probe selects the pods with the label app=probe |
| `validate-target-port-fixed.sh` | The Service probe forwards to port 9898 |
| `validate-endpoints-present.sh` | The Service probe has at least one endpoint address |
| `validate-probe-workload-unchanged.sh` | The probe pods keep the label app=probe and are ready |
| `validate-same-namespace-works.sh` | The pod shuttle reaches the Service probe |
| `validate-cross-namespace-works.sh` | The pod drifter reaches the Service probe in another namespace |
