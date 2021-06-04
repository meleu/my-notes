# Build Automation & CI/CD with Jenkins

## 1. Intro to Build Automation

What can you do with Jenkins?:

- run tests
- build artifacts
- publish artifacts
- deploy artifacts
- send notifications
- many more...

Jenkins acts like a man in the middle, talking with several tools via plugins. It needs to integrate with many other tools, like:

- Docker
- Build tools
- Repositories
- Deployment servers
- etc...


## 2. Install Jenkins

Installing Jenkins as Docker container is easier.

Recommended DigitalOcean droplet to run Jenkins in a Docker container:

- 4Gb RAM
- 2 CPUs
- 80 GB Disk

Open port 8080 in the firewall.

```sh
# install docker
apt update
apt install docker.io

# create a Jenkins container
# port 8080 is to access Jenkins via browser
# port 50000 is where the communication between
# Jenkins master and workers happen
docker container run \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -d \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts

# getting the initial password
docker container exec -it jenkins bash
cat /var/jenkins_home/secrets/initialAdminPassword

# the same information is available in the host OS
docker volume inspect jenkins_home
# check the "Mountpoint" value
cat /var/lib/docker/volumes/jenkins_home/_data/secrets/initialAdminPassword
```

Access the host via browser in port 8080 and set the initial password.

Install the suggested plugins.

Create first admin user.


## 3. Introduction to Jenkins UI

- Jenkins Administrator
    - administers and manages Jenkins
    - sets up Jenkins cluster
    - installs plugins
    - backup Jenkins data

- Jenkins User
    - creating the actual jobs to run workflows


## 4. Install Build Tools in Jenkins

- Java app: needs Maven
- JavaScript app: needs npm

2 Ways of configuring those tools:

1. Jenkins Plugins
2. install the tool directly on Server

### Via Plugins

**Maven:**

1. Manage Jenkins (left sidebar)
2. Global Tool Configuration
3. Add Maven -> install from Apache


### Directly on the Server

**Node/npm**:

1. Manage Jenkins
2. Manage Plugins
3. Search for `nodejs`
4. As we need `npm` also, we're gonna install it directly inside the container where Jenkins is running

```sh
# in the host OS, enter the container as root user `-u 0`
docker container exec -u 0 -it container_name bash

# inside the container, check the distro
cat /etc/issue

# default distro used for jenkins:lts is Debian
# so, assure curl is installed
apt update
apt install curl

# installing NodeJS
# note: I usually prefer to install via nvm (Node Version Manager)
curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh
bash nodesource_setup.sh
apt install nodejs

# check installation
nodejs -v
npm -v
```
