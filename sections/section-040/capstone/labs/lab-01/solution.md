---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Connectivity Capstone: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-040-cap)"
```

## Step 1: Test from both clients

```sh
kubectl -n starfleet exec shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://probe:9898/
kubectl -n outpost exec drifter -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://probe.starfleet.svc.cluster.local:9898/
```

Both fail. Because both clients fail, start with the part that both depend on, which is the cluster DNS.

## Step 2: Repair CoreDNS

```sh
kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}'
```

The `kubernetes` line names the zone `clusterx.local`. Edit the ConfigMap, change it to `cluster.local` and restart CoreDNS.

```sh
kubectl -n kube-system edit configmap coredns
kubectl -n kube-system rollout restart deployment/coredns
kubectl -n kube-system rollout status deployment/coredns
```

## Step 3: Repair the Service

Test the request from `drifter` again. The name now resolves, but the Service has no endpoints.

```sh
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe
kubectl -n starfleet get service probe -o jsonpath='{.spec.selector}'
kubectl -n starfleet patch service probe --type merge -p '{"spec":{"selector":{"app":"probe"}}}'
```

## Step 4: Repair shuttle

The request from `drifter` works now, and the request from `shuttle` still fails. Read the DNS settings of the pod:

```sh
kubectl -n starfleet get pod shuttle -o jsonpath='{.spec.dnsPolicy}'
kubectl -n starfleet exec shuttle -- cat /etc/resolv.conf
```

The policy is `None` and the nameserver is not the cluster DNS. The policy cannot be changed on a running pod, so delete the pod and create it again without `dnsPolicy`.

```sh
kubectl -n starfleet delete pod shuttle
kubectl apply -f - <<'POD'
apiVersion: v1
kind: Pod
metadata:
  name: shuttle
  namespace: starfleet
  labels:
    app: shuttle
spec:
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
POD
kubectl -n starfleet wait --for=condition=Ready pod/shuttle --timeout=120s
```

## Step 5: Test again

```sh
kubectl -n starfleet exec shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://probe:9898/
kubectl -n outpost exec drifter -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://probe.starfleet.svc.cluster.local:9898/
```

Both requests print `200`.

Submit with `astrona submit -c sections/section-040/capstone/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-040-cap`.

## Common pitfalls

> [!WARNING]
> Fix the faults in the order of dependency: DNS first, then the Service, then the single pod. If you test the Service before DNS works, the name fails and hides the Service fault. Create the new `shuttle` pod with the same name and image, otherwise the checks cannot find it.
