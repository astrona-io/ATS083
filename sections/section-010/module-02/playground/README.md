# Installing A Network Plugin On A Cluster (Playground)

- **Slug:** ats-083-playground-010-02
- **Type:** Astrona playground. A clean environment with no task and no grading. UNTESTED: static checks only.

Two-node kind cluster with the reference CNI plugins on every node and no network plugin. The nodes are NotReady and no example workloads exist.

## Run it

```sh
astrona run -c sections/section-010/module-02/playground
astrona destroy ats-083-playground-010-02
```
