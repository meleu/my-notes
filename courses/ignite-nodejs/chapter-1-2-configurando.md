# Chapter 1: Configurando o Projeto

## Estrutura do projeto

- instalar o node, preferencialmente via nvm (node version manager)
- instalar yarn
- instalar VS Code
- instalar o insomnia


```sh
mkdir fundamentos-nodejs
cd fundamentos-nodejs
yarn init -y
yarn add express
yarn add nodemon -D
mkdir src
```

- criar um src/index.js com um hello world
- editar o `package.json`
```json
"scripts": {
  "dev": "nodemon src/index.js"
}
```

- criar uma rota para cada verbo http:
    - `.get`
    - `.post`
    - `.put`
    - `.patch`
    - `.delete`

- 4 tipos de parâmetros:
    - route params: `request.params`
    - query params: `request.query`
        - `request.query.key: 'value'`
    - body params: `request.body`
        - normalmente usamos JSON e pra isso precisamos usar o middleware `app.use(express.json())`
    - header params: `request.headers`
    
