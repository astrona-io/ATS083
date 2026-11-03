# Pod CIDR Allocation To Nodes (Playground)

- **Slug:** ats-083-playground-020-01
- **Type:** Astrona playground. A clean environment with no task and no grading. UNTESTED: static checks only.

Two-node kind cluster with the reference CNI plugins and flannel, plus the `probe` Service, the `shuttle` pod and the `drifter` pod. No evidence ConfigMap exists.

## Run it

```sh
astrona run -c sections/section-020/module-01/playground
astrona destroy ats-083-playground-020-01
```
