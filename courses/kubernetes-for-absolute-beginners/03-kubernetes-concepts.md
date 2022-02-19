# Kubernetes Concepts

Official docs: <https://kubernetes.io/docs/concepts/>

## Pods

In kubernetes our ultimate aim is to deploy application in containers in a set of machines that are configured as worker nodes in a cluster.

We can't deploy containers directly, but we can deploy a pod, which is an abstraction layer on top of the container, that can have one or more containers.

When the load increases (number of users accessing the service), we deploy another pods. If the load increases even more, kubernetes can even deploy a new pod in another Node.



### Multi-Container Pods

Having multiple containers in the same pod is OK. However, it's recommended to do it only when the containers that must escalate together.



### `kubectl` commands

```sh
# starting a pod
kubectl run nginx --image=nginx

# get pod info
kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          34s

# a little more info about the pod
kubectl get pods -o wide

# see detailed info about a pod
kubectl describe pod nginx
```

Interesting info shown by `kubectl describe`

- The node where it's running
- when it started
- labels
- Pod's IP address
- Containers' info
    - image
- Events that happened in that event

