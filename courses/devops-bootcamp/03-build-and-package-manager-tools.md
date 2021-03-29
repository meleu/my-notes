# Build and Package Manager Tools

- Building the code
    - Compiling
    - Compress
    - Hundreds of files into 1 single file

- Artifactory repository
    - Keep artifact in storage
    - to deploy it multiple times, have backup, etc
    - examples:
        - Nexus
        - JFrog Artifactory

What kind of file is the artifact?

Artifact file looks different for each programming language

Example, for Java, the artifact is a JAR file, which includes whole code plus dependencies.


## Install Build Tools

### Install Java:

```
# using the one from the package manager
sudo apt install default-jdk

# setting JAVA_HOME variable (seems to be important for some tools)
# put the code below in your ~/.profile
if [ -d "/usr/lib/jvm/default-java/bin" ]; then
    JAVA_HOME="/usr/lib/jvm/default-java"
    PATH="$JAVA_HOME/bin:$PATH"
fi

```

### Install Maven

See instructions in <https://maven.apache.org/install.html>


### Install Gradle

I just used [IntelliJ](#download-intellij).

### Install Node + npm

I prefer to use [Node Version Manager](https://github.com/nvm-sh/nvm#installing-and-updating).

### Download IntelliJ

Download page: <https://www.jetbrains.com/idea/download/>

The Community version has the needed tools.


## Build an Artifact

- Build tools for Java applications:
  - Maven (uses XML)
  - Gradle (uses Groovy)

### With Gradle

The `./gradlew` present in the [Nana's repo](https://gitlab.com/devops-bootcamp3/java-gradle-app) is enough to build the project.

Executing `./gradlew build` will generate the `./build/` folder and the `.jar` file will be placed in `./build/libs/`.

### With Maven

Config the `pom.xml` file with the `<build>` tag. Then:

```sh
mvn install
```

The `.jar` file will be placed in `./target/` folder.


## Build Tools for Development

Managing dependencies:

- With Maven:
    - file: `pom.xml`
- With Gradle:
    - file: `build.gradle`
- repository: <https://mvnrepository.com/>


## Run the Application

Command to run a `.jar` file:
```sh
java -jar <file.jar>
```


## Build JS Application

### Backend

- no special artifact type
- npm or yarn for dependency manager
- npm repository for dependencies

```sh
# install dependencies (inside projects directory)
npm install

# when the package.json is properly configured
npm start   # start the application
npm stop    # stop the application
npm test    # run the tests
npm publish # publish the artifact

# create an artifact file
npm pack    # creates a tar file
```

What does the zip/tar file include?

- application code, but NOT the dependencies.
- to run the app on the server:
    - you must install the dependencies first
    - unpack zip/tar
    - run the App


### Frontend

- Frontend/React code needs to be transpiled
- code needs to be compressed/minified
- Separate tools for that - build tools/bundler (e.g.: webpack, grunt, etc.)

```sh
# install dependencies (inside projects directory)
npm install

# assuming webpack is installed and "build" in package.json calls webpack
# and it bundles the code minified/transpiled.
npm run build
```

When working with Java in the backend and React in the frontend, it's possible to:

- bundle the App with Webpack
- manage dependencies with npm or yarn
- package everything into a WAR file


## Common Concepts and Differences of Build Tools

| language | dependency manager |
|:-:|-:|
| Java | Maven or Gradle
| JavaScript | npm or yarn |
| Python | pip |


Pattern in all these tools:

- dependency file
- repository for dependencies
- command line tool
- package managers


## Publish an Artifact

Publish artifact into a artifact repository.

- build tools have commands for that
- then you can download (curl, wget) it anywhere


## Build Tools & Docker

- No need to build and move different artifact types (e.g.: jar, war, zip).
    - Just one artifact type: a docker image.
- No need for a repository for each file type.
    - Just one, for Docker images.
- No need to install dependencies on the server.
    - Just execute install command inside Docker image.

- Docker makes it easier to standardize the way to publish software artifacts.
- Docker image is an alternative for all other artifact types.
- You don't need to install npm or java on the server. Execute everything in the image.

- You still need to build the Apps, and then create the Docker image (via `Dockerfile`).


## Build Tools for DevOps

Why should a DevOps Engineer know these build tools?

- help developers for building the application
- because you know where and how it will run
    - build Docker image > push to repo > run on server
- you need to configure the build automation tool, CI/CD pipeline
    - install dependencies, run tests, build/bundle the app, push to repo
    - **you DON'T run the app locally**
- you need to execute tests on the build servers
- build and package into Docker image.
- 
