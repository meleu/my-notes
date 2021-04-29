# Containers With Docker

## 1. What is a Container

- A way to package application with all the necessary dependencies and configuration
- portable artifact, easily shared and moved around
- make development and deployment more efficient

### Where do containers live?

- container repository
- public repository for Docker (Docker Hub)
- private repository


### How containers improved Application Development

#### Before containers

- Installation process of dev tools different on each OS environment
- Many steps where something could go wrong

#### After containers

- Own isolated environment
- Packaged with all needed configuration
- One command to install the app
- Run same app with more than one different version
- Devs and Ops work together to package the application in a container
- No environmental configuration needed on server - except Docker runtime

### Other Container Technologies

Docker is just the most popular container technology, but there are others, like:

- containerd
- cri-o
- etc.


## 2. Container vs. Image

### What is a container?

- Layers of images
    - advantage: equal layers are reused.
- Mostly Linux Base Image, because small in size
- Application image on top

### Docker Image

- the actual package
- artifact, that can be moved around

### Docker Container

- actually start the application
- it's an image running
- when it's started, the container environment is created

Analogy: OOP -> Image is the class, containers are the objects.


## 3. Docker vs. Virtual Machine

- OS have 2 layers above hardware:
    - 1. OS Kernel
    - 2. Applications

- Container images are much smaller
- Containers start and run much faster
- VM of any OS can run on any OS host

**My words:**

- Docker provides an OS Kernel to Applications.
- Virtual Machines provide hardware to Operating Systems.

## 4. Docker Architecture and Components

- Containers existed already before Docker
- Docker made containers popular

- Docker Engine:
    1. Server
    2. API
    3. CLI

- Docker Server:
    - container Runtime:
        - pulling images
        - managing container lifecycle
    - Volumes
        - persisting data
    - network
        - configuring network for container communication
    - build images
        - build own Docker images

### Alternatives for Docker

- Need only a container runtime?
    - containerd: <https://containerd.io/>
    - cri-o: <https://cri-o.io/>
- Need only an image builder:
    - buildah: <https://buildah.io/>

## 5. Main Docker Commands

```sh
# list locally available images
docker image ls

# list running containers
docker container ls
docker ps

# list all available containers
docker container ls -a
docker ps -a

# create and run a container based on an image
docker container run redis
docker container run redis:4.0  # specify the version

# create and run a container in detach mode
docker container run --detach redis
docker container run -d redis

# start an existing created container
docker container start container_name

# stop a running container
docker container stop container_name
```

### Container Port vs. Host Port

- multiple containers can run on your host machine
- your laptop has only certain ports available
- conflict when same port on host machine
- you can bind a different port between the container and your host ports

```sh
# host port: 6000
# container port: 6379
docker container run --publish 6000:6379 redis
docker container run -p 6000:6379 redis

# host port: 6001
# container port: 6379
docker container run --publish 6001:6379 redis:4.0
```


## 6. Debug Commands

```sh
# see the latest logs from a running container
docker container logs containerName

# execute a command in a running container
docker container exec containerName command

# start a shell session in a running container
docker container exec -it containerName /bin/bash
# using `env` to see the environment variables is quite useful
```

## 7. Docker Demo - Project Overview

Workflow with Docker

![workflow with docker](img/workflow-with-docker.png)


## 8. Developing with Docker

```sh
# get project's source file from...
????

# get MongoDB image
docker pull mongo

# get MongoDB frontend
docker pull mongo-express

```

- 4:40 - Explaining Docker Network

```sh
# list available docker networks
docker network ls

# create a new network
docker network create mongo-network
```

### MongoDB containers

```sh
# https://hub.docker.com/_/mongo
# create a MongoDB container defining the root username/password
docker run \
  -p 27017:27017 \
  --detach \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=password \
  --name mongodb \
  --net mongo-network \
  mongo

# https://hub.docker.com/_/mongo-express
# create the Mongo Express container
docker run \
  -p 8081:8081 \
  --detach \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD=password \
  -e ME_CONFIG_MONGODB_SERVER=mongodb \
  --net mongo-network \
  --name mongo-express \
  mongo-express
```

- 14:30 - interacting with mongo-express interface