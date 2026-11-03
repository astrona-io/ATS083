# Overview: Troubleshooting Pod-to-Pod Connectivity (Playground)

This is a playground, not a lab. It starts a fresh two-node kind cluster (Kubernetes v1.35.0) with flannel v0.28.10 as the network plugin, creates the example workloads, and waits. Everything works at the start. There is no task, no `astrona submit` and no pass or fail.

Connect to it first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-playground-040-02)"
```

## What is in the cluster

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server (podinfo) on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `outpost` | Pod `drifter` | A client pod with `curl`, in another namespace |
| `kube-flannel` | DaemonSet `kube-flannel-ds` | The network plugin |

## Practice tasks

- Read the Service, its EndpointSlices and the pod labels with `kubectl -n starfleet get service probe -o yaml` and `kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe -o yaml`.
- Patch the selector of the Service to `app: nobody`, find the missing endpoints, and restore `app: probe`.
- Patch `targetPort` to 9999 and compare the result of a request with the result of the wrong selector. Then restore 9898.
- Scale `probe` to 2 replicas and request each pod address directly from `shuttle` and from `drifter`.
