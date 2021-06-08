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


## 6. Docker in Jenkins

Making the docker command from the host available in a Jenkins container

```sh
# it needs to be a new container
docker container run \
  --name jenkins-docker \
  -p 8080:8080 \
  -p 50000:50000 \
  -d \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(which docker):/usr/bin/docker \
  jenkins/jenkins:lts

# enter the container as root user
docker container exec -u 0 -it jenkins-docker bash

# INSIDE THE CONTAINER:
# grant RW permissions for everyone in /var/run/docker.sock
chmod 666 /var/run/docker.sock

# exit the container and enter again as the 'jenkins' user
exit
docker container exec -it jenkins-docker bash

# check if docker is available
docker version
```

Now `docker` command is available in the Jenkins container.



### Build a Docker Image and Push to Docker Hub

0. Create a repo for your Image on Docker Hub.
1. Dashboard -> Manage Jenkins -> Manage Credentials -> Jenkins -> Global credentials -> Add Credentials (left sidebar)
2. Create credentials to access your Docker Hub account.
3. Back to Jenkins, go to the `java-maven-build` project.
4. `Buil Environment` tab:
    - [x] Use secret text(s) or file(s)
    - In `Bindings`, choose `Username and password (separate)`, name the variables and choose the credentials.
4. `Build` tab.
    - Remove `maven test`
    - Add `Execute shell`:
```sh
docker build -t meleuzord/demo-app:jma-1.0 .
echo "${PASSWORD}" | docker login -u $USERNAME --password-stdin
docker push meleuzord/demo-app:jma-1.0
```

### Push Docker Image to Nexus Repository

**NOTE**: it's assumed you already have a Nexus instance up and running, and a [Docker hosted repository properly configured](07-containers-with-docker#15-create-docker-hosted-repository-on-nexus)

In the host OS, create the file: `/etc/docker/daemon.json`
```json
{
  "insecure-registries": ["167.99.248.163:8083"]
}
```

Restart the docker service:
```sh
systemctl restart docker

# restart your jenkins container
docker container start jenkins-docker

# reconfigure the `docker.sock` file
docker container exec -u 0 -it jenkins-docker bash
chmod 666 /var/run/docker.sock
```

Create credentials to access your Docker Repository on Nexus:

- Dashboard -> Manage Jenkins -> Manage Credentials -> Jenkins -> Global credentials -> Add Credentials (left sidebar)

Open your project again, `Configure` -> `Build` tab -> `Execute shell`:
```sh
docker build -t ${NEXUS_IP}:${NEXUS_CONNECTOR_PORT}/java-maven-app:1.0 .
echo "${PASSWORD}" | docker login -u $USERNAME --password-stdin ${NEXUS_IP}:${NEXUS_CONNECTOR_PORT}
docker push ${NEXUS_IP}:${NEXUS_CONNECTOR_PORT}/java-maven-app:1.0
```

And save it.

Go to the project again, `Build Now` and then check the `Console output` to see if it pushed the image successfully.

Check in your Nexus server if the image was successfully uploaded.


## 7. Freestyle to Pipeline Job

Chain multiple Freestyle projects:

In the project's `Configure` screen, `Add post-build action` -> `Build other projects`

Cons:

- limitations
- hugely UI based :(
- doesn't allow scriptting
- Limited to Input Fields of Plugin
- not suitable for complex workflows

**Use `Pipeline Jobs` instead!!**



## 8. Introduction to Pipeline Job

Create a new pipeline:

1. New Item (left sidebar)
2. Name it `my-pipeline`, select `Pipeline project` and then click `[OK]` button.


**First thing: connect your pipeline to a git repository.**

Go to `Pipeline` tab.

In the `Definition` you can see `Pipeline script` and `Pipeline script from SCM` options. **Best practice** is to use the pipeline script in your git repository. So, choose `Pipeline script from SCM`.

Configure the repo, the credentials and the branch.

`Script Path` is usually left as the default: `Jenkinsfile`

If the repo doesn't have the `Jenkinsfile`, create this basic one:
```groovy
// this is a declarative groovy script
pipeline {      // `pipeline` must be top-level

    agent any   // `agent` - where to execute (relevant for Jenkins cluster)

    stages {    // `stages` - where the work happens
        stage("build") {
            steps {
                echo 'building...'
            }

        stage("test") {
            steps {
                echo 'testing...'
            }

        stage("deploy") {
            steps {
                echo 'deploying...'
            }
        }
    }
}
```


Jenkinsfile can be **scripted** or **declarative**

- Scripted:
    - first syntax
    - Groovy engine
    - advanced scripting capabilities, high flexibility
    - difficult to start

- Declarative
    - more recent addition
    - easier to get started, but not that powerful
    - pre-defined structure



## 9. Jenkinsfile Syntax

### `post` attribute in Jenkinsfile

With `post` you can execute some logic **after** all stages are done.

```groovy
pipeline {
    agent any

    stages {
        // ...
    }

    post {      // execute after all stages are done

        always {
            // code here will be executed no matter if the
            // stages succeeded or failed.
        }

        success {
            // executed if build succeeds
        }

        failure {
            // executed if build fails
        }

    }
}
```


### Conditionals for each stage

Example, execute `test` only when 

```groovy
pipeline {
    agent any

    stages {
        // ...
        stage("test") {
            steps {
                echo 'testing...'
            }
        }
    }
}
```    
