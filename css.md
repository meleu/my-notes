# CSS
[✏️](https://github.com/meleu/my-notes/edit/master/css.md)

## smooth scrolling

```css
scroll-behavior: smooth;
```

## CSS variables

From <https://www.w3schools.com/css/css3_variables.asp>

> Variables in CSS should be declared within a CSS selector that defines its scope. For a global scope you can use either the `:root` or the `body` selector.
> 
> The variable name must begin with two dashes (--) and is case sensitive!
> 
> The syntax of the var() function is as follows:
>
> `var(custom-name, value)`
> - `custom-name`: Required. The custom property's name (must start with two dashes)
> - `value`: Optional. The fallback value (used if the custom property is invalid)


## flexbox way to position something in the center of the screen

```css
html, body, #container {
  height: 100vh;
}

#container {
  display: flex;
  align-items: center;
  justify-content: center;
}
```
