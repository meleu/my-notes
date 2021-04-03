# Artifact Repository Manager with Nexus

## 1. Intro to Artifact Repository Manager

### What is an Artifact Repository?

- artifacts = apps built into a single file
- different artifact formats (jar, war, zip, tar, etc)
- artifact repository = storage of those artifacts
- artifact repository **needs to support this specific format**
- repository for each file/artifact type

### What is an Artifact Repository Manager?

- different technologies (java, python, node) produce different types of artifacts
- you need different repositories for different artifacts
- different software for repository?!
- with an artifact repository manager (like Nexus) you have just one application for managing all

#### Nexus

- one of the most popular Artifact Repository Manager
- upload and store different built artifacts
- retrieve (download) artifacts later
- central storage
- proxy repository
  - either company internal or public artifacts, you can fetch them through Nexus
- open source and commercial
- multiple repositories for different formats

There are also public repository managers (e.g. MVNrepository, npm). There you can make your own project publically available.

### Features of Repository Manager

- Integrate with LDAP
- flexible and powerful REST API for integration with other tools
- backup and restore
- multi-format support (different file types, zip, tar, docker, etc)
- metadata tagging policies
- cleanup policies
- search functionality (across projects, artifact repos, etc.)
- user token support for system user authentication


## 2. Install and Run Nexus on a Cloud Server

DigitalOcean droplet to be used:

- Basic ($40/mo in april/2021)
  - 8GB RAM
  - 4 CPUs
  - 160 GB SSD Disk
  - 5TB transfer

- add firewall rule
- install Java 8

Commands to be ran as root user:
```sh
# log as root user
cd /opt

# grab the link for download here: https://help.sonatype.com/repomanager3/download
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz

# unpack
tar xvzf latest-unix.tar.gz

# 2 directories:
ls
```

- Created directories:
    - nexus-*: contains runtime and application of Nexus.
    - sonatype-work: contains config for Nexus and data.

When upgrading the application, the binaries go in the `nexus-*/` directory and the configs are kept in `sonatype-work/`.

- `sonatype-work/`:
    - subdirectories depending on your Nexus configuration
    - IP address that accessed Nexus
    - logs of Nexus App
    - your uploaded files and metadata
    - you can use this folder for backup

### Starting Nexus

- services should not run with root user permissions
- best practice: create own user for service (e.g.: Nexus)
- only the permission for that specific service

```sh
# create a new user
adduser nexus

# change the ownership of the directories:
chown -R nexus:nexus /opt/nexus-*
chown -R nexus:nexus /opt/sonatype-work

# set the user who will run nexus
vim /opt/nexus-*/bin/nexus.rc
# remove the comment and set:
# run_as_user="nexus"

# switch user
su -u nexus

# start the service:
/opt/nexus-*/bin/nexus start

# check the process:
ps aux | grep nexus

# check the port nexus is listening to
netstat -lnpt

# open the 8081 port on your host and check the connection with a browser


# if you need the admin password:
cat /opt/sonatype-work/nexus3/admin.password
```

## 3. Introduction to Nexus

Just showing the UI.

- Access the Administration section by clicking the gear icon on the top

- Repository
    - Repositories
    - Blob stores
    - Content Selectors
    - Cleanup Policies
    - Routing Rules

## 4. Repository Types

- Repositories
    - type:
        - proxy: linked to a remote repository
        - hosted: hosted locally
        - group: one endpoint to reach different repositories

## 5. Publish Artifact to Repository

- upload jar file to existing hosted repository on Nexus
- maven/gradle command for pushing to remote repository
- configure both tools to connect to Nexus (Nexus Repo URL + Credentials)
- Nexus User with permission to upload

### Create Nexus User & Role

- starts at 1:45


### Gradle Project - Configure with Nexus

- starts at 5:20

Edit the `build.gradle`.

- Gradle properties file: at 10:10


### Gradle Project - Jar Upload

```sh
# inside projects directory
./gradlew build

# check `build/libs/my-app*.jar`

# upload the artifact
./gradlew publish
```

Go to the Nexus web interface and check if the artifact is there (Browse > maven-snapshots).


### Maven Project - Configure with Nexus

- starts at 15:37

Edit the `pom.xml`. (16:35)

Create the `~/.m2/settings.xml`
```sh
vim ~/.m2/settings.xml
```

```xml
<settings>
  <servers>
    <server>
      <id>nexus-snapshots</id>
      <username>nana</username>
      <password>xxxxx</password>
    </server>
  </servers>
</settings>
```

### Maven Project - Jar Upload

- starts at 21:05

```sh
# in projects directory
mvn package

# upload the artifact to nexus
mvn deploy
```

Go to the Nexus web interface and check if the artifact is there (Browse > maven-snapshots).


## 6. Nexus REST API

- Query Nexus Repository for different information
    - which components?
    - what are the versions?
    - which repositories
- this information is needed in your CI/CD Pipeline
- when you are pushing multiple artifacts per day

### How to access the REST endpoint

- use a tool like curl or wget to execute http request
- provide user and credential of a Nexus user
- use the Nexus user with the required permissions

```sh
# list the repositories available for 'user'
curl -u user:password -X GET "http://${ip}:${port}/service/rest/v1/repositories"

# list all repositories (using admin credentials)
curl -u admin:password -X GET "http://${ip}:${port}/service/rest/v1/repositories"

# listing components
curl -u user:password -X GET "http://${ip}:${port}/service/rest/v1/components?repository=maven-snapshots"

# displaying one specific component
curl -u user:password -X GET "http://${ip}:${port}/service/rest/v1/components/${component_id}"
```


## 7. Blob Store

- Nexus storage to store all the uploaded files
- storage of binary files
- **Local** storage or **Cloud** storage

Configs are placed at `/opt/sonatype-work/nexus3/blobs`.

### Blob Store - Type

- Type field = Storage Backend
    - file system-based storage (default)
    - cloud-based storage (e.g. S3)
        - wondering if DigitalOcean Spaces could also be used?
- state field = state of the blob store
    - started: indicates it's running as expected
    - failed: indicates a configuration issue - failed to initialize
- blob count = number of blobs currently stored

**NOTE:** when creating a new blob store, the Path field is the absolute path to the desired file system location. It needs to be fully accessible by the `nexus` user account.

### Some things to consider

- Blob store **can NOT be modified!**
- Blob store used by a repository **can NOT be deleted!**

- You need to decide carefully:
    - How many blob stores you want to create
    - With which sizes
    - Which ones you'll use for which repos
    - You need to know approximately how much space each repo will need


## 8. Component vs. Asset

In the Nexus' web interface, Browse link in the sidebar, you see the components and their assets.

- Component
    - abstract (high level definition)
    - what we are uploading
    - term "component" refers to any type or format (jar, zip, Dockerfile, etc.)

- Asset
    - Actual packages/files being uploaded
    - 1 component = 1 or more assets

- Docker Format gives assets unique identifiers (Docker layers)
- Docker Layers == Assets
- e.g. two Docker images -> 2 components sharing same assets


## 9. Cleanup Policies and Scheduled Tasks

Admin > Cleanup Policies > Create Cleanup Policy

After creating a cleanup policy, you still need to associate it to a repository.

Admin > Repositories > choose a repo > Cleanup Policies > Save

### When will the cleanup happen?

Admin > System > Tasks

A task is created as soon as you create a Cleanup Policy

Create a Task to compact blob store

You can also run the tasks manually by clicking in the [Run] button.

