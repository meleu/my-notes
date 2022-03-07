# Challenge 6

- challenge: <https://github.com/rocketseat-education/bootcamp-gostack-desafios/tree/master/desafio-database-upload>
- solution: <https://www.youtube.com/watch?v=aEUDRBBbo-Y>


- Create the databases `gostack_desafio06` and `gostack_desafio06_tests`
- Create the migration `CreateCategories`
- Create the `Category` model
- Create the migration `CreateTransactions`
- Create the `Transaction` model
- Create the `TransactionRepository` with the method `.getBalance()`.
- Routes:
  - `GET /transactions/:id`
  - `POST /transactions`
- Create `CreateTransactionService`
  - if category doesn't exist, create one;
  - if category title exist, use the existent one.
- Route `DELETE /transaction/:id`
- Create `DeleteTransactionService`.

## Random Notes

- Order:
```
create the databases (one for practice, and one for the unit tests)
migrations
models
[repository]
routes
services (business rules)
tests with insomnia
```

- I need a better understanding of the differences between `transactionRepository.delete()` and `transactionRepository.remove()`.

- Importing CSV Files
  - use `multer` to get the csv file
  - use `csv-parser` to parse the file
  - bulk save the contents of the file in the database

- short and useful video showing how to parse csv with `csv-parser`: <https://www.youtube.com/watch?v=9_x-UIVlxgo>
```js
const parse = require('csv-parse');
const fs = require('fs');

const csvData = [];

fs.createReadStream(__dirname + '/test.csv')
  .pipe(
    parse({
      delimiter: ','
    })
  )
  .on('data', (dataRow) => csvData.push(dataRow))
  .on('end', () => console.log(csvData));
```

- Cleaning up the provided solution.



I must understand every single line of code here:
```ts
import { getCustomRepository, getRepository, In } from 'typeorm';
import csvParse from 'csv-parse';
import fs from 'fs';

import Transaction from '../models/Transaction';
import Category from '../models/Category';

import TransactionsRepository from '../repositories/TransactionsRepository';

interface Request {
  filePath: string;
}

interface CSVTrasaction {
  title: string;
  value: number;
  type: 'income' | 'outcome';
  category: string;
}

class ImportTransactionsService {
  async execute({ filePath }: Request): Promise<Transaction[]> {
    const transactionsRepository = getCustomRepository(TransactionsRepository);
    const categoriesRepository = getRepository(Category);

    const csvStream = fs.createReadStream(filePath);

    csvStream
      .pipe(csvParse({ from_line: 2 }))
      .on('data', line => {
        const [title, type, value, category] = line.map((item: string) =>
          item.trim(),
        );

        if (!title || !type || !value) return;

        categories.push(category);

        transactions.push({
          title,
          type,
          value,
          category,
        });
      })

    const transactions: CSVTrasaction[] = [];
    const categories: string[] = [];


    await new Promise(resolve => {
      parseCSV.on('end', resolve);
    });

    const categoriesExists = await categoriesRepository.find({
      where: { title: In(categories) },
    });

    const categoriesExistsTitles = categoriesExists.map(
      (category: Category) => category.title,
    );

    const addCategoryTitles = categories
      .filter(category => !categoriesExistsTitles.includes(category))
      .filter((value, index, self) => self.indexOf(value) === index);

    const newCategories = categoriesRepository.create(
      addCategoryTitles.map(title => ({
        title,
      })),
    );

    await categoriesRepository.save(newCategories);

    const finalCategories = [...newCategories, ...categoriesExists];

    const createdTransactions = transactionsRepository.create(
      transactions.map(transaction => ({
        title: transaction.title,
        type: transaction.type,
        value: transaction.value,
        category: finalCategories.find(
          category => category.title === transaction.category,
        ),
      })),
    );

    await transactionsRepository.save(createdTransactions);

    await fs.promises.unlink(filePath);

    return createdTransactions;
  }
}
```
