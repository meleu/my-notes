# JSONPath

## Video Tutorial

<https://youtu.be/ni1UrmaXQkM>

## kubectl use

### Get the name of all deployments with replicas different than zero

```bash
kubectl get deployments \
  -o jsonpath='{.items[?(@.status.replicas != 0)].metadata.name}'
```


### Get the labels of all pods

```bash
kubectl get deployments \
  -o jsonpath='{.items[*].spec.template.metadata.labels}' \
  | jq .
```

If you want the value of a specific label (let's say, `app`) this can be more efficient:
```bash
kubectl get deployments \
  -o jsonpath='{.items[*].spec.template.metadata.labels.app}' 
```


### Get all labels to which all services are selecting

```bash
kubectl get services \
  -o jsonpath='{.items[*].spec.selector}' \
  | jq .
```

If you want the value of a specific label (let's say, `app`) this can be more efficient
```bash
kubectl get services \
  -o jsonpath='{.items[*].spec.selector.app}'
```


