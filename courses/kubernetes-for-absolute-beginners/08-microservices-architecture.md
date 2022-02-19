# Microservices Architecture


## Deploying a Microservices Application with Pods

![[Pasted image 20210914140851.png]]

### Pods

`voting-app-pod.yaml`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: voting-app-pod
  labels:
    name: voting-app-pod
    app: demo-voting-app
spec:
  containers:
    - name: voting-app
      image: kodekloud/examplevotingapp_vote:v1
      ports:
        - containerPort: 80
```

`result-app-pod.yaml`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: result-app-pod
  labels:
    name: result-app-pod
    app: demo-voting-app
spec:
  containers:
    - name: result-app
      image: kodekloud/examplevotingapp_result:v1
      ports:
        - containerPort: 80
```

`redis-pod.yaml`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: redis-pod
  labels:
    name: redis-pod
    app: demo-voting-app
spec:
  containers:
    - name: redis
      image: redis
      ports:
        - containerPort: 6379
```

`postgres-pod.yaml`:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: postgres-pod
  labels:
    name: redis-pod
    app: demo-voting-app
spec:
  containers:
    - name: postgres
      image: postgres
      ports:
        - containerPort: 5432
      env:
        - name: POSTGRES_USER
          value: "postgres"
        - name: POSTGRES_PASSWORD
          value: "postgres"
```

`worker-app-pod.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: worker-app-pod
  labels:
    name: worker-app-pod
    app: demo-voting-app
spec:
  containers:
    - name: worker-app
      image: kodekloud/examplevotingapp_worker:v1
```


### Services

`redis-service.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: redis
  labels:
    name: redis-service
    app: demo-voting-app
spec:
  ports:
    # type is omitted, therefore ClusterIP
    - port: 6379
      targetPort: 6379
  selector:
    # obtained from redis-pod
    name: redis-pod
    app: demo-voting-app
```

`postgres-service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: db
  labels:
    name: postgres-service
    app: demo-voting-app
spec:
  ports:
    - port: 5432
      targetPort: 5432
  selector:
    # obtained from postgres-pod
    name: postgres-pod
    app: demo-voting-app
```

`voting-app-service.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: voting-service
  labels:
    name: voting-service
    app: demo-voting-app
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30004
  selector:
    name: voting-app-pod
    app: demo-voting-app
```

`result-app-service.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: result-service
  labels:
    name: result-service
    app: demo-voting-app
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30005
  selector:
    name: result-app-pod
    app: demo-voting-app
```


### Running it

Use `kubectl create -f ${file}` for each one of those files above.

Or if everything is in the same directory:
```sh
kubectl apply -R -f dir/
```

And to access it:
```sh
# voting service (get the url)
minikube service voting-service --url

# result service (get the url)
minikube service result-service
```

## Deploying Microservices Application with Deployments

![[Pasted image 20210914140925.png]]

Deploying pods doesn't help to scale the application properly

`voting-app-deploy.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: voting-app-deploy
  labels:
    name: voting-app-deploy
    app: demo-voting-app
spec:
  replicas: 1
  selector:
    matchLabels:
      name: voting-app-pod
      app: demo-voting-app
      
    template:
      metadata: voting-app-pod
      labels:
        name: voting-app-pod
        app: demo-voting-app
      spec:
        containers:
          - name: voting-app
            image: kodekloud/examplevotingapp_vote:v1
            ports:
              - containerPort: 80
```

Do the same for `redis-deploy.yaml`, `result-app-deploy.yaml`, and `postgres-deploy.yaml`

Then `kubectl apply -f ${file}` using those files.

Then let's scale up the `voting-app-deploy`:
```sh
kubectl scale deployment voting-app-deploy --replicas=3
```

Access the voting page again and change the vote several times. Note at the bottom of the page that the pod's name is changed sometimes (meaning you're accessing a different pod).


