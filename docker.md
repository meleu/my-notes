# docker
[✏️](https://github.com/meleu/my-notes/edit/master/docker.md)

## basic commands

Install docker following the instructions in <https://docs.docker.com/get-docker/> and don't forget to follow the post-install instructions.

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

### Create an image with a volume that can be shared

In this example we're going to use a Python web server. The file is named `run.py`:
```python
import logging
import http.server
import socketserver
import getpass

class MyHTTPHandler(http.server.SimpleHTTPRequestHandler):
  def log_message(self, format, *args):
    logging.info("%s - - [%s] %s\n"% (
      self.client_address[0],
      self.log_date_time_string(),
      format%args
    ))

logging.basicConfig(
  filename='/log/http-server.log',
  format='%(asctime)s - %(levelname)s - %(message)s',
  level=logging.INFO
)
logging.getLogger().addHandler(logging.StreamHandler())
logging.info('starting...')
PORT = 8000

httpd = socketserver.TCPServer(("", PORT), MyHTTPHandler)
logging.info('listening on port: %s', PORT)
logging.info('user: %s', getpass.getuser())
httpd.serve_forever()
```

**Note**: in the code above we're creating a log in the file `/log/http-server.log`.

We'll also need a simple `index.html`:
```html
<h1>Hello from Python!</h1>
```

`Dockerfile`
```
FROM python:3.6
LABEL maintainer 'meleu <meleu at meleu.dev>'

RUN useradd www && \
  mkdir /app && \
  mkdir /log && \
  chown www /log

USER www
VOLUME /log
WORKDIR /app
EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/python"]
CMD ["run.py"]
```

**Note**: the volume that will be available for external containers will be the `/log`.

Building the image:
```
docker image build --tag python-web-server
```

Running the container:
```
docker container run \
  --interactive \
  --tty \
  --volume "$(pwd)":/app \
  --publish 80:8000 \
  --name python-server \
  python-web-server
```

Now we're going to run another container and get access to the volume created in
the container above:

```
docker container run \
  --interactive \
  --tty \
  --volumes-from python-server \
  debian \
  cat /log/http-server.log
```


## Pushing an image to the Docker Hub

1. create an account at <https://hub.docker.com>.

2. create a tag for the image you're going to upload:
```
docker image tag ex-simple-build USER_NAME/IMAGE_BUILD_NAME:1.0
```

3. authenticate via CLI (it'll ask for your password):
```
docker login --username=USER_NAME
```

4. push it to the server:
```
docker image push USER_NAME/IMAGE_BUILD_NAME:1.0
```

## Networking

Default networking model (bridge network):
```
,-------------, ,-------------,
| Container A | | Container B |
|-------------| |-------------|
| net.interf. | | net.interf. |
'-------------' '-------------'
      ^               ^
      |               |
      v               v
,-----------------------------,
|     Bridge (docker0)        |
'-----------------------------'
,-----------------------------,
|           host              |
'-----------------------------'
              ^
              |
              v
           internet
```

Networking types:
- None network
- Bridge network (default)
- Host network
- Overlay network (via Swarm)

commands:
```
docker network ls
```

### None Network
```
$ docker container run --rm alpine ash -c ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:02  
          inet addr:172.17.0.2  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:2 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:180 (180.0 B)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

$ docker container run --net none --rm alpine ash -c ifconfig
lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```

### Bridge Network

```
$ docker network inspect bridge
[
    {
        "Name": "bridge",
        "Id": "62015cfacbd4491f71d72d2edc2abdea62466c5351d87373ad64ad8cfb7c69b6",
        "Created": "2020-12-12T16:36:28.31057956-03:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    }
]
```

Creating two containers and ping one each other:

```
$ docker container run -d --name container1 alpine sleep 1000
b65cf2f729bdd6c0b35fa057c7ac253980b2ca852fe49c7eb09c00a78ca5f67b

$ docker container exec -it container1 ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:02  
          inet addr:172.17.0.2  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:21 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:3128 (3.0 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


$ docker container run -d --name container2 alpine sleep 1000
d330529c17f5a3c3a7073755a17be2c8c3b0e37df2744770ca3d6d61271c1836
$ docker container exec -it container2 ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:03  
          inet addr:172.17.0.3  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:20 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:2978 (2.9 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

$ docker container exec -it container2 ping 172.17.0.2
PING 172.17.0.2 (172.17.0.2): 56 data bytes
64 bytes from 172.17.0.2: seq=0 ttl=64 time=0.097 ms
64 bytes from 172.17.0.2: seq=1 ttl=64 time=0.122 ms
64 bytes from 172.17.0.2: seq=2 ttl=64 time=0.128 ms
...
```

Creating a new network separated from the default one:
```
$ docker network create --driver bridge NewNetwork
4efc2b0ce69807aa4fe068715b2e60b5bbbbfa18a58f4682a7682029112f0e6c

$ docker network ls
NETWORK ID     NAME         DRIVER    SCOPE
4efc2b0ce698   NewNetwork   bridge    local
62015cfacbd4   bridge       bridge    local
38729066bc9d   host         host      local
9a7fdf6bef68   none         null      local

$ docker network inspect NewNetwork 
[
    {
        "Name": "NewNetwork",
        "Id": "4efc2b0ce69807aa4fe068715b2e60b5bbbbfa18a58f4682a7682029112f0e6c",
        "Created": "2020-12-15T18:04:10.565305611-03:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```

Note the network is now 172.18.0.0 (not 172.17.0.0).

Now let's create a new container connected to the NewNetwork and check if we can ping the two containers in the default bridge network:
```
$ docker container run -d --name container3 --net NewNetwork alpine sleep 1000
c2a20307341bef4b04ed5902fbcb6efc5b0677eb0980813391f851f6604b8608

$ docker container exec -it container3 ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:12:00:02  
          inet addr:172.18.0.2  Bcast:172.18.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:47 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:7454 (7.2 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

$ docker container exec -it container3 ping 172.17.0.2 # <-- ip of container1
PING 172.17.0.2 (172.17.0.2): 56 data bytes
^C
--- 172.17.0.2 ping statistics ---
30 packets transmitted, 0 packets received, 100% packet loss

```

We couldn't reach container1 from container3 because they're connected to different networks.

Now let's connect container3 to the default bridge network:
```
$ docker network connect bridge container3 

$ docker container exec -it container3 ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:12:00:02  
          inet addr:172.18.0.2  Bcast:172.18.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:62 errors:0 dropped:0 overruns:0 frame:0
          TX packets:4 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:9956 (9.7 KiB)  TX bytes:336 (336.0 B)

eth1      Link encap:Ethernet  HWaddr 02:42:AC:11:00:02  
          inet addr:172.17.0.2  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:14 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:1996 (1.9 KiB)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


$ docker container exec -it container3 ping 172.17.0.2 # <-- ip of container1
PING 172.17.0.2 (172.17.0.2): 56 data bytes
64 bytes from 172.17.0.2: seq=0 ttl=64 time=0.071 ms
64 bytes from 172.17.0.2: seq=1 ttl=64 time=0.107 ms
64 bytes from 172.17.0.2: seq=2 ttl=64 time=0.108 ms
64 bytes from 172.17.0.2: seq=3 ttl=64 time=0.108 ms
64 bytes from 172.17.0.2: seq=4 ttl=64 time=0.108 ms
^C
--- 172.17.0.2 ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 0.071/0.100/0.108 ms

$ # let's disconnect container3 from the default bridge network...

$ docker network disconnect bridge container3 

$ docker container exec -it container3 ifconfig
eth0      Link encap:Ethernet  HWaddr 02:42:AC:12:00:02  
          inet addr:172.18.0.2  Bcast:172.18.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:62 errors:0 dropped:0 overruns:0 frame:0
          TX packets:4 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:9956 (9.7 KiB)  TX bytes:336 (336.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:10 errors:0 dropped:0 overruns:0 frame:0
          TX packets:10 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:840 (840.0 B)  TX bytes:840 (840.0 B)


$ docker container exec -it container3 ping 172.17.0.2 # <-- ip of container1
PING 172.17.0.2 (172.17.0.2): 56 data bytes
^C
--- 172.17.0.2 ping statistics ---
5 packets transmitted, 0 packets received, 100% packet loss

```

### Host network

Giving to the container direct access to the host's interfaces.

Example:
```
$ docker container run -d --name container4 --net host alpine sleep 1000

$ docker container exec -it container4 ifconfig
# it shows all the interfaces you have in the host OS
```


### Starting Multiple Containers

- Docker Compose: <https://docs.docker.com/compose/install/>

Basically:
```sh
# check the latest release version: https://github.com/docker/compose/releases
sudo curl -L \
  "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

**Example**

File structure (<https://github.com/cod3rcursos/curso-docker/node-mongo-compose>):
```
node-mongo-compose/
├── backend
│   ├── app.js
│   ├── package.json
│   └── package-lock.json
├── docker-compose.yml
└── frontend
    └── index.html
```

`docker-compose.yml`:
```
version: '3'
services:
  db:
    image: mongo:3.4
  backend:
    image: node:8.1
    volumes:
      - ./backend:/backend
    ports:
      - 3000:3000
    command: bash -c "cd /backend && npm i && node app"
  frontend:
    image: nginx:1.13
    volumes:
      - ./frontend:/usr/share/nginx/html/
    ports:
      - 80:80
```

And then run:
```
docker-compose up
```

### A more realistic example

```
mkdir email-worker-compose
cd email-worker-compose
```

#### postgresql

`docker-compose.yml`:
```yml
version: '3' # versao do docker-compose
services:
  db:
    image: postgres:9.6
    environment:
      - POSTGRES_HOST_AUTH_METHOD=trust
```

commands:
```sh
docker-compose up -d # daemon mode
docker-compose ps
docker-compose exec db psql -U postgres -c '\l'
```

#### volumes

Create the following files:
`scripts/init.sql`:
```sql
create database email_sender;

\c email_sender

create table emails (
  id serial not null,
  data timestamp not null default current_timestamp,
  assunto varchar(100) not null,
  mensagem varchar(250) not null
);
```

`scripts/check.sql`:
```sql
\l
\c email_sender
\d emails
```

And edit the `docker-compose.yml`:
```yml
version: '3' # versao do docker-compose
volumes:
  dados:
services:
  db:
    image: postgres:9.6
    environment:
      - POSTGRES_HOST_AUTH_METHOD=trust
    volumes:
      # volume dos dados
      - dados:/var/lib/postgresql/data
      # scripts
      - ./scripts:/scripts
      - ./scripts/init.sql:/docker-entrypoint-initdb.d/init.sql
      # Check <https://hub.docker.com/_/postgres> - "Initialization scripts"
```

And then:
```sh
docker-compose down # assure we're starting fresh
docker-compose up -d
docker-compose ps
docker-compose exec db psql -U postgres -f /scripts/check.sql
```

#### frontend

`web/index.html`:
```html
<html>
    <head>
        <meta charset='uft-8'>

        <title>E-mail Sender</title>

        <style>
            label { display: block; }
            textarea, input { width: 400px; }
        </style>
    </head>
    <body class="container">
        <h1>E-mail Sender</h1>
        <form action="http://localhost:8080 method="POST">
            <div>
                <label for="assunto">Assunto</label>
                <input type="text" name="assunto">
            </div>

            <div>
                <label for="mensagem">Mensagem</label>
                <textarea name="mensagem" cols="50" rows="6"></textarea>
            </div>

            <div>
                <button>Enviar !</button>
            </div>
        </form>
    </body>
</html>
```

`docker-compose.yml`:
```yml
# services: ...
# ...
  frontend:
    image: nginx:1.13
    volumes:
      # site
      - ./web:/usr/share/nginx/html/
    ports:
      - 80:80
```

Testing:
```
docker-compose down # assure we're starting fresh
docker-compose up -d
docker-compose ps
docker-compose logs -f -t
# browser http://localhost/
```

#### backend app

Initially we're going to allow the app server to be contacted directly, via port 8080. Later we'll use a reverse proxy.

`app/app.sh`:
```sh
#!/bin/sh

pip install bottle==0.12.13
python -u sender.py
```

`app/sender.py`:
```py
from bottle import route, run, request

@route('/', method='POST')
def send():
  assunto = request.forms.get('assunto')
  mensagem = request.forms.get('mensagem')
  return 'Mensagem enfileirada ! Assunto: {} Mensagem: {}'.format(
    assunto, mensagem
  )

if __name__ == '__main__':
  run(host='0.0.0.0', port=8080, debug=True)
```

`docker-compose.yml`:
```yml
# services: ...
# ...
  app:
    image: python:3.6
    volumes:
      # application
      - ./app:/app
    working_dir: /app
    command: bash ./app.sh
    ports:
      - 8080:8080
```

Testing:
```
docker-compose down # assure we're starting fresh
docker-compose up -d
docker-compose ps
docker-compose logs -f -t
# browser http://localhost/
```

#### reverse proxy

Adding a config in the frontend to act like a reverse proxy to the backend app, so we
don't need to allow direct access to the backend (increase security).

`nginx/default.conf`:
```
server {
  listen 80;
  server_name localhost;

  location / {
    root /usr/share/nginx/html;
    index index.html index.htm;
  }

  error_page 500 502 503 504 /50x.html;
  location = /50x.html {
    root /usr/share/nginx/html;
  }

  location /api {
    proxy_pass http://app:8080/;
    # the "app" address is the service name used in the docker-compose.yml
    proxy_http_version 1.1;
  }
}
```

`web/index.html`
```diff
-         <form action="http://localhost:8080" method="POST">
+         <form action="http://localhost/api" method="POST">
```

`docker-compose.yml`
```diff
services:
  frontend:
+      # reverse proxy config
+      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf
  app:
-    ports:
-      - 8080:8080
```

Testing:
```
docker-compose down # assure we're starting fresh
docker-compose up -d
docker-compose ps
docker-compose logs -f -t
# browser http://localhost/
```

#### segregate networks

We're going to have a network for the web frontend and a network for the database.
And the app is going to be connected to both.

`docker-compose.yml`:
```diff
networks:
  banco:
  web:

services:
  db:
+    networks:
+      - banco
  frontend:
+    networks:
+      - web
+    depends_on:
+      - app

  app:
+    networks:
+      - web
+      - banco
+    depends_on:
+      - db
```

`app/app.sh`:
```sh
#!/bin/sh

pip install bottle==0.12.13 psycopg2==2.7.3.2
python -u sender.py
```

`app/sender.py`:
```py
import psycopg2
from bottle import route, run, request

DSN = 'dbname=email_sender user=postgres host=db'
SQL = 'INSERT INTO emails (assunto, mensagem) VALUES (%s, %s)'

def register_message(assunto, mensagem):
  conn = psycopg2.connect(DSN)
  cur = conn.cursor()
  cur.execute(SQL, (assunto, mensagem))
  conn.commit()
  cur.close()
  conn.close()

  print('Mensagem registrada!')

@route('/', method='POST')
def send():
  assunto = request.forms.get('assunto')
  mensagem = request.forms.get('mensagem')

  register_message(assunto, mensagem)
  return 'Mensagem enfileirada ! Assunto: {} Mensagem: {}'.format(
    assunto, mensagem
  )

if __name__ == '__main__':
  run(host='0.0.0.0', port=8080, debug=True)
```

Testing:
```
docker-compose down # assure we're starting fresh
docker-compose up -d
docker-compose ps
docker-compose logs -f -t
# browser http://localhost/
docker-compose exec db psql -U postgres -d email_sender -c 'select * from emails'
```

#### queue and workers

Add a new network named `fila`, and two new services using that network: `queue` and `worker`.
The service `app` is also connected to the `fila` network.

`docker-compose.yml`:
```diff
networks:
  banco:
  web:
+  fila:

services:
	app:
    networks:
      - web
      - banco
+      - fila
    depends_on:
      - db
+      - queue

+  queue:
+    image: redis:3.2
+    networks:
+      - fila
+
+  worker:
+    image: python:3.6
+    volumes:
+    # worker
+    - ./worker:/worker
+    working_dir: /worker
+    command: bash ./app.sh
+    networks:
+      - fila
+    depends_on:
+      - queue
```

`worker/app.sh`:
```sh
#!/bin/sh

pip install redis==2.10.5
python -u worker.py
```

`worker/worker.py`:
```py
import redis
import json
from time import sleep
from random import randint

if __name__ == '__main__':
  r = redis.Redis(host='queue', port=6379, db=0)
  while True:
    mensagem = json.loads(r.blpop('sender')[1])
    # simulando envio de email...
    print ('Mandando a mensagem: ', mensagem['assunto'])
    sleep(randint(15, 45))
    print('Mensagem', mensagem['assunto'], 'enviada')
```

`app/app.sh`
```sh
#!/bin/sh

pip install bottle==0.12.13 psycopg2==2.7.3.2 redis==2.10.5
python -u sender.py
```

`app/sender.py`:
```py
import psycopg2
import redis
import json
from bottle import Bottle, request


class Sender(Bottle):
    def __init__(self):
        super().__init__()
        self.route('/', method='POST', callback=self.send)
        self.fila = redis.StrictRedis(host='queue', port=6379, db=0)
        DSN = 'dbname=email_sender user=postgres host=db'
        self.conn = psycopg2.connect(DSN)
        
    def register_message(self, assunto, mensagem):
        SQL = 'INSERT INTO emails (assunto, mensagem) VALUES (%s, %s)'
        cur = self.conn.cursor()
        cur.execute(SQL, (assunto, mensagem))
        self.conn.commit()
        cur.close()

        msg = {'assunto': assunto, 'mensagem': mensagem}
        self.fila.rpush('sender', json.dumps(msg))

        print('Mensagem registrada !')

    def send(self):
        assunto = request.forms.get('assunto')
        mensagem = request.forms.get('mensagem')

        self.register_message(assunto, mensagem)
        return 'Mensagem enfileirada ! Assunto: {} Mensagem: {}'.format(
            assunto, mensagem
        )

if __name__ == '__main__':
    sender = Sender()
    sender.run(host='0.0.0.0', port=8080, debug=True)
```


#### scalate

- video: <https://www.udemy.com/course/curso-docker/learn/lecture/7560004>
- repo: <https://github.com/cod3rcursos/curso-docker/tree/master/email-worker-compose>


