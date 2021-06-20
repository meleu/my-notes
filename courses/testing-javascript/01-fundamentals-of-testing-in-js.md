# Fundamentals of Testing in JavaScript

- code: <https://github.com/kentcdodds/js-testing-fundamentals/tree/egghead-2018>

## Lib to be tested: `math.js`

```js
// sum is intentionally broken so you can see errors in the tests
const sum = (a, b) => a - b
const subtract = (a, b) => a - b

// these are kinda pointless I know, but it's just to simulate an async function
const sumAsync = (...args) => Promise.resolve(sum(...args))
const subtractAsync = (...args) => Promise.resolve(subtract(...args))

module.exports = {sum, subtract, sumAsync, subtractAsync}
```

Simplest way to test it: `simple.js`
```js
const {sum, subtract} = require('./math')

// returns an object with a toBe() method, checking if `actual` is equal to `expected`
function expect(actual) {
  return {
    toBe(expected) {
      if (actual !== expected) {
        throw new Error(`${actual} is not equal to ${expected}`)
      }
    }
  }
}

let result, expected

result = sum(3, 7)
expected = 10
expect(result).toBe(expected)

result = subtract(7, 3)
expected = 4
expect(result).toBe(expected)
```


## Giving a title to each test:

```js
// NOTE: doesn't work with async functions
const {sum, subtract} = require('./math')

function test(title, callback) {
  try {
    callback()
    console.log(`✓ ${title}`)
  } catch (error) {
    console.error(`✕ ${title}`)
    console.error(error)
  }
}

function expect(actual) {
  return {
    toBe(expected) {
      if (actual !== expected) {
        throw new Error(`${actual} is not equal to ${expected}`)
      }
    }
  }
}

test('sum adds numbers', () => {
  const result = sum(3, 7)
  const expected = 10
  expect(result).toBe(expected)
})

test('subtract subtracts numbers', () => {
  const result = subtract(7, 3)
  const expected = 4
  expect(result).toBe(expected)
})
```


## Supporting asynchronous functions:

```js
const {sumAsync, subtractAsync} = require('./math')

async function test(title, callback) {
  try {
    await callback()
    console.log(`✓ ${title}`)
  } catch (error) {
    console.error(`✕ ${title}`)
    console.error(error)
  }
}

function expect(actual) {
  return {
    toBe(expected) {
      if (actual !== expected) {
        throw new Error(`${actual} is not equal to ${expected}`)
      }
    }
  }
}

test('sumAsync adds numbers asynchronously', async () => {
  const result = await sumAsync(3, 7)
  const expected = 10
  expect(result).toBe(expected)
})

test('subtractAsync subtracts numbers asynchronously', async () => {
  const result = await subtractAsync(7, 3)
  const expected = 4
  expect(result).toBe(expected)
})
```

## Putting the test functions as globals

`setup-globals.js`:
```js
async function test(title, callback) {
  try {
    await callback()
    console.log(`✓ ${title}`)
  } catch (error) {
    console.error(`✕ ${title}`)
    console.error(error)
  }
}

function expect(actual) {
  return {
    toBe(expected) {
      if (actual !== expected) {
        throw new Error(`${actual} is not equal to ${expected}`)
      }
    }
  }
}

global.test = test
global.expect = expect
```

`simple.js`:
```js
const {sumAsync, subtractAsync} = require('./math')

test('sumAsync adds numbers asynchronously', async () => {
  const result = await sumAsync(3, 7)
  const expected = 10
  expect(result).toBe(expected)
})

test('subtractAsync subtracts numbers asynchronously', async () => {
  const result = await subtractAsync(7, 3)
  const expected = 4
  expect(result).toBe(expected)
})
```

running it:
```sh
node --require setup-globals.js simple.js
```

## Running tests with Jest

Rename the `simple.js` file to `simple.test.js` and then run:
```sh
npx jest
```

You'll see much clearer and helpful messages about the errors.

