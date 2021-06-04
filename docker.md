# docker
[✏️](https://github.com/meleu/my-notes/edit/master/docker.md)


## links

- <https://labs.play-with-docker.com/> - practice online, directly in your browser.

## quick-tips

Enter a container as root user:
```
# use the `-u 0` option. Exemple:
docker container exec -u 0 -it container_name bash
```

## installation

For the officially supported distributions (CentOS, Debian, Fedora, Raspbian and Ubuntu), it's possible to use the method below:
```
# DOES NOT WORK ON LINUX MINT
sudo apt-get remove docker docker-engine docker.io containerd runc
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker meleu

# on CentOS I also had to do this:
sudo systemctl start docker   # start dockerd
sudo systemctl status docker  # check if it's running fine
sudo systemctl enable docker  # make sure it starts at reboot
```

On Linux Mint I used the instructions in <https://docs.docker.com/get-docker/> and <https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository>. And don't forget to follow the [post-install instructions](https://docs.docker.com/engine/install/linux-postinstall/).


## Basic `docker container` commands:

```sh
# Create and launch a new container using <imageName>
docker container run <imageName>

# List active containers (-a to include the stopped ones)
docker container ls [-a]

# Starts an existing <containerName>
docker container start <containerName>

# Stops a running container
docker container stop <containerName>

# Show <containerName> logs
docker container logs containerName

#####################
# example with nginx:
#####################
docker container run \
  --publish 8080:80 \
  --name webhost \
  nginx

# stop it:
docker container stop webhost

# [re]start it:
docker container start webhost

# execute a command inside of it:
docker container exec webhost <COMMAND>

# execute an interactive shell inside of it:
docker container exec -it webhost bash
```

What's going on in a container?
```sh
docker container top <containerName>      # process list in one container
docker container inspect <containerName>  # details of one container config
docker container stats                    # monitor performance stats for all containers
```


### a fact about `docker run`

The `docker run` command groups 4 other commands:

```sh
docker image pull       # downloads the image from the registry
docker container create # creates the container
docker container start  # starts the container
docker container exec   # executes a command in a running container
```

That's why after each `docker run`, it creates a new container.

**Note**: if you give a command at the end of a `docker run` command, it replaces the `CMD` defined for that image. Example:
```sh
# creates a container named 'nginx-shell' where the CMD is replaced with bash
# (use -it to make it interactive)
docker container run --name nginx-shell -it nginx bash

# later, when we start that container, its CMD is still bash
# (use -ai to make it interactive)
docker container start -ai nginx-shell
```

## Basic `docker network` commands

```sh
# list the available networks
docker network ls

# create a new network (default driver: bridge)
docker network create <networkName>

# connect a running container to a network
docker network connect <networkName> <containerName>

# disconnect a running container from a network
docker network disconnect <networkName> <containerName>

# network detailed info
docker network inspect <networkName>

# create a container connected to a non-default network:
docker container run --network <networkName> <imageName>
```

Filtering with `jq`:
```sh
# which containers are connected to a specific network:
docker network inspect <networkName> | jq '.[].Containers'

# which networks the container is connected to
docker container inspect <containerName> | jq '.[].NetworkSettings.Network'
```

**Note**: the Docker daemon has a builtin DNS server that containers use by default in custom networks (not in the default one 'bridge'). It defaults the hostname to the container's name. Example:
```sh
# creting a new network
docker network create new-network

# creating two containers connected to the new network
docker container run --network new-network --name container1 alpine sleep 10000
docker container run --network new-network --name container2 alpine sleep 10000

# it's possible to ping one each other using the container's name
docker container exec -it container2 ping container1
```

> knowledge gap: understand what exactly the `--network-alias` option does.

