# NLW #6 - Aula 1

## Descrição do Projeto - 11:50

**NLW Valoriza**

- Cadastro de usuários

- Cadastro de tags (elogios possíveis)
    - Somente usuário administrador

- Cadastro de elogios
    - ID do usuário a receber elogios
    - ID do usuário que está enviando o elogio
    - ID da tag
    - Data de criação

- Autenticação de usuário
    - Gerar token JWT
    - Validar usuário logado nas rotas necessárias

- Listagem de usuários
- Listagem de tags
- Listagem de elogios por usuário


> ideia:
> - implementar algo similar para achievement creators
> - somente users com mais de 1000 points podem elogiar


## Ferramentas

- <https://www.notion.so/Mission-Node-js-a25b063cc195465180563951d03e2459>
- insomnia
- bekeeper studio


## Primeiro Projeto 51:35

```sh
mkdir nlwValoriza
cd nlwValoriza
yarn init -y
yarn add typescript -D
yarn tsc --init
```

editar `tsconfig.json`
```json
{
  // ...
  "strict": false,
  // ...
}
```

instalando ExpressJS e outros
```sh
yarn add express
yarn add @types/express ts-node-dev -D

mkdir src
cd src
touch server.ts
```

adicionar ao `package.json`:
```json
{
  // ...
  "scripts": {
    "dev": "ts-node-dev src/server.ts"
  },
  // ...
}
```

- 1:10:20 - Hello World do Express (NOTA: lembrar de colocar o `return response.send()`
- 1:12:50 - Básico de utilização do insomnia

