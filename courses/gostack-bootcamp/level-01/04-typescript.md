# TypeScript

## Why TypeScript?

- Specially useful for development.
- The editor can show the data format (IntelliSense).
- Improves code maintenability.
- Allows using recent features of JS


## Starting a TypeScript project

```
mkdir project
yarn init -y
yarn add typescript -D
yarn add express
yarn add @types/express -D

# create a Hello World in src/index.ts
yarn tsc src/index.ts # generates the .js code

# start tsconfig.json
yarn tsc --init # creates the tsconfig.json file
yarn tsc        # no need to specify the .ts files to convert
```

It's useful to edit the `tsconfig.json`:
```json
{
  //...
  "outDir": "./dist",
  //...
}
```

When developing with TypeScript, the `ts-node-dev` package is a nice replacement for `nodemon`.


## Interface Examples

```ts
interface TechObject {
  title: string;
  experience?: number; // question mark for optional property
}

interface CreateUserData {
  name?: string; // optional
  email: string;
  password: string;
  techs: Array<string | TechObject>; // array of strings OR TechObjects
}

export default function createUser({ name, email, password }: CreateUserData) {
  const user = {
    name, email, password, techs
  };

  //...

  return user;
}
```
