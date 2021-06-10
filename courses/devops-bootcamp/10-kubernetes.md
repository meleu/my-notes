# Container Orchestration with Kubernetes

## 1. Intro to Kubernetes

- Open source **container orchestration tool**
- Developed by Google
- Helps you **manage containerized applications** in different **deployment environments**.

- Questions
    - What **problems** does kubernetes solve?
    - What are the **tasks** of an orchestration tool?

- The need for a container orchestration tool
    - Trend from **monolith** to **microservices**.
    - Increased usage of **containers**
    - Demand for a **proper way** of **managing** those hundreds of containers.

- What features do orchestration tools offer?
    - **high availability** or no downtime
    - **scalability** or hight performance
    - **disaster recovery** - backup and restore


## 2. Main Kubernetes Components

- video: <https://techworld-with-nana.teachable.com/courses/1108792/lectures/28679161>


### Node and Pod

- Node: a virtual machine where the pods run
- Pod:
    - smallest unit of k8s
    - abstraction layer over container
        - you only interact with the kubernetes layer
    - usually 1 application per pod
    - each pod gets its own IP address
    - new IP address on re-creation
        - inconvenient


### Service and Ingress

- Service:
    - permanent IP address
    - connected to the Pod, but...
    - lifecycle of Pod and Service are NOT connected
        - if a Pod dies, the Service keeps the IP address
    - types:
        - internal services
        - external services
            - should use HTTPS (securre)
            - should have a friendly name (`my-app.com`)
            - managed by **Ingress**
    - service is also a load balancer, so it can forward requests to several nodes

![](img/basic-k8s-components.png)


### ConfigMap and Secrets

- ConfigMap:
    - external configuration of your application
        - allows you to configure your app with no need to rebuild it.
        - !!! **don't put credentials into ConfigMap** !!!

- Secret:
    - used to store secret data (e.g.: credentials)
    - base64 encoded
        - true encryption can only be achieved via 3rd party tools
    - !(?) the buil-in security mechanism is not enabled by default!
    - (?) use it as environment variables or as a properties file


### Volumes

- storage can be be:
    - on local machine
    - or remote, outside the k8s cluster
- regardless of storage being local or remote, always consider as an external component of k8s
    - !!! **k8s doesn't manage data persistance!**


### Deployment and StatefulSet

- Deployment:
    - blueprint for `my-app` pods
    - you create Deployments
    - abstraction layer over pods
        - in practice you mostly work with deployments and not with pods
    - !!! **DB can't be replicated via Deployment**
    - for stateless apps

- Statefulset
    - meant for application like Databases
    - for STATEFUL apps
    - :( deploying StatefulSet is not easy
    - DB are often hosted outside of k8s cluster


## 3. Kubernetes Architecture

- Types of clusters:
    - Master
    - Slave

- Each Node has multiple Pods on it
- Worker Nodes do the actual work
- 3 processes must be running on every Node
    1. container runtime
    2. kubelet:
        - interacts with Container and Node
        - starts the Pod with a Container inside
    3. kube proxy - forwards the requests


### Master Nodes

- 4 processes on every master node
    1. API server
        - the cluster gateway
    2. Scheduler
        - **note**: Scheduler just decids **on which Node** nwe pod should be scheduled
        - the process who actually starts the scheduling in the Node's kubelet
    3. Controller Manager:
        - detects cluster state changes
    4. etcd
        - consider it as "the cluster's brain"
        - key value store
        - examples of info in etcd:
            - is the cluster healthy?
            - what resources are available?
            - did the cluster state change?
        - **note**: app data is NOT stored in etcd


### Example Cluster Set-Up

A very small cluster you're probably have

- 2 master nodes
- 3 worker nodes

To add new Master/Worker server

1. get new bare server
2. install all the master/worker node processes
3. add it to the cluster


## 4. Minikube and kubectl - Local Kubernetes Cluster

### Minikube

Having a real cluster setup to practice would require a lot of resources, not usually available in personal computers.

Minikube is a way to test local cluster setup. You have Master and Worker Nodes processes running on **ONE machine**.

- minikube:
    - creates a virtual box on your computer
    - Node runs in that virtual box
    - 1 node k8s cluster
    - for testing purposes


### kubectl

`kubectl` is a command line tool for k8s cluster.

One of the master processes mentioned earlier is the `API Server`. Clients communicate with the `API Server` through a web UI, API calls, or a CLI. And `kubectl` is that CLI (and the most powerful one).


### Installing & Creating a minikube cluster

- video: <https://techworld-with-nana.teachable.com/courses/1108792/lectures/28679481>

- installation instructions
    - minikube: <https://kubernetes.io/docs/tasks/tools/install-minikube/>
    - kubectl: <https://kubernetes.io/docs/tasks/tools/install-kubectl/>

```sh
# define the virtual machine driver with `--driver`
# default is 'autodetect'
minikube start --driver=hyperkit

# check minikube status
minikube status

# check the kubectl version
kubectl version
```

- **kubectl CLI**: for configuring the minikube cluster.
- **minikube CLI**: for start up/deleting the cluster.


## 5. Main kubectl commands

### Get status of components

```sh
kubectl get nodes

kubectl get pod

kubectl get services
```

### Creating a Pod (actually a deployment)

Pod is the smallest unit of a cluster, **but** we're not going to create pods directly. As mentioned earlier, "Deployment" is an abstraction layer over Pods. And with `kubectl` we're going to create "Deployments".

```sh
# get help about ~~pod~~ deployment creation
kubectl create -h

# usage:
# kubectl create deployment NAME --image=image [--dry-run] [options]
# example creating an nginx deployment (nginx image will
# be donwloaded from Docker Hub):
$ kubectl create deployment nginx-depl --image=nginx
deployment.apps/nginx-depl created

# get deployment status
$ kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
nginx-depl   0/1     1            0           9s

# get pod status
$ kubectl get pod
NAME                          READY   STATUS              RESTARTS   AGE
nginx-depl-5c8bf76b5b-nq8dj   0/1     ContainerCreating   0          17s
# STATUS above is still 'ContainerCreating'...
# after a couple of minutes, it's 'Running'
$ kubectl get pod
NAME                          READY   STATUS    RESTARTS   AGE
nginx-depl-5c8bf76b5b-nq8dj   1/1     Running   0          2m12s

# get replicaset status
# note: replicaset is managing the replicas of a pod
# note 2: the pod name is
# ${DEPLOYMENT_NAME}-${REPLICASET_HASH}-${POD_HASH}
$ kubectl get replicaset
NAME                    DESIRED   CURRENT   READY   AGE
nginx-depl-5c8bf76b5b   1         1         1       2m3s
```


### Layers of Abstraction

![](img/k8s-abstraction-layers.png)

**Everything below "Deployment" is handled by Kubernetes**


### Editing a Pod / Deployment

When you edit a deployment, kubernetes automatically create a new pod, and once it's up and running it kills the old pod.

```sh
# edit the deployment
# change spec.template.spec.containers.image from 'nginx' to 'nginx:1.16'
$ kubectl edit deployment nginx-depl
deployment.apps/nginx-depl edited

# checking the deployment status after edition
$ kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
nginx-depl   1/1     1            1           20m

# checking pods status
# here, the old version is running and the new one is being created
$ kubectl get pod
NAME                          READY   STATUS              RESTARTS   AGE
nginx-depl-5c8bf76b5b-nq8dj   1/1     Running             0          20m
nginx-depl-7fc44fc5d4-fbtt5   0/1     ContainerCreating   0          9s

# new pod is running, old one is terminating
$ kubectl get pod
NAME                          READY   STATUS        RESTARTS   AGE
nginx-depl-5c8bf76b5b-nq8dj   0/1     Terminating   0          21m
nginx-depl-7fc44fc5d4-fbtt5   1/1     Running       0          30s

# only the new pod is running
$ kubectl get pod
NAME                          READY   STATUS    RESTARTS   AGE
nginx-depl-7fc44fc5d4-fbtt5   1/1     Running   0          37s

# the old replicaset has no pods
$ kubectl get replicaset
NAME                    DESIRED   CURRENT   READY   AGE
nginx-depl-5c8bf76b5b   0         0         0       42m
nginx-depl-7fc44fc5d4   1         1         1       21m
```


### Debugging pods

- `kubectl logs ${POD_NAME}`
- `kubectl describe pod ${POD_NAME}`

```sh
# let's create another deployment with a mongodb image
# (which creates a more verbose log)
kubectl create deployment mongo-depl --image=mongo

# the pod is not running yet
$ kubectl logs mongo-depl-5fd6b7d4b4-rpqhg
Error from server (BadRequest): container "mongo" in pod "mongo-depl-5fd6b7d4b4-rpqhg" is waiting to start: ContainerCreating     

# checking the detailed status
$ kubectl describe pod mongo-depl-5fd6b7d4b4-rpqhg
Name:           mongo-depl-5fd6b7d4b4-rpqhg
Namespace:      default
Priority:       0
Node:           minikube/192.168.99.100
Start Time:     Thu, 10 Jun 2021 10:24:08 -0300
Labels:         app=mongo-depl
                pod-template-hash=5fd6b7d4b4
# ...
# more info
# ...
Events:
Type    Reason     Age   From               Message
----    ------     ----  ----               -------
  Normal  Scheduled  4m6s  default-scheduler  Successfully assigned default/mongo-depl-5fd6b7d4b4-rpqhg to minikube
  Normal  Pulling    4m5s  kubelet            Pulling image "mongo"
  Normal  Pulled     106s  kubelet            Successfully pulled image "mongo" in 2m18.898375616s
  Normal  Created    105s  kubelet            Created container mongo
  Normal  Started    105s  kubelet            Started container mongo

# the pod is now up and running, let's check the logs
$ kubectl logs mongo-depl-5fd6b7d4b4-rpqhg
# ... a lot of mongodb logs...
```

- Starting an interactive shell session inside the pod:
```sh
kubectl exec -it ${POD_NAME} -- /bin/bash
```


### Delete Deployment

```sh
# deleting the mongodb deployment
$ kubectl delete deployment mongo-depl
deployment.apps "mongo-depl" deleted

# after deleting a deployment, its pods are going to terminate
$ kubectl get pods
NAME                          READY   STATUS        RESTARTS   AGE
mongo-depl-5fd6b7d4b4-rpqhg   0/1     Terminating   0          18m
nginx-depl-7fc44fc5d4-fbtt5   1/1     Running       0          71m

# the replicaset is already gone
$ kubectl get replicaset
NAME                    DESIRED   CURRENT   READY   AGE
nginx-depl-5c8bf76b5b   0         0         0       92m
nginx-depl-7fc44fc5d4   1         1         1       71m

# deleting the nginx deployment too
$ kubectl delete deployment nginx-depl
deployment.apps "nginx-depl" deleted

$ kubectl get pods
NAME                          READY   STATUS        RESTARTS   AGE
nginx-depl-7fc44fc5d4-fbtt5   0/1     Terminating   0          72m

$ kubectl get replicaset
No resources found in default namespace.
```

### Apply Configuration File

`kubectl apply -f config-file.yaml`

An example for `nginx-deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:       # deployment specs
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:   # pod specs
      containers:
      - name: nginx
        image: nginx:1.16
        ports:
        - containerPort: 80
```

```sh
# type the file above
$ vim nginx-deployment.yaml

# applying that config file
# note that the output says "... created"
$ kubectl apply -f nginx-deployment.yaml 
deployment.apps/nginx-deployment created

$ kubectl get pod
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-644599b9c9-qp8lb   1/1     Running   0          7s

$ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   1/1     1            1           17s

$ kubectl get replicaset
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-644599b9c9   1         1         1       28s

# edit the file and increase the `spec.replicas` from 1 to 2
$ vim nginx-deployment.yaml 

# note that the output says "... configured"
# kubernetes know when to create/update a deployment
$ kubectl apply -f nginx-deployment.yaml 
deployment.apps/nginx-deployment configured

$ kubectl get deployment
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   2/2     2            2           65s

$ kubectl get replicaset
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-644599b9c9   2         2         2       68s

$ kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-644599b9c9-c9nc2   1/1     Running   0          16s
nginx-deployment-644599b9c9-qp8lb   1/1     Running   0          76s
```

### Summarizing

```sh
# CRUD commands
########################################
kubectl create deployment ${NAME}
kubectl edit deployment ${NAME}
kubectl delete deployment ${NAME}
# using files
kubectl apply -f ${YAML_FILE}
kubectl delete -f ${YAML_FILE}

# Status of different k8s components
########################################
kubectl get nodes | services | deployment | replicaset | pod

# Debugging
########################################

# get logs
kubectl logs ${POD_NAME}

# detailed info about the pod
kubectl describe pod ${POD_NAME}

# interactive shell session inside a pod
kubectl exec -it ${POD_NAME} -- /bin/bash
```


## 6. YAML Configuration File

### 3 Parts of a k8s Configuration File

1. metadata
2. specifications
    - the first two lines (`apiVersion` and `kind`)
    - and the `spec` part
    - attributes of `spec` are specific to the `kind`.
3. status
    - automatically generated/added by kubernetes
    - created by comparing the desired state (from the `spec` part of the yaml) and the actual state
    - if the states don't match, kubernetes knows that there's something to be fixed
    - status data comes from `etcd` Master process
        - `etcd` holds the current status of any k8s component


### Format of k8s Configuration File

- YAML file
- "human friendly data serialization standard for all programming languages
- syntax: strict indentation
- store the config file with your code or own git repository


### Blueprint for Pods (Templates)

The `template`:

- has its own `metadata` and `spec` sections (it's like a config file inside a config file).
- applies to a Pod
- it's the blueprint for a Pod


### Connecting components (Labels & Selectors & Ports)

Connection is stablished using labels and selectors.

- `metadata` part contains the `labels`
- `spec` part contains `selector`

- Pods get the label through the template blueprint
    - example:
```yaml
spec:
  template:
    metadata:
    labels:
        app: nginx
```

- we tell the Deployment to create the connection only for the pods where labels match with the one defined in `selector`
```yaml
spec:
  selector:
    matchLabels:
      app: nginx
```

- this way the Deployment knows which Pod belongs to it.

- deployment has it's own label, used by the `Service`.

- the `selector` in the `Service` yaml file identifies to which Deployment it's connected to.

**Ports**

![](img/k8s-ports-in-service-and-pod.png)


```sh
# creating deployment and service
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml

# let's check them
kubectl get pod
kubectl get service

# get more details about the service
kubectl describe service nginx-service
# check the Selector, TargetPort and Endpoints

```