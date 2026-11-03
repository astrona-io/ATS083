---
draft: true
exam_objectives:
- Configuring Multi-interface Pods
---
# Configuring Multi-interface Pods

This section explains how a pod gets more than one network interface. Multus is a CNI plugin that calls other CNI plugins. It creates the default interface with the cluster network plugin and the extra interfaces from NetworkAttachmentDefinition objects that the pod names in an annotation.

Each module has a landing page, two reading parts and a summary. The readings use a private playground for hands-on steps. Each module has one graded lab, and the section ends with a capstone lab and a knowledge check.

## Modules

**Multus And Network Attachment Definitions**

- Explain how Multus calls the default network and the additional networks.
- Write a NetworkAttachmentDefinition with the bridge and host-local plugins.
- Attach a pod with the networks annotation, including namespace and interface name.
- Read the interfaces and the network status of a pod.

**Troubleshooting Secondary Interfaces**

- Recognise a pod that waits for a failed attachment.
- Read the events to find the failing step.
- Repair a missing definition, a wrong namespace or a wrong plugin type.
- Check the result inside the pod and confirm that the default network works.

## Labs and quiz

The labs are marked UNTESTED: they passed static checks and have not been run. The capstone lab combines the skills of the section. The quiz has single-choice questions and a pass score of 70 percent.
