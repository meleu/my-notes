# Apache Maven: Beginner to Guru

- <https://www.udemy.com/course/apache-maven-beginner-to-guru/>

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