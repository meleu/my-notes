# Lesson 3 - Nunjucks basics

- <https://piccalil.li/course/learn-eleventy-from-scratch/lesson/3/>

## TL;DR

```
# 1. supporting Nunjucks in .eleventy.js:
markdownTemplateEngine: 'njk',
dataTemplateEngine: 'njk',
htmlTemplateEngine: 'njk',

# 2. template layouts
mkdir -p src/_includes/layouts/
vim src/_includes/layouts/base.html
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

# 3. home layout
vim src/_includes/layouts/home.html
{% extends "layouts/base.html" %}
{% block content %}
<article>
  <h1>{{ title }}</h1>
  {{ content | safe }}
</article>
{% endblock %}

# 4. Hello, world. Using template layouts now:
vim src/index.md
---
title: 'Hello, world'
layout: 'layouts/home.html'
---

This is pretty _rad_, isn't it?


# 5. launch it
npm start
xdg-open http://localhost:8080
```


## Getting started with Nunjucks

Add these lines in the `.eleventy.js`:
```
markdownTemplateEngine: 'njk',
dataTemplateEngine: 'njk',
htmlTemplateEngine: 'njk',
```

We're telling Eleventy that markdown files, data files and HTML files should be processed by Nunjucks.

Now let's create a folder for the templates:
```sh
mkdir -p src/_includes/layouts
```

Inside that folder you've just created, add the file `base.html`:
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

This is the **base template**. All future templates will **extend** this one.

There are two areas of interest in that snippet:

1. The `{{ title }}` part prints the yet to be defined `title` variable on the page.
2. The `{% block content %}{% endblock %}` area lets us create a named placeholder. If a template that extends `base.html` also puts content inside a `{% block content %}{% endblock %}`, it will render inside that block on `base.html`. This is handy for complex templates, because you can set as many `{% block %}` elements as you like.

> One handy thing we can do with a [Nunjucks block](https://mozilla.github.io/nunjucks/templating.html#block) is to populate with a placeholder content:
> ```html
> {% block content %}
> <p>
>  Placeholder that will render if a template doesn't define a block.
> </p>
> {% endblock %}
> ```
> Usefor for generating `<title>` elements - or anything else - while we're still figuring out the content but we want to make sure there's something in place in the meantime.

`src/_includes/layouts/home.html`:
```html
{% extends "layouts/base.html" %}
{% block content %}
<article>
  <h1>{{ title }}</h1>
  {{ content | safe }}
</article>
{% endblock %}
```

The `{{ content | safe }}`  makes the `content` be converted to HTML ans use a [filter](https://mozilla.github.io/nunjucks/templating.html#filters) with `safe`.

In Nunjucks we have something called [autoescaping](https://mozilla.github.io/nunjucks/templating.html#autoescaping) turned on, which protect us agains cross-site scripting.

Without the `safe` filter, the HTML would be automatically *escaped* to keep our site safe.

Adding the `safe` filter to our content marks it as a safe and allows to render on the page.

 
## Assigning our template to our page

`src/index.md`:
```md
---
title: 'Hello, world'
layout: 'layouts/home.html'
---

This is pretty _rad_, isn't it?

```


Test it:
```sh
npm start
```

Access <http://localhost:8080>

