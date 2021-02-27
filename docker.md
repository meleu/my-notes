# docker
[✏️](https://github.com/meleu/my-notes/edit/master/docker.md)


## links

- <https://labs.play-with-docker.com/>


## installation

For the officially supported distributions (CentOS, Debian, Fedora, Raspbian and Ubuntu), it's possible to use the method below:
```
# DOES NOT WORK ON LINUX MINT
sudo apt-get remove docker docker-engine docker.io containerd runc
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker meleu
```

On Linux Mint I used the instructions in <https://docs.docker.com/get-docker/> and <https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository>. And don't forget to follow the [post-install instructions](https://docs.docker.com/engine/install/linux-postinstall/).


## basic commands

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


