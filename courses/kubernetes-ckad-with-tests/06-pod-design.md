# Pod Design

## Labels, Selectors and Annotations

You can label the kubernetes objects in the `metadata.label` part, and then select such objects using a selector.

```bash
kubectl get pods --selector app=App2
```

**Note**: be mindful that in a ReplicaSet or Deployment, the `metadata.label` refers to the ReplicaSet/Deployment itself. And the `spec.template.metadata.label` refers to the labels of the pods generated by the ReplicaSet/Deployment.


### Annotations

Annotations are used to record other details for informative purpose. Details like name, version, build, etc. Or contact details, phone numbers, emails, IDs, etc.


## Rolling Updates & Rollbacks in Deployments

Rollout Command
```bash
kubectl rollout status deployment/myapp-deployment

kubectl rollout history deployment/myapp-deployment
```


Two types of Deployment Strategies:
- **Recreate**: Destroy all pods first, and then bring up the new ones (con: downtime)
- **Rolling Update**: Destroy 1 pod, and then bring up a new one. Repeat it until all pods are the new version.


Rollback:
```bash
kubectl rollout undo deployment/myapp-deployment
```

### Summarize Commands

```bash
# CREATE
kubectl create -f deployment.yaml

# GET
kubectl get deployments

# UPDATE
kubectl apply -f deployment.yaml
kubectl set image deployment/myapp-deployment nginx=nginx1.9.1

# STATUS
kubectl rollout status deployment/myapp-deployment
kubectl rollout history deployment/myapp-deployment

# ROLLBACK
kubectl rollout undo deployment/myapp-deployment
```


## Jobs

Types of workloads:

- Continuous
    - web (frontend?)
    - application (backend?)
    - database
- Temporary
    - Batch processing
    - Analytics / Reporting


### RestartPolicy

- Always
- Never
- OnFailure


### Kubernetes Jobs

There's a kubernetes component for temporary tasks (as oposed to apps that must be running continuously).

The most basic job definition file (oversimplified for educational purposes):
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: math-add-job
spec:
  template: 
    spec: # that's a pod's spec
      containers:
        - name: math-add
          image: ubuntu
          command: ['expr', '3', '+', '2']
      restartPolicy: Never
```

Generate the yaml via CLI:
```bash
kubectl create job throw-dice-job \
  --image kodekloud/throw-dice \
  --dry-run=client -o yaml
```


```bash
# CREATE
kubectl create -f job.yaml

# GET
kubectl get jobs
kubectl get pods

# READ
kubectl logs podName

# DELETE
kubectl delete job jobName
```

#### completions

You can also set the number of successfull completions you want for a job to be considered done. Such configuration is put in `Job.spec.completions`.


#### parallelism

The default Job's behavior is to start new pods only when the current one is finished.

If you want the Job's pod to run in parallel, set the amount of pods running in parallel you want in `Jobs.spec.parallelism`.

#### Backoff Limit

See also: `Jobs.spec.backoffLimit`: <https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy>


## CronJobs

A CronJob is a way to run Jobs at certain specified times.

Example:
```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: reporting-cron-job
spec: # CronJob's spec
  schedule: "*/1 * * * *"
  jobTemplate:
    spec: # Job's spec
      completions: 3
      parallelism: 3
      template:
        spec: # Pod's spec
          containers:
            - name: reporting-tool
              image: reporting-tool
          restartPolicy: Never
```

Generate the yaml via CLI:
```bash
kubectl create cronjob throw-dice-cron-job \
  --image kodekloud/throw-dice \
  --schedule "30 21 * * *" \
  --dry-run=client -o yaml
```

```bash
# CREATE
kubectl create -f cron-job-definition.yaml

# GET
kubectl get cronjob
```


