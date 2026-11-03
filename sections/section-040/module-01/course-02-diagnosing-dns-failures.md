---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Diagnosing DNS Failures

A DNS fault looks like a network fault from the outside. The application says that a host is unknown or that a request timed out. The way to find the real cause is to test one step at a time, from the pod outwards, and to stop at the first step that fails. This part gives that order, the meaning of each result and the faults that you will meet most often.

## Step 1: Decide whether it is a name problem

Take the name out of the test. If a request to the ClusterIP of the Service works but a request to its name does not, the fault is in name resolution. Read the ClusterIP and try both:

```sh
kubectl -n starfleet get service probe -o jsonpath='{.spec.clusterIP}'
kubectl -n starfleet exec shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://CLUSTER_IP:9898/
kubectl -n starfleet exec shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://probe:9898/
```

Replace `CLUSTER_IP` with the address from the first command. A `200` for the address and `000` for the name proves that the Service and the pod network work and that only the name fails. From here on, all steps are about DNS.

## Step 2: Read the resolver file of the failing pod

```sh
kubectl -n starfleet exec shuttle -- cat /etc/resolv.conf
```

Check three things. The `nameserver` must be the ClusterIP of `kube-dns`. The `search` line must start with the namespace of the pod and end with `cluster.local`. The line `options ndots:5` should be present unless someone changed it on purpose. A `nameserver` that is not the cluster DNS address means the pod uses a custom DNS policy. Read it from the pod:

```sh
kubectl -n starfleet get pod shuttle -o jsonpath='{.spec.dnsPolicy}'
```

The value `ClusterFirst` is the default for pods that do not use the host network. The value `None` means that the pod ignores the cluster DNS and uses only the addresses in `dnsConfig`. A pod with `None` and a wrong address fails every lookup, while the other pods work. The field `dnsPolicy` cannot be changed on a running pod, so the pod must be created again.

## Step 3: Check the DNS Service and its pods

```sh
kubectl -n kube-system get service kube-dns
kubectl -n kube-system get endpointslice -l kubernetes.io/service-name=kube-dns
kubectl -n kube-system get pods -l k8s-app=kube-dns
```

The Service must have a ClusterIP that matches the resolver file. The EndpointSlice must list at least one address. The pods must be `Running` and ready. If no pod is ready, read why:

```sh
kubectl -n kube-system describe pod -l k8s-app=kube-dns
kubectl -n kube-system logs -l k8s-app=kube-dns
```

A pod that restarts in a loop and prints a message about a loop or about a configuration error points to the Corefile. A pod that is `Pending` points to the scheduler or to a network plugin that is not ready.

## Step 4: Test the name from a pod that has a lookup tool

The client image has `curl` but no lookup command. Start a short-lived pod with a lookup tool and ask for the name directly. The busybox image contains `nslookup`:

```sh
kubectl -n starfleet run dnscheck --rm -it --restart=Never --image=busybox:1.37.0 -- nslookup probe.starfleet.svc.cluster.local
```

The result tells you which part fails:

- An answer with an address: DNS works for this name. Look at the application or at the name it uses.
- A reply that says the name does not exist (`NXDOMAIN`): CoreDNS answered, and it does not know the name. Suspect the zone in the Corefile, a wrong name or a missing Service.
- No reply and a timeout: the query did not reach CoreDNS or CoreDNS did not answer. Suspect the Service, the pods or the network between them.

The difference between the last two is the most useful fact in this part. A negative answer means the server works. A timeout means it may not.

## Step 5: Read the Corefile

```sh
kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}'
```

Read the line that starts with `kubernetes`. The zone must be `cluster.local`, the same domain as in the `search` line of the pods. A typing error here is enough to turn every cluster name into `NXDOMAIN` while the CoreDNS pods stay healthy and ready. Also check that the `forward` line is present, because without it external names fail while cluster names work.

## Step 6: Apply the fix and make CoreDNS read it

Edit the ConfigMap and restart the Deployment, so that you do not have to wait:

```sh
kubectl -n kube-system edit configmap coredns
kubectl -n kube-system rollout restart deployment/coredns
kubectl -n kube-system rollout status deployment/coredns
```

The `reload` plugin loads a changed Corefile by itself after a delay, but the restart makes the result certain. If the new Corefile has a syntax error, the new pods fail to start and the rollout does not finish. The old pods stay in service while the new pods fail, so read `kubectl logs` of a new pod to see the error line.

## Typical faults and where they show

| Observation | Likely cause |
| --- | --- |
| Every name fails in every pod; the Service has no endpoints | CoreDNS pods are not ready |
| Cluster names return `NXDOMAIN`; external names work | Wrong zone or plugin line in the `kubernetes` block |
| Cluster names work; external names fail | Missing or wrong `forward` line, or no route from the node to the upstream |
| One pod fails; others work | Custom `dnsPolicy` or `dnsConfig` in that pod |
| Names work after the first try only | A rule between pods and CoreDNS that drops UDP but allows TCP, or a lost packet |
| Short names fail but full names work | The `search` line of the pod is wrong or the pod is in the wrong namespace |

## Try it

<!-- astrona:playground:renew -->

Walk through steps 1 to 5 on the healthy playground cluster, so that you know what normal looks like. Save the Corefile to a file with `kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}' > Corefile.orig` first. Then change the zone in the ConfigMap to `clusterx.local`, restart CoreDNS and repeat step 1 and step 4. Restore the file when you are done.

## Common pitfalls

> [!WARNING]
> Do not delete the CoreDNS pods or the ConfigMap as a first reaction. A deleted ConfigMap leaves the new pods without a configuration, and a restart does not repair a wrong Corefile. Read the Corefile, change one thing, restart and test again. Keep a copy of the original text before you edit it.
