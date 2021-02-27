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

