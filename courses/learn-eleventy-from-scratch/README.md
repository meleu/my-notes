# Learn Eleventy from Scratch

- [[lesson-01]]
- [[lesson-02]]
- [[lesson-03]]
- [[lesson-04]]
- [[lesson-05]]
- [[lesson-06]]
- [[lesson-07]]


## Resumindo

### 1. Básico

```sh
# 1. instalar node:
# <https://github.com/nvm-sh/nvm#installing-and-updating>

# 2. criar diretório
mkdir eleventy-from-scratch
cd eleventy-from-scratch

# 3. download starter files
wget https://piccalilli.s3.eu-west-2.amazonaws.com/eleventy-from-scratch/eleventy-from-scratch-starter-files.zip
unzip *.zip
rm -rf *.zip __MACOSX/


# 4. git sutff
git init
curl -L https://gitignore.io/api/node,visualstudiocode,vim,linux,macos,sass,dotenv,windows > .gitignore

# 5. npm stuff
npm init -y
npm install @11ty/eleventy
```

6. adicionar "script.start" ao `package.json`:
```json
  "start": "npx eleventy --serve"
```

7. `.eleventy.js`:
```js
module.exports = config => {
  // copy static files from a dir to the `output` dir
  config.addPassthroughCopy('./src/images/');
  
  return {
    // use nunjucks as template engine
    markdownTemplateEngine: 'njk',
    dataTemplateEngine: 'njk',
    htmlTemplateEngine: 'njk',

    dir: {
      input: 'src',
      output: 'dist'
    }
  };
};
```

8. layouts:
  1. `src/_includes/layouts/base.html`
```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>{{ title }}</title>
  </head>
  <body>
    {% block content %}{% endblock %}
  </body>
</html>
```
  2. `src/_includes/layouts/home.html`
```html
{% extends "layouts/base.html" %}
{% block content %}
<article>
  <h1>{{ title }}</h1>
  {{ content | safe }}
</article>
{% endblock %}
```

9. `src/index.md`:
```md
---
title: 'Hello, world'
layout: 'layout/home.html'
---

This is pretty _rad_, isn't it?

```

10. launch it!
```sh
npm start
xdg-open http://localhost:8080/
```

