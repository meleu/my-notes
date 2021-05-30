# Improving the API

## Uploading files

Allowing the user to have an avatar.


### multer

Install `multer` to handle Multipart Form data:
```
yarn add multer
```

Create a new folder: `tmp/uploads`.

Create a file `src/config/multer.js`:
```js
import multer from 'multer';
import crypto from 'crypto';
import { extname, resolve } from 'path';

export default {
  storage: multer.diskStorage({
    destination: resolve(__dirname, '..', '..', 'tmp', 'uploads'),
    filename: (req, file, cb) => {
      crypto.randomBytes(16, (err, res) => {
        return err
          ? cb(err)
          : cb(null, res.toString('hex') + extname(file.originalname));
      });
    },
  }),
};
```


### Database table for files

Create a migration for the `files` table:
```
yarn sequelize migration:create --name=create-files
```

File `src/database/migrations/XXXXXXX-create-files.js` contents:
```js
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('files', {
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
      path: {
        type: Sequelize.STRING,
        allowNull: false,
        unique: true,
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

  down: queryInterface => {
    return queryInterface.dropTable('files');
  },
};
```

Run the migration:
```
yarn sequelize db:migrate
```

### File Model

Create the file `src/app/models/File.js`:
```js
import Sequelize, { Model } from 'sequelize';

class File extends Model {
  static init(sequelize) {
    super.init(
      {
        name: Sequelize.STRING,
        path: Sequelize.STRING,
        url: {
          type: Sequelize.VIRTUAL,
          get() {
            return `http://localhost:3333/files/${this.path}`;
          },
        },
      },
      {
        sequelize,
      }
    );

    return this;
  }
}

export default File;
```

Import the `File.js` model in `src/database/index.js`.


### File Controller

Create the `src/app/controllers/FileController.js`:
```js
import File from '../models/File';

class FileController {
  async store(req, res) {
    const { originalname: name, filename: path } = req.file;

    const file = await File.create({ name, path });

    return res.json(file);
  }
}

export default new FileController();
```

### Add the `avatar_id` field to the `users` table

Create a new field for the `users` table:
```
yarn sequelize migration:create --name=add-avatar-field-to-users
```

Edit `src/database/migrations/XXXXXXX-add-avatar-field-to-users.js`:
```js
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.addColumn('users', 'avatar_id', {
      type: Sequelize.INTEGER,
      references: { model: 'files', key: 'id' },
      onUpdate: 'CASCADE',
      onDelete: 'SET NULL',
      allowNull: true,
    });
  },

  down: queryInterface => {
    return queryInterface.removeColumn('users', 'avatar_id');
  },
};
```

Run the migration:
```
yarn sequelize db:migrate
```

### Associating the File with the User model

Add `associate` method to `src/app/models/User.js`:
```js
static associate(models) {
  this.belongsTo(models.File, { foreignKey: 'avatar_id', as: 'avatar' });
}
```

In `src/database/index.js`:
```js
  init() {
    this.connection = new Sequelize(databaseConfig);

    models
      .map(model => model.init(this.connection))
      .map(model => model.associate && model.associate(this.connection.models));
  }
```

### Route for uploading files

Add file's stuff in `src/routes.js`:
```js
// importing multer stuff
import multer from 'multer';
import multerConfig from './config/multer';

// importing FileController
import FileController from './app/controllers/FileController';


// instantiate a multer object
const upload = multer(multerConfig);

// below the authentication middleware call
routes.post('/files', upload.single('file'), FileController.store);
```

### Serving static files

Make the app able to serve static files: in the `src/app.js`, method `middlewares()`:
```js
// import path to resolve the path name
import path from 'path';

// inside middlewares()
  this.server.use(
    '/files',
    express.static(path.resolve(__dirname, '..', 'tmp', 'uploads'))
  );
```


## Making appointments

### List service providers

Create `src/app/controllers/ProviderController.js`:
```js
import User from '../models/User';
import File from '../models/File';

class ProviderController {
  async index(req, res) {
    const providers = await User.findAll({
      where: { provider: true },
      attributes: ['id', 'name', 'email', 'avatar_id'],
      include: [{
        model: File,
        as: 'avatar',
        attributes: ['name', 'path', 'url'],
      }],
    });

    return res.json(providers);
  }
}

export default new ProviderController();
```

Add a route for `/providers`:
```js
// import the controller
import ProviderController from './app/controllers/ProviderController';

// add the route
routes.get('/providers', ProviderController.index);
```

Test with insomnia...


### Appointment migration and model

```
yarn sequelize migration:create --name=create-appointments
```

Edit `src/database/migrations/XXXXX-create-appointments.js
```js
module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('appointments', {
      id: {
        type: Sequelize.INTEGER,
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
      },
      date: {
        type: Sequelize.DATE,
        allowNull: false,
      },
      user_id: {
        type: Sequelize.INTEGER,
        references: { model: 'users', key: 'id' },
        onUpdate: 'CASCADE',
        onDelete: 'SET NULL',
        allowNull: true,
      },
      provider_id: {
        type: Sequelize.INTEGER,
        references: { model: 'users', key: 'id' },
        onUpdate: 'CASCADE',
        onDelete: 'SET NULL',
        allowNull: true,
      },
      cancelled_at: {
        type: Sequelize.DATE,
        allowNull: true,
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

  down: queryInterface => {
    return queryInterface.dropTable('appointments');
  },
};
```

```
yarn sequelize db:migrate
```

Create an appointment model `src/app/models/Appointment.js`:
```js
import Sequelize, { Model } from 'sequelize';
import { isBefore, subHours } from 'date-fns';

class Appointment extends Model {
  static init(sequelize) {
    super.init(
      {
        date: Sequelize.DATE,
        canceled_at: Sequelize.DATE,
        past: {
          type: Sequelize.VIRTUAL,
          get() {
            return isBefore(this.date, new Date());
          },
        },
        cancelable: {
          type: Sequelize.VIRTUAL,
          get() {
            return isBefore(this.date, subHours(this.date, 2));
          },
        },
      },
      {
        sequelize,
      }
    );
    return this;
  }

  static associate(models) {
    this.belongsTo(models.User, { foreignKey: 'user_id', as: 'user' });
    this.belongsTo(models.User, { foreignKey: 'provider_id', as: 'provider' });
  }
}

export default Appointment;
```

Add the model to `src/database/index.js`:
```
// import the model and add it to the array of models
import Appointment from '../app/models/Appointment.js';

// ...
const models = [User, File, Appointment];
```

### Making an appointment

Create a controller `src/app/controllers/AppointmentController.js`:
```js
import * as Yup from 'yup';
import Appointment from '../models/Appointment';
import User from '../models/User';

class AppointmentController {
  async store(req, res) {
    const schema = Yup.object().shape({
      provider_id: Yup.number().required(),
      date: Yup.date().required(),
    });

    if (!(await schema.isValid(req.body))) {
      return res.status(400).json({ error: 'Validation fails' });
    }

    const { provider_id, date } = req.body;

    if (provider_id === req.userId) {
      return res
        .status(400)
        .json({ error: 'Client and provider must be different users' });
    }

    const isProvider = await User.findOne({
      where: { id: provider_id, provider: true },
    });

    if (!isProvider) {
      return res.status(400).json({ error: 'You must inform a provider user' });
    }

    const appointment = await Appointment.create({
      user_id: req.userId,
      provider_id,
      date,
    });

    return res.json(appointment);
  }
}

export default new AppointmentController();
```

Create a route for appointments in `src/routes.js`:
```js
// import the controller
import AppointmentController from './src/app/controllers/AppointmentController.js';

// put this bellow the authentication
routes.post('/appointments', AppointmentsController.store);
```

### Validating appointments

Let's assure the appointment is not scheduled to a past date-time and that the provider is available.

```
yarn add date-fns
```

In `src/app/controllers/AppointmentController.js`:
```js
import { startOfHour, parseISO, isBefore } from 'date-fns';

// right below checking if the user is a provider
    const hourStart = startOfHour(parseISO(date));
    if (isBefore(hourStart, new Date())) {
      return res.status(400).json({ error: 'Past dates are not permitted' });
    }

    const isNotAvailable = await Appointment.findOne({
      where: {
        provider_id,
        canceled_at: null,
        date: hourStart,
      },
    });
    if (isNotAvailable) {
      return res.status(400).json({
        error: 'The provider is not available at the given date-time',
      });
    }
```


Test with insomnia...


### Listing user's appointments

Add the route in `src/routes.js`:
```js
routes.get('/appointments', AppointmentController.index);
```

In `src/app/controllers/AppointmentController.js`:
```js
// import file model
import File from '../models/File';

  async index(req, res) {
    const { page = 1 } = req.query;

    const appointments = await Appointment.findAll({
      where: {
        user_id: req.userId,
        canceled_at: null,
      },
      order: ['date'],
      attributes: ['id', 'date', 'past', 'cancelable'],
      limit: 20,
      offset: (page - 1) * 20,
      include: [
        {
          model: User,
          as: 'provider',
          attributes: ['id', 'name'],
          include: [
            {
              model: File,
              as: 'avatar',
              attributes: ['id', 'path', 'url'],
            },
          ],
        },
      ],
    });

    return res.json(appointments);
  }
```


### Listing provider's schedule

Create the controller `src/app/controllers/ScheduleController.js`:
```js
import { startOfDay, endOfDay, parseISO } from 'date-fns';
import { Op } from 'sequelize';

import User from '../models/User';
import Appointment from '../models/Appointment';

class ScheduleController {
  async index(req, res) {
    const isProvider = await User.findOne({
      where: {
        id: req.userId,
        provider: true,
      },
    });
    if (!isProvider) {
      return res.status(401).json({ error: 'User is not a provider' });
    }

    const parsedDate = parseISO(req.query.date);

    const appointments = await Appointment.findAll({
      where: {
        provider_id: req.userId,
        canceled_at: null,
        date: {
          [Op.between]: [startOfDay(parsedDate), endOfDay(parsedDate)],
        },
      },
      order: ['date'],
    });

    return res.json(appointments);
  }
}

export default new ScheduleController();
```

Create the route in `src/routes.js`:
```js
import ScheduleController from './app/controllers/ScheduleController';


// below the authentication
routes.get('/schedule', ScheduleController.index);
```

## Notifications

### Setting up MongoDB

Download & install the MongoDB container:
```
docker run --name mongobarber -p 27017:27017 -d -t mongo
```

Install mongoose:
```
yarn add mongoose
```

Add these lines in `src/database/index.js`:
```js
import mongoose from 'mongoose';

// inside the constructor()
    this.mongo();


// mongo() function
mongo() {
  this.mongoConnection = mongoose.connect(
    'mongodb://localhost:27017/gobarber',
    { 
      useNewUrlParser: true,
      useFindAndModify: false,
      useUnifiedTopolgy: true,
    }
  );
}
```

### Notifying new appointments

Create the file `src/schemas/Notification.js`:
```js
import mongoose from 'mongoose';

const NotificationSchema = new mongoose.Schema(
  {
    content: {
      type: String,
      required: true,
    },
    user: {
      type: Number,
      required: true,
    },
    read: {
      type: Boolean,
      required: true,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

export default mongoose.model('Notification', NotificationSchema);
```

Edit `src/app/controllers/AppointmentController.js`:
```js
// imports section
import { format } from 'date-fns';
import pt from 'date-fns/locale/pt';
import Notification from '../schemas/Notification';


// in the store() method, right below Appointment.create()
    const user = await User.findByPk(req.userId);
    const formattedDate = format(hourStart, "'dia' dd 'de' MMMM', às' HH:mm", {
      locale: pt,
    });

    await Notification.create({
      content: `Novo agendamento de ${user.name} para ${formattedDate}`,
      user: provider_id,
    });

    return res.json(appointment);
```

Download and install MongoDB Compass Community

Create an appointment with insomnia and check in MongoDB Compass if it was registered.

### Listing notifications

Create the `src/app/controllers/NotificationController.js`:
```js
import User from '../models/User';
import Notification from '../schemas/Notification';

class NotificationController {
  async index(req, res) {
    const checkIsProvider = await User.findOne({
      where: { id: req.userId, provider: true },
    });

    if (!checkIsProvider) {
      return res.status(401).json({ error: 'User is not a provider' });
    }

    const notifications = await Notification.find({ user: req.userId })
      .sort({ createdAt: 'desc' })
      .limit(20);

    return res.json(notifications);
  }

  async update(req, res) {
    const notification = await Notification.findByIdAndUpdate(
      req.params.id,
      { read: true },
      { new: true }
    );

    return res.json(notification);
  }
}

export default new NotificationController();
```

Add the route in `src/routes.js`:
```
import NotificationController from './app/controllers/NotificationController';

// below authentication line
routes.get('/notifications', NotificationController.index);
routes.put('/notifications/:id', NotificationController.update);
```

## Cancel an appointment

In `src/routes.js`:
```js
routes.delete('/appointements/:id', AppointmentController.delete);
```

In `src/app/controllers/AppointmentController.js` create the `delete()` method:
```js
  async delete(req, res) {
    const appointment = await Appointment.findByPk(req.params.id);

    if (appointment.user_id !== req.userId) {
      return res
        .status(401)
        .json({ error: 'You can only cancel your own appointements' });
    }

    if (appointment.canceled_at) {
      return res
        .status(400)
        .json({ error: 'This appointment was already canceled' });
    }

    const timeLimit = subHours(appointment.date, 2);

    if (isBefore(timeLimit, new Date())) {
      return res.status(400).json({
        error:
          'Appointments can only be canceled with more than 2 hours of advance',
      });
    }

    appointment.canceled_at = new Date();

    await appointment.save();

    return res.json(appointment);
  }
```


## Sending emails

Install nodemailer:
```
yarn add nodemailer
```

Create an account at https://mailtrap.io/ (really cool service!)

Create `src/config/mail.js`:
```js
export default {
  host: 'smtp.mailtrap.io',
  port: 2525,
  secure: false,
  auth: {
    user: '6a2f975bc7f2f5',
    pass: 'fc7f3bd9d6da0c',
  },
  default: {
    from: 'Equipe GoBarber <noreply@gobarber.com>',
  },
};
```

Create `src/lib/Mail.js`:
```js
import nodemailer from 'nodemailer';
import mailConfig from '../config/mail';

class Mail {
  constructor() {
    const { host, port, secure, auth } = mailConfig;

    this.transporter = nodemailer.createTransport({
      host,
      port,
      secure,
      auth: auth.user ? auth : null,
    });
  }

  sendMail(message) {
    return this.transporter.sendMail({
      ...mailConfig.default,
      ...message,
    });
  }
}

export default new Mail();
```

Edit the `src/app/controllers/AppointmentController.js` in the method `delete()`:
```js
// import Mail lib
import Mail from '../../lib/Mail';

// replace the 'appointment' atribution with:
    const appointment = await Appointment.findByPk(req.params.id, {
      include: [
        {
          model: User,
          as: 'provider',
          attributes: ['name', 'email'],
        },
      ],
    });

// send the email right after saving the canceled appointment
    await Mail.sendMail({
      to: `${appointment.provider.name} <${appointment.provider.email}>`,
      subject: 'Agendamento cancelado',
      text: 'Você tem um novo cancelamento',
    });

```

Test the appointment being canceled with insomnia.


### Email templates

```
yarn add express-handlebars nodemailer-express-handlebars
```

Create the following directories:
- `src/app/views`
    - `emails`
        - `layouts`
        - `partials`

Create `src/app/views/emails/partials/footer.hbs`:
```html
<br />
Equipe GoBarber
```

Create `src/app/views/emails/layouts/default.hbs`:
```html
<div style="font-family: Arial, Helvetica, sans-serif; font-size: 16px; line-height: 1.6; color: #222; max-width: 600px;">
  {{{ body }}}
  {{> footer }}
</div>
```

Create `src/app/views/emails/cancellation.hbs`:
```html
<strong>Olá, {{ provider }}</strong>
<p>Houve um cancelamento de horário, confira os detalhes abaixo:</p>
<p>
  <strong>Cliente:</strong> {{ user }} <br />
  <strong>Data-Hora:</strong> {{ date }} <br />
  <small>
    O horário está novamente disponível para agendamentos.
  </small>
</p>
```

In `src/lib/Mail.js`:
```js
// import section
import { resolve } from 'path';
import expresshbs from 'express-handlebars'
import nodemailerhbs from 'nodemailer-express-handlebars';

// at the end of constructor()
    this.configureTemplates();

// create the method
  configureTemplates() {
    const viewPath = resolve(__dirname, '..', 'app', 'views', 'emails');

    this.transporter.use(
      'compile',
      nodemailerhbs({
        viewEngine: expresshbs.create({
          layoutsDir: resolve(viewPath, 'layouts'),
          partialsDir: resolve(viewPath, 'partials'),
          defaultLayout: 'default',
          extname: '.hbs',
        }),
        viewPath,
        extName: '.hbs',
      })
    );
  }
```

In the method `delete()` of `src/app/controllers/AppointmentController.js`:
```js
// get the client name in the appointment declaration:
    const appointment = await Appointment.findByPk(req.params.id, {
      include: [
        {
          model: User,
          as: 'provider',
          attributes: ['name', 'email'],
        },
        {
          model: User,
          as: 'user',
          attributes: ['name'],
        }
      ],
    });

// in Mail.sendMail() part:
    
```

### Mail queues with Redis (background jobs)

Download & install a Redis container:
```
docker run --name redisbarber -p 6379:6379 -d -t redis:alpine
```

Install bee-queue:
```
yarn add bee-queue
```

Create directory `src/app/jobs` and file `src/app/jobs/CancellationMail.js`:
```js
import { format, parseISO } from 'date-fns';
import pt from 'date-fns/locale/pt';
import Mail from '../../lib/Mail';

class CancellationMail {
  get key() {
    return 'CancellationMail';
  }

  async handle({ data }) {
    const { appointment } = data;

    Mail.sendMail({
      to: `${appointment.provider.name} <${appointment.provider.email}>`,
      subject: 'Agendamento cancelado',
      template: 'cancellation',
      context: {
        provider: appointment.provider.name,
        user: appointment.user.name,
        date: format(
          parseISO(appointment.date),
          "'dia' dd 'de' MMMM', às' HH:mm",
          { locale: pt }
        ),
      },
    });
  }
}

export default new CancellationMail();
```

Create `src/config/redis.js`:
```js
export default {
  host: '127.0.0.1',
  port: 6379
}
```

Create `src/lib/Queue.js`:
```js
import Bee from 'bee-queue';
import CancellationMail from '../app/jobs/CancellationMail';
import redisConfig from '../config/redis';

const jobs = [CancellationMail];

class Queue {
  constructor() {
    this.queues = {};
    this.init();
  }

  init() {
    jobs.forEach(({ key, handle }) => {
      this.queues[key] = {
        bee: new Bee(key, { redis: redisConfig }),
        handle,
      };
    });
  }

  add(queue, job) {
    return this.queues[queue].bee.createJob(job).save();
  }

  processQueue() {
    jobs.forEach(job => {
      const { bee, handle } = this.queues[job.key];
      bee.on('failed', this.handleFailure).process(handle);
    });
  }

  handleFailure(job, err) {
    // TODO: remove the console.log()
    console.log(`Queue ${job.queue.name}: FAILED`, err);
  }
}

export default new Queue();
```

In `src/app/controllers/AppointmentController.js`:
```js
// rather than Mail, let's import Queue
import CancellationMail from '../jobs/CancellationMail';
import Queue from '../../lib/Queue';

// rather than Mail.sendMail()...
await Queue.add(CancellationMail.key, { appointment });
```

Create `src/queue.js`:
```js
import Queue from './lib/Queue';

Queue.processQueue();
```

In `package.json`, add this line in `"scripts"` property:
```json
    "queue": "nodemon src/queue.js"
```


### List provider's availability times

Create `src/app/controllers/AvailableController.js`:
```js
import {
  startOfDay,
  endOfDay,
  setSeconds,
  setMinutes,
  setHours,
  isAfter,
  format,
} from 'date-fns';
import { Op } from 'sequelize';
import Appointment from '../models/Appointment';

class AvailableController {
  async index(req, res) {
    const date = Number(req.query.date);

    if (!date || Number.isNaN(date)) {
      return res.status(400).json({ error: 'Invalid date' });
    }

    const appointments = await Appointment.findAll({
      where: {
        provider_id: req.params.providerId,
        canceled_at: null,
        date: { [Op.between]: [startOfDay(date), endOfDay(date)] },
      },
    });

    const schedule = [
      '08:00',
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
      '19:00',
      '20:00',
    ];

    const available = schedule.map(time => {
      const [hour, minute] = time.split(':');
      const value = setSeconds(setMinutes(setHours(date, hour), minute), 0);

      return {
        time,
        value: format(value, "yyyy-MM-dd'T'HH:mm:ssxxx"),
        available:
          isAfter(value, new Date()) &&
          !appointments.find(a => format(a.date, 'HH:mm') === time),
      };
    });

    return res.json(available);
  }
}

export default new AvailableController();
```

In `src/routes`:
```js
// importing
import AvailableController from './app/controllers/AvailableController';

// below authentication
routes.get('/providers/:providerId/available', AvailableController.index);
```

### Handling Exceptions


Create an account at https://sentry.io/ and then create a new Project and choose Express.

```
yarn add express-async-errors youch
yarn add @sentry/node@5.12.2
```

Create the `src/config/sentry.js`:
```js
export default {
  dsn: 'https://GivenToken...@sentry.io/12345'
}
```

Edit the `src/app.js`:
```js
import express from 'express';
import 'express-async-errors';
import * as Sentry from '@sentry/node';
import path from 'path';
import Youch from 'youch';
import routes from './routes';
import sentryConfig from './config/sentry';

import './database';

class App {
  constructor() {
    this.server = express();

    Sentry.init(sentryConfig);

    this.middlewares();
    this.routes();
    this.exceptionHandler();
  }

  middlewares() {
    this.server.use(Sentry.Handlers.requestHandler());
    this.server.use(express.json());
    this.server.use(
      '/files',
      express.static(path.resolve(__dirname, '..', 'tmp', 'uploads'))
    );
  }

  routes() {
    this.server.use(routes);
    this.server.use(Sentry.Handlers.errorHandler());
  }

  exceptionHandler() {
    this.server.use(async (err, req, res, next) => {
      const errors = await new Youch(err, req).toJSON();
      return res.status(500).json(errors);
    });
  }
}

export default new App().server;
```

### Environment Variables

Install dotenv:
```
yarn add dotenv
```

In the very first line of `src/app.js` **and** in `src/queue.js`:
```js
import 'dotenv/config';
```

In `src/config/database.js` we can't use the `import` notation (sequelize limitation), then use this:
```js
require('dotenv/config');
```

Edit the `src/app.js` in the `exceptionHandler()` method:
```js
    this.server.use(async (err, req, res, next) => {
      if (process.env.NODE_ENV === 'development') {
        const errors = await new Youch(err, req).toJSON();
        return res.status(500).json(errors);
      }
    return res.status(500).json({ error: 'Internal server error' });
    });
```

This is the `.env.sample`:
```
APP_URL= # src/app/models/File.js
APP_PORT= # src/server.js
NODE_ENV= # src/app.js

# auth
APP_SECRET= # src/config/auth.js

# database - src/config/database.js
DB_HOST=
DB_NAME=
DB_USER=
DB_PASS=


# mongo - src/database/index.js
MONGO_URL=

# redis - src/config/redis.js
REDIS_HOST=
REDIS_PORT=

# email - src/config/mail.js
MAIL_HOST=
MAIL_PORT=
MAIL_USER=
MAIL_PASS=

# sentry dsn (only for production) - src/config/sentry.js
SENTRY_DSN=
```
