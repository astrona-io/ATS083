---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Troubleshooting Pod-to-Pod Connectivity

When a request from one pod to another pod or to a Service fails, the cause can sit in many places: the name, the Service, the endpoints, the port, the pod itself, or the network between two nodes. Guessing wastes time. This module teaches a fixed order of tests that narrows the fault to one layer.

You will learn how a request to a Service is turned into a request to a pod, which objects hold the data for that step, and how to compare them. You will also separate faults of the Service layer from faults of the pod network.

The module has two parts. The first part explains how a Service finds its pods and how traffic reaches them. The second part gives the diagnosis order, the meaning of each failure type and the commands for each check.

## Learning objectives

After this module you can:

- Explain how a Service selector, EndpointSlices and `targetPort` decide where traffic goes.
- Tell a name problem, a Service problem and a pod network problem apart.
- Explain the difference between a refused connection, a timeout and a reset.
- Find why a Service has no endpoints.
- Test pod-to-pod traffic directly by pod address, also across nodes.

## Before you start

You need Kubernetes basics: pods, labels, Services and the commands `kubectl get`, `kubectl exec` and `kubectl describe`.

Your playground is a two-node kind cluster running Kubernetes 1.35 with flannel v0.28.10. Everything works at the start.

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `outpost` | Pod `drifter` | A client pod with `curl` in another namespace |

`kubectl` already points at the playground cluster. Launch the playground now and keep it running while you read the parts:

<!-- astrona:playground -->
