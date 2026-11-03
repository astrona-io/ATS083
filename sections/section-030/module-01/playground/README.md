# Inspecting Pod Network Interfaces With ip (Playground)

- **Slug:** ats-083-playground-030-01
- **Type:** Astrona playground. A clean environment with no task and no grading. UNTESTED: static checks only.

Two-node kind cluster with the reference CNI plugins and flannel, plus the `probe` Service, the `shuttle` pod and the `drifter` pod. No evidence ConfigMap exists.

## Run it

```sh
astrona run -c sections/section-030/module-01/playground
astrona destroy ats-083-playground-030-01
```
