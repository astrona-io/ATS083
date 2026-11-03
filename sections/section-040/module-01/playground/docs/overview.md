# Overview: Troubleshooting Cluster DNS (Playground)

This is a playground, not a lab. It starts a fresh two-node kind cluster (Kubernetes v1.35.0) with flannel v0.28.10 as the network plugin, creates the example workloads, and waits. CoreDNS runs normally. There is no task, no `astrona submit` and no pass or fail.

Connect to it first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-playground-040-01)"
```

## What is in the cluster

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server (podinfo) on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `outpost` | Pod `drifter` | A client pod with `curl`, in another namespace |
| `kube-system` | Deployment `coredns`, Service `kube-dns`, ConfigMap `coredns` | The cluster DNS |

## Practice tasks

- Print the resolver file with `kubectl -n starfleet exec shuttle -- cat /etc/resolv.conf` and compare the nameserver with `kubectl -n kube-system get service kube-dns`.
- Run `kubectl -n starfleet run dnscheck --rm -it --restart=Never --image=busybox:1.37.0 -- nslookup probe.starfleet.svc.cluster.local`.
- Read the Corefile with `kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}'`.
- Scale CoreDNS to zero with `kubectl -n kube-system scale deployment coredns --replicas=0`, test a lookup, and scale it back to its previous number.
