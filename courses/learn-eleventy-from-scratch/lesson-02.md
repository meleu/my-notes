# Lesson 2 - Hello World

- <https://piccalil.li/course/learn-eleventy-from-scratch/lesson/2/>

## TL;DR

```
# 1. starting a node project and installing eleventy
npm init -y
npm install @11ty/eleventy

# 2. add "script.start" to the package.json
"start": "npx eleventy --serve"

# 3. .eleventy.js
module.exports = config => {
  return {
    dir: {
      input: 'src',
      output: 'dist'
    }
  };
};

# 4. Hello World
echo 'Hello, world!' > src/index.md
npm start
xdg-open https://localhost:8080/
```



## Eleventy Config file

`.eleventy.js`:
```js
module.exports = config => {
  return {
    dir: {
      input: 'src',
      output: 'dist'
    }
  };
};
```

We're exporting a function which returns some settings. These settings tell Eleventy to look in the `src` folder for all our content, templates and other source code, and tell it to use `dist` as the output folder.

The output will be folders and HTML pages (at the moment).


## Adding some dependencies

Initialize an npm project inside `eleventy-from-scratch` folder:

```sh
npm init -y
npm install @11ty/eleventy
```

Edit the `package.json`, replace the `"test": ...` part with
```
"start": "npx eleventy --serve"
```

## Hello, world

```sh
echo 'Hello, world!' > src/index.md

# npx eleventy --serve
npm start
```

Check <http://localhost:8080> in your browser.
