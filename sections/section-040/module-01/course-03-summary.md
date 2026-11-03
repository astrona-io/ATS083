---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Summary

A pod resolves names through `/etc/resolv.conf`. The file holds the ClusterIP of the Service `kube-dns` as nameserver, a `search` list that starts with the namespace of the pod, and `ndots:5`. A short name such as `probe` is completed with the search suffixes. A name from another namespace needs at least the namespace, for example `probe.starfleet`.

## What you learned

CoreDNS runs as the Deployment `coredns` in `kube-system` behind the Service `kube-dns`. Its configuration is the Corefile in the ConfigMap `coredns`. The `kubernetes` plugin answers the zone `cluster.local` from the API, and the `forward` plugin sends all other names to the upstream servers. If the zone in the Corefile and the domain in the search list differ, cluster names return `NXDOMAIN` while the CoreDNS pods stay ready.

The diagnosis goes from the pod outwards: separate the name from the address, read the resolver file, check the Service, the endpoints and the pods, ask for the name with a lookup tool, and read the Corefile. A negative answer means CoreDNS works and does not know the name. A timeout means that the query did not arrive or was not answered.

After a Corefile change, restart the Deployment and test again. The field `dnsPolicy` of a pod cannot be changed while the pod runs, so a pod with a wrong policy is created again.

- `nameserver`, `search` and `ndots` decide how a name is tried.
- The `kubernetes` plugin zone must equal the cluster domain.
- `NXDOMAIN` is a negative answer; a timeout is no answer.
- Edit the ConfigMap, restart CoreDNS, test from a pod.
- Recreate a pod to change its DNS policy.

<!-- astrona:playground:destroy -->
