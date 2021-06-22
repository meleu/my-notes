# NLW #6 - Aula 2

- <https://nextlevelweek.com/episodios/node/aula-2/edicao/6>


## Tabelas - 3:55

```md
# users

- id: uuid (pk)
- name: varchar
- email: varchar
- password: varchar
- admin: boolean
- created_at: Date
- updated_at: Date


# tags

- id: uuid (pk)
- name: varchar
- created_at: Date
- updated_at: Date


# compliments

- id: uuid (pk)
- user_sender: uuid (fk)
- user_receiver: uuid (fk)
- tag_id: uuid (fk)
- message: varchar
- created_at: Date
- updated_at: Date
```


## Tipos de Parâmetros - 7:15

utilizaremos 3 tipos:

- routes: `https://example.com/produtos/12345`
- query: `https://example.com/produtos?serch=teclado&description=mecanico`
- body: vai no corpo da requisição, geralmente em formato JSON


## Banco de Dados - 13:30

- driver nativo do banco
- query builder. ex.: knex
- ORM. ex.: Sequelize, TypeORM, Prisma


## Instalando TypeORM - 24:00

```sh
yarn add typeorm reflect-metadata sqlite3 uuid
yarn add @types/uuid -D
mkdir database
```

`ormconfig.json`:
```json
{
  "type": "sqlite",
  "database": "src/database/database.sqlite",
  "migrations": ["src/database/migrations/*.ts"],
  "entities": ["src/entities/*.ts"],
  "cli": {
    "migrationsDir": "src/database/migrations",
    "entitiesDir": "src/entities"
  }
}
```

`src/database/index.ts`:
```ts
import { createConnection } from "typeorm";

createConnection();
```

## Migrations - 33:20

Adicionar ao `package.json`:
```json
{
  "scripts": {
    "typeorm": "ts-node-dev ./node_modules/typeorm/cli.js"
  }
}
```

```sh
# testando:
yarn typeorm -help

# criando migrations:
yarn typeorm migration:create -n CreateUsers
# verificar se a migration se encontra em src/database/migrations
```

`src/database/migrations/*CreateUsers*.ts`:
```ts
// 44:45
// 45:30
// 46:40

```

Executando a migration:
```sh
yarn typeorm migration:run

# se precisar reverter a migration:
# yarn typeorm migration:revert
```

Verificar no beekeeper se a tabela foi criada.


## Entities - 50:00

OBSERVAÇÃO: ajustar o `tsconfig.json` para usar decorators:
```json
{
  "strictPropertyInitialization": false,
  "experimentalDecorators": true,
  "emitDecoratorMetadata": true,
}
```

Assumindo que o `ormconfig.json` está devidamente configurado:
```sh
yarn typeorm entity:create -n User
```

Criará o arquivo `src/entities/User.ts`:
```ts
// 1:02:15
```

## Repositório - 1:02:40

É uma camada entre as entidades e o banco de dados.

```sh
mkdir -p src/repositories
touch UserRepositories.ts
```

`src/repositories/UserRepositories.ts`:
```ts
import { EntityRepository, Repository } from "typeorm";
import { User } from "../entities/User";

@EntityRepository(User)
class UsersRepositories extends Repository<User> {}

export { UsersRepositories };
```



## Services (Use Cases, Regras de Negócio) - 1:09:25

`README.md`
```md
# NLW Valoriza

- 1:13:25
```

Explicação interessante sobre "Services" em 1:14:40

```txt
fluxo de requisição
===================

client -> server -> (  ) -> services -> repositories -> DB
                               ^
                               |
                      verifica as regras
```


```sh
# 1:19:20
mkdir -p src/services
```

`src/services/CreateUserService.ts`:
```ts
// 1:22:55
// 1:23:50
// 1:35:35 - correção para usar getCustomRepository()
```

## Controllers - 1:24:30

```sh
mkdir -p src/controllers
```
Explicação interessante sobre "Controllers" em 1:25:00

```txt
fluxo de requisição
===================

client -> server -> controllers -> services -> repositories -> DB
                         ^
                         |
                classe que tem acesso ao
                   request/response

meu comentário:
  - um controller "conhece" HTTP
  - um service não "conhece" HTTP
```

Fazendo requisição com insomnia: 1:27:00

`src/controllers/CreateUserController.ts`:
```ts
// 1:28:50
```


## Router - 1:29:00

`src/routes.ts`:
```ts
// 1:31:10
```

`src/server.ts`:
```ts
import "reflect-metadata";
import express from "express";

import { router } from "./routes";

import "./database";

const app = express();

app.use(express.json());

app.use(router);

app.listen(3000, () => console.log("Server is running"));
```


