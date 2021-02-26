# React
[✏️](https://github.com/meleu/my-notes/edit/master/react.md)

## Notes about "The Beginner's Guide to React"

- link: <https://egghead.io/courses/the-beginner-s-guide-to-react>

- source code: <https://github.com/kentcdodds/beginners-guide-to-react/tree/egghead>

- <unpkg.com> is an useful way to use individual npm packages.

- importing `react` and `react-dom`:
```html
  <script src="https://unpkg.com/react@16.12.0/umd/react.development.js"></script>
  <script src="https://unpkg.com/react-dom@16.12.0/umd/react-dom.development.js"></script>
```

- `React.createElement()` is like a more practical way to do `document.createElement()`.

- `ReactDOM.render(element, rootElement)` is like a more practical way to do `rootElement.appendChild(element)`.

- [Babel](https://babeljs.io/) is a JavaScript compiler. It allows us to use JSX, which gives us a more practical way to use `React.createElement()`.

- `React.Fragment` is an element used to group siblings elements without creating a new parent element.

- `<React.Fragment></React.Fragment>` can be replaced by `<></>`.

- React elements must start with an UpperCase letter.

- In JSX when you declare a constant/variable with an UpperCase letter, it's equivalent to calling `React.createElement()` with the function referenced by that variable.

- In `<Message>Hello World!</Message>`, the `Hello World!` string is the `Message.props.children`.

- You can use the npm package `prop-types` to validate props. Example:
```js
  SayHello.propTypes = {
    firstName: PropTypes.string.isRequired,
    lastName: PropTypes.string.isRequired,
  }
```

