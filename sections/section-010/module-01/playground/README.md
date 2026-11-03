# How The Runtime Finds And Calls A CNI Plugin (Playground)

- **Slug:** ats-083-playground-010-01
- **Type:** Astrona playground. A clean environment with no task and no grading. UNTESTED: static checks only.

Two-node kind cluster with the reference CNI plugins and flannel installed as the network plugin, plus the `probe` Service, the `shuttle` pod and the `drifter` pod.

## Run it

```sh
astrona run -c sections/section-010/module-01/playground
astrona destroy ats-083-playground-010-01
```
