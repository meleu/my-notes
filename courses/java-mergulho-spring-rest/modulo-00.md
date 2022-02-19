# Mergulho Spring REST - Preparação do Ambiente

## Instalar JDK

```sh
# instalar
sudo apt update
sudo apt install openjdk-11-jdk-headless

# verificar
javac -version
java -version
```

### Alternativa: SDKMAN

https://sdkman.io/

Parece ser uma alternativa no estilo NVM (Node Version Manager).


## Spring Tool Suite

https://spring.io/tools

Baixar o Spring Tools for Eclipse.

O pacote para Linux será um `.tar.gz`. Ao descompactá-lo, o executável será o `SpringToolSuite4`.


## Lombok

https://projectlombok.org/

Go to the `Download` page and get the latest stable version (it's a `.jar` file).

Run the jar file and select your IDE.


## Postman / Insomnia

Install Postman: https://www.getpostman.com/downloads/

I prefer Insomnia: https://insomnia.rest/


## MySQL

```sh
# create and start the mysql container
docker container run \
  -d \
  --publish 3306:3306 \
  --env MYSQL_ALLOW_EMPTY_PASSWORD=yes \
  --name mysql8 \
  mysql:8.0
  
  
# stop the mysql container
docker container stop mysql8
 
 
# start the mysql container
docker container start mysql8
```


### MySQL Workbench

https://dev.mysql.com/downloads/workbench/

I prefer to use dbeaver: https://dbeaver.io/


