# NLW #6 - Aula 3

- <https://nextlevelweek.com/episodios/node/aula-3/edicao/6>
- <https://github.com/meleu/nlw-06/commit/177db34156390c319c0aedfb60631dcbb1222a6c>


## Tratamento de Exceções - 5:10

Adicionando um middleware de tratamento de erro no `server.ts`.

```sh
yarn add express-async-errors
```

`src/server.ts`:
```ts
import "reflect-metadata";
import "express-async-errors";
import express, { Request, Response, NextFunction, response } from "express";

import "./database";
import { router } from "./routes";

const app = express();

app.use(express.json());

app.use(router);

app.use((err: Error, request: Request, response: Response, next: NextFunction) => {
  if (err instanceof Error) {
    return response.status(400).json({
      error: err.message
    });
  }
});

app.listen(3000, () => console.log("Server is running"));
```

## Migration de tags - 18:45

```sh
yarn typeorm migration:create -n CreateTags
```

`src/database/migrations/*CreateTags.ts`:
```ts
import { MigrationInterface, QueryRunner, Table } from "typeorm";

export class CreateTags1624528928967 implements MigrationInterface {

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: "tags",
        columns: [
          {
            name: "id",
            type: "uuid",
            isPrimary: true
          },
          {
            name: "name",
            type: "varchar",
          },
          {
            name: "created_at",
            type: "timestamp",
            default: "now()"
          },
          {
            name: "updated_at",
            type: "timestamp",
            default: "now()"
          }
        ]
      })
    )
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable("tags");
  }

}
```

```sh
yarn typeorm migration:run
```

## Entity de tags - 22:35

`src/entities/Tag.ts`
```ts
import { Column, CreateDateColumn, Entity, PrimaryColumn, UpdateDateColumn } from "typeorm";
import { v4 as uuid } from "uuid";

@Entity("tags")
class Tag {
  @PrimaryColumn()
  readonly id: string;

  @Column()
  name: string;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  constructor() {
    if (!this.id) {
      this.id = uuid();
    }
  }
}

export { Tag };
```

## Repositório de tags - 26:15

`src/repositories/TagsRepositories.ts`
```ts
import { EntityRepository, Repository } from "typeorm";
import { Tag } from "../entities/Tag";

@EntityRepository(Tag)
class TagsRepositories extends Repository<Tag> { }

export { TagsRepositories };
```

## Service de tags - 28:30

`src/services/CreateTagService.ts`:
```ts
import { getCustomRepository } from "typeorm";
import { TagsRepositories } from "../repositories/TagRepositories";

class CreateTagService {
  async execute(name: string) {
    const tagsRepositories = getCustomRepository(TagsRepositories);

    if (!name) {
      throw new Error("Incorrect name!");
    }

    const tagAlreadyExists = await tagsRepositories.findOne({
      name
    });

    if (tagAlreadyExists) {
      throw new Error("Tag already exists!");
    }

    const tag = tagsRepositories.create({
      name
    });

    await tagsRepositories.save(tag);

    return tag;
  }
}

export { CreateTagService };
```

## Controller de tags - 35:20

`src/controllers/CreateTagController.ts`:
```ts
import { Request, response, Response } from "express";
import { CreateTagService } from "../services/CreateTagService";

class CreateTagController {
  async handle(request: Request, response: Response) {

    const { name } = request.body;

    const createTagService = new CreateTagService();

    const tag = await createTagService.execute(name);

    return response.json(tag);
  }
}

export { CreateTagController };
```

## Middlewares - 43:30

```sh
mkdir -p src/middlewares
```

`src/middlewares/ensureAdmin.ts`:
```sh
import { Request, Response, NextFunction } from "express";

export function ensureAdmin(
  request: Request,
  response: Response,
  next: NextFunction
) {
  // TODO: remove this hardcoded test
  const admin = true

  if (admin) {
    return next();
  }

  return response.status(401).json({
    error: "Unauthorized"
  });
}
```

Ajuste em `src/routes` 50:34 - após criação do middleware ensureAdmin

```sh
yarn dev
# testar adicionar uma tag via insomnia
```

Testar no insomnia:
- `admin = false`
- `admin = true`
- tag repetida