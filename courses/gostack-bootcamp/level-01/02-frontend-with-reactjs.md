# Front-end With ReactJS

## Concepts

- video: <https://app.rocketseat.com.br/node/front-end-com-react-js/lesson/conceitos-react-js>

### Declarative vs Imperative programming

### babel / webpack

<!-- anki -->

**babel**: Transpile React code into something the browser can understand.

**webpack**: Convert each file type (.js, .png, .css) into something different. That's what allows us to use `import icon from './img/icon.png'`, for example.

**loaders**: babel-loader, css-loader, image-loader


## Starting A React Project From Scratch

```sh
mkdir frontend
cd frontend
yarn init -y
mkdir src public
yarn add react react-dom
yarn add @babel/core @babel/preset-env @babel/preset-react babel-loader webpack
yarn add @babel/cli @babel/plugin-transform-runtime webpack-cli webpack-dev-server -D
```

### Configuring babel

- video: <https://app.rocketseat.com.br/node/front-end-com-react-js/lesson/configurando-babel-1>

`babel.config.js`:
```js
module.exports = {
  presets: [
    '@babel/preset-env',
    '@babel/preset-react'
  ],
  plugins: [
    '@babel/plugin-transform-runtime'
  ]
};
```

### Configuring webpack

- video: <https://app.rocketseat.com.br/node/front-end-com-react-js/lesson/configurando-webpack-1>

`webpack.config.js`:
```js
const path = require('path');

module.exports = {
  entry: path.resolve(__dirname, 'src', 'index.js'),
  output: {
    path: path.resolve(__dirname, 'public'),
    filename: 'bundle.js'
  },
  devServer: {
    contentBase: path.resolve(__dirname, 'public'),
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
        }
      }
    ]
  },
};
```

### Source files

- video: <https://app.rocketseat.com.br/node/front-end-com-react-js/lesson/componentizacao-1>

`public/index.html`:
```html
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>ReactJS</title>
</head>

<body>
  <div id="app"></div>

  <script src="bundle.js"></script>
</body>

</html>
```

Creating an `App` component in `src/App.js`:
```js
import React from 'react';

function App() {
  return <h1>Hello GoStack!</h1>;
}

export default App;
```

`src/index.js`:
```js
import React from 'react';
import { render } from 'react-dom';

import App from './App';

render(<App />, document.getElementById('app'));
```

## Properties

- video: <https://app.rocketseat.com.br/node/front-end-com-react-js/lesson/propriedades-1>

In React, only parent elements can pass properties to their children.

Example of `App` passing properties to the `Header` component:
```js
// snippet of src/App.js
function App() {
  return (
    <Header title="Homepage">
      <ul>
        <li>Homepage</li>
        <li>Projects</li>
        <li>About</li>
      </ul>
    </Header>
  );
}
```

In the `Header` component we can access `title` and its children elements, like this:
```js
// snippet of src/Header.js
function Header({ title, children }) { // children is autmatically created by React
  return (
    <header>
      <h1>{title}</h1>
      {children}
    </header>
  );
}
```

## State and Immutability

- video: <https://app.rocketseat.com.br/node/front-end-com-react-js/lesson/estado-e-imutabilidade-1>

**Note**: when there's an iteration in a React component, the top-level element must have a `key` attribute.

In order to use states, it's necessary to import `useState`:
```js
import React, { useState } from 'react';
//...
  const something = useState('');
```

`useState()` returns an array with 2 elements. The first one is the value, and the second one is the function to change that value.

Usually they're obtained with the destructuring method:
```js
  const [ something, setSomething ] = useState('');
```

Changing `something` directly won't bring the expected result, you must use `setSomething()` instead.

By using the `setSomething()`, it makes the React re-render the component.


## Importing CSS and Images

- video: <https://app.rocketseat.com.br/node/front-end-com-react-js/lesson/importando-css-e-imagens>

To allow things like this:
```js
import './App.css';
import backgroundImage from './assets/background.jpeg';
```

Install:
```
yarn add style-loader css-loader file-loader -D
```

Add the following rules to the `webpack.config.js`:
```js
  module: {
    rules: [
			// ...
      {
        test: /\.css$/,
        exclude: /node_modules/,
        use: [
          { loader: 'style-loader' },
          { loader: 'css-loader' },
        ]
      },
      {
        test: /\.(gif|png|jpe?g)$/i,
        use: {
          loader: 'file-loader'
        }
      }
    ]
  }
  // ...
```

**Tip**: for `package.json`:
```json
  "scripts": {
    "dev": "webpack-dev-server --mode development",
    "build": "webpack --mode production"
  }
```

## `useEffect()`

The React's `useEffect()` allows you to trigger a function. It takes two arguments, the first one is the function to be triggered, the second one is when such function should be triggered.

Example:
```js
  useEffect(someFunction, [variable]);
```

In the example above `somefunction()` is triggered everytime `variable` is changed. If the second argument is an empty array, it'll trigger the function everytime the component is rendered.
