# Starting With NodeJS and TypeScript

## GoBarber layout

<https://www.figma.com/file/BXCihtXXh9p37lGsENV614/GoBarber?node-id=34%3A1180>


## Project Structure

```
mkdir projectName
cd projectName
yarn init -y
yarn add express
yarn add typescript @types/express ts-node-dev -D
yarn tsc --init # generates the tsconfig.json
mkdir src
```

`tsconfig.json`:
```json
{
  "compilerOptions": {
    //...
    "outDir": "./dist",
    "rootDir": "./src",
    //...
  }
}
```

`package.json`:
```json
{
  //...
  "scripts": {
    "build": "tsc",
    "dev:server": "ts-node-dev --transpile-only --ignore-watch node_modules src/server.ts"
  },
  //...
}
```

## EditorConfig, ESLint and Prettier

### EditorConfig

- Install `EditorConfig for VS Code` plugin
- right-click on the file structure and choose `Generate .editorconfig`
- put this content in the `.editorconfig` file:
```
root = true

[*]
indent_style = space
indent_size = 2
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
end_of_line = lf
```

### ESLint

- Install `ESLint` plugin
- Press Ctrl+Shift+P and `open settings (json)`, and then add:
```json
"editor.codeActionsOnSave": {
  "source.fixAll.eslint": true
}
```

#### Node

For node, let's use the 6.8.0 version, as the new ones have some inconveniences.

[TODO: what are the inconveniences in the new version of eslint?]

```
yarn add eslint@6.8.0 -D
yarn eslint --init
# 1. To check syntax, find problems and enforce code style
# 2. JavaScript modules (import/export)
# 3. None of these
# 4. (use TypeScript?) Yes
# 5. (mark only Node with space bar and then Enter)
# 6. Use a popular style guide
# 7. Airbnb
# 8. JSON
# 9. (install with npm?) No
# copy the packages shown on the question 9 above and then...
yarn add @typescript-eslint/eslint-plugin@latest eslint-config-airbnb-base@latest eslint-plugin-import@^2.21.2 @typescript-eslint/parser@latest -D
yarn add eslint-import-resolver-typescript -D
```

Create the `.eslintignore` file:
```
/*.js
node_modules
dist
```

Edit `.eslintrc.json`:
```json
{
  // ...
  "extends": [
    // ...
    "plugin:@typescript-eslint/recommended"
  ],
  // ...
  "rules": {
    "import/extensions": [
      "error",
      "ignorePackages",
      {
        "ts": "never"
      }
    ]
  },
  // ...
  "settings": {
    "import/resolver": {
      "typescript": {}
    }
  }
  // ...
}
```

#### ReactJS

Assuming the project was created with `create-react-app`.

In the `package.json` **REMOVE** this part:
```json
"eslintConfig": {
  "extends": "react-app"
},
```

Install eslint 6.8.0 and initialize it:
```
yarn add eslint@6.8.0 -D
yarn eslint --init
# 1. To check syntax, find problems and enforce code style
# 2. JavaScript modules (impot/export)
# 3. React
# 4. (use TypeScript?) Yes
# 5. (mark only Browser with space bar and then Enter)
# 6. Use a popular style guide
# 7. Airbnb
# 8. JSON
# 9. (install with npm?) No

# copy the packages shown on the question 9 except 'eslint@^5.16.0 || ^6.8.0'
# because we already have it, and remove 1.7.0 from
# 'eslint-plugin-react-hooks@^2.5.0 || ^1.7.0'. The command will become like this:
yarn add eslint-plugin-react@^7.19.0 @typescript-eslint/eslint-plugin@latest eslint-config-airbnb@latest eslint-plugin-import@^2.20.1 eslint-plugin-jsx-a11y@^6.2.3 eslint-plugin-react-hooks@^2.5.0 @typescript-eslint/parser@latest -D

# making ReactJS undertand TypeScrpt
yarn add eslint-import-resolver-typescript -D
```

Create the `.eslingignore` file:
```
**/*.js
node_modules
build
/src/react-app-env.d.ts
```

Edit `.eslintrc.json`:
```json
{
  // ...
  "extends": [
    "plugin:react/recommended"
    // ...
    "plugin:@typescript-eslint/recommended"
  ],
  // ...
  "plugins": [
    // ...
    "react-hooks",
    "@typescript-eslint"
  ],
  "rules": {
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn",
    "import/prefer-default-export": "off",
    "import/extensions": [
      "error",
      "ignorePackages",
      {
        "ts": "never",
        "tsx": "never"
      }
    ]
  },
  // ...
  "settings": {
    "import/resolver": {
      "typescript": {}
    }
  }
  // ...
}
```

**Note**: if you're facing a warning like `'React' was used before it was defined`, add this to the `.eslintrc.json`:
```json
"rules": {
  // ...
  "no-use-before-define": "off",
  // ...
},
```

Restart VS Code.

#### React Native

Install eslint 6.8.0 and initialize it:
```
yarn add eslint@6.8.0 -D
yarn eslint --init
# 1. To check syntax, find problems and enforce code style
# 2. JavaScript modules (impot/export)
# 3. React
# 4. (use TypeScript?) Yes
# 5. (unmark every option and then Enter)
# 6. Use a popular style guide
# 7. Airbnb
# 8. JSON
# 9. (install with npm?) No

# copy the packages shown on the question 9 except 'eslint@^5.16.0 || ^6.8.0'
# because we already have it, and remove 1.7.0 from
# 'eslint-plugin-react-hooks@^2.5.0 || ^1.7.0'. The command will become like this:
yarn add eslint-plugin-react@^7.19.0 @typescript-eslint/eslint-plugin@latest eslint-config-airbnb@latest eslint-plugin-import@^2.20.1 eslint-plugin-jsx-a11y@^6.2.3 eslint-plugin-react-hooks@^2.5.0 @typescript-eslint/parser@latest -D

# making ReactJS undertand TypeScrpt
yarn add eslint-import-resolver-typescript -D
```

Create the `.eslingignore` file:
```
**/*.js
node_modules
build
```

Edit `eslintrc.json`:
```json
{
  // ...
  "extends": [
    "plugin:react/recommended"
    // ...
    "plugin:@typescript-eslint/recommended"
  ],
  // ...
  "globals": {
    // ...
    "__DEV__": "readonly"
  },
  "plugins": [
    // ...
    "react-hooks",
    "@typescript-eslint"
  ],
  "rules": {
    "react-hooks/rules-of-hooks": "error",
    "react-hooks/exhaustive-deps": "warn",
    "react/jsx-filename-extension": [1, { "extensions": [".tsx"] }],
    "import/prefer-default-export": "off",
    "import/extensions": [
      "error",
      "ignorePackages",
      {
        "ts": "never",
        "tsx": "never"
      }
    ]
  },
  // ...
  "settings": {
    "import/resolver": {
      "typescript": {}
    }
  }
  // ...
}
```

**Note**: if you're facing a warning like `'React' was used before it was defined`, add this to the `.eslintrc.json`:
```json
"rules": {
  // ...
  "no-use-before-define": "off",
  // ...
},
```

Restart VS Code.


### Prettier

It's the same for NodeJS, ReactJS and React Native.

```
yarn add prettier eslint-config-prettier eslint-plugin-prettier -D
```

Edit the `.eslintrc.json`:
```json
{
  // ...
  "extends": [
    "prettier/@typescript-eslint",
    "plugin:prettier/recommended",
  ],
  // ...
  "plugins": [
    // ...
    "prettier"
  ],
  "rules": {
    // ...
    "prettier/prettier": "error"
  },
  // ...
}
```

#### Solving conflicts between ESLint and Prettier.

`prettier.config.js`
```js
module.exports = {
  singleQuote: true, 
  trailingComma: 'es5',
  arrowParens: 'avoid',
}
```

`.eslintignore`:
```
# ...
/*.js
```

## Debugging in VS Code

- Click on the VS Code debugging icon.
- Click `create a launch.json file`.

`.vscode/launch.json`:
```json
{
  "version": "...",
  "configurations": [
    {
      "type": "node",
      "request": "attach",
      "protocol": "inspector",
      "restart": true,
      "name": "Debug",
      "skipFiles": [
        "<node_internals>/**"
      ],
      "outFiles": [
        "${workspaceFolder}/**/*.js"
      ]
    }
  ]
}
```

`package.json`:
```json
  "dev:server": "ts-node-dev --inspect --transpile-only --ignore node_modules src/server.ts"
```

Now when launching `dev:server` the debugger will be listening and if you click in the debuggin icon it'll be attached
to the application's debugger.

Use the `WATCH` to add variables you want to check.

**Note**: when the debugger is attached, the bottom bar becomes red.

## Appointments

- video: <https://app.rocketseat.com.br/node/nivel-02/group/construindo-aplicacao/lesson/cadastro-de-agendamentos>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/56f854a6614f386a27241021e2603a5632a899e1#diff-8232ea036c3319568d81c8bbc7d7b180>

```
#yarn add uuidv4
yarn add uuid
# looks like uuidv4 package is deprecated
# I got the same results by using "import { v4 } from 'uuid'"
```

We can have different route files for different endpoints. And then in an `routes/index.ts` we call
the specific router as a module and use it like a middleware.

`src/routes/index.ts`:
```ts
import { Router } from 'express';
import appointmentsRouter from './appointments.routes'

const routes = Router();

routes.use('/appointments', appointmentsRouter);
// ...
```

Now in the `src/routes/appointments.routes.ts` we can omit the `/appointments`, like in this example:
```ts
import { Router } from 'express';

const appointmentsRouter = Router();

// in the route below we omit the '/appointments' part, as it was assigned in
// the 'routes/index.ts'
appointmentsRouter.post('/', (request, response) => {
  // do something
});

// ...
```

**Note**: in the video there are some tests with insomnia [3:30].



## Validating Dates

- video: <https://app.rocketseat.com.br/node/nivel-02/group/construindo-aplicacao/lesson/validando-a-data>

- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/6f85e98c9050c9a5301af5ce09efa56b0471af13#diff-8232ea036c3319568d81c8bbc7d7b180>

```
yarn add date-fns
```

The goal is to allow appointments only for "full hours" prevent multiple appointments at the same time.

Methods imported from `date-fns`:

- `parseISO`: parse a string with an ISO-8601 date and return an instance of `Date`.
- `startOfHour`: return the start of an hour for the given date (0 minutes, 0 seconds). The result will be in the local timezone.
- `isEqual`: are the given dates equal? (returns boolean)


## Appointment Model

- video: <https://app.rocketseat.com.br/node/nivel-02/group/construindo-aplicacao/lesson/model-de-agendamento>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/1b1f12d6d2c342cc4d01492c6d4722a9f957d65d#diff-8232ea036c3319568d81c8bbc7d7b180>

Creating an `Appointment` class and using its constructor when creating a new appointment.

A goal we have is to make the routes files as clean as possible.

**Note**: when we have a data type that will be stored, it's a good practice to create a model for it.


## Creating Repositories

- video: <https://app.rocketseat.com.br/node/nivel-02/group/construindo-aplicacao/lesson/criando-repositorios>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/f8525f5705deffa5b1528c225270531bcf4b1d05#diff-8232ea036c3319568d81c8bbc7d7b180>

Repository is a connection between the data persistence (usually a database) and the application. Something like this:

```
persistence <--> repository <--> route
```

**Note**: in this context repository is not a code repository, like the ones used by git.

Usually we have one repository per model.

The repository is the class responsible for the logic to create/find/delete/update data


## Listing Appointments

- video: <https://app.rocketseat.com.br/node/nivel-02/group/construindo-aplicacao/lesson/listando-agendamentos-2>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/da3d8363d88f0446f77fad5d057043c669b775d5#diff-8232ea036c3319568d81c8bbc7d7b180>

Just a short lesson to tell that the responsibility to connect to the persistence layer and 
return all appointments belongs to the repository, not the route.


## Working With Data - Data Transfer Object

- video: <https://app.rocketseat.com.br/node/nivel-02/group/construindo-aplicacao/lesson/trabalhando-com-dados>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/535432384679d814c5bb7f2e2c3e67e824636a5c#diff-8232ea036c3319568d81c8bbc7d7b180>

DTO (Data Transfer Object) is useful to pass data between methods/classes/files/etc.

Before:
```ts
class AppointmentsRepository {
  // ...
  public create(provider: string, date: Date): Appointment {
    // ...
  }
}
```

Using DTO:
```ts
interface CreateAppointmentDTO {
  provider: string;
  date: Date;
}

class AppointmentsRepository {
  // ...
  public create({ provider, date }: CreateAppointmentDTO): Appointment {
    // ...
  }
}
```

It's particularly useful because you can easily add/remove the number of parameters to be received
in a method. Also, the editor can help showing the name and the type of the expected parameters.

Another interesting TypeScript feature is the `Omit<Type, Keys>` utility type. In the example below it's
useful to allow the constructor to be called with an `Appointment` object but without the `id` (which
is generated during the construction of the new instance):
```ts
class Appointment {
  id: string;
  provider: string;
  date: Date;

  constructor({ provider, date }: Omit<Appointment, 'id'>) {
    // ...
  }
}
```

## The Services Pattern & SOLID

- video: <https://app.rocketseat.com.br/node/nivel-02/group/construindo-aplicacao/lesson/services-and-solid>
- commit: <https://github.com/rocketseat-education/bootcamp-gostack-modulos/commit/6ec88cccbe08907b37c8004269b6462110940b48>

Concepts:

**Model** is how the data is structured.

**Repository** is how the data is persisted. In other words, it's a layer that sits between your project's domain and the database.

**Route** is responsible to get a request, dispatch it to the responsible service, and then provide a response. Probably it handles data transformation too (e.g.: using `parseISO()` to convert a string into a `Date` object).

**Service** is about the business rules. All business rules logic should be in the service.

Services Features:
- is a class.
- is responsible for the business rules.
- has only one and a very specific task to accomplish.
- has only one public method (usually called `execute` or `run`).
- on success, return data; on error `throw an Error()` (it doesn't have access to the HTTP (express) layer).

Interesting article about the Repository Pattern: <https://culttt.com/2014/09/08/benefits-using-repositories/>

> four main benefits of using The Repository Pattern:
> 1. Data storage as a mere detail of the overall application.
> 2. Much easier for testing.
> 3. One-way dependency.
> 4. In-memory illusion.

## Summary

- [ ] Installing dependencies:
```
yarn add express uuid date-fns
yarn add -D typescript ts-node-dev @types/express @types/uuid 
```
- [ ] Install [EditorConfig, ESLint and Prettier](#editorconfig-eslint-and-prettier) stuff.

- [ ] Setup [debugging in VS Code](#debugging-in-vs-code).

- [ ] `package.json`
```json
  "scripts": {
    "build": "tsc",
    "dev:server": "ts-node-dev --inspect --transpile-only --ignore-watch node_modules src/server.ts"
  },
```

- [ ] `tsconfig.json`
```json
{
  "compilerOptions": {
    //...
    "outDir": "./dist",
    "rootDir": "./src",
    "strictPropertyInitialization": false,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
  }
}
```

- [ ] Create the appointments router (at least for GET and POST).

- [ ] Create the Appointments model.

- [ ] Create the AppointmentsRepository (for now the persistence is still in-memory).

- [ ] Create a service to CreateAppointment (it must handle the business rules).

- [ ] Code Files Structure
```
$ tree src/
src/
├── models
│   └── Appointment.ts
├── repositories
│   └── AppointmentsRepository.ts
├── routes
│   ├── appointments.routes.ts
│   └── index.ts
├── server.ts
└── services
    └── CreateAppointmentService.ts
```

  - [ ]  `server.ts`: Just load the routes and starts the server.

  - [ ]  `routes/*`: The files taking requests from the user's applications, dispatching them to the respective service, and delivering a response.

**Note**: Besides `server.ts` and `routes/*.ts`, none of the files below is aware about HTTP, ExpressJS or such details.

  - [ ]  `models/Appointment.ts`: Describes how the appointment data are structured, and just that.


  - [ ]  `repositories/AppointmentsRepository.ts`: A class that represents the collection of appointments and offers methods to create/list/delete/find appointments.


  - [ ]  `services/CreateAppointmentService.ts`: A class with only one public method (`execute`) and with a very specific task: take the business rules into consideration and create a valid appointment (if it's not possible, throw an Error).

An instance of this class should be constructed with an instance of `AppointmentsRepository` in which it will store the information.

**Question**: if a client of `CreateAppointmentService` already have an `AppointmentsRepository`, why can't it use the repository's methods to create an appointment?
**Answer**: because the business rules' logic sits on the service. The client shouldn't be worried about business rules.


## My GoBarber codebase up to this point

<https://github.com/meleu/gobarber/tree/31c499b3df733a8e7224df9d210035699ddc2503>


## Challenge 5

- challenge: <https://github.com/rocketseat-education/bootcamp-gostack-desafios/tree/master/desafio-fundamentos-nodejs>
- solution: <https://youtu.be/FYsFvjM6AJM>

Interesting stuff I learned while working in this challenge:

- The `Array.reduce()` takes a "reducer" function as the first parameter and this function reduces the array to just one value. OK, I'm already familiar with how it works, but the interesting thing I learned was that the second parameter passed to `reduce()` (aka `initialValue`) defines the type of the value returned by the function. [Documentation](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/Reduce).

- The `Array.includes()` can be an useful way to validate if a string is valid. In this challenge I used this to validate the `type` of a transaction: `!['income', 'outcome'].includes(type)`.

- As said in the "Services" lesson, the service class is where the business rules should be. I had to rethink the first thought of implementing a transacion creation business rule in the repository class.
