# Troubleshooting Pod-to-Pod Connectivity (Playground)

- **Slug:** ats-083-playground-040-02
- **Type:** Astrona playground. A clean environment with no task and no grading. UNTESTED: static checks only.

Two-node kind cluster with flannel, the `probe` Service, the `shuttle` pod and the `drifter` pod. Everything works.

## Run it

```sh
astrona run -c sections/section-040/module-02/playground
astrona destroy ats-083-playground-040-02
```
