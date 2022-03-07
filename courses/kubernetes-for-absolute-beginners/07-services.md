# Services

"Services" is the abstraction used to allow communication between pods/deployments/nodes and the external world.

![[Pasted image 20210913140211.png]]

In this example there's a NodePort service forwarding requests reaching the Node's port 30008 and forwarding it to the pod's IP/port.

![[Pasted image 20210913141111.png]]

## Service Types

- NodePort: maps a port on the node to a port on the pod.
- ClusterIP: creates a virtual IP inside the cluster to enable communication between different services.
- LoadBalancer: distribute the load across the services


![[Pasted image 20210913141246.png]]


## NodePort

![[Pasted image 20210913142149.png]]

`service-definition.yml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  type: NodePort
  ports:
    - targetPort: 80  # pod's port (pods matching the selector)
      port: 80        # service's port accessing pod's port
      nodePort: 30008 # port accessible to the outside world
  selector: # put the pod's labels
    app: myapp
    type: front-end
```

- Notes:
    - if you don't provide `targetPort`, it'll be the same as `port`.
    - if you don't specify a `nodePort`, kubernetes will automatically set it to a free port between [30000-32767].
    - if there are multiple pods, the Service will forward the request randomly (trying to preserve the session?)
    
If the pods are distributed between different nodes, a single service acts like the same in the different nodes:

![[Pasted image 20210913163607.png]]

Summarizing:

In any of these cases:

- single pod in a single node
- multiple pods in a single node
- multiple pods in multiple nodes

the Service is created exactly the same.

Create a NodePort Service via CLI:
```bash
kubectl expose deployment \
  webapp-deployment \
  --name=webapp-service \
  --type=NodePort \
  --target-port=8080 \
  --port=8080 \
  --dry-run=client \
  -o yaml
# notes:
# 1. the deployment must exist
# 2. nodePort should be added later
```



## ClusterIP

Used for communication between pods.

It's useful because pods (and their IPs) are ephemeral. So a ClusterIP Service can handle this communication properly.

![[Pasted image 20210914090711.png]]

```yaml
apiVersion: v1
kind: Service
metadata:
  name: back-end
spec:
  type: ClusterIP
  ports:
    - targetPort: 80  # pod's port
      port: 80        # service's port
  selector:
    app: myapp
    type: back-end
```

Note: `ClusterIP` is the default `Service`. So, if you omit the `type` in the yaml file, it's assumed you mean `type: ClusterIP`.



## LoadBalancer

All you need to do is to use a NodePort configuration file replacing `type: NodePort` with `type: LoadBalancer`.

Note: it only works with supported cloud platforms (GCP, AWS, etc.).