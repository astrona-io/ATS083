# Troubleshooting Cluster DNS (Playground)

- **Slug:** ats-083-playground-040-01
- **Type:** Astrona playground. A clean environment with no task and no grading. UNTESTED: static checks only.

Two-node kind cluster with flannel and CoreDNS running normally, plus the `probe` Service, the `shuttle` pod and the `drifter` pod.

## Run it

```sh
astrona run -c sections/section-040/module-01/playground
astrona destroy ats-083-playground-040-01
```
