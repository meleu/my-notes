# NLW #6 - Aula 4

- <https://nextlevelweek.com/episodios/node/aula-4/edicao/6>
- https://github.com/meleu/nlw-06/commit/b421899894133b4a384431e63f7cef4537b69de5


## JWT - 4:30

```sh
yarn add jsonwebtoken bcryptjs
yarn add @types/jsonwebtoken @types/bcryptjs -D
```

### Alterar tabela `users` para adicionar campo de senha - 14:45

```sh
yarn typeorm migration:create -n AlterUsersAddPassword
```

`src/database/migrations/*AterUsersAddPassword.ts`
```ts
import { MigrationInterface, QueryRunner, TableColumn } from "typeorm";

export class AlterUsersAddPassword1624650506779 implements MigrationInterface {

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.addColumn(
      "users",
      new TableColumn({
        name: "password",
        type: "varchar",
        isNullable: true
      })
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropColumn("users", "password")
  }

}
```

```sh
yarn typeorm migration:run
```

Adicionar coluna `password` em:

`src/entities/User.ts`:
```ts
@Column()
password: string;
```

`src/services/CreateUserService.ts`
```ts
import { hash } from "bcryptjs";

interface IUserRequest {
  name: string;
  email: string;
  admin?: boolean;
  password: string;
}

class CreateUserService {
  async execute({ name, email, admin = false, password }: IUserRequest) {
	// ...
    const passwordHash = await hash(password, 8);

    const user = usersRepository.create({
      name,
      email,
      admin,
      password: passwordHash
    });
	// ...
  }
 }
```

`src/controllers/CreateUserController.ts`
```ts
class CreateUserController {
  async handle(request: Request, response: Response) {
    const { name, email, admin, password } = request.body;

    const createUserService = new CreateUserService();

    const user = await createUserService.execute({ name, email, admin, password });

    return response.json(user);
  }
}
```

## Criptografia de senha - 22:50

Testa criar um usuário via insomnia e confere no beekeeper se a senha está criptografada.

## Autenticação - 27:20

`src/services/AuthenticateUserService.ts`:
```ts
import { getCustomRepository } from "typeorm";
import { compare } from "bcryptjs";
import { sign } from "jsonwebtoken";
import { UserRepositories } from "../repositories/UserRepositories";

interface IAuthenticateRequest {
  email: string;
  password: string;
}

class AuthenticateUserService {
  async execute({ email, password }: IAuthenticateRequest) {
    const usersRepositories = getCustomRepository(UserRepositories);

    const user = await usersRepositories.findOne({
      email
    });

    if (!user) {
      throw new Error("Email/Password incorrect");
    }

    const isPasswordCorrect = await compare(password, user.password);

    if (!isPasswordCorrect) {
      throw new Error("Email/Password incorrect");
    }

    const token = sign(
      {
        email: user.email
      },
      "cf0ae2f97f7f852f8cdede8ac4ccfc21", // generated with `md5sum`
      {
        subject: user.id,
        expiresIn: "1d"
      }
    );

    return token;
  }
}

export { AuthenticateUserService };
```

`src/controllers/AuthenticateUserController.ts`:
```ts
import { Request, Response } from "express";
import { AuthenticateUserService } from "../services/AuthenticateUserService";

class AuthenticateUserController {
  async handle(request: Request, response: Response) {
    const { email, password } = request.body;

    const authenticateUserService = new AuthenticateUserService();

    const token = await authenticateUserService.execute({
      email,
      password
    });

    return response.json(token);
  }
}

export { AuthenticateUserController };
```


`src/routes.ts`:
```ts
import { AuthenticateUserController } from "./controllers/AuthenticateUserController";
// ...

const authenticateUserController = new AuthenticateUserController;
// ...

router.post("/login", authenticateUserController.handle);
// ...
```

Testar autenticação via insomnia - 41:40

## Tabela `compliments` - 44:55

```sh
yarn typeorm migration:create -n CreateCompliments
```

`src/migrations/*.CreateCompliments.ts`:
```ts
import { MigrationInterface, QueryRunner, Table } from "typeorm";

export class CreateCompliments1624652706618 implements MigrationInterface {

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: "compliments",
        columns: [
          {
            name: "id",
            type: "uuid",
            isPrimary: true
          },
          {
            name: "user_sender",
            type: "uuid",
          },
          {
            name: "user_receiver",
            type: "uuid",
          },
          {
            name: "tag_id",
            type: "uuid"
          },
          {
            name: "message",
            type: "varchar"
          },
          {
            name: "created_at",
            type: "timestamp",
            default: "now()"
          }
        ],
        foreignKeys: [
          {
            name: "FKUserSenderCompliments",
            referencedTableName: "users",
            referencedColumnNames: ["id"],
            columnNames: ["user_sender"],
            onDelete: "SET NULL",
            onUpdate: "SET NULL"
          },
          {
            name: "FKUserReceiverCompliments",
            referencedTableName: "users",
            referencedColumnNames: ["id"],
            columnNames: ["user_receiver"],
            onDelete: "SET NULL",
            onUpdate: "SET NULL"
          },
          {
            name: "FKUserSenderCompliments",
            referencedTableName: "tags",
            referencedColumnNames: ["id"],
            columnNames: ["tag_id"],
            onDelete: "SET NULL",
            onUpdate: "SET NULL"
          },

        ]
      })
    )
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable("compliments");
  }

}
```

```sh
yarn typeorm migration:run
```

Checar no beekeeper se a tabela foi criada corretamente e se as chaves estrangeiras estão devidamente identificadas.

## Entidade - 58:40

`src/entities/Compliment.ts`:
```ts
import { Column, CreateDateColumn, Entity, JoinColumn, ManyToOne, PrimaryColumn } from "typeorm";
import { v4 as uuid } from "uuid";
import { Tag } from "./Tag";
import { User } from "./User";

@Entity("compliments")
class Compliment {

  @PrimaryColumn()
  readonly id: string;

  @Column()
  user_sender: string;

  @JoinColumn({ name: "user_sender" })
  @ManyToOne(() => User)
  userSender: User;

  @Column()
  user_receiver: string;

  @JoinColumn({ name: "user_receiver" });
  @ManyToOne(() => User)
  userReceiver: User;

  @Column()
  tag_id: string;

  @JoinColumn({ name: "tag_id" });
  @ManyToOne(() => Tag)
  tag: Tag;

  @Column()
  message: string;

  @CreateDateColumn()
  created_at: Date;

  constructor() {
    if (!this.id) {
      this.id = uuid();
    }
  }

}

export { Compliment };
```

## Repositório - 1:06:45

`src/repositories/ComplimentsRepositories.ts`
```ts
import { Repository } from "typeorm";
import { Compliment } from "../entities/Compliment";

class ComplimentsRepositories extends Repository<Compliment> { }

export { ComplimentsRepositories };
```


## Service - 1:07:30

`src/services/CreateComplimentService.ts`
```ts
import { getCustomRepository } from "typeorm";
import { ComplimentsRepositories } from "../repositories/ComplimentsRepositories";
import { UserRepositories } from "../repositories/UserRepositories";

interface IComplimentRequest {
  tag_id: string;
  user_sender: string;
  user_receiver: string;
  message: string;
}

class CreateComplimentService {
  async execute({
    tag_id,
    user_sender,
    user_receiver,
    message,
  }: IComplimentRequest) {
    if (user_sender === user_receiver) {
      throw new Error("Incorrect User Receiver");
    }

    const complimentsRepositories = getCustomRepository(ComplimentsRepositories);
    const usersRepositories = getCustomRepository(UserRepositories);

    const userReceiverExists = await usersRepositories.findOne(user_receiver);

    if (!userReceiverExists) {
      throw new Error("User Receiver does not exist!");
    }

    const compliment = complimentsRepositories.create({
      tag_id,
      user_sender,
      user_receiver,
      message
    });

    await complimentsRepositories.save(compliment);

    return compliment;
  }
}

export { CreateComplimentService };
```


## Controller - 1:16:00

`src/controllers/CreateComplimentController.ts`:
```ts
import { Request, Response } from "express";
import { CreateComplimentService } from "../services/CreateComplimentService";

class CreateComplimentController {
  async handle(request: Request, response: Response) {
    const { tag_id, user_sender, user_receiver, message } = request.body;

    const createComplimentService = new CreateComplimentService();

    const compliment = await createComplimentService.execute({
      tag_id,
      user_sender,
      user_receiver,
      message
    });

    return response.json(compliment);
  }
}

export { CreateComplimentController };
```

## Router - 1:18:05

`src/routes.ts`
```ts
// ...
import { CreateComplimentController } from "./controllers/CreateComplimentController";
// ...

const createComplimentController = new CreateComplimentController();
//...

router.post("/compliments", createComplimentController.handle);

export { router };
```

Testar a aplicação e tentar criar um elogio via insomnia, acessando o endpoint `/compliments` com o seguinte payload:
```json
{
  "tag_id": "",
  "user_sender": "",
  "user_receiver": "",
  "message": ""
}
```

Conferir no beekeeper.

Outros testes:
- `user_sender === user_receiver` não pode
- sender inválido (esse teste será feito na autenticação)
- receiver inválido
- id inexistente
- tag inexistente

## Adendo

No `src/services/CreateUserService.ts`, definir um valor default para `admin` - 1:24:50.

Desta forma ao criar um usuário não precisa enviar `"admin": false` no JSON.

