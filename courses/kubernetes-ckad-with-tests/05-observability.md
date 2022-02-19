# Observability

## Readiness and Liveness Probes

### Pod Statuses

You can see the Pods' statuses by running `kubectl get pods`.

- Pending: when the scheduler is figuring where to place the pod
- ContainerCreating: when the container's image is being pulled
- Running

### Pod Conditions

You can see Pods' statuses by running `kubectl describe pod podName`

- PodScheduled
- Initialized
- ContainersReady
- Ready


### Ready Conditions

`kubectl get pods` shows a `READY` column.

The number at the rightside is the amount of containers, and in the leftside is the amount of container that are ready. If both numbers are the equal, the Pod is ready to receive traffic.

Sometimes a container is running but the application is still not ready to receive traffic. That's where the readiness probe is useful.


### Readiness Probe

With the Readiness Probe we can set a way for kubernetes to know if the pod is really ready to receive requests.

- HTTP Test
- TCP Test
- Execute Command Test

HTTP Test
```yaml
readinessProbe:
  httpGet:
    path: /api/ready
    port: 8080
```

TCP Test
```yaml
readinessProbe
  tcpSocket:
    port: 3306
```

Execute Command Test
```yaml
readinessProbe:
  exec:
    command:
      - cat
      - /app/is_ready
```

Other options to be used in `readinessProbe`:

- `initialDelaySeconds`: seconds to wait before start the tests
- `periodSeconds`: interval between each test
- `failureThreshold`: how many fails needed to set `Ready` status to `false`


### Liveness Probe

The liveness probe exist to tell kubernetes that a pod must be restarted (if the test fails).


## Container Logging

You can see the logs in a pod with this command:
```bash
kubectl logs -f podName
```

But if you have multiple containers in a pod, you need to explicitly say the container's name:
```bash
kubectl logs -f podName containerName
```


## Monitor and Debug Applications

Kubernetes doesn't have with a builtin monitoring system.

Here are some options:

- Metrics Server
- Prometheus
- Elastic Stack
- DataDog
- dynatrace

**NOTE**: if you see mentions to the Heapster, be aware that it's now deprecated.

### Metrics Server

- works in-memory (no historical data)

Once it's installed, you can use commands like this:
```bash
kubectl top node
kubectl top pod
```