---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Repair The probe Service: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-040-02-01)"
```

## Step 1: Check the endpoints

```sh
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe
kubectl -n starfleet describe service probe
```

The Service has no endpoints. The selector in the description names a label that the pods do not have.

## Step 2: Compare the selector with the pod labels

```sh
kubectl -n starfleet get service probe -o jsonpath='{.spec.selector}'
kubectl -n starfleet get pods --show-labels
```

The pod `probe` has the label `app=probe`. The Service selects `app=probe-v2`.

## Step 3: Compare the target port

The container listens on 9898. Read the Service port mapping:

```sh
kubectl -n starfleet get service probe -o jsonpath='{.spec.ports}'
```

The `targetPort` is 9999, which is wrong.

## Step 4: Patch the Service

```sh
kubectl -n starfleet patch service probe --type merge -p '{"spec":{"selector":{"app":"probe"},"ports":[{"port":9898,"targetPort":9898}]}}'
```

## Step 5: Test from both namespaces

```sh
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe
kubectl -n starfleet exec shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://probe:9898/
kubectl -n outpost exec drifter -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://probe.starfleet:9898/
```

Both requests print `200`.

Submit with `astrona submit -c sections/section-040/module-02/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-040-02-01`.

## Common pitfalls

> [!WARNING]
> Fix the Service and not the Deployment. If you change the label of the pods to match the wrong selector, the check that the Deployment is unchanged fails. Fixing only the selector leaves the wrong `targetPort`, and the request is still refused.
