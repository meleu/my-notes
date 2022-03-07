# Tests

Install:
```
yarn add jest @sucrase/jest-plugin @types/jest -D
```

Init jest:
```
yarn jest --init
```

Answers:
- Would you like to use Jest when running "test" script in "package.json"? … yes
- Choose the test environment that will be used for testing › node
- Do you want Jest to add coverage reports? … yes
- Automatically clear mock calls and instances between every test? … yes

It'll generate the `jest.config.js`. Change it to be like this:
```js
module.exports = {
  bail: 1,
  clearMocks: true,
  collectCoverage: true,
  collectCoverageFrom: ['src/app/**/*.js'],
  coverageDirectory: '__tests__/coverage',
  coverageReporters: ['text', 'lcov'],
  testEnvironment: 'node',
  testMatch: ['**/__tests__/**/*.test.js'],
  transform: {
    '.(js|jsx|ts|tsx)': '@sucrase/jest-plugin',
  },
};
```

We're going to use a sqlite database for testing.

Create a `.env.test`:
```
APP_URL=http://localhost:3333
NODE_ENV=development

# Auth

APP_SECRET=templatenoderocketseat

# Database

DB_DIALECT=sqlite
```

In the `package.json`, change the `scripts.test` to this:
```json
    "test": "NODE_ENV=test jest"
```


Create the `src/bootstrap.js`:
```js
import dotenv from 'dotenv';

dotenv.config({
  path: process.env.NODE_ENV === 'test' ? '.env.test' : '.env',
});
```

Edit the `src/config/database.js`:
```js
require('../bootstrap');

module.exports = {
  dialect: process.env.DB_DIALECT || 'postgres', // added
  host: process.env.DB_HOST,
  username: process.env.DB_USER,
  password: process.env.DB_PASS,
  storage: './__tests__/db.sqlite', // added
  database: process.env.DB_NAME,
  define: {
    timestamps: true,
    underscored: true,
    underscoredAll: true,
  },
};
```

Edit the top of the `src/app.js`, replacing the `import dotenv...` by:
```js
import './bootstrap';
```


