# User Registration and Authentication

## User's Migration

```
yarn sequelize migration:create --name=create-users
```

In the file `src/database/migrations/XXXX-create-users.js`:

```js
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('users', {
      id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
      },
      name: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      email: {
        type: Sequelize.STRING,
        allowNull: false,
        unique: true,
      },
      password_hash: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      provider: {
        type: Sequelize.BOOLEAN,
        defaultValue: false,
        allowNull: false,
      },
      created_at: {
        type: Sequelize.DATE,
        allowNull: false,
      },
      updated_at: {
        type: Sequelize.DATE,
        allowNull: false,
      },
    });
  },
  // down: ...
}
```

And then run:
```
yarn sequelize db:migrate
```

If I need to undo last migration:
```
yarn sequelize db:migrate:undo
```

Undo all migrations
```
yarn sequelize db:migrate:undo:all
```

## User Model

in `src/app/models/User.js`:
```js
import Sequelize, { Model } from 'sequelize';

class User extends Model {
  static init(sequelize) {
    super.init(
      {
        name: Sequelize.STRING,
        email: Sequelize.STRING,
        password_hash: Sequelize.STRING,
        provider: Sequelize.BOOLEAN,
      },
      {
        sequelize,
      }
    );
  }
}

export default User;
```

**NOTE** the properties of the first argument of `super.init()` above does NOT necessarily need to reflect the database table. You can use fields that are not present on the DB table.

## Model Loader

Create the file to connect to the database and load the models: `src/database/index.js`:

```js
import Sequelize from 'sequelize';
import User from '../app/models/User';

import databaseConfig from '../config/database';

const models = [User];

class Database {
  constructor() {
    this.init();
  }

  init() {
    this.connection = new Sequelize(databaseConfig);

    models.map(model => model.init(this.connection));
  }
}

export default new Database();
```

import the file in the `src/app.js`:
```js
// put this with the imports of the src/app.js
import './database'; // automatically imports the index.js
```

## Registering a new user

Create the `store()` method in the file `src/app/controllers/UserController.js`
```js
import User from '../models/User';

class UserController {
  async store(req, res) {
    const userExists = await User.findOne({
      where: { email: req.body.email },
    });

    if (userExists) {
      return res.status(400).json({ error: 'email is already in use.' });
    }

    const { id, name, email, provider } = await User.create(req.body);

    return res.json({
      id,
      name,
      email,
      provider,
    });
  }
}

export default new UserController();
```

in order to test, let's use this `src/routes.js`:
```js
import { Router } from 'express';

import UserController from './app/controllers/UserController';

const routes = new Router();

routes.post('/users', UserController.store);

export default routes;
```

## Generating Password Hash

```
yarn add bcryptjs
```

in the file `src/app/models/User.js`:
```js
// add the bcrypt import
import bcrypt from 'bcryptjs';

// add this as a property of the first argument of super.init() call
        password: Sequelize.VIRTUAL,

// call this method right after super.init()
    this.addHook('beforeSave', async (user) => {
      if (user.password) {
        user.password_hash = await bcrypt.hash(user.password, 8);
      }
    });

    return this;
```

**NOTES**:

- `Sequelize.VIRTUAL` is a field that doesn't exist in the database table.
- `this.addHook('beforeSave', callback)` runs the callback function before saving anything in the database.
- the second argument of `bcrypt.hash()` defines the number of rounds to be used to encrypt the password.

## JWT Authentication

JWT = JSON Web Token

```
yarn add jsonwebtoken
```

in `src/app/models/User.js`:
```js
// add the following method
checkPassword(password) {
  return bcrypt.compare(password, this.password_hash);
}
```

create the file `src/config/auth.js`:
```js
// generate a secret at https://www.md5online.org/
export default {
  secret: 'GeneratedHashForThis',
  expiresIn: '7d'
}
```

in `src/app/controllers/SessionController.js`:
```js
import jwt from 'jsonwebtoken';

import User from '../models/User';
import authConfig from '../../config/auth';

class SessionController {
  async store(req, res) {
    const { email, password } = req.body;

    const user = await User.findOne({
      where: { email }
    });

    if (!user) {
      return res.status(401).json({ error: 'User not found' });
    }

    if (!(await user.checkPassword(password))) {
      return res.status(401).json({ error: 'Password does not match' });
    }

    const { id, name } = user;

    return res.json({
      user: {
        id,
        name,
        email,
      },
      token: jwt.sign(
        { id },
        authConfig.secret,
        { expiresIn: authConfig.expiresIn },
      )
    });
  }
}
```

in `src/routes.js`:
```js
// import the SessionController
import SessionController from './app/controllers/SessionController';

// add this route
routes.post('/sessions', SessionController.store);
```

Test the authentication with insomnia.

Requests that requires authentication must use the token generated by JWT. This token is obtained by sending the `email` and `password` to the route `/sessions`.

Authenticated requests must have the token inside the field `Authorization` of the `Header` of the HTTP request. The contents must start with `Bearer ` (the word Bearer followed by a space) and then the generated token.



## Authentication Middleware

Create the file `src/app/middlewares/auth.js`:
```js
import jwt from 'jsonwebtoken';
import { promisify } from 'util';
// promisify: takes a function following the common error-first callback style,
// and returns a version that returns promises

import authConfig from '../../config/auth';

export default async (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({ error: 'Missing token' });
  }

  const [, token] = authHeader.split(' ');

  try {
    const decoded = await promisify(jwt.verify)(token, authConfig.secret);
    req.userId = decoded.id;
  } catch(err) {
    return res.status(401).json({ error: 'Invalid token' });
  }


```

Create the route in `src/routes.js`:
```js
// import the authorization middleware method
import authMiddleware from './app/middlewares/auth';

routes.use(authMiddleware);

routes.put('/users', UserController.update);
```






<!--stackedit_data:
eyJoaXN0b3J5IjpbMTU1NjA3NzAwMF19
-->
