# NLW #6 - Aula 4

- <https://nextlevelweek.com/episodios/node/aula-4/edicao/6>


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
// 16:20
// 17:45
```

```sh
yarn typeorm migration:run
```

Adicionar coluna `password` em:

- `src/entities/User.ts` - 18:35
- `src/services/CreateUserService.ts` - 18:50 - 19:00
- `src/controllers/CreateUserController.ts` - 19:20

## Criptografia de senha - 22:50

`src/services/CreateUserService.ts`:
```ts
// 23:00
// 24:10 - 25:00
```

Testa criar um usuário via insomnia e confere no beekeeper se a senha está criptografada.

## Autenticação - 27:20

`src/services/AuthenticateUserService.ts`:
```ts
// 30:30
// 39:18
```

`src/controllers/AuthenticateUserController.ts`:
```ts
// 40:42
```


`src/routes.ts`:
```ts
// 41:35
```

Testar autenticação via insomnia - 41:40

## Tabela `compliments` - 44:55

```sh
yarn typeorm migration:create -n CreateCompliments
```

`src/migrations/*.CreateCompliments.ts`:
```ts
// 46:50
// 57:15
// 57:28
```

```sh
yarn typeorm migration:run
```

Checar no beekeeper se a tabela foi criada corretamente e se as chaves estrangeiras estão devidamente identificadas.

## Entidade - 58:40

`src/entities/Compliment.ts`:
```ts
// 1:01:15
// 1:06:30
```

## Repositório - 1:06:45

`src/repositories/ComplimentsRepositories.ts`
```ts
// 1:07:20
```


## Service - 1:07:30

`src/services/CreateComplimentService.ts`
```ts
// 1:12:50
// 1:15:20
```


## Controller - 1:16:00

`src/controllers/CreateComplimentController.ts`:
```ts
// 1:18:03
```

## Router - 1:18:05

`src/routes.ts`
```ts
// 1:18:50
```

Testar a aplicação e tentar criar um elogia via insomnia
```json
{
  "tag_id": ""
  "user_sender": ""
  "user_receiver": ""
  "message": ""
}
```

Conferir no beekeeper.

Outros testes:
- `user_sender === user_receiver` não pode 
- id inexistente
- tag inexistente

## Adendo

No `src/services/CreateUserService.ts`, definir um valor default para `admin` - 1:24:50.

Desta forma ao criar um usuário não precisa enviar `"admin": false` no JSON.

