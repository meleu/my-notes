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


## 5. Jenkins Basics Demo - Freestyle Job

- video: <https://techworld-with-nana.teachable.com/courses/1108792/lectures/28664055>

1. New Item (left sidebar)
2. Name it `my-job`, select `Freestyle project` and then click `[OK]` button.
3. Leave everything as default, scroll down to the `Build` section, click `Add build step` and select `Execute shell`.
    - In the text box, type `npm --version`
5. `Add build step` again, and select `Invoke top-level Maven targets`.
    - Select the Maven Version and for Goals, type `--version`.
6. Click `[Save]` button.
7. In the `my-job` project screen, click `Build Now` (left sidebar)
8. Once the build is finished, you can check `Console Output`.

**NOTES**:

- Build tools installed directly on the server offers more flexibility.
- Build tools installed via plugin are limited to provided input fields.


### Add NodeJS Plugin

1. Manage Jenkins
2. Manage Plugins
3. Search for `nodejs` and install it
4. Manage Jenkins (left sidebar)
5. Global Tool Configuration
6. Add NodeJS...
7. It's now available in the job's Build tab


### Configure Git Repository

1. Go to the project
2. Tab `Source Code Management`
3. Git
4. Fill the form with your git repo info

Test:

1. Click in `Build Now`
2. Check `Console Output` and you should see git commands there.

**Note**:

- job's infor is stored in `/var/jenkins_home/jobs/my-job/builds`
- cloned repo is stored in `/var/jenkins_home/workspace/my-job`


### Do something from git repo in Jenkins job

Edit `my-job` project:

Source Code Management:

    - repo: <https://gitlab.com/nanuchi/java-maven-app.git>
    - branch: `*/jenkins-jobs`

Build:

    - Execute shell -> Command

```sh
chmod a+x freestyle-build.sh
./freestyle-build.sh
```


### Java/Maven

checkout git repo -> run tests -> build jar file

1. Create a new freestyle job named `java-maven-build`
2. Configuration
    - Source Code Management:
        - repo: <https://gitlab.com/nanuchi/java-maven-app.git>
        - credentials...
        - branch: `jenkins-jobs`
    - Build:
        - Invoke top-level Maven targets
        - Goals:
            1. `test`
            2. `package`

