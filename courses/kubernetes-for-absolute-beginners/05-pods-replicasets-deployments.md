# Kubernetes Concepts: PODs, ReplicaSets, Deployments

## YAML in Kubernetes

A kubernetes definition file always have 4 top-level fields: `apiVersion`, `kind`, `metadata` and `spec`.

- `apiVersion`: self explanatory. Needed in order to use specific features that only exist in specific versions.
- `kind`: can be:
    - `Pod`
    - `Service`
    - `ReplicaSet`
    - `Deployment`
    - many more...
- `metadata.labels`: helps you to identify a pod later in time. Under `labels` you can have any kind of key-value as you see fit.
- `spec`: specifications


Example:

`pod-definition.yml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
    type: front-end
spec:
  containers:
    - name: nginx-container
      image: nginx
```

```sh
# create the pod defined in that file
kubectl create -f pod-definition.yml

# let's see info about it:
kubectl get pods
kubectl describe pod myapp-pod

# edit a pod yaml file "on-the-fly"
kubectl edit pod myapp-pod
```


### trick to create a yaml file from CLI

```sh
kubectl run redis --image=redis --dry-run=client -o yaml
```


## Replication Controllers and ReplicaSets

Controllers are the processes responsible to monitor kubernetes objects and respond accordingly. Here we'll discuss about the Replication Controller.

Replication controller is the old technology to manage pods replication. ReplicaSet is the new way.

### ReplicationController

Minimum fields in the yaml file:
```yaml
apiVersion: 
kind: 
metadata: 
  name: 
  labels: 
spec: 
  template: 
    # pode definition
  replicas: 
```

`rc-definition.yml`
```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: myapp-rc
  labels:
    app: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
      - name: nginx-container
        image: nginx
  replicas: 3
```

```sh
# create the ReplicationController
kubectl create -f rc-definition.yml

# view the list of ReplicationControllers
kubectl get replicationcontroller

# see the amount of replicas you're running
# (in this example it should be 3)
kubectl get pods
```


### ReplicaSet

ReplicaSet requires:

- `apiVersion: apps/v1`
- `selector: `

`replicaset-definition.yml`:
```yaml
apiVersion:
kind:
metadata:
  name:
  labels:
spec:
  template:
    # pod definition
  replicas:
  selector:
    matchLabels:
      # pod's labels
```

Example `replicaset-definition.yml`
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp-rc
  labels:
    app: myapp
    type: front-end
spec:
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
      - name: nginx-container
        image: nginx
  replicas: 3
  selector:
    matchLabels:
      type: front-end
```

```sh
# create the ReplicaSet
kubectl create -f replicaset-definition.yml

# get info
kubectl get replicaset

# see if there are three replicas of that pod definition
kubectl get pods
```


### Labels and Selectors

The labels in the pods is the way the ReplicaSet can know how many new pods it needs to put up (and it will create new ones based on the `spec.template` definition).

The `selector.matchLabels` is the way the ReplicaSet can know which pods to keep monitoring. It could also be `selector.matchExpressions`.

### Scaling

```sh
# update the definition file and then:
kubectl replace -f replicaset-definition.yml

# without modifying the definition file, but based on it:
kubectl scale --replicas=6 -f replicaset-definition.yml

# referencing the ReplicaSet's name, and still,
# without modifying the definition file
kubectl scale --replicas=6 replicaset myapp-replicaset

# editing the live version of the ReplicaSet
kubectl edit replicaset myapp-replicaset
```


## Deployment

Deployment is an abstraction layer on top of ReplicaSet.

The definition file looks exactly the same as a ReplicaSet, only changing the `kind` from `ReplicaSet` to `Deployment`.

commands:
```sh
kubectl create -f deployment-definition.yml

kubectl get deployments

# you can see how a deployment creates a ReplicaSet
kubectl get replicaset 

# and how the ReplicaSet creates the pods
kubectl get pods

# see "everything"
kubectl get all

# create a deployment yaml from CLI
kubectl create deployment \
  httpd-frontend \
  --image=httpd:2.4-alpine \
  --replicas=3 \
  --dry-run=client \
  -o yaml
```



## Rollout and Versioning

 When you create a deployment, it triggers a rollout. A rollout creates a new revision.
 
 See status of the rollout:
 ```sh
 kubectl rollout status deployment/myapp-deployment
 ```
 
### Deployment Strategy

- Recreate:
     - shutdown every pods and then put up the newer version ones
- Rolling Update (default)
     - shutdown one, put up a new one with the newer version

When you upgrade using the Rolling Update strategy, the deployment creates a new ReplicaSet and scale it up synchronized with the previous ReplicaSet version, scaling it down.

### Rollback

```sh
kubectl rollout undo deployment/myapp-deployment
```


### Summarize Commands

```sh
# create
kubectl create -f deployment-definition.yml
 
 # get
kubectl get deployments

# update
kubectl apply -f deployment-definition.yml
kubectl set image deployment/myapp-deployment nginx=nginx:1.9.1

# status
kubectl rollout status deployment/myapp-deployment
kubectl rollout history deployment/myapp-deployment
 
# rollback
kubectl rollout undo deployment/myapp-deployment
```



