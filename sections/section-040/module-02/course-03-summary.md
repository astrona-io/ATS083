---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Summary

A Service sends traffic to pods through three objects: the Service with its selector and `targetPort`, the EndpointSlices that the control plane fills with the addresses of matching ready pods, and the rules that kube-proxy writes on each node. The ClusterIP is virtual. The node rewrites it to a pod address before the packet leaves the node.

## What you learned

A selector that matches no pod gives a Service with no endpoints and no error message. A wrong `targetPort` gives endpoints that refuse or reset the connection. A pod that is not ready is removed from the usable endpoints. The Service layer and the pod network are two layers, and a request by pod address separates them.

The diagnosis order is: test the name and the address separately, read the endpoints, compare the target port, bypass the Service with the pod address, ask the pod on localhost, compare same-node and cross-node requests, and check policies. The type of failure tells the layer: refused points to the Service or the port, timeout points to the network or a drop rule, an HTTP error code points to the application.

Change one thing at a time and test again. Fix the side that is wrong: patch the Service when its selector is wrong, and change the Deployment only when the pod labels are the error.

- Selector, EndpointSlices and `targetPort` decide where Service traffic goes.
- Empty endpoints mean the selector, the readiness or the namespace is wrong.
- A pod-address test separates the Service layer from the pod network.
- Refused, timeout and HTTP error codes point to different layers.
- Patch one field and repeat the failing request.

<!-- astrona:playground:destroy -->
