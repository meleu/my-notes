# Configuration

## Commands and Arguments in Docker

### `CMD` and `ENTRYPOINT` in Dockerfile

The `CMD` instruction says which command is to be run when the container starts. This is the command to be run while the container is alive. When this command finishes or crashes, the container finishes.

Example:
```Dockerfile
# image name: ubuntu-sleeper
FROM ubuntu

# sleep for 5 seconds
CMD sleep 5
```

It can be overwritten in the command line:
```bash
docker container run ubuntu-sleeper sleep 10
# command at startup: sleep 10
```

The `CMD` instruction also accepts an "array notation":
```Dockerfile
# CMD command param1 paramN

CMD ["command", "param1", "paramN"]
```


If you want your image to have always the same command, but let the user set an argument, use the `ENTRYPOINT` instruction:
```Dockerfile
# image name: ubuntu-sleeper
FROM ubuntu

ENTRYPOINT ["sleep"]
```

Now you can just pass the argument in the docker command:
```bash
docker container run ubuntu-sleeper 10
# command at startup: sleep 10
```

If you don't pass an argument, the resulting command is going to be `sleep` which generates an error.


You can also have the same command and a default argument:
```Dockerfile
# image name: ubuntu-sleeper
FROM ubuntu

ENTRYPOINT ["sleep"]

CMD ["5"]
```

This way you can use the default command or pass an argument to overwrite the default one:
```bash
docker container run ubuntu-sleeper
# command at startup: sleep 5

docker container run ubuntu-sleeper 10
# command at startup: sleep 10
```

And if you want to overwrite the entrypoint:
```bash
docker container run --entrypoint sleep2.0 ubuntu-sleeper 10
# command at startup: sleep2.0 10
```


### `command` and `args` in Pod's definition

If you want to overwrite `ENTRYPOINT` and `CMD` in the Pod's definition file, use the `command` and `args` keys.

Example:
```yaml
apiVersion: v1

kind: Pod

metadata:
  name: ubuntu-sleeper-pod

spec:
  containers:
    - name: ubuntu-sleeper
      image: ubuntu-sleeper
      
      # overwrites ENTRYPOINT
      command: ["sleep2.0"]
      
      # overwrites CMD
      args: ["10"]
```

**Note**: remember that `CMD` is **NOT** overwritten by the `command` key, but by `args`.



## Environment Variables in Kubernetes

```yaml
# ... pod's specification
spec:
  containers:
    - image: webapp-image
      # ...
      env:
        - name: VAR_NAME
          value: VAR_VALUE
          
        # Examples:
        
        # 1. play key-value
        - name: APP_COLOR
          value: ping

        # 2. ConfigMap
        - name: APP_COLOR
          valueFrom:
            configMapKeyRef:

        # 3. Secret
        - name: APP_COLOR
          valueFrom:
            secretKeyRef:
```



## ConfigMaps

ConfigMaps are used to pass configuration data in the form of key-value pairs.

Creating a ConfigMap, the imperative way:
```bash
# command syntax:
kubectl create configmap ${configName} --from-literal=${key}=${value}

# example:
kubectl create configmap app-config \
  --from-literal=APP_COLOR=blue \
  --from-literal=APP_MOD=prod

# getting the key-value pairs from a file
kubectl create configmap app-config \
  --from-file=app_config.properties
```

ConfigMap, the declarative way:
%% anki %%
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_COLOR: blue
  APP_MODE: prod
```

**WARNING**: a ConfigMap definition file doesn't need a `spec`.

ConfigMap in Pods:

```yaml
# ... pod's definition
spec:
  containers:
    - # ...
      envFrom:
        - configMapRef:
          name: ${configMapName}
```


3 ways to use ConfigMaps in Pods:

- env var from whole config map
- single env var from the config map
- volume

```yaml
# env var from whole config map
pod.spec.containers:
  - envFrom:
    - configMapRef:
        name: app-config


# single env var from the config map
pod.spec.containers:
  env:
    - name: APP_COLOR
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: APP_COLOR


# volume
pod.spec.containers:
  volumes:
  - name: app-config-volume
    configMap:
      name: app-config
```

practicing: <https://kodekloud.com/topic/configmaps-2/>


## Secrets

It works like a ConfigMap but used to store sensitive data, like passwords.


### Creating secrets

Imperative way:
```bash
# getting key-value pairs directly from command line
kubectl create secret generic ${secretName} \
  --from-literal=${key}=${value}

# getting key-value pairs from a file
kubectl create secret generic ${secretName} \
  --from-file=${filePath}
```


Declarative way:
```yaml
apiVersion: v1

kind: Secret

metadata:
  name: app-secret

data:
  DB_Host: base64EncodedHost
  DB_User: base64EncodedUser
  DB_Password: base64EncodedPassword
```


### Secrets in Pods

```yaml
pod.spec.containers:
  - envFrom:
    - secretRef:
        name: app-secret # secret's name
```

3 ways to use Secrets in Pods:

- env var from whole secret
- single env var from the secret
- volume

```yaml
# env var from whole secret
pod.spec.containers:
  - envFrom:
    - secretRef:
        name: app-secret


# single env var from the config map
pod.spec.containers:
  env:
    - name: DB_Password
      valueFrom:
        secretKeyRef:
          name: app-secret
          key: DB_Password


# volume
pod.spec.containers:
  volumes:
  - name: app-config-volume
    secret:
      secretName: app-secret
```

If you set the secret as a volume, kubernetes creates a directory `/opt/app-secret-volumes` with the contents of the secret in files.


## Docker Security

By default, the container's entrypoint is ran by `root`. You can overwrite it by using the `--user` option:
```bash
docker container run --user=1001 ubuntu sleep 3600
```

Linux capabilities are listed in `/usr/include/linux/capability.h`

A docker container has, by default, not all capabilities enabled. You can enable them individually with the `--cap-add` option. Example:
```bash
docker container run --cap-add MAC_ADMIN ubuntu
```

You can drop them with `--cap-drop` option:
```bash
docker container run --cap-drop KILL ubuntu
```

If you want all privileges enabled, use the `--privileged` flag:
```bash
docker container run --privileged ubuntu
```


## Security Context

The docker security features mentioned above can be used in the pod's definition file as well, via `securityContext`

You can decide if you want to set the `securityContext` in the pod's level (`pod.spec.securityContext`) or individual containers' level (`pod.spec.containers.securityContext`)

Example:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-pod
spec:
  containers:
    - name: ubuntu
      image: ubuntu
      command: ["sleep", "3600"]
      securityContext:
        runAsUser: 1000
        # NOTE: capabilities are only supported at container's level
        capabilities:
          add: ["MAC_ADMIN"]
```


## Service Account

**NOTE**: I need to find another way to understand the Service Account concept.

Create a service account:
```bash
kubectl create serviceaccount dashboard-sa
```

A service account automatically creates a token as a Secret. You can see the secret name via:
```bash
kubectl describe serviceaccount dashboard-sa
```


## Resource Requirements

| Notation        | bytes         |
| --------------- | ------------- |
| 1 G (Gigabyte)  | 1,000,000,000 |
| 1 M (Megabyte)  | 1,000,000     |
| 1 K (Kilobyte)  | 1,000         |
| 1 Gi (Gibibyte) | 1,073,741,824 |
| 1 Mi (Mebibyte) | 1,048,576     |
| 1 Ki (Kibibyte) | 1,024         |

Example:
```yaml
# pod's spec
containers:
  - resources:
      requests:
        cpu: "500m"
        memory: "128Mi"
      limits:
        cpu: "1000m"
        memory: "256Mi"
```

- Requests -> minimum
- Limits -> maximum



## Taints & Tolerations

Analogy:

A person want to repel bugs. A person use a taint in himself to avoid those bugs that are intolerant to that taint. There are, though, some bugs that are tolerant to that taint and will be able to land on the person.

Now, assume the Node is the person, and the pods are the bugs. Taints are applied to Nodes to prevent certain pods from being instantiated in the tainted Node. But you can also make a Pod tolerant to certain taints.

Taints are set on Nodes and Toleration are set on Pods

How to apply a taint to a node:
```bash
kubectl taint nodes ${nodeName} ${key}=${value}:${taintEffect}

# ${taintEffect}: determines what happens to Pods
#                 that do not tolerate the taint
# - NoSchedule - intolerant pod's won't be scheduled
# - PreferNoSchedule - prefer to schedule in another Node
# - NoExecute - won't schedule and finish existing ones

# Example:
kubectl taint nodes node1 app=blue:NoSchedule
```

How to apply a toleration to a pod:
```yaml
# pod's spec
# NOTE: the values need "double quotes"
tolerations:
  - key: ${key}
    operator: ${operator}
    value: ${value}
    effect: ${effect}
```

Example:
```yaml
# applying a toleration to the following taint
# kubectl taint nodes node1 app=blue:NoSchedule

# pod's spec
tolerations:
  - key: "app"
    operator: "Equal"
    value: "blue"
    effect: "NoSchedule"
```


**Note**: taint-toleration technique does **not** guarantee that a tolerant Pod will be instantiated in the tainted Node. The feature for such usecase is called Node Affinity.


Interesting info: The Scheduler prevent pods from being instantiated in the Master Node using a taint.




## Node Selectors

Nodes with different resources.

You'd like to spawn more demanding apps to be run in the most powerful node

```yaml
# pod's definition
spec:
  containers:
  # containers definition
  nodeSelector:
    size: Large # node's key-value label
```

How to setup complex situations like: "Large OR Medium" and "NOT Small"?

Because of such limitations, the Node Affinity feature was created.


## Node Affinity

Hands-on labs: <https://uklabs.kodekloud.com/topic/node-affinity-3/>

Assure that pods are running in particular Nodes.

Node Affinity increases the complexity. The previous example with `pods.spec.nodeSelector.size: Large` would be something like this:

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
          - key: size
            operator: In
            values:
              - Large
```

Other possibilities
```yaml
# Large OR Medium
- key: size
  operator: In
  values:
    - Large
    - Medium
---
# NOT Small
- key: size
  operator: NotIn
  values:
    - Small
---
# label 'size' simply exists, no matter its value
- key: size
  operator: Exists
```


### Node Affinity Types

- `requiredDuringSchedulingIgnoredDuringExecution`
- `preferredDuringSchedulingIgnoredDuringExecution`
- `requiredDuringSchedulingRequiredDuringExecution` (planned to be implemented)


