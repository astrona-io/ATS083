# ATS083 — CKNE: Core Infrastructure and CNI

Preparation for the **Core Infrastructure and CNI** domain of **Certified Kubernetes Network Engineer (CKNE)**.
The published domain weight is **15%**. This repository belongs to
the [ATP017 training path](https://github.com/astrona-io/ATP017).

**Status:** Under development; curriculum is provisional. Technical pages are draft.

Each section has two modules with a landing page, two reading parts and a summary. Each module has a private playground and a graded lab. Each section ends with a capstone lab and a quiz, and the course ends with a final domain quiz.

## Course Outline

| Section | Official objective | Modules |
| --- | --- | --- |
| 010 | Installing and Configuring CNI Plugins | 2 |
| 020 | Managing IPAM and Pod CIDR Allocation | 2 |
| 030 | Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues | 2 |
| 040 | Troubleshooting Pod Connectivity (DNS, pod-to-pod) | 2 |
| 050 | Configuring Multi-interface Pods | 2 |

| Section / module | Module | Lab |
| --- | --- | --- |
| 010 / 01 | How The Runtime Finds And Calls A CNI Plugin | Record The CNI Configuration Of The Nodes |
| 010 / 02 | Installing A Network Plugin On A Cluster | Install Flannel On A Cluster Without A Network Plugin |
| 010 / cap | Capstone | CNI Installation Capstone |
| 020 / 01 | Pod CIDR Allocation To Nodes | Record The Pod Ranges Of The Nodes |
| 020 / 02 | IPAM In The CNI Plugin | Trace A Pod Address To Its Node Range |
| 020 / cap | Capstone | IPAM Capstone |
| 030 / 01 | Inspecting Pod Network Interfaces With ip | Record The Network Settings Of A Pod |
| 030 / 02 | Packet-level Tools: iptables And tcpdump | Record The Service Path Of probe |
| 030 / cap | Capstone | Packet-level Capstone |
| 040 / 01 | Troubleshooting Cluster DNS | Restore Cluster DNS |
| 040 / 02 | Troubleshooting Pod-to-Pod Connectivity | Repair The probe Service |
| 040 / cap | Capstone | Connectivity Capstone |
| 050 / 01 | Multus And Network Attachment Definitions | Attach A Second Interface To A Pod |
| 050 / 02 | Troubleshooting Secondary Interfaces | Repair A Pod With A Failed Attachment |
| 050 / cap | Capstone | Multi-interface Capstone |

## Hands-On Coverage

This course has 10 ungraded playgrounds and 15 graded labs: one per module and one capstone per section. The labs are marked UNTESTED. They passed static checks (`astrona validate`, `bash -n` and a YAML parse) and have not been run.

| Section / module | Lab |
| --- | --- |
| 010 / 01 | Record The CNI Configuration Of The Nodes |
| 010 / 02 | Install Flannel On A Cluster Without A Network Plugin |
| 010 / cap | CNI Installation Capstone |
| 020 / 01 | Record The Pod Ranges Of The Nodes |
| 020 / 02 | Trace A Pod Address To Its Node Range |
| 020 / cap | IPAM Capstone |
| 030 / 01 | Record The Network Settings Of A Pod |
| 030 / 02 | Record The Service Path Of probe |
| 030 / cap | Packet-level Capstone |
| 040 / 01 | Restore Cluster DNS |
| 040 / 02 | Repair The probe Service |
| 040 / cap | Connectivity Capstone |
| 050 / 01 | Attach A Second Interface To A Pod |
| 050 / 02 | Repair A Pod With A Failed Attachment |
| 050 / cap | Multi-interface Capstone |

See [CURRICULUM.md](CURRICULUM.md) for the objective map and authoring checklist,
[astrona.yaml](astrona.yaml) for the course manifest, and
[CLAUDE.md](CLAUDE.md) for writing and environment rules.

Curriculum source: [official CKNE page](https://training.linuxfoundation.org/kubernetes-network-engineer-program/), checked 2026-10-10.
License: [Apache-2.0](LICENSE). Curriculum objectives retain attribution to
The Linux Foundation and CNCF; see [CNCF curriculum licensing](https://github.com/cncf/curriculum).
