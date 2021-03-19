# Docker Mastery

- <https://www.udemy.com/course/docker-mastery/>
- Course repository: <https://github.com/bretfisher/udemy-docker-mastery>
- Discord community: <https://discord.gg/AnP5pgM>

## My goals

Besides the foundational knowledge needed to go on with kubernetes, I also want the docker knowledge to achieve these:

- use a `docker-compose` to make it simple to run the RetroAchievements website in a development environment.
- get the tools needed to deploy <https://docs.retroachievements.org/>.
- get the tools needed to deploy <https://news.retroachievements.org/>.
- create a network like the one illustrated in the first page of the book "TCP/IP Illustrated" (vol 1, 1st edition) by Richard Stevens.
- **ambitious**: get the tools needed to build RetroArch for Windows, Linux, Android, Raspberry Pi (ARM processors).

## Installation

```sh
sudo apt-get remove docker docker-engine docker.io containerd runc

# the script below does NOT work with Linux Mint :(
# detailed instructions here: https://docs.docker.com/get-docker/

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

sudo usermod -aG docker meleu

# just checking:
docker version
```

- Install `docker-machine`: <https://github.com/docker/machine/releases/>

- Install `docker-compose`: <https://docs.docker.com/compose/install/>

Clone de course repository:
```sh
git clone https://github.com/bretfisher/udemy-docker-mastery
```

Install VS Code **and the Docker plugin**.

Bonus: check also [SpaceVim](https://spacevim.org/).


## Running a NginX container

```sh
# start a new container
docker container run --publish 80:80 nginx
# use the --detach option to run nginx in background

# list running containers
docker container ls
# old: docker ps
# also accepts the -a option

# stop a container
docker container stop 123
# the number at the end must be enough to be an unique ID
```

**Note:** `docker container run` always start a new container. Use `docker container start` to start an existing stopped one.

Starting a container with a custom name: use the `--name containerName` option.
```sh
docker container run --publish 80:80 --detach --name webhost nginx

# see the logs:
docker container logs webhost

# see the running processes
docker container top webhost
```

Removing containers:
```sh
docker container rm 123 456 789
# use 'rm -f' to force removal
```

## What happens in `docker container run nginx`

1. Looks for that image locally in image cache. If doesn't find anything...
2. Then looks in remote image repository (defaults to Docker Hub)
3. Downloads the latest version (nginx:latest by default)
4. Creates new container based on that image and prepares to start
5. Gives it a virtual IP on a private network inside docker engine
6. Opens up port 80 on host and forwards to port 80 in container
7. Starts container by using the CMD in the image Dockerfile

You can changes the defaults via command line arguments:
```sh
docker container run --publish 8080:80 --name webhost -d nginx:1.11 nginx -T
#  --publish 8080:80  # change host listening port
#  nginx:1.11         # change version of image
#  nginx -T           # change CMD to be launched on start
```


## What's going on in containers

- `docker container top`: process list in one container
- `docker container inspect`: details of one container config
- `docker container stats`: continuous monitor performance stats for all containers


## Getting a shell inside containers

### Create a new container and launch an interactive shell inside of it

```sh
docker container run -it <imageName> bash
# -i = --interactive
# -t = --tty
```

Remember: the `bash` right after the `<imageName>` is the command that replaces the one define in the `CMD` part of the image's `Dockerfile`.

In the images created for the famous Linux distributions, the `CMD` is usually calling a shell. In such cases you don't need to specify it in command line.

Example:
```sh
docker container run -it ubuntu # it'll run bash interactively
```

### Launch an interactive shell in a running container running dettached

```sh
docker container exec -it <containerName> bash
```

**Note**: the `exec` runs an additional process in the running container. So if you exit the shell launched this way, the container will still be running in background.

### Start a container launching an interactive shell

**Note**: This only works when the Dockerfile used to create the image has a `CMD` calling a shell, which is most common in the images created for Linux distros.

```sh
docker container start -ai <containerName>
# -a = --attach
# -i = --interactive
```

What that command actually do is launch the container and attach its stdin/stdout to the terminal. If the `CMD` is a shell, then you'll have a shell inside the container, otherwise you'll only be able to interactive with whatever is being called in the `CMD`.


## Docker Networks

### Concepts

- Quick port check: `docker container port <containerName>`.
- Each container connected to a private virtual network "bridge".
- Each virtual network routes through NAT firewall on host IP.
- All containers on a virtual network can talk to each other without `-p`.
- Best practice is to creae a new virtual network for each app:
    - network `my_web_app` for mysql and php/apache containers
    - network `my_api` for mongo and nodejs containers
- Make new virtual networks (one per app).
- Attach containers to more than one virtual network (or none).
- Skip virtual networks and use host IP (`--net=host`) - less secure, use with caution.
- Use different Docker network drivers to gain new abilities.

### Commands

```sh
# show networks
docker network ls

# inspect network
docker network inspect <networkName>

# create a network
docker network create <newNetworkName>

# attach a network to container
docker network connect <networkName> <containerName>

# detach a network from container
docker network disconnect <networkName> <containerName>
```

Other command tricks:
```sh
# which containers are connected to a specific network:
docker network inspect <networkName> | jq '.[].Containers'

# which networks the container is connected to
docker container inspect <containerName> | jq '.[].NetworkSettings.Network'
```

### DNS

Containers are constantly launching and disappearing, so forget about IPs. Static IPs and using IPs for talking to containers is an anti-pattern. Do your best to avoid it.

Fortunately the Docker daemon has a built-in DNS server that containers use by default. It defaults the hostname to the container's name, but you can also set aliases.

**Note**: the default `bridge` network does NOT have the DNS built-in by default. So, it's better to create a new network.

Example:
```sh
# creating a new network
docker network create NewNetwork

# creating two containers connected to NewNetwork
docker container run -d --name container1 --network NewNetwork alpine sleep 1000
docker container run -d --name container2 --network NewNetwork alpine sleep 1000

# it's possible to ping one each other using the container name
docker container exec -it container2 ping container1
```

### Assignment: DNS Round Robin Test

- Since Docker 1.11 we can have multiple containers on a created network responde to the same DNS address.
- Create a new virtual network.
- Create two containers from `elasticsearch:2` image.
- Research and use `--network-alias search` when creating them to give them an additional DNS name to respond to.
- Run `alpine:3.10 nslookup search` with `--net` to see the two containers list for the same DNS name.
- Run `centos:7 curl -s search:9200` with `--net` multiple times until you see both "name" fields show.

**Note**: due to a [bug introduced in alpine 3.11.3](https://github.com/gliderlabs/docker-alpine/issues/539), use `alpine:3.10`.




## Container Images

What's in an image?

- App binaries and dependencies.
- Metadata about the image data and how to run the image.
- Official definition:
    - "An image is an ordered collection of root filesystem changes and the corresponding execution parameters for use within a container runtime."


### Docker Hub

Official docker registry: <https://hub.docker.com>


### Image Layers

Union File System - making layers about the changes.

Fundamental concept of cache of image layers: An image can have a change on top of the same layer already present in the cache. It saves a lot of time and space, because there's no need to download layers already present in cache. Remember: it uses a unique SHA for each layer so it's guaranteed to be the exact layer it needs.

Biggest benefits: we're never storing the same image data more than once in our file system. It also means that when we're up/downloading, we don't need to up/download the same layers already present on the other side.

#### Copy on Write

When running a container you have a "living" layer on top of the previous one. And when you change something in the filesystem, the changed file is copied from the original layer into the contaner's one. This technique is called **Copy on Write**.


#### image `history` and `inspect` commands

Checking the history of layers:
```sh
# show layers of changes made in image
docker image history nginx:latest
docker image history mysql
```

Inspecting an image:
```sh
docker image inspect nginx
```

It shows some useful information, specially in `ContainerConfig`. Examples:

- exposed ports (which you may probably `--publish`)
- environment variables
- command to be ran by default when starting a container with this image


#### Review

- Images are made up of file system changes and metadata.
- Each layer is uniquely identified and only stored once on a host.
- This saves storage space on host and transfer time on push/pull.
- A container is just a single read/write layer on top of image.
- `docker image history` and `inspect` can show useful info about images and its layers.

**Read more**: <https://docs.docker.com/storage/storagedriver/>


## Image Tagging

`<user>/<repo>:<tag>`

- default tag is `latest` if not specified.
- `latest` usually means the latest stable version of an image.
- `<user>` can be omitted for "official" images.

```sh
# tagging an image
docker image tag <orignalImage> <hubUser>/<repo>:<tag>

# example (remember: default tag is latest)
docker image tag nginx meleu/nginx

# login to the registry (default is Docker Hub, but you
# can override by adding server URL)
docker login

# check your credentials:
cat .docker/config.json

# don't forget to logout when using machines not owned by you
# docker logout

# uploading it to Docker Hub
docker image push meleu/nginx

# tagging another image
docker image tag meleu/nginx meleu/nginx:testing
docker image push meleu/nginx:testing
```

**Note**: in order to create a private repo for your images, you need create it on the Docker Hub website first, before uploading it.


## Building Images: The Dockerfile Basics

- The default filename is `Dockerfile`, but you can specify with `docker build -f <some-dockerfile>`.

```Dockerfile
# FROM tells which image we want to use as a base.
# a good reason to use debian, ubuntu, fedora, centos, etc. is to be
# able to use their package managers (`apt`, `yum`, etc.)
FROM debian:stretch-slim

# ENV is used to set environment variables
# that's the preferred way to inject key/value into a container
ENV NGINX_VERSION 1.13.6-1~stretch

# RUN is used to execute shell commands inside the container
# pro-tip:  use && to chain multiple relative commands in order avoid
#           creating multiple unnecessary layers (saves time and space)
RUN apt-get update && apt-get install -y something...

# It's also a good practice to spit logs in stdout/stderr
# The line below forwards request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# EXPOSE sets the port to be exposed (by default there's no port being exposed)
# you still need to use -p or -P to open/forward these ports on host
EXPOSE 80 443

# CMD required. It's the final command that will be run everytime you
# launch a new container from the image or start a stopped one.
# only one CMD is allowed, so if there are multiple, last one wins
```

## Buildiung Images: Running Docker Builds

```sh
# build a new image from Dockerfile present in the current directory
# and tag it as 'customnginx'
docker image build -t customnginx .
```

## Building Images: Extending Official Images

```Dockerfile
# extending an existing official image from Docker Hub

FROM nginx:latest
# it's hightly recommended to always pin versions for anything beyond dev/learn

WORKDIR /usr/share/nginx/html
# change working directory to root of nginx webhost,
# it's a preferred method than using 'RUN cd /some/path'

# COPY <source> <destination>
COPY index.html index.html
# some notes about COPY:
# - <source> path must be inside the context of the build (you can't use '..')
# - if <source> is a directory, the entire contents of it is copied
# - for more info check <https://docs.docker.com/engine/reference/builder/#copy>

# no need to specify EXPOSE or CMD as they're already set in the FROM image
```


