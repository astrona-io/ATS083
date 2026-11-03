# Troubleshooting Secondary Interfaces (Playground)

- **Slug:** ats-083-playground-050-02
- **Type:** Astrona playground. A clean environment with no task and no grading. UNTESTED: static checks only.

Two-node kind cluster with flannel and Multus, the example workloads, and two pods stuck in ContainerCreating: `ferry` in outpost and `cutter` in starfleet.

## Run it

```sh
astrona run -c sections/section-050/module-02/playground
astrona destroy ats-083-playground-050-02
```
