# Visual Studio Code
[✏️](https://github.com/meleu/my-notes/edit/master/vscode.md)

## debugar via VSCode

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

Ir nas configurações do vscode: `Ctrl+Shift+P` e digite `settings json`. E adicionar isso ao `settings.json`:
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
