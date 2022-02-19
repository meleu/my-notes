# Lesson 5 - Passthrough basics

## Adding passthrough

Add this to `.eleventy.js`, right below `module.exports = config => {` (therefore, before the `return`):
```js
config.addPassthroughCopy('./src/images/');
```

This is used to pass contents from `input` dir to the `output` dir.

