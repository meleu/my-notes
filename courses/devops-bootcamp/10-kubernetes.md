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
    - !!! ** DB can't be replicated via Deployment
    - for stateless apps

- Statefulset
    - meant for application like Databases
    - for STATEFUL apps
    - :( deploying StatefulSet is not easy
    - DB are often hosted outside of k8s cluster


### Wrap Up



