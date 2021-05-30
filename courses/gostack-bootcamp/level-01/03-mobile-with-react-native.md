# Mobile With Reach Native

## Concepts

- vide: <https://app.rocketseat.com.br/node/mobile-com-react-native/lesson/arquitetura-react-native>

What is React Native? A React version for mobile development.

Advantage: multiplatform (Android and iOS)

Architechture: JS -> Metro Bundler (packager) -> bundle -> bridge (connect js and native) -> Android or iOS

### Syntax

- no HTML tags allowed (only `react-native` components)
- `View` works like a `div`
  - consequence: no semantic meaning
- `Text` is used for **any** text element (p, span, h1, strong, etc.)
  - consequence: no default styles
- `TouchableOpacity` is usually used rather than `button`
- `onPress` replaces the `onClick`
- each component element should have a `style=` property - there's no inheritance.
- styles are done via `StyleSheet`
- style properties are similar to CSS but with camelCase
- all elements are `display: flex` **by default**

- property values are strings (between quotes) or numbers.
- `View` is not scrollable
- use `ScrollView` for a scrollable View
- if the scroll is caused by a list (contents of an array), it's recommended to use `FlatList` (better performance)

The use of components is identical to ReactJS, but we don't use html tags (no `div`, `span`, `p`, etc...).

Styles are aplied without classes or IDs.

Styles are similar to the CSS, but with camelCase rather than hyphens, like this:

```js
const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
  },

  button: {
    backgroundColor: '#7159c1',
  },

  text: {
    fontWeight: 'bold',
  },
});
```

(thanks to yoga)


### Expo

SDK with a lot of ready to use functionalities (camera, video, integrations, etc.)

There's no need to install an emulator (with an app you can run the app in your device).

Why we won't use Expo in this bootcamp?

- limitations over controlling the native code.
- manu used libvraries do not support Expo.
- **Cool!**: Expo released their tools to be used outside from Expo.

## React Native Development Environment

- video: <https://app.rocketseat.com.br/node/mobile-com-react-native/lesson/configurando-sdk>

Website with instructions (in portuguese) to install a React Native development environment:
- https://react-native.rocketseat.dev/


## Starting a New Project

- video: <https://app.rocketseat.com.br/node/mobile-com-react-native/lesson/criando-novo-projeto>

```
react-native init mobile
cd mobile
rm .prettierrc.js .eslintrc.js
npx react-native run-android # be ready for problems here
code mobile

yarn add axios
```

**WARNING!**: be psychologicaly prepared to face some issues!


## Snippets

### Hello World

```js
import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

export default function App() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Hello GoStack</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#7149c1',
    justifyContent: 'center',
    alignItems: 'center'
  },

  title: {
    color: '#fff',
    fontSize: 32,
    fontWeight: 'bold'
  }
});
```


### Example of `FlatList`

Example of `FlatList` use:
```jsx
<FlatList
  data={projects} // projects must be an Array
  keyExtractor={project => project.id} // it must be an unique key
  renderItem={({ item: project }) => ( // function used to loop through the items
    <Text style={styles.project}>{project.title}</Text>
  )}
/>
```


