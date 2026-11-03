---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Troubleshooting Pod Connectivity (DNS, pod-to-pod)

This section teaches a fixed order of checks for broken connectivity in a cluster. A request from one pod to another can fail because the name does not resolve, because a Service has no endpoints, because a port is wrong, or because the pod network drops packets. Each check clears one layer.

Each module has a landing page, two reading parts and a summary. The readings use a private playground for hands-on steps. Each module has one graded lab, and the section ends with a capstone lab and a knowledge check.

## Modules

**Troubleshooting Cluster DNS**

- Explain the resolver file of a pod, the search list and `ndots`.
- Name the CoreDNS Deployment, Service and ConfigMap.
- Read a Corefile and find a wrong zone.
- Tell a negative answer from a timeout, and restart CoreDNS after a change.

**Troubleshooting Pod-to-Pod Connectivity**

- Explain how a Service selector, EndpointSlices and `targetPort` decide where traffic goes.
- Find why a Service has no endpoints.
- Tell refused, timeout and HTTP error results apart.
- Test pod-to-pod traffic by pod address, also across nodes.

## Labs and quiz

The labs are marked UNTESTED: they passed static checks and have not been run. The labs break the cluster during setup, and the grader checks the live state after your repair. The capstone lab combines three faults. The quiz has single-choice questions and a pass score of 70 percent.
