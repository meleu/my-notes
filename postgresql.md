# PostgreSQL
[✏️](https://github.com/meleu/my-notes/edit/master/postgresql.md)

## install via docker

PostgreSQL container: [https://hub.docker.com/_/postgres](https://hub.docker.com/_/postgres)

Installing:
```
docker run --name database -e POSTGRES_PASSWORD=docker -p 5432:5432 -d postgres
```

**Note**: in the option `-p`, the first number is the port of the host machine, and the number after `:` is the container's port.


### Postbird

https://www.electronjs.org/apps/postbird

It's a nice GUI client for PostgreSQL.

Once connected to a PostgreSQL DB through Postbird, create a database (leave `template` blank and for `encoding` use UTF8).

