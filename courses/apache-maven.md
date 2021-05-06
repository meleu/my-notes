# Apache Maven: Beginner to Guru

- <https://www.udemy.com/course/apache-maven-beginner-to-guru/>

## DevOps Notes

Notes by me while taking this course.

### First Maven Execution

Noticed that when running some maven tasks for the first time (like `clean` and `package`) it downloads artifacts and it takes a lot of time, and the next executions go really fast (no need to download stuff).

Doing this in a pipeline, where the runner is a "fresh" container, results in downloading artifacts allways.

There must be a way to prevent this.

---

The very first execution of `mvn package` for my simple Hello World project took 01:08 min, because maven needed to download a bunch of artifacts from `https://repo.maven.apache.org/`.

The next executions took less than 1 second!!!

That fact alerted me that probably I could dramatically improve the speed of my GitLab CI pipeline...

Every stage of the pipeline starts a "fresh" container. We have two stages with maven (one to build and another to run a SAST Scanner), I noticed that in both we're downloading artifacts...

I need to save such artifacts in a cache!

---






## Compiling Java

### Creating Java jar files from Command line

- <https://www.udemy.com/course/apache-maven-beginner-to-guru/learn/lecture/12781593>

This "Hello World":

```java
public class HelloWorld {
  public  static void main(String[] args) {
    System.out.println("Hello World!");
  }
}
```

```sh
$ # the source is compiled with `javac`
$ javac HelloWorld.java 
$ # it creates the .class file
$ ls
HelloWorld.class  HelloWorld.java
$ # you can run that class with the `java` command:
$ java HelloWorld 
Hello World!
$ # let's build a .jar file with the `jar` command
$ jar cf myjar.jar HelloWorld.class 
$ # let's run the class HelloWorld from that .jar file
$ java -classpath myjar.jar HelloWorld 
Hello World!
```

**Note**: the `.jar` file is actually a zipped file.

In simple terms, what Maven basically does is compiling classes and then package them into a `.jar` file.



### Using 3rd Party Jars with Command Line Java

- <https://www.udemy.com/course/apache-maven-beginner-to-guru/learn/lecture/12781725>

**Note**: there's a `commons-lang3-3.8.1.jar` file in the zipped "Resources" of the lecture.

```sh
# building it
$ javac -classpath ./lib/* HelloWorld.java 

# running it
$ java -classpath ./lib/*:./ HelloWorld 
Hello World!
Hello world
```

Another thing maven does is managing such dependencies.


## Getting Started with Maven

In order to build with Maven we need a `pom.xml`.

Example for our HelloWorld:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>guru.springframework</groupId>
    <artifactId>hello-world</artifactId>
    <version>0.0.1-SNAPSHOT</version>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>11</java.version>
        <maven.compiler.source>${java.version}</maven.compiler.source>
        <maven.compiler.target>${java.version}</maven.compiler.target>
    </properties>

</project>
```

Pay attention to that `<artifactId>` and `<version>`. They're goint to be used to generate the `.jar` file.

```sh
# clean out the environment (looks similar to `make clean`)
mvn clean

# create a jar file
mvn package

# inside the `target/` folder you'll see a file named
# `hello-world-0.0.1-SNAPSHOT.jar`

# if you run the `clean` again, the target/ directory will be deleted
mvn clean

# put your HelloWorld.java in a subdir
mkdir -p src/main/java
mv HelloWorld.java src/main/java

# you can clean and package in the same command line
mvn clean package

```



### Dependencies

In order to add dependencies to your project, just add the dependency's coordinates to your `pom.xml`, like this:

```xml
<dependencies>
    <dependency>
        <groupId>org.apache.commons</groupId>
        <artifactId>commons-lang3</artifactId>
        <version>3.8.1</version>
    </dependency>
</dependencies>
```

In the next run of `mvn package` it'll download the dependencies.


## Maven Basics

### Maven Coordinates

```xml
    <groupId>guru.springframework</groupId>
    <artifactId>hello-world</artifactId>
    <version>0.0.1-SNAPSHOT</version>
```

- `SNAPSHOT` sufix tells maven this is a development version.



### Maven Repositories

Types:

- Local: `~/.m2/`
- Central: <https://repo1.maven.org/maven2>
- Remote: other locations which can be public or private
    - JBoss, Oracle, Atlassian, Google Android
    - Private - hosted by companies for internal artifacts

```
                      ,-> Central
Project <-> ~/.m2/ <-{
                      '-> Others
```


