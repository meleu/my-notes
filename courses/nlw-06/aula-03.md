# NLW #6 - Aula 3

- <https://nextlevelweek.com/episodios/node/aula-3/edicao/6>



## Tratamento de Exceções - 5:10

Adicionando um middleware de tratamento de erro no `server.ts`.

```sh
yarn add express-async-errors
```

`src/server.ts`:
```ts
//...

import "express-async-errors"

// 15:50
```

## Migration de tags - 18:45

```sh
yarn typeorm migration:create -n CreateTags
```

`src/database/migrations/*CreateTags.ts`:
```ts
// 21:05
// 21:25
```

```sh
yarn typeorm migration:run
```

## Entity de tags - 22:35

`src/entities/Tag.ts`
```ts
// 26:00
```

## Repositório de tags - 26:15

`src/repositories/TagsRepositories.ts`
```ts
// 28:25
```

## Service de tags - 28:30

`src/services/CreateTagService.ts`:
```ts

```