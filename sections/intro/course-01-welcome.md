# Welcome To The Course

This course prepares you for the Core Infrastructure and CNI domain of the Certified Kubernetes Network Engineer (CKNE) exam. The domain is worth 15% of the published curriculum. The exam is under development, so the curriculum can change. The course is independently written practice material and does not simulate the exam.

## Who the course is for

The course is for people who run or build Kubernetes clusters and want to understand the pod network. You need basic knowledge of Pods, Deployments, Services, namespaces and the `kubectl` command. You do not need prior knowledge of CNI.

## What you can do at the end

After the course you can explain how a container runtime calls a CNI plugin, install a network plugin on a cluster that has none, and read how pod address ranges are given to nodes. You can use `ip`, `iptables` and `tcpdump` to inspect the path of a packet, find faults in cluster DNS and in pod-to-pod connectivity, and attach a second network interface to a pod with Multus.

## The words the course uses

A CNI (Container Network Interface) plugin is a program that the container runtime runs to connect a pod to the network. IPAM (IP address management) is the part that chooses the IP address of a pod. A pod CIDR is the range of addresses that one node may give to its pods. flannel is a network plugin. Multus is a plugin that lets a pod have more than one network interface. Each page defines a term again the first time it appears.

## The example application

The examples use a small application. The `probe` Deployment and Service in the `starfleet` namespace run a small HTTP server on port 9898. The `shuttle` pod in `starfleet` and the `drifter` pod in `outpost` are client pods with `curl`. The names are only labels for the examples and carry no technical meaning.

## How the course is laid out

The course has five sections, one for each exam objective. A section has two modules. A module has a landing page, two reading parts, a graded lab and a summary. Each module has a playground, which is a private cluster for the hands-on steps. Each section ends with a capstone lab and a knowledge check, and the course ends with a final knowledge check.

Read each part in order. Run the commands in the playground as you read. Then solve the lab task in its own environment before you open the solution.
