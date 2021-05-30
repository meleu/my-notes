# Back-end With NodeJS

## Node.js

- video: <https://app.rocketseat.com.br/node/nivel-01/lesson/conceitos-node-js>

Using [nvm](https://github.com/nvm-sh/nvm) is better than install node from your distro's official package (avoid problems with different versions of node).

Use `yarn` instead of `npm` (that comes with node by default) to manage JS packages/dependencies. (**note**: I still didn't find why `yarn` is considered a better option, but let's keep going...)

Node.js features:

- event-loop architecture:
    - event based (in a web context it means *routes*)
    - call stack (a LIFO)
- single thread
    - behind the scenes, C++ and libuv allows multithread
    - background threads
- non blocking I/O

### frameworks

ExpressJS (good for starters):

- Non-opnionated (generalist)

Opnionated frameworks:

- AdonisJS
- NestJS


## REST APIs

- video: <https://app.rocketseat.com.br/node/nivel-01/lesson/conceitos-api-rest>
<!-- anki -->

HTTP verbs:

-  `GET http://minhaapi.com/users` - requests something
-  `POST http://minhaapi.com/users` - sends new data
-  `PUT http://minhaapi.com/users/1` - sends data for updating
-  `DELETE http://minhaapi.com/users/1` - requests a deletion

Data flows in JSON format

## basic structure of a HTTP request

- video: <https://app.rocketseat.com.br/node/nivel-01/lesson/metodos-http>

<!-- anki -->

```
GET http://api.com/company/1/users?page=2
# route -----------^       ^ ^     ^
# route parameter ---------' |     |
# route ---------------------'     |
# query parameters ----------------'
```

The `POST` and `PUT` methods also use the `body` field.

Another commonly used field is the `Header`.


### HTTP Codes

<!-- anki -->

Commonly used HTTP codes:

-   1xx: informational
-   2xx: success
    - 200: SUCCESS
    - 201: CREATED
    - 204: NO CONTENT
-   3xx: Redirection
    - 301: MOVED PERMANENTLY
    - 302: MOVED
-   4xx: Client Error
    - 400: BAD REQUEST
    - 401: UNAUTHORIZED
    - 404: NOT FOUND
-   5xx: Server Error
    - 500: INTERNAL SERVER ERROR


## ExpressJS

**Hello World**
```js
const express = require('express');
const server = express();

server.get('/', (request, response) => {
  return response.json({ message: 'Hello World!' });
});

server.listen(3000)
```

### getting HTTP data from `request`

we can get some HTTP data from the `request` parameter.

URL example
```
GET http://api.com/company/1/users?page=2
# route -----------^       ^ ^     ^
# route parameter ---------' |     |
# route ---------------------'     |
# query parameters ----------------'
```
#### route parameter

example to get the company ID from `/company/:id`
```js
server.get('/company/:id', (request, response) => {
  const { id } = request.params;
  // ...
}
```

#### query params

example to get the page value from `?page=2`:
```js
server.get('/users/:id', (request, response) => {
  const { page } = request.query;
  // ...
}
```

#### body properties

example to get the name and email from the body `{ "name": "meleu", "email": "meleu@mailserver.com" }`:
```js
server.post('/user', (request, response) => {
  const { name, email } = request.body;
  // ...
}
```

## nodemon

- video: <https://app.rocketseat.com.br/node/nivel-01/lesson/configurando-nodemon>

Using `nodemon` is a nice way to restart your application right after saving your code.
```
yarn add nodemon -D
```
then add to your `package.json`:
```json
  "main": "src/index.js",
  "scripts": {
    "dev": "nodemon"
  }
```

now, just execute `yarn dev` (ou `npm run dev`).

## CRUD



Dumb backend example using an array named `projects` to store data:
```js
const express = require('express');
const { v4: uuid } = require('uuid'); // used to create an universal unique ID

const app = express();

// allows reading request.body in json format
app.use(express.json());


// simulating data persistence
const projects = [];

// GET: request info from the backend
app.get('/projects', (request, response) => {
  const { title } = request.query;

  const results = title
    ? projects.filter(project => project.title.includes(title))
    : projects;

  return response.json(results);
});


// POST: submit a new entry to the backend
app.post('/projects', (request, response) => {
  const { title, owner } = request.body;

  const project = { id: uuid(), title, owner };
  projects.push(project);

  response.json(project);
});


// PUT: updates an entry in the backend
app.put('/projects/:id', (request, response) => {
  const { id } = request.params;
  const { title, owner } = request.body;

  const projectIndex = projects.findIndex(project => project.id === id);

  if (projectIndex < 0) {
    return response.status(404).json({ error: 'Project not found' });
  }

  project = {
    id,
    title,
    owner,
  };

  projects[projectIndex] = project;

  return response.json(project);
});


// DELETE: delete an entry from the backend
app.delete('/projects/:id', (request, response) => {
  const { id } = request.params;

  const projectIndex = projects.findIndex(project => project.id === id);
  if (projectIndex < 0) {
    return response.status(404).json({ error: 'Project not found' });
  }

  projects.splice(projectIndex, 1);

  return response.status(204).send();
});

app.listen(3333, () => console.log('🚀 back-end started!'));
```

see also: https://github.com/meleu/bootcamp-gostack-challenge-01/blob/master/index.js


## middleware

- video: <https://app.rocketseat.com.br/node/nivel-01/lesson/middlewares-2>
- old video: <https://app.rocketseat.com.br/node/ambiente-e-conceitos-5/group/introducao-ao-node/lesson/middlewares-1>

It's a "request's interceptor", that can either interrupt the request or
change request's data.

It's a function/method executed in a sequence with other functions/methods.

Useful for validation.

Example:

```js
// a middleware function
function checkBodyHasName(request, response, next) {
  if (!request.body.name) {
    return response.status(400).json({ error: 'User name is required' });
  }
  return next();
}

// middleware function being used:
server.post('/users', checkBodyHasName, (request, response) => {
  const { name } = request.body;
  users.push(name);
  return response.json(users);
});
```

**Note**: to use a middleware in all requests, `server.use(middlewareFunction)`

**Note 2**: use a middleware only in specific routes:
`server.use('/route/:id', middlewareFunction)`.

## CORS

```
yarn add cors
```

`index.js`:
```js
const cors = require('cors');
// ...

const app = express();

app.use(cors());
// ...
```

