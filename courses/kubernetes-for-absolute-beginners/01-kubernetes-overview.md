# Kubernetes Overview

Container + Orchestration

> Docker is not meant to run different Operating Systems/Kernels on the same hardware. The main purpose of docker, is to containerize applications and ship and run them.

**Container orchestration:** the process of automatically deploying and managing containers (usually based on the load needs).

### Kubernetes Architecture

- Worker Node (aka minions): the worker machines where the containers are running. If node fails, the app is down (that's why we must have multiple nodes).
- Cluster: a set of nodes. If a node fails, the app is still available through the other nodes
- Master Node: watches over the nodes and is responsible for the containers orchestration.

- Components:
    - API Server: frontend for kubernetes
    - etcd: distributed reliable key-value store, to store data used to manage the cluster. Stores logs to ensure no conflicts between the masters.
    - Scheduler: distribute work and containers and assign them to nodes.
    - Controller: the brain behind orchestration, responsible to react when containers/nodes/endpoints go down.
    - Container Runtime: the underlying software used to run containers (currently it's docker)
    - kubelet: the agent running in each node in the cluster, responsible to assure the containers are running as expected. It interacts with the Master node via API Server.

```
| -------------- |       | ----------------- |
| kube-apiserver | <---> | kubelet           |
| etcd           |       |                   |
| controller     |       |                   |
| scheduler      |       |                   |
|                |       | container runtime |
| -------------- |       | ----------------- |
| Master Node    |       | Worker Node       |
| -------------- |       | ----------------- |
```

The `kubectl` is the CLI used to interact with kubernetes.

Examples:

- `kubectl run hello-minikube` - deploy an application
- `kubectl cluster-info` - view info about the cluster
- `kubectl get nodes` - list all the nodes that are part of the cluster


## anki cards


TARGET DECK: kubernetes

The 6 main kubernetes components #flashcard 
- Master Node:
    - API Server
    - etcd
    - controller
    - scheduler
- Worker Node
    - kubelet
    - container runtime


k8s component: API Server #flashcard 
- handles communication with the worker node.
- runs on the Master Node

k8s component: etcd #flashcard
- key-value store with data used to manage the cluster
- stores logs to prevent conflicts between the nodes
- runs on the master node

k8s component: Scheduler #flashcard
- distributes work and containers, assigning them to nodes
- runs on the master node


k8s component: Controller #flashcard
- the brain behind orchestration
- responsible to react when containers/nodes/endpoints go down
- runs on the master node

k8s component: Container Runtime #flashcard
- underlying software used to run containers
- runs on the worker node


k8s component: kubelet #flashcard
- the agent running in each node
- responsible to assure containers runs as expected
- runs on the worker node
- interacts with master node via API Server

