---
estimated_duration: 25m
---

# Lab: Record The Service Path Of probe

Graded lab. **UNTESTED**: the files passed static checks only (`astrona validate`, `bash -n`). The lab has not been run, and the reference solution has not been proven.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run -c sections/section-030/module-02/labs/lab-01
astrona submit -c sections/section-030/module-02/labs/lab-01
astrona destroy ats-083-lab-030-02-01
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-service-ip-recorded.sh` | The report holds the live cluster IP of the probe Service |
| `validate-endpoint-ip-recorded.sh` | The report holds the live pod address behind the Service |
| `validate-probe-node-recorded.sh` | The report holds the live node of the backend pod |
| `validate-kube-proxy-pods-recorded.sh` | The report holds the live number of kube-proxy pods |
