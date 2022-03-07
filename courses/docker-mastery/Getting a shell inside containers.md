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