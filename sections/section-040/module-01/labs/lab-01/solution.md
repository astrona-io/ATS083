---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Restore Cluster DNS: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-040-01-01)"
```

## Step 1: Separate the name from the address

Read the ClusterIP of the Service and request it directly. Then request the name.

```sh
kubectl -n starfleet get service probe -o jsonpath='{.spec.clusterIP}'
kubectl -n starfleet exec shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://CLUSTER_IP:9898/
kubectl -n starfleet exec shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://probe:9898/
```

Replace `CLUSTER_IP` with the address. The request to the address works, so the fault is in name resolution.

## Step 2: Check CoreDNS

```sh
kubectl -n kube-system get pods -l k8s-app=kube-dns
kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}'
```

The pods are ready. In the Corefile, the line that starts with `kubernetes` names the zone `clusterx.local`. The cluster domain is `cluster.local`, so CoreDNS does not answer cluster names.

## Step 3: Correct the zone and restart CoreDNS

Edit the ConfigMap and change `clusterx.local` to `cluster.local`.

```sh
kubectl -n kube-system edit configmap coredns
kubectl -n kube-system rollout restart deployment/coredns
kubectl -n kube-system rollout status deployment/coredns
```

## Step 4: Test again

```sh
kubectl -n starfleet exec shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://probe.starfleet.svc.cluster.local:9898/
kubectl -n starfleet exec shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://probe:9898/
```

Both requests print `200`.

Submit with `astrona submit -c sections/section-040/module-01/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-040-01-01`.

## Common pitfalls

> [!WARNING]
> Change only the zone name, not other lines of the Corefile. If the CoreDNS pods do not become ready after the restart, the Corefile has a syntax error: read the logs of a new pod. Do not delete the ConfigMap.
