# Starting the project

## structure

Source code goes in `src/`

Common files are: `app.js`, `server.js` and `routes.js`.


## sucrase and nodemon

```
yarn sucrase nodemon -D
```

in `package.json`:
```json
  "scripts": {
    "dev": "nodemon --config nodemon.json src/server.js",
  }
```

in `.nodemon.json`:
```json
{
  "execMap": {
    "js": "node --require sucrase/register"
  }
}
```

sucrase allow us to use the "import-from" syntax:

```js
// thanks to sucrase we can use 'import ... from ...'
import express from 'express';

class App {
  constructor() {
    this.server = express()
    // ...
  }

  // ...
}

// thanks to sucrase we can use 'export default ...'
export default new App().server;
```

### debugging

add `dev:debug` in `package.json`, like this:
```json
  "scripts": {
    "dev": "nodemon --config nodemon.json src/server.js",
    "dev:debug": "nodemon --inspect src/server.js"
  }
```

Go to the debug section in VSCode and start a new `launch.json`. In this file, remove the line with the `program` property and change the ones listed below:

```json
{
  "configurations": [
    {
      "request": "attach",
      "restart": true,
      "protocol": "inspector"
    }
  ]
}
```

## docker

Install docker following the instructions in [https://docs.docker.com/install/](https://docs.docker.com/install/) and don't forget to follow the Post-install instructions.

basic commands:

```
docker ps                   # list active containers
docker ps -a                # list available containers in this machine
docker stop containerName   # quite obvious
docker start containerName  # idem
docker log containerName    # idem
docker run                  # runs a process in a new container
```

## PostgreSQL

Installing a PostgreSQL container:

docker: [https://hub.docker.com/_/postgres](https://hub.docker.com/_/postgres)

install:
```
docker run --name database -e POSTGRES_PASSWORD=docker -p 5432:5432 -d postgres
```

**note**: in the `-p` option, the first number is the port in the actual machine, the number at the right of the `:` is the port of the container.


### Postbird

A neat GUI to access a PostgreSQL database (runs on Linux):
[https://www.electronjs.org/apps/postbird](https://www.electronjs.org/apps/postbird)

Once connected to the PostegreSQL via Postbird, create a database named `gobarber` (no template, encoding UTF8).


## Sequelize

```
yarn add sequelize pg pg-hstore
yarn add sequelize-cli -D
```

file `.sequelizerc`:
```js
const { resolve } = require('path');

module.exports = {
  config: resolve(__dirname, 'src', 'config', 'database.js'),
  'models-path': resolve(__dirname, 'src', 'app', 'models'),
  'migrations-path': resolve(__dirname, 'src', 'database', 'migrations'),
  'seeders-path': resolve(__dirname, 'src', 'database', 'seeds'),
```

in `src/config/database.js`:
```js
module.exports = {
  dialect: 'postgres',
  host: 'localhost',
  username: 'postgres',
  password: 'docker',
  database: 'gobarber',
  define: {
    timestamps: true,
    underscored: true,
    underscoredAll: true,
  },
};
```


> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTI1MzIxNTQ3NCwtMjAxNDk5Mjg3MSw4NT
A0MDcwOTksLTE1MjU2NTQ2OCwtMTExMzYzMjQ2MSwtMTA2NTEy
MDI5OCwtMTUzMjY5NzQzMCw5NDIzOTQwMzJdfQ==
-->
