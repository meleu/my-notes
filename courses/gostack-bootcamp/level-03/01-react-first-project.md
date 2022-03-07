# React - First Project

## Starting the Project

- video: <https://app.rocketseat.com.br/node/nivel-03/group/estrutura-e-padroes-1/lesson/criando-projeto-5>
- figma layout: <https://www.figma.com/file/HOCmxfrElzLpI75LdzFLia/Github-Explorer?node-id=0%3A1>

```
npx create-react-app project-name --template=typescript
cd project-name
rm README.md
cd src
rm App.css App.test.tsx index.css logo.svg serviceWorker.ts
# remove the references to the deleted files in index.tsx and App.tsx
# write an React.FC with a 'Hello World' in the App.tsx
cd ../public
rm favicon.ico logo192.png logo512.png manifest.json
# remove the references to the deleted files in index.html
```

`public/index.html`:
```html
<meta name="theme-color" content="#3a3a3a" />
<title>GitHub Explorer</title>
```

## Editor Config

```txt
root = true

[*]
indent_style = space
indent_size = 2
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
end_of_line = lf
```

## ESLint

- instructions: <https://www.notion.so/ESLint-7e455a7ac78b424892329ee064feaf99#c76fc9ceba6d4944a80c134aa16c61c5>

Assuming the project was created with `create-react-app`.

In the `package.json` **REMOVE** this part:
```json
"eslintConfig": {
  "extends": "react-app"
},
```

Install eslint and initialize it:
```
yarn add eslint
yarn eslint --init
# 1. To check syntax, find problems and enforce code style
# 2. JavaScript modules (impot/export)
# 3. React
# 4. (use TypeScript?) Yes
# 5. (mark only Browser with space bar and then Enter)
# 6. Use a popular style guide
# 7. Airbnb
# 8. JSON
# 9. (install with npm?) No

# copy the packages shown on the question 9 except 'eslint@^5.16.0 || ^6.8.0'
# because we already have it, and remove 1.7.0 from
# 'eslint-plugin-react-hooks@^2.5.0 || ^1.7.0'. The command will become like this:
yarn add eslint-plugin-react@^7.19.0 @typescript-eslint/eslint-plugin@latest eslint-config-airbnb@latest eslint-plugin-import@^2.20.1 eslint-plugin-jsx-a11y@^6.2.3 eslint-plugin-react-hooks@^2.5.0 @typescript-eslint/parser@latest -D

# making ReactJS undertand TypeScrpt
yarn add eslint-import-resolver-typescript -D
```

Create the `.eslingignore` file:
```
**/*.js
node_modules
build
/src/react-app-env.d.ts
```

Edit `.eslintrc.json`:
```json
{
  // ...
  "extends": [
    "plugin:react/recommended"
    // ...
    "plugin:@typescript-eslint/recommended"
  ],
  // ...
  "plugins": [
    // ...
    "react-hooks",
    "@typescript-eslint"
  ],
  "rules": {
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn",
    "import/prefer-default-export": "off",
    "import/extensions": [
      "error",
      "ignorePackages",
      {
        "ts": "never",
        "tsx": "never"
      }
    ]
  },
  // ...
  "settings": {
    "import/resolver": {
      "typescript": {}
    }
  }
  // ...
}
```

**Note**: if you're facing a warning like `'React' was used before it was defined`, add this to the `.eslintrc.json`:
```json
"rules": {
  // ...
  "no-use-before-define": "off",
  // ...
},
```
### Prettier

It's the same for NodeJS, ReactJS and React Native.

```
yarn add prettier eslint-config-prettier eslint-plugin-prettier -D
```

Edit the `.eslintrc.json`:
```json
{
  // ...
  "extends": [
    "prettier/@typescript-eslint",
    "plugin:prettier/recommended",
  ],
  // ...
  "plugins": [
    // ...
    "prettier"
  ],
  "rules": {
    // ...
    "prettier/prettier": "error"
  },
  // ...
}
```

#### Solving conflicts between ESLint and Prettier.

`prettier.config.js`
```js
module.exports = {
  singleQuote: true,
  trailingComma: 'es5',
  arrowParens: 'avoid',
}
```

`.eslintignore`:
```
# ...
/*.js
```

Restart VS Code.

## Creating Routes

- video: <https://app.rocketseat.com.br/node/nivel-03/group/criando-a-aplicacao/lesson/criando-rotas-1>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/a76ec299c913f1b6287cacc9f85f4a23c8037d43#diff-d67efd4422e8d3b452172c2fce767185>

```
yarn add react-router-dom
yarn add -D @types/react-router-dom
```

1. `App.tsx`:
```tsx
<BrowserRouter>
  <Routes>
</BrowserRouter>
```

2. `routes/index.tsx`:
```tsx
<Switch>
  <Route path="/" exact component={Dashboard} />
  <Route path="/repositories" component={Repository} />
</Switch>
```

3. Create the `pages/*.tsx`

---

Short way to declare the type a React's function component: `React.FC`.
```tsx
import React from 'react';

const Dashboard: React.FC = () => <h1>Dashboard</h1>;

export default Dashboard;
```

Why using `<Switch>` as a parent of `<Route>`s?
To render only the first child `<Route>` that matches the location.

**Note**: `<Switch>` must be used inside a Router (such as `<BrowserRouter>`).

Use `exact` to match the exact route. Example:
```tsx
<Route path="/" exact component={Dashboard} />
```

## Using Styled Components

- video: <https://app.rocketseat.com.br/node/nivel-03/group/criando-a-aplicacao/lesson/utilizando-styled-components>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/7afdc0a458bdc36cb2296ad972de691b0c1a2aae#diff-d67efd4422e8d3b452172c2fce767185>
- asset: <https://xesque.rocketseat.dev/platform/1587379725719-attachment.svg>

**Why styled-components?**

Styled components is a way to create a React component with the styles attached to it.

From the [styled-component docs](https://styled-components.com/docs/basics#getting-started):

> It removes the mapping between components and styles. This means that when you're defining your styles, you're actually creating a normal React component, that has your styles attached to it.

Don't forget: a styled component **is** a React component (therefore you can pass props to it).

```
yarn add styled-components
yarn add -D styled-components
```

Install the VS Code plugin: vscode-styled-components. It helps with the intellisense.

Styled components allows you to use css inside the JavaScript:
```ts
import styled from 'styled-components';

export const Title = styled.h1`
  font-size: 48px;
  color: #3a3a3a;
`;
```

For global styling use `createGlobaStyle`, link in this `src/styles/globals.ts`:
```tsx
import { createGlobalStyle } from 'styled-components';

export default createGlobalStyle`
  * {
    margin: 0;
    padding: 0;
    outline: 0;
    box-sizing: border-box;
  }

  body {
    background: #f0f0f5;
  }
`;
```



## Styling the Dashboard

- video: <https://app.rocketseat.com.br/node/nivel-03/group/criando-a-aplicacao/lesson/estilizando-dashboard>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/5592050304995c925d5ed66e3452e341f46e334d#diff-d67efd4422e8d3b452172c2fce767185>
- asset: <https://xesque.rocketseat.dev/platform/1587379765556-attachment.svg>

Styled components accept CSS preprocessing. Example:
```ts
export const Form = styled.form`
  button {
    background: #333
    /* ... */

    &:hover {
      background: #111;
    }
  }
```

`&` meaning the current element (in the example above it's the `button`).

One more lib for writing styles in JavaScript:
```
yarn add polished
yarn add react-icons
```

In this example we're going to use the `shade()` method:
```ts
background: ${shade(0.2, '#444')};
```

Use `transition` so the background can change smoothly:
```css
transition: background-color 0.2s;
```





## Connecting the API

- video: <https://app.rocketseat.com.br/node/nivel-03/group/criando-a-aplicacao/lesson/conectando-a-api>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/f7fc18a1f671e51262976cd75e289598effe55af#diff-d67efd4422e8d3b452172c2fce767185>

```
yarn add axios
```

`src/services/api.ts`:
```ts
import axios from 'axios';

const api = axios.create({
  baseURL: 'https://api.github.com'
});

export default api;
```



## Handling Errors

- video: <https://app.rocketseat.com.br/node/nivel-03/group/criando-a-aplicacao/lesson/lidando-com-erros-3>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/cc909a498ee00717ce2d1923ae4ad104606b4e36#diff-d67efd4422e8d3b452172c2fce767185>

Accessing `props` inside the styles. Example:

In the `Form`'s client:
```tsx
<Form hasError={!!inputError}>
  //...
</Form>
```

In the `Form`'s code:
```ts
import styled, { css } from 'styled-components';

interface FormProps {
  hasError: boolean;
}

export const Form = styled.form<FormProps>`
  input {
    ${(props) => props.hasError && css`
      border-color: #c53030;
    `}
  }
`
```



## Saving Data in the localStorage

- video: <https://app.rocketseat.com.br/node/nivel-03/group/criando-a-aplicacao/lesson/salvando-no-storage-3>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/81ab10301b8c891ad1ea41336fe70117fb587127#diff-d67efd4422e8d3b452172c2fce767185>

```tsx
const [repositories, setRepositories] = useState<Repository[]>(() => {
  const storedRepositories = localStorage.getItem(
    '@GithubExplorer:repositories',
  );

  if (storedRepositories) {
    return JSON.parse(storedRepositories);
  } else {
    return [];
  }
});

useEffect(() => {
  localStorage.setItem(
    '@GithubExplorer:repositories',
    JSON.stringify(repositories)
  );
}, [repositories]);
```


## Browsing Between Routes

- video: <https://app.rocketseat.com.br/node/nivel-03/group/criando-a-aplicacao/lesson/navegando-entre-rotas>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/05b1b84cedb3aaffbd393a64cf978e219a6de186#diff-d67efd4422e8d3b452172c2fce767185>

Using `Link` from `react-router-dom`. It's just replacing `a` with `Link` and `href` with `to`.

In order to get everything after the route as a route param, use the `+` sign, like this: `path="/repositories/:repository+`.

Disable `react/jsx-one-expression-per-line` when there are text a variables in the same line (it confuses the eslint).


## Styling Details

- video: <https://app.rocketseat.com.br/node/nivel-03/group/criando-a-aplicacao/lesson/estilizando-detalhe>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/884765b06582045179e6cccf0c3fa671ca3e18ae#diff-d67efd4422e8d3b452172c2fce767185>

Tip: avoid to style more than two children of an element/component.


## Listing Issues

- video: <https://app.rocketseat.com.br/node/nivel-03/group/criando-a-aplicacao/lesson/listando-issues-da-api>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/tree/master/nivel-03/01-primeiro-projeto-com-react>

In the video it's shown how useful it is to have the eslint plugin `react-hooks`.

`.eslintrc.json`:
```
"plugins": [
  "react-hooks"
],
"rules": {
  "rect-hooks/exhaustive-deps": "warn"
}
```

There's an useful tip about how beneficial it is to use `.then()` instead of `async-await`. Multiple calls with `.then()` allows the functions to run in parallel (asynchronously), improving the perceived speed.

Optional chaining: instead of `repository && repository.owner`, use `repository?.owner`.

