# Packet-level Tools: iptables And tcpdump (Playground)

- **Slug:** ats-083-playground-030-02
- **Type:** Astrona playground. A clean environment with no task and no grading. UNTESTED: static checks only.

Two-node kind cluster with the reference CNI plugins and flannel, plus the `probe` Service, the `shuttle` pod and the `drifter` pod. No evidence ConfigMap exists.

## Run it

```sh
astrona run -c sections/section-030/module-02/playground
astrona destroy ats-083-playground-030-02
```
