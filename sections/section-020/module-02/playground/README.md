# IPAM In The CNI Plugin (Playground)

- **Slug:** ats-083-playground-020-02
- **Type:** Astrona playground. A clean environment with no task and no grading. UNTESTED: static checks only.

Two-node kind cluster with flannel, plus the `probe` Service, the `shuttle` pod, the `drifter` pod and a Deployment `crew` with four pods.

## Run it

```sh
astrona run -c sections/section-020/module-02/playground
astrona destroy ats-083-playground-020-02
```
