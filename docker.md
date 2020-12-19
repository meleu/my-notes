# docker
[✏️](https://github.com/meleu/my-notes/edit/master/docker.md)

## basic commands

Install docker following the instructions in https://docs.docker.com/install/ and don't forget to follow the post-install instructions.

Basic docker commands:

```
docker ps                   # list active containers
docker ps -a                # list available containers in your machine
docker start containerName  # starts containerName
docker stop containerName   # stops containerName
docker logs containerName   # show containerName logs
docker run                  # runs a process in a new container
```

### a fact about `docker run`

The `docker run` command groups 4 other commands:

```
docker image pull       # downloads the image from the registry
docker container create # creates the container
docker container start  # starts the container
docker container exec   # executes a command in a running container
```

That's why after each `docker run`, it creates a new container.

? Question ?: What's the difference between `docker start`

## Concepts

### Possible isolations:

- memory usage limits
- CPU usage limits
- I/O usage limits
- network usage limits
- isolation of available ports
- filesystem isolation
- permissions and policies
- kernel capabilities


### Container's features:

1. A segregated process.
2. Has a dedicated/isolated filesystem.
3. Portable and lightweight.
4. Encapsulate all binaries and libraries needed to run the application.
5. Something between chroot and Virtual Machines.


### What is a docker image?

- A readonly filesystem model used to create containers.
- Images are created through build (using commits is not recommended).
- Stored in repositories in the Registry.
- Made of one or more layers.
- Each layer represents one or more changes in the filesystem.
- Each layer is also known as intermediate layer.
- The union of these layers creates an image.
- When a container is started, it creates a new layer which can be changed.
- The AUFS (Advanced mult-layered Unification FileSystem) is used a lot.
- The main goal of the strategy of split the image in layers is to allow the reuse.
- It's possible to compose images from the layers of other images.


### Image vs. Container

Using the Object-Oriented Programing paradigm as an analogy, the Image is a Class and the Container is an Object (an instance of the Class).


### Why not use Virtual Machines?

Less consumption of resources. The container uses the same kernel as the host.
Also uses the same libraries and many other resources of the host OS.


### Ways to run docker

Daemon mode vs Interactive mode


## Basic Usage Commands

### run an interactive container

The following command
1. pulls the debian image from the registry (if it's not available in the local cache).
2. creates a new container.
3. starts the container.
4. run the bash.
    1. `-i` for interactive mode.
    2. `-t` for attaching a pseudo-terminal to it.

```
docker run -it debian bash
```

       -i, --interactive=true|false
          Keep STDIN open even if not attached. The default is false.
          When set to true, keep stdin open even if not attached.

       -t, --tty=true|false
          Allocate a pseudo-TTY. The default is false.


To achieve the same as above with an existing container (without creating a new one):

```
docker start -ai containerName
```

       -a, --attach[=false]      Attach STDOUT/STDERR and forward signals

       -i, --interactive[=false]      Attach container's STDIN



### Mapping ports

Providing access via port 8080 to a container running NginX listening on port 80:

```
docker run -p 8080:80 nginx
```

       -p, --publish ip:[hostPort]:containerPort | [hostPort:]containerPort
          Publish a container's port, or range of ports, to the host.
       
       Both hostPort and containerPort can be specified as a range.
       When specifying ranges for both, the number of ports in ranges should be equal.

       Examples: -p 1234-1236:1222-1224, -p 127.0.0.1:$HOSTPORT:$CONTAINERPORT.

       Use docker port(1) to see the actual mapping, e.g. docker port CONTAINER $CONTAINERPORT.


### Mapping directories (volumes)

Making a host's directory accessible inside the container:

```
docker run -p 8080:80 -v /home/USER/html:/usr/share/nginx/html nginx
```

       -v|--volume[=[[HOST-DIR:]CONTAINER-DIR[:OPTIONS]]]
          Create a bind mount. If you specify, -v /HOST-DIR:/CONTAINER-DIR, Docker
          bind mounts /HOST-DIR in the host to /CONTAINER-DIR in the Docker
          container. If 'HOST-DIR' is omitted,  Docker automatically creates the new
          volume on the host.  The OPTIONS are a comma delimited list and can be:

              • [rw|ro]

              • [z|Z]

              • [[r]shared|[r]slave|[r]private]

              • [delegated|cached|consistent]

              • [nocopy]


### Running a container as a daemon

Option `-d`:

```
docker run -d --name myNingX -p 8080:80 -v /home/USER/html:/usr/share/nginx/html nginx
```

    -d, --detach=true|false
       Detached mode: run the container in the background and print the new  container  ID.
    The default is false.
 
    At any time you can run docker ps in the other shell to view a list of the running con‐
    tainers. You can reattach to a detached container with docker attach.
 
    When attached in the tty mode, you can detach from the container (and leave it running)
    using  a configurable key sequence. The default sequence is CTRL-p CTRL-q.  You config‐
    ure the key sequence using the --detach-keys option or a configuration file.  See  con‐
    fig-json(5) for documentation on using a configuration file.

### Useful commands to interact with a container running as daemon

- Get details of the container in a JSON format:
```
docker inspect containerName
```

- Run a command inside a running container:
```
docker exec containerName COMMAND
```

- Check the logs:
```
docker logs containerName
```


## Useful commands to handle docker images

```
docker image
  pull
  ls
  rm
  inspect
  tag
  build
  push
```

## docker hub vs. docker registry

Docker Registry: a server-side application to store and distribute Docker images.

Docker Hub: a cloud docker image registry service, allowing association with repositories to image building automatization.

The docker hub offers a public docker registry.


## Creating Docker Images


### Create your first image

An example with nginx.

Create a new directory, go inside of it and then create a `Dockerfile`:
```
FROM nginx:latest
RUN echo '<h1>Hello meleu!</h1>' > /usr/share/nginx/html/index.html
```

And then run the command **in the same directory as the `Dockerfile`**:
```
docker image build --tag nginx-hello-meleu .
```

Now you have your custom image, and you can see it with this command
```
docker image ls
```

And run it like this:
```
docker container run --publish 80:80 nginx-hello-meleu
```


### Create an image allowing arguments

Create a new directory, go inside of it and then create a `Dockerfile`:
```
FROM debian
LABEL maintainer 'meleu <meleu@meleu.dev>'

ARG S3_BUCKET=files
ENV S3_BUCKET=${S3_BUCKET}
```

This allows us to provide a custom `S3_BUCKET` via command line.

Let's create the image by running this command **in the same directory as the `Dockerfile`**:
```
docker image build \
  --build-arg S3_BUCKET='myApp' \
  --tag nginx-hello-meleu .
```

Run the following to check if the variable is different than the default one:
```
docker container run nginx-hello-meleu bash -c 'echo "$S3_BUCKET"'
```

### Create an image with copy of files from the host OS

`Dockerfile`:
```
FROM nginx:latest
LABEL maintainer 'meleu <meleu@meleu.dev>'

COPY *.html /usr/share/nginx/html/
```

Inside the same directory, let's assume we have this `index.html`:
```html
<h1>This file is originally in the host OS</h1>
```

Create the image:
```
docker image build --tag nginx-copy-file .
```

Run it:
```
docker container run --publish 80:80 nginx-copy-file
```
