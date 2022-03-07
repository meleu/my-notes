# Services & Networking

## Services

> "Services" allows loose coupling between the microservices in our application.

![[Pasted image 20211018093926.png]]


### Service Types

- NodePort: enable connections from outside of the Node to reach the pods inside that Node.
- ClusterIP: allows communications between pods.
- LoadBalancer: provisions load balancers to our application.


### NodePort

Three ports involved:

1. Actual Node's port - `nodePort`
2. Service's port - `port`
3. Pod's port - `targetPort`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  type: NodePort
  selector:
    app: myapp
    tier: front-end
  ports:
    - nodePort: 30008
      port: 80
      targetPort: 80
```

**Notes**:

- `port` is the only mandatory field
- if you don't provide a `targetPort`, it'll be the same as `port`
- if you don't provide a `nodePort`, it'll be a randomly choosen between 30000-32767.
- the `ports` is an array, therefore you can have multiple mappings here.


## ClusterIP

Allows communication between pods inside a cluster

![[Pasted image 20211018101600.png]]

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  type: ClusterIP
  selector:
    app: myapp
    type: back-end
  ports:
    - targetPort: 80
      port: 80
```


## Ingress Networking

- <https://www.udemy.com/course/certified-kubernetes-application-developer/learn/lecture/13302764#overview>

> Ingress helps your users to access your application through a single URL.

Ingress Controller - Ingress Resources

![[Pasted image 20211018103913.png]]

You do not have an Ingress Controller in kubernetes by default, so you must deploy one.

### Ingress Controller

This NginX image can be used as an Ingress Controller: <https://quay.io/repository/kubernetes-ingress-controller/nginx-ingress-controller>

#### Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata: 
  name: nginx-ingress-controller
spec:
  replicas: 1
  selector:
    matchLabels:
      name: nginx-ingress
  template:
    metadata:
      labels:
        name: nginx-ingress
    spec:
      containers:
        - name: nginx-ingress-controller
          image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0
      args:
        - /nginx-ingress-controller
        - --configmaps=$(POD_NAMESPACE)/nginx-configuration
      env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        - name: POD_NAMESPACE
          valueFrom:
            fieldRef:
              fieldPath: metadata.namespace
      ports:
        - name: http
          containerPort: 80
        - name: https
          containerPort: 443
```

Some settings must be in a ConfigMap


#### Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-ingress
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  - port: 443
    targetPort: 443
    protocol: TCP
    name: https
  selector:
    name: nginx-ingress
```


#### Service Account

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: nginx-ingress-serviceaccount
```

It must have configs for `Roles`, `ClusterRoles` and `RoleBindings`.


### Ingress Resources


```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-wear
spec:
  backend:
    serviceName: wear-service
    servicePort: 80
```

#### Ingress rules

Based on path:
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-wear-watch
spec:
  rules:
  - http:
      paths:
      - path: /wear
        backend:
          serviceName: wear-service
          servicePort: 80
      - path: /watch
        backend:
          serviceName: watch-service
          servicePort: 80
```

Based on the domain:
```yaml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-wear-watch
spec:
  rules:
  - host: wear.my-online-store.com
    http:
      paths:
      - backend:
          serviceName: wear-service
          servicePort: 80
  - host: watch.my-online-store.com
    http:
      paths:
      - backend:
          serviceName: watch-service
          servicePort: 80
```

