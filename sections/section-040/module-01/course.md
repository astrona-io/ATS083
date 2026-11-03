---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Troubleshooting Cluster DNS

Most pods do not use IP addresses to find each other. They use names such as `probe` or `probe.starfleet.svc.cluster.local`. A name only helps if something turns it into an address. In a cluster this is the job of the DNS service, which is CoreDNS in almost every cluster. When it fails, applications report timeouts or unknown hosts, and the network itself is often healthy.

This module teaches how a pod resolves a name, which files and objects are involved, and an ordered set of checks that finds the fault. You will read the resolver file of a pod, the CoreDNS Deployment and Service and the Corefile, and you will repair a cluster whose Corefile has been changed.

The module has two parts. The first part explains the resolution path from the application to CoreDNS and back. The second part gives the diagnosis order and the typical faults, with the commands for each check.

## Learning objectives

After this module you can:

- Explain what `/etc/resolv.conf` of a pod contains and what `search` and `ndots` do.
- Name the CoreDNS Service, Deployment and ConfigMap and say where each lives.
- Read a Corefile and say what the `kubernetes`, `forward`, `cache` and `reload` plugins do.
- Tell the difference between a name that does not exist and a DNS server that does not answer.
- Run an ordered set of checks and fix a broken Corefile.

## Before you start

You need Kubernetes basics: pods, Services, namespaces and the commands `kubectl get`, `kubectl exec` and `kubectl describe`.

Your playground is a two-node kind cluster running Kubernetes 1.35 with flannel v0.28.10. CoreDNS runs normally.

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `outpost` | Pod `drifter` | A client pod with `curl` in another namespace |
| `kube-system` | Deployment `coredns`, Service `kube-dns`, ConfigMap `coredns` | The cluster DNS |

`kubectl` already points at the playground cluster. Launch the playground now and keep it running while you read the parts:

<!-- astrona:playground -->
