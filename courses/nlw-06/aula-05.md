# NLW #6 - Aula 5

- <https://nextlevelweek.com/episodios/node/aula-5/edicao/6>
- https://github.com/meleu/nlw-06/commit/3bbbf05a55f59ef24334befdc89b2c6ac22c0a9d

## Middleware de Autenticação - 5:50

Bearer Token no Insomnia: 11:20

Adicionando um campo ao request para que o middleware consiga passar uma informação adiante.

`src/@types/express/index.d.ts`:
```ts
declare namespace Express {
  export interface Request {
    user_id: string;
  }
}
```

Adicionar o diretório `src/@types` ao `tsconfig`

`tsconfig.json`:
```json
{
  // ...
  "typeRoots": ["./src/@types"],
  // ...
}
```

`src/middleware/ensureAuthentication.ts`:
```ts
import { NextFunction, Request, Response } from "express";
import { verify } from "jsonwebtoken";

interface IPayload {
  sub: string;
}

export function ensureAuthentication(
  request: Request,
  response: Response,
  next: NextFunction
) {
  const authToken = request.headers.authorization;

  if (!authToken) {
    return response.status(401).end();
  }

  const [, token] = authToken.split(" ");

  try {
    const { sub } = verify(
      token,
      "cf0ae2f97f7f852f8cdede8ac4ccfc21" // generated with `md5sum`
    ) as IPayload;

    request.user_id = sub;

    return next();
  } catch (err) {
    return response.status(401).end();
  }
}
```

`src/routes.ts`:
```ts
import { NextFunction, Request, Response } from "express";
import { verify } from "jsonwebtoken";

interface IPayload {
  sub: string;
}

export function ensureAuthentication(
  request: Request,
  response: Response,
  next: NextFunction
) {
  const authToken = request.headers.authorization;

  if (!authToken) {
    return response.status(401).end();
  }

  const [, token] = authToken.split(" ");

  try {
    const { sub } = verify(
      token,
      "cf0ae2f97f7f852f8cdede8ac4ccfc21" // generated with `md5sum`
    ) as IPayload;

    request.user_id = sub;

    return next();
  } catch (err) {
    return response.status(401).end();
  }
}
```

`src/middleware/ensureAdmin.ts`:
```ts
import { Request, Response, NextFunction } from "express";
import { getCustomRepository } from "typeorm";
import { UserRepositories } from "../repositories/UserRepositories";

export async function ensureAdmin(
  request: Request,
  response: Response,
  next: NextFunction
) {
  const { user_id } = request;

  const usersRepositories = getCustomRepository(UserRepositories);

  const { admin } = await usersRepositories.findOne(user_id);

  if (admin) {
    return next();
  }

  return response.status(401).end();
}
```

Faz alguns testes com insomnia - 40:00
- gerar token
- criar tag sem admin
- criar tag repetida com admin
- criar nova tag


 `src/controllers/CreateComplimentController.ts`:
```ts
import { Request, Response } from "express";
import { CreateComplimentService } from "../services/CreateComplimentService";

class CreateComplimentController {
  async handle(request: Request, response: Response) {
    const { tag_id, user_receiver, message } = request.body;

    const createComplimentService = new CreateComplimentService();

    const compliment = await createComplimentService.execute({
      tag_id,
      user_sender: request.user_id,
      user_receiver,
      message
    });

    return response.json(compliment);
  }
}

export { CreateComplimentController };
```

Fazer teste enviando `user_sender` no JSON

## Listar elogios - 47:25

`src/services/ListComplimentsBySenderService.ts`
```ts
import { getCustomRepository } from "typeorm"
import { ComplimentsRepositories } from "../repositories/ComplimentsRepositories"

class ListComplimentsBySenderService {
  async execute(user_id: string) {
    const complimentsRepositories = getCustomRepository(ComplimentsRepositories);

    const compliments = await complimentsRepositories.find({
      where: {
        user_sender: user_id
      },
    });

    return compliments;
  }
}

export { ListComplimentsBySenderService };
```

`src/services/ListComplimentsByReceiverService.ts`
```ts
import { getCustomRepository } from "typeorm"
import { ComplimentsRepositories } from "../repositories/ComplimentsRepositories"

class ListComplimentsByReceiverService {
  async execute(user_id: string) {
    const complimentsRepositories = getCustomRepository(ComplimentsRepositories);

    const compliments = await complimentsRepositories.find({
      where: {
        user_receiver: user_id
      },
    });

    return compliments;
  }
}

export { ListComplimentsByReceiverService };
```


`src/controllers/ListComplimentsBySenderController.ts`
```ts
import { Request, Response } from "express";
import { ListComplimentsBySenderService } from "../services/LisComplimentsBySenderService";

class ListComplimentsBySenderController {
  async handle(request: Request, response: Response) {
    const { user_id } = request
    const listComplimentsBySenderService = new ListComplimentsBySenderService();
    const compliments = await listComplimentsBySenderService.execute(user_id);

    return response.json(compliments);
  }
}

export { ListComplimentsBySenderController }
```


`src/controllers/ListComplimentsByReceiverController.ts`
```ts
import { Request, Response } from "express";
import { ListComplimentsByReceiverService } from "../services/ListComplimentsByReceiverService";

class ListComplimentsByReceiverController {
  async handle(request: Request, response: Response) {
    const { user_id } = request
    const listComplimentsByReceiverService = new ListComplimentsByReceiverService();
    const compliments = await listComplimentsByReceiverService.execute(user_id);

    return response.json(compliments);
  }
}

export { ListComplimentsByReceiverController }
```


`src/routes.ts`
```ts
// ...
router.get(
  "/users/compliments/send",
  ensureAuthentication,
  listComplimentsBySenderController.handle
);
router.get(
  "/users/compliments/receive",
  ensureAuthentication,
  listComplimentsByReceiverController.handle
);

//...
```

Testar com insomnia 57:10


## Obter relacionamentos - 58:30

`src/services/ListComplimentsByReceiverService.ts`:
```ts
	//...
    const compliments = await complimentsRepositories.find({
      where: {
        user_receiver: user_id
      },
      relations: ["userSender", "userReceiver", "tag"]
    });
	//...
```


## Listando as tags

`src/services/ListTagsService.ts`:
```ts
import { getCustomRepository } from "typeorm"
import { TagsRepositories } from "../repositories/TagRepositories"

class ListTagsService {
  async execute() {
    const tagsRepositories = getCustomRepository(TagsRepositories);
    const tags = await tagsRepositories.find();
    return tags;
  }
}

export { ListTagsService }
```

`src/controllers/ListTagsController.ts`:
```ts
import { Request, Response } from "express";
import { ListTagsService } from "../services/ListTagsService";

class ListTagsController {
  async handle(request: Request, response: Response) {
    const listTagsService = new ListTagsService();
    const tags = await listTagsService.execute();
    return response.json(tags);
  }
}

export { ListTagsController };
```

`src/routes.ts`:
```ts
router.get("/tags", ensureAuthentication, listTagsController.handle);
```

Teste com insomnia: 1:05:00

## Alterando uma classe: 1:06:00

```sh
yarn add class-transformer
```

`src/entities/Tag.ts`
```ts
import { Expose } from "class-transformer";
// ...

  @Expose({ name: "name_custom" })
  nameCustom(): string {
    return `#${this.name}`;
  }
// ...
// user name_custom
```

`src/services/ListTagsService.ts`
```ts
// ...
import { classToPlain } from "class-transformer";
// ...
    return classToPlain(tags);
// ...	
```

## Listar todos usuários

`src/services/ListUsersService.ts`
```ts
import { getCustomRepository } from "typeorm"
import { UserRepositories } from "../repositories/UserRepositories";

class ListUsersService {
  async execute() {
    const usersRepositories = getCustomRepository(UserRepositories);
    const users = await usersRepositories.find();
    return users;
  }
}

export { ListUsersService }
```

`src/controllers/ListUsersController.ts`
```ts
import { Request, Response } from "express";
import { ListUsersService } from "../services/ListUsersService";

class ListUserController {
  async handle(request: Request, response: Response) {
    const listUsersService = new ListUsersService();
    const users = await listUsersService.execute();
    return response.json(users);
  }
}

export { ListUserController };
```

`src/routes.ts`
```ts
router.get("/users", ensureAuthentication, listUsersController.handle);
```

### Ocultar a senha no response

`src/entities/User.ts`
```ts
// ...
import { Exclude } from "class-transformer";
// ...
  @Exclude()
  @Column()
  password: string;
//...
```

`src/services/ListUsersService.ts`
```ts
import { getCustomRepository } from "typeorm"
import { UserRepositories } from "../repositories/UserRepositories";
import { classToPlain } from "class-transformer";

class ListUsersService {
  async execute() {
    const usersRepositories = getCustomRepository(UserRepositories);
    const users = await usersRepositories.find();
    return classToPlain(users);
  }
}

export { ListUsersService }
```


## Teste com frontend: 1:24:25

Para testar com o frontend, instalar `cors` e `@types/cors -D`.

