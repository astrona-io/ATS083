# Multus And Network Attachment Definitions (Playground)

- **Slug:** ats-083-playground-050-01
- **Type:** Astrona playground. A clean environment with no task and no grading. UNTESTED: static checks only.

Two-node kind cluster with flannel and Multus, the example workloads, the NetworkAttachmentDefinition `side-net` and the pod `tender` with a second interface.

## Run it

```sh
astrona run -c sections/section-050/module-01/playground
astrona destroy ats-083-playground-050-01
```
