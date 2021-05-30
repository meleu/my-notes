# Tools and Basic Setup

## tools

- install node through [nvm](https://github.com/nvm-sh/nvm)

- Visual Studio Code is a pretty neat editor to work with JavaScript.
    - vim keybindings plugin (I'm much more productive with vim keybindings).
    -  Saved my preferences here: https://github.com/meleu/vscode-preferences

- https://insomnia.res is a nice software to test REST APIs (runs on Linux)

- docker (to manage PostgreSQL, MongoDB and Redis containers).

- [Postbird](https://www.electronjs.org/apps/postbird): PostgreSQL GUI client

- DevDocs.io is an awesome tool to have documentation at hand and available even while offline. There's also a Desktop app for it: https://devdocs.egoist.moe/


## nodemon + sucrase

**NOTE**: sorry, I originally wrote it in portuguese and didn't find enough freetime to translate.

nodemon: reinicia a aplicação a cada mudança no código

sucrase: permite que usemos `import ... from ...` no lugar de `require()`


Instalar como dependência de desenvolvimento (opção `-D`):
```
yarn add nodemon sucrase -D
```

Adicionar ao `package.json`:
```json
  "scripts": {
    "dev": "nodemon src/server.js",
    "dev:debug": "nodemon --inspect"
  }
```

Criar o arquivo `.nodemon.json`:
```json
{
  "execMap": {
    "js": "node --require sucrase/register"
  }
}
```

### debugging via VSCode

**NOTE**: sorry, I originally wrote it in portuguese and didn't find enough freetime to translate.

1. No VSCode, vai na seção de "Debug and Run" (atalho: `Ctrl+Shift+D`)
2. Inicie um novo `launch.json`.
3. Remova a linha com a propriedade `program`.
4. Altere as propriedades do `configurations` que estão listadas abaixo:

```js
{
  "configurations": [
    {
      "request": "attach",
      // remover "program"
      "restart": true,
      "protocol": "inspector"
    }
  ]
}
```


## ESLint + Prettier + EditorConfig

**NOTE**: sorry, I originally wrote it in portuguese and didn't find enough freetime to translate.


Ir na seção de plugins do VSCode e instalar ESLint.

Em seguida vai no terminal:

```
yarn add eslint prettier eslint-config-prettier eslint-plugin-prettier -D
yarn eslint --init
```

Durante o init selecionar:

1. check syntax, find problems and enforce code style
2. JavaScript modules (import/export) (graças ao sucrase)
3. Sobre framework: None of these (nem React nem Vue.js)
4. Desmarcar `Browser` e marcar `Node` (usando espaço)
5. Use a popular style guide
6. Airbnb
7. aceitar instalação (vai instalar via `npm`)

Remover o `package-lock.json` e executar simplesmente `yarn` para que seja feito o mapeamento das dependências no `yarn.lock`.

O arquivo `.eslintrc.js` será criado, vamos fazer algumas alterações nele:
```js
  // ...
  extends: ['airbnb-base', 'prettier'],
  plugins: ['prettier'],
  // ...
  rules: {
    "prettier/prettier": "error",
    "class-methods-use-this": "off",
    "no-param-reassign": "off",
    "camelcase": "off",
    "no-unused-vars": ["error", { "argsIgnorePattern": "next" }],
  }
```

Criar o arquivo `.prettierrc`:
```json
{
  "singleQuote": true,
  "trailingComma": "es5"
}
```

Aplicar eslint em todos arquivos `.js`:
```
yarn eslint --fix src --ext .js
```

Ir nas configurações do vscode: `Ctrl+Shift+P`01 - Toolbox tips

- DevDocs.io is an awesome tool to have documentation at hand and available even while offline. There's also a Desktop app for it: https://devdocs.egoist.moe/
- https://insomnia.res is a nice software to test REST APIs (runs on Linux)
- Visual Studio Code is a pretty neat e digite `settings json`. E adicionar isso ao `settings.json`:
```json
  "[javascript]": {
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true,
    },
  },
  "[javascriptreact]": {
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true,
    },
  },
```

### EditorConfig

**NOTE**: sorry, I originally wrote it in portuguese and didn't find enough freetime to translate.


EditorConfig é útil quando trabalhamos em projetos onde os outros desenvolvedores utilizam editores diferentes do nosso (VSCode).

Ir na seção de plugins do VSCode e instalar EditorConfig.

Criar arquivo `.editorconfig`:
```
root = true

[*]
indent_style = space
indent_size = 2
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
```


## ExpressJS

```
yarn add express
```

File structure:
```
src/
+-- app
¦   +-- controllers
¦   +-- middlewares
¦   +-- models
+-- config
+-- database
¦   +-- migrations
+-- app.js
+-- routes.js
+-- server.js
```


## docker

Install docker following the instructions in https://docs.docker.com/install/ and don't forget to follow the post-install instructions.

Basic docker commands:

```
docker ps                   # list active containers
docker ps -a                # list available containers in your machine
docker start containerName  # starts containerName
docker stop containerName   # stops containerName
docker logs containerName   # show containerName logs
docker run                  # runs a process in a new container
```

## PostgreSQL

PostgreSQL container: [https://hub.docker.com/_/postgres](https://hub.docker.com/_/postgres)

Installing:
```
docker run --name database -e POSTGRES_PASSWORD=docker -p 5432:5432 -d postgres
```

**Note**: in the option `-p`, the first number is the port of the "real" machine, and the number after `:` is the container's port.


### Postbird

https://www.electronjs.org/apps/postbird

It's a nice GUI client for PostgreSQL.

Once connected to a PostgreSQL DB through Postbird, create a database (leave `template` blank and for `encoding` use UTF8).


## Sequelize

Installing Sequelize and the dependencies to work with PostgreSQL dialect:
```
yarn add sequelize pg pg-hstore
yarn add sequelize-cli -D
```

Create the file `.sequelizerc`:

```js
const { resolve } = require('path');

module.exports = {
  config: resolve(__dirname, 'src', 'config', 'database.js'),
  'models-path': resolve(__dirname, 'src', 'app', 'models'),
  'migrations-path': resolve(__dirname, 'src', 'database', 'migrations'),
  'seeders-path': resolve(__dirname, 'src', 'database', 'seeds'),
};
```

Create the file `src/config/database.js`:
```js
module.exports = {
  dialect: 'postgres',
  host: 'localhost',
  username: 'postgres',
  password: 'docker', // <-- definido via POSTGRES_PASSWORD lá no docker run
  database: 'DBName', // <-- definido na criação do BD com o Postbird
  define: {
    timestamps: true,
    underscored: true,
    underscoredAll: true,
  },
};
```

## bcrypt + JWT +Yup

Packages used to deal with authentication.

```
yarn add bcryptjs jsonwebtoken yup
```
tor to work with JavaScript. Saved my preferences here: https://github.com/meleu/vscode-preferences

> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE2NTUxNTI4MzJdfQ==
-->