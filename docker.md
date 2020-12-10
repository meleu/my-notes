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


