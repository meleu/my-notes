# First ReactJS Project

## Starting From Scratch

```
yarn create react-app modulo05
cd modulo05
```

In `package.json` delete the `eslintConfig` property.

Removing PWA stuff in `public`:

- `manifest.json`.
- In `index.html`, remove the line:
```html
<link rel="manifest" href="%PUBLIC_URL%/manifest.json" />
```

Removing other files from `src` that we're going to create from scratch:

- `serviceWorker.js`
- `App.css`
- `App.test.js`
- `index.css`
- `logo.svg`

In `src/index.js`, delete the lines importing the `.css` and `servicWorker`, also the `serviceWorker.unregister()`.

In `src/App.js`, delete the lines importing the logo and the `.css`. Also delete everything between `<header>...</header>`. Put a `<h1>Hello World</h1>` as a placeholder.


## ESLint, Prettier and EditorConfig

`.editorconfig`:
```
root = true

[*]
end_of_line = lf
indent_style = space
indent_size = 2
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
```

```
yarn add eslint prettier eslint-config-prettier eslint-plugin-prettier babel-eslint -D
yarn eslint --init
```

During the init, choose:

- check syntax, find problems and enforce code style
- JavaScript modules (import/export)
- Framework: React
- Browser
- Use a popular style guide
- Airbnb
- config file to be in JavaScript
- Downgrade yes
- accept installation with npm

Delete the `package-lock.json` and run `yarn`.

In the `.eslintrc.js`
```js
//...
extends: [
  'airbnb',
  'prettier',
  'prettier/react'
],
//...
parser: 'babel-eslint',
// parserOptions ...
plugins: [
  'react',
  'prettier'
],
rules: {
  'prettier/prettier': 'error',
  'react/jsx-filename-extension': [
    'warn',
    { etensions: ['.jsx', '.js'] }
  ],
  'import/prefer-default-export': 'off'
}
```

Create `.prettierrc`:
```json
{
  "singleQuote": true,
  "trailingComma": "es5"
}
```

## Routing

```
yarn add react-router-dom
```

Create `src/pages/Main/index.js`:
```js
import React from 'react';

function Main() {
  return <h1>Main</h1>
}

export default Main;
```

Create `src/pages/Repository/index.js`:
```js
import React from 'react';

function Repository() {
  return <h1>Repository</h1>
}

export default Repository;
```

Create `src/routes.js`:
```js
import React from 'react';
import { BrowserRouter, Switch, Route } from 'react-router-dom';

import Main from './pages/Main';
import Repository from './pages/Repository';

export default function Routes() {
  return (
    <BrowserRouter>
      <Switch>
        <Route path="/" exact component={Main} />
        <Route path="/repository" component={Repository} />
      </Switch>
    </BrowserRouter>
  );
}
```

Now import and use it in `src/App.js`:
```js
import React from 'react';

import Routes from './routes';

function App() {
  return <Routes />;
}

export default App;
```

Test those routes with
```
yarn start
```

## Styled Components

Styled components allow us to write CSS in JS, nest styles, access component properties, and more...

```
yarn add styled-components
```

Install `vscode-styled-components` to have syntax highlighting and IntelliSense for css content inside a `.js` file.


Create `src/pages/Main/styles.js`:
```js
import styled from 'styled-components';

export const Title = styled.h1`
  // you can write css in js (and use comments)
  font-size: 24px;

  // access properties
  color: ${props => (props.error ? 'red' : '#7159c1')};
  font-family: Arial, Helvetica, sans-serif;

  // nesting styles
  small {
    font-size: 14px;
    color: #333;
  }
`;
```

And in your `src/pages/Main/index.js`:
```js
import React from 'react';

import { Title } from './styles';

export default function Main() {
  return (
    <Title error>
      meleu
      <small>menor</small>
    </Title>
  );
}
```

## Global Styles

Create `src/styles/global.js`:
```js
import { createGlobalStyle } from 'styled-components';

export default createGlobalStyle`
  * {
    margin: 0;
    padding: 0;
    outline: 0;
    box-sizing: border-box;
  }

  html, body, #root {
    min-height: 100%;
  }

  body {
    background: #7159c1;
    -webkit-font-smoothing: antialiased !important;
  }

  body, input, button {
    color: #222;
    font-size: 14px;
    font-family: Arial, Helvetica, sans-serif;
  }

  button {
    cursor: pointer;
  }
`;
```


In `src/App.js`:
```js
import React from 'react';

import Routes from './routes';
import GlobalStyle from './styles/global';

function App() {
  return (
    <>
      <Routes />
      <GlobalStyle />
    </>
  );
}

export default App;
```

Make `src/pages/Main/styles.js` to be simply:
```js
import styled from 'styled-components';

export const Title = styled.h1`
  color: #fff;
`;
```


And `src/pages/Main/index.js` just:
```js
import React from 'react';

import { Title } from './styles';

export default function Main() {
  return <Title>Hello World</Title>;
}
```

And go see how it looks (use `yarn start` if necessary).


## Developing an Application

```
yarn add react-icons
```

In `src/pages/Main/index.js`:
```js
import React, { Component } from 'react';
import { FaGithubAlt, FaPlus } from 'react-icons/fa';

import { Container, Form, SubmitButton } from './styles';

export default class Main extends Component {
  state = {
    newRepo: '',
  };

  handleInputChange = (e) => {
    this.setState({ newRepo: e.target.value });
  };

  handleSubmit = (e) => {
    e.preventDefault();

    console.log(this.state.newRepo);
  };

  render() {
    const { newRepo } = this.state;

    return (
      <Container>
        <h1>
          <FaGithubAlt />
          Repositórios
        </h1>

        <Form onSubmit={this.handleSubmit}>
          <input
            type="text"
            placeholder="Adicionar repositório"
            value={newRepo}
            onChange={this.handleInputChange}
          />

          <SubmitButton>
            <FaPlus color="#FFF" size={14} />
          </SubmitButton>
        </Form>
      </Container>
    );
  }
}
```

In `src/pages/Main/styles.js`:
```js
import styled from 'styled-components';

export const Title = styled.div`
  max-width: 700px;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
  padding: 30px;
  margin: 80px auto;

  h1 {
    font-size: 20px;
    display: flex;
    flex-direction: row;
    align-items: center;

    svg {
      margin-right: 10px;
    }
  }
`;

export const Form = styled.form`
  margin-top: 30px;
  display: flex;
  flex-direction: row;

  input: {
    flex: 1;
    border: 1px solid #eee;
    padding: 10px 15px;
    border-radius: 4px;
    font-size: 16px;
  }
`;

export const SubmitButton = styled.button.attrs({
  type: 'submit',
})`
  background: #7159c1;
  border: 0;
  padding: 0 15px;
  margin-left: 10px;
  border-radius: 4px;

  display: flex;
  justify-content: center;
  align-items: center;
`;
```

### Adding repositories

Install axios:
```
yarn add axios
```

Create `src/services/api.js`:
```js
import axios from 'axios';

const api = axios.create({
  baseURL: 'https://api.github.com',
});

export default api;
```

In the `src/pages/Main/index.js`:
```js
import React, { Component } from 'react';
import { FaGithubAlt, FaPlus, FaSpinner } from 'react-icons/fa';

import api from '../../services/api';
import { Container, Form, SubmitButton } from './styles';

export default class Main extends Component {
  state = {
    newRepo: '',
    repositories: [],
    loading: false,
  };

  handleInputChange = (e) => {
    this.setState({ newRepo: e.target.value });
  };

  handleSubmit = async (e) => {
    e.preventDefault();

    this.setState({ loading: true });

    const { newRepo, repositories } = this.state;

    const response = await api.get(`/repos/${newRepo}`);

    const data = {
      name: response.data.full_name,
    };

    this.setState({
      repositories: [...repositories, data],
      newRepo: '',
      loading: false,
    });
  };

  render() {
    const { newRepo, loading } = this.state;

    return (
      <Container>
        <h1>
          <FaGithubAlt />
          Repositórios
        </h1>

        <Form onSubmit={this.handleSubmit}>
          <input
            type="text"
            placeholder="Adicionar repositório"
            value={newRepo}
            onChange={this.handleInputChange}
          />

          <SubmitButton loading={loading}>
            {loading ? (
              <FaSpinner color="#FFF" size={14} />
            ) : (
                <FaPlus color="#FFF" size={14} />
              )}
          </SubmitButton>
        </Form>
      </Container>
    );
  }
}
```

Add this to the `src/pages/Main/styles.js`:
```css
import styled, { keyframes, css } from 'styled-components';


// add this before SubmitButton
const rotate = keyframes`
  from {
    transform: rotate(0deg);
  }

  to {
    transform: rotate(360deg);
  }
`;


// add 'disabled' in SubmitButton signature:
export const SubmitButton = styled.button.attrs((props) => ({
  type: 'submit',
  disabled: props.loading,
}))`

  // ...

  &[disabled] {
    cursor: not-allowed;
    opacity: 0.6;
  }

  ${(props) =>
    props.loading &&
    css`
      svg {
        animation: ${rotate} 2s linear infinite;
      }
    `}
`;
```

### Listing repositories


