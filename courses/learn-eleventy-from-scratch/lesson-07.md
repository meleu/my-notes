# Lesson 7 - Data basics

`src/_data/site.json`:
```json
{
  "name": "Issue 33",
  "url": "https://meleu.github.io/eleventy-from-scratch"
}
```

In `src/_includes/partials/site-head.html`, replace the `aria-label="Issue 33 - home"` with `aria-label="{{ site.name }} - home"`.



## Wiring up our navigation

`src/_data/navigation.json`:
```json
{
  "items": [
    {
      "text": "Home",
      "url": "/"
    },
    {
      "text": "About",
      "url": "/about-us/"
    },
    {
      "text": "Work",
      "url": "/work/"
    },
    {
      "text": "Blog",
      "url": "/blog/"
    },
    {
      "text": "Contact",
      "url": "/contact/"
    }
  ]
}
```

In `src/_includes/partials/site-head.html`, replace everything inside the `<ul class="nav__list">` element with this:

```html
<ul class="nav__list">
  {% for item in navigation.items %}
  <li>
    <a href="{{ item.url }}">{{ item.text }}</a>
  </li>
  {% endfor %}
</ul>
```


Create `src/_data/helpers.js`:
```js
module.exports = {
  /**
  Returns back some attributes based on whether the
  link is active or a parent of an active item.
  
  @param {String} itemUrl The link in question
  @param {String} pageUrl The page context
  @returns {String} The attributes or empty
  */
  getLinkActiveState(itemUrl, pageUrl) {
    let response = '';
    
    if (itemUrl === pageUrl) {
      response = ' aria-current="page"';
    }
    
    if (itemUrl.length > 1 && pageUrl.indexOf(itemUrl) === 0) {
      response += ' data-state="active"';
    }
    
    return response;
  }
}
```

Again in `src/_includes/partials/site-head.html`, inside that same `<ul>` element:
```html
{% for item in navigation.items %}
<li>
  <a href="{{ item.url }}" {{ helpers.getLinkActiveState(item.url, page.url) | safe }}
</li>
{% endfor %}
```

> **FYI**
> Eleventy also provides global data. A good example is the `page` item. Documentation [here](https://www.11ty.dev/docs/data-eleventy-supplied/#page-variable-contents)


## Cascading data

Create `src/_data/cta.json`:
```json
{
  "title": "Get in touch if we seem like a good fit",
  "summary": "Vestibulum id ligula porta felis euismod semper. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Donec ullamcorper nulla non metus auctor fringilla.",
  "buttonText": "Start a new project",
  "buttonUrl": "/contact/"
}
```

Create `src/_includes/partials/cta.html`:
```html
{% set ctaPrefix = cta %}

{% if ctaContent %} 
  {% set ctaPrefix = ctaContent %}
{% endif %}

<article class="[ cta ] [ dot-shadow panel ] [ bg-dark-shade color-light ]">
  <div class="wrapper">
    <div class="[ cta__inner ] [ flow ]">
      <h2 class="[ cta__heading ] [ headline ]" data-highlight="quaternary">{{ ctaPrefix.title }}</h2>
      <p class="[ cta__summary ] [ measure-short ]">{{ ctaPrefix.summary }}</p>
      <div class="cta__action">
        <a class="button" data-variant="ghost" href="{{ ctaPrefix.buttonUrl }}">{{ ctaPrefix.buttonText }}</a>
      </div>
    </div>
  </div>
</article>
```

What we’re doing in this example is pulling that content from `cta.json`, by setting `ctaPrefix` as `cta`. We do this [using the Nunjucks `{% set %}` feature](https://mozilla.github.io/nunjucks/templating.html#set) that lets us create variables.

Then what we do is check to see if `ctaContent` is defined. If it is: we override the `ctaPrefix` with that variable.

Why would we do that though? We do it because we might want to override that content on a **per-instance basis**.

For example, on the home page, there are two calls to action. One is the global one, that appears on every page, and the other is something that only appears on our home page.

To make this happen, we create two references to our partial. For one of them, we want to use the global content from `cta.json`, but for the other one, we’ll set the content in our Front Matter.

In `src/_includes/layouts/home.html`, after the `</article>`:

```html
{% set ctaContent = primaryCTA %}
{% include "partials/cta.html" %}

{% set ctaContent = cta %}
{% include "partials/cta.html" %}
```

In `src/index.md`, add this to the front matter:
```yaml
primaryCTA:
  title: 'This is an agency that doesn’t actually exist'
  summary: 'This is the project site you build when you take the “Learn Eleventy From Scratch” course so it is all made up as a pretend context. You will learn a lot about Eleventy by building this site though. Take the course today!'
  buttonText: 'Buy a copy'
  buttonUrl: 'https://piccalil.li/course/learn-eleventy-from-scratch/'
```



