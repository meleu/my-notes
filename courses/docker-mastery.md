# Docker Mastery

- <https://www.udemy.com/course/docker-mastery/>
- Course repository: <https://github.com/bretfisher/udemy-docker-mastery>
- Discord community: <https://discord.gg/AnP5pgM>

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
#  nginx -T           # change CMD run on start
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


