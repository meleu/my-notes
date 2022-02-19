# GoStack Bootcamp

Some notes about what I've been learning in the [GoStack Bootcamp](https://rocketseat.com.br/gostack).

To be honest these notes were not written in a way to be "consumed" by others, but mostly like my personal notes. I'm using a github repo to make it easier to edit/search the notes when working on different computers.

## Table of Contents


### level-01

- [Back-end With NodeJS](01-backend-with-nodejs.md)
    - [Node.js](01-backend-with-nodejs.md#nodejs)
        - [frameworks](01-backend-with-nodejs.md#frameworks)
    - [REST APIs](01-backend-with-nodejs.md#rest-apis)
    - [basic structure of a HTTP request](01-backend-with-nodejs.md#basic-structure-of-a-http-request)
        - [HTTP Codes](01-backend-with-nodejs.md#http-codes)
    - [ExpressJS](01-backend-with-nodejs.md#expressjs)
        - [getting HTTP data from `request`](01-backend-with-nodejs.md#getting-http-data-from-request)
            - [route parameter](01-backend-with-nodejs.md#route-parameter)
            - [query params](01-backend-with-nodejs.md#query-params)
            - [body properties](01-backend-with-nodejs.md#body-properties)
    - [nodemon](01-backend-with-nodejs.md#nodemon)
    - [CRUD](01-backend-with-nodejs.md#crud)
    - [middleware](01-backend-with-nodejs.md#middleware)
    - [CORS](01-backend-with-nodejs.md#cors)





- [Front-end With ReactJS](02-frontend-with-reactjs.md)
    - [Concepts](02-frontend-with-reactjs.md#concepts)
        - [Declarative vs Imperative programming](02-frontend-with-reactjs.md#declarative-vs-imperative-programming)
        - [babel / webpack](02-frontend-with-reactjs.md#babel--webpack)
    - [Starting A React Project From Scratch](02-frontend-with-reactjs.md#starting-a-react-project-from-scratch)
        - [Configuring babel](02-frontend-with-reactjs.md#configuring-babel)
        - [Configuring webpack](02-frontend-with-reactjs.md#configuring-webpack)
        - [Source files](02-frontend-with-reactjs.md#source-files)
    - [Properties](02-frontend-with-reactjs.md#properties)
    - [State and Immutability](02-frontend-with-reactjs.md#state-and-immutability)
    - [Importing CSS and Images](02-frontend-with-reactjs.md#importing-css-and-images)
    - [`useEffect()`](02-frontend-with-reactjs.md#useeffect)




- [Mobile With Reach Native](03-mobile-with-react-native.md)
    - [Concepts](03-mobile-with-react-native.md#concepts)
        - [Syntax](03-mobile-with-react-native.md#syntax)
        - [Expo](03-mobile-with-react-native.md#expo)
    - [React Native Development Environment](03-mobile-with-react-native.md#react-native-development-environment)
    - [Starting a New Project](03-mobile-with-react-native.md#starting-a-new-project)
    - [Snippets](03-mobile-with-react-native.md#snippets)
        - [Hello World](03-mobile-with-react-native.md#hello-world)
        - [Example of `FlatList`](03-mobile-with-react-native.md#example-of-flatlist)



- [TypeScript](04-typescript.md)
    - [Why TypeScript?](04-typescript.md#why-typescript)
    - [Starting a TypeScript project](04-typescript.md#starting-a-typescript-project)
    - [Interface Examples](04-typescript.md#interface-examples)




### level-02


- [Starting With NodeJS and TypeScript](01-starting-with-nodejs-and-typescript.md)
    - [GoBarber layout](01-starting-with-nodejs-and-typescript.md#gobarber-layout)
    - [Project Structure](01-starting-with-nodejs-and-typescript.md#project-structure)
    - [EditorConfig, ESLint and Prettier](01-starting-with-nodejs-and-typescript.md#editorconfig-eslint-and-prettier)
        - [EditorConfig](01-starting-with-nodejs-and-typescript.md#editorconfig)
        - [ESLint](01-starting-with-nodejs-and-typescript.md#eslint)
            - [Node](01-starting-with-nodejs-and-typescript.md#node)
            - [ReactJS](01-starting-with-nodejs-and-typescript.md#reactjs)
            - [React Native](01-starting-with-nodejs-and-typescript.md#react-native)
        - [Prettier](01-starting-with-nodejs-and-typescript.md#prettier)
            - [Solving conflicts between ESLint and Prettier.](01-starting-with-nodejs-and-typescript.md#solving-conflicts-between-eslint-and-prettier)
    - [Debugging in VS Code](01-starting-with-nodejs-and-typescript.md#debugging-in-vs-code)
    - [Appointments](01-starting-with-nodejs-and-typescript.md#appointments)
    - [Validating Dates](01-starting-with-nodejs-and-typescript.md#validating-dates)
    - [Appointment Model](01-starting-with-nodejs-and-typescript.md#appointment-model)
    - [Creating Repositories](01-starting-with-nodejs-and-typescript.md#creating-repositories)
    - [Listing Appointments](01-starting-with-nodejs-and-typescript.md#listing-appointments)
    - [Working With Data - Data Transfer Object](01-starting-with-nodejs-and-typescript.md#working-with-data---data-transfer-object)
    - [The Services Pattern & SOLID](01-starting-with-nodejs-and-typescript.md#the-services-pattern--solid)
    - [Summary](01-starting-with-nodejs-and-typescript.md#summary)
    - [My GoBarber codebase up to this point](01-starting-with-nodejs-and-typescript.md#my-gobarber-codebase-up-to-this-point)
    - [Challenge 5](01-starting-with-nodejs-and-typescript.md#challenge-5)




- [Backend - Database](02.1-backend-database.md)
    - [DataBase Abstractions](02.1-backend-database.md#database-abstractions)
    - [docker](02.1-backend-database.md#docker)
        - [concepts: ](02.1-backend-database.md#concepts-)
    - [Creating a PostgreSQL Container](02.1-backend-database.md#creating-a-postgresql-container)
        - [DB Clients](02.1-backend-database.md#db-clients)
    - [Configuring TypeORM](02.1-backend-database.md#configuring-typeorm)
    - [Creating the Appointments Table](02.1-backend-database.md#creating-the-appointments-table)
    - [Creating the Appointment Model](02.1-backend-database.md#creating-the-appointment-model)
    - [TypeORM Repositories](02.1-backend-database.md#typeorm-repositories)
    - [Summary](02.1-backend-database.md#summary)
    - [My GoBarber codebase up to this point](02.1-backend-database.md#my-gobarber-codebase-up-to-this-point)



- [Backend - Registering Users](02.2-backend-registering-users.md)
    - [User's Model and Migration](02.2-backend-registering-users.md#users-model-and-migration)
    - [Relations in the Models](02.2-backend-registering-users.md#relations-in-the-models)
    - [Route to Create Users](02.2-backend-registering-users.md#route-to-create-users)
    - [Encrypting the Password](02.2-backend-registering-users.md#encrypting-the-password)
    - [Summary](02.2-backend-registering-users.md#summary)
    - [Need More Understanding](02.2-backend-registering-users.md#need-more-understanding)
    - [My GoBarber codebase up to this point](02.2-backend-registering-users.md#my-gobarber-codebase-up-to-this-point)



- [Backend - Authentication](02.3-backend-authentication.md)
    - [JWT Concepts](02.3-backend-authentication.md#jwt-concepts)
    - [Validating Credentials](02.3-backend-authentication.md#validating-credentials)
    - [Generating a Token](02.3-backend-authentication.md#generating-a-token)
    - [Authenticated Routes / Authentication Middleware](02.3-backend-authentication.md#authenticated-routes--authentication-middleware)
    - [Summary](02.3-backend-authentication.md#summary)
    - [My GoBarber codebase up to this point](02.3-backend-authentication.md#my-gobarber-codebase-up-to-this-point)




- [Backend - Images Upload](02.4-backend-images-upload.md)
    - [File Upload](02.4-backend-images-upload.md#file-upload)
        - [Handling Uploads](02.4-backend-images-upload.md#handling-uploads)
        - [Create the `avatar` field for Users](02.4-backend-images-upload.md#create-the-avatar-field-for-users)
    - [Updating the Avatar](02.4-backend-images-upload.md#updating-the-avatar)
    - [Serving Static Files](02.4-backend-images-upload.md#serving-static-files)
    - [Summary](02.4-backend-images-upload.md#summary)
    - [My GoBarber codebase up to this point](02.4-backend-images-upload.md#my-gobarber-codebase-up-to-this-point)


- [Backend - Handling Exceptions](02.5-backend-handling-exceptions.md)
    - [Creating the AppError Class](02.5-backend-handling-exceptions.md#creating-the-apperror-class)
    - [Dealing with Errors](02.5-backend-handling-exceptions.md#dealing-with-errors)
    - [Summary](02.5-backend-handling-exceptions.md#summary)
    - [My GoBarber codebase up to this point](02.5-backend-handling-exceptions.md#my-gobarber-codebase-up-to-this-point)


- [GoBarber Backend Summary](02.99-gobarber-backend-summary.md)
    - [Development Environment](02.99-gobarber-backend-summary.md#development-environment)
    - [GitHub Repository](02.99-gobarber-backend-summary.md#github-repository)
    - [Kickstarting the Code](02.99-gobarber-backend-summary.md#kickstarting-the-code)
        - [EditorConfig](02.99-gobarber-backend-summary.md#editorconfig)
        - [ESLint](02.99-gobarber-backend-summary.md#eslint)
            - [Node](02.99-gobarber-backend-summary.md#node)
        - [Prettier](02.99-gobarber-backend-summary.md#prettier)
            - [Solving conflicts between ESLint and Prettier.](02.99-gobarber-backend-summary.md#solving-conflicts-between-eslint-and-prettier)
    - [Debugging in VS Code](02.99-gobarber-backend-summary.md#debugging-in-vs-code)
    - [Docker & Data Base](02.99-gobarber-backend-summary.md#docker--data-base)
    - [TypeORM](02.99-gobarber-backend-summary.md#typeorm)
    - [Users](02.99-gobarber-backend-summary.md#users)
        - [API Endpoints](02.99-gobarber-backend-summary.md#api-endpoints)
        - [Registering Users](02.99-gobarber-backend-summary.md#registering-users)
        - [Handling Errors](02.99-gobarber-backend-summary.md#handling-errors)
        - [Password Encryption](02.99-gobarber-backend-summary.md#password-encryption)
        - [Authentication](02.99-gobarber-backend-summary.md#authentication)
            - [Requesting a Token](02.99-gobarber-backend-summary.md#requesting-a-token)
            - [Authentication Middleware](02.99-gobarber-backend-summary.md#authentication-middleware)
    - [Updating The Avatar](02.99-gobarber-backend-summary.md#updating-the-avatar)
        - [Upload The File](02.99-gobarber-backend-summary.md#upload-the-file)
        - [Updating the `avatar` field](02.99-gobarber-backend-summary.md#updating-the-avatar-field)
    - [Appointments](02.99-gobarber-backend-summary.md#appointments)
        - [Appointments Table](02.99-gobarber-backend-summary.md#appointments-table)
        - [Appointments Model](02.99-gobarber-backend-summary.md#appointments-model)
        - [Appointments Repository](02.99-gobarber-backend-summary.md#appointments-repository)
        - [CreateAppointmentService](02.99-gobarber-backend-summary.md#createappointmentservice)


- [Challenge 6](03-backend-challenge.md)
    - [Random Notes](03-backend-challenge.md#random-notes)




### level-03


- [React - First Project](01-react-first-project.md)
    - [Starting the Project](01-react-first-project.md#starting-the-project)
    - [Editor Config](01-react-first-project.md#editor-config)
    - [ESLint](01-react-first-project.md#eslint)
        - [Prettier](01-react-first-project.md#prettier)
            - [Solving conflicts between ESLint and Prettier.](01-react-first-project.md#solving-conflicts-between-eslint-and-prettier)
    - [Creating Routes](01-react-first-project.md#creating-routes)
    - [Using Styled Components](01-react-first-project.md#using-styled-components)
    - [Styling the Dashboard](01-react-first-project.md#styling-the-dashboard)
    - [Connecting the API](01-react-first-project.md#connecting-the-api)
    - [Handling Errors](01-react-first-project.md#handling-errors)
    - [Saving Data in the localStorage](01-react-first-project.md#saving-data-in-the-localstorage)
    - [Browsing Between Routes](01-react-first-project.md#browsing-between-routes)
    - [Styling Details](01-react-first-project.md#styling-details)
    - [Listing Issues](01-react-first-project.md#listing-issues)


- [React - Pages Structure](02.1-frontend-pages.md)
    - [Starting the Project](02.1-frontend-pages.md#starting-the-project)
        - [Editor Config](02.1-frontend-pages.md#editor-config)
        - [ESLint](02.1-frontend-pages.md#eslint)
        - [Prettier](02.1-frontend-pages.md#prettier)
        - [`.eslintrc.json`](02.1-frontend-pages.md#eslintrcjson)
        - [Solving conflicts between ESLint and Prettier.](02.1-frontend-pages.md#solving-conflicts-between-eslint-and-prettier)
    - [Global Styles](02.1-frontend-pages.md#global-styles)
    - [Login Page](02.1-frontend-pages.md#login-page)
    - [Isolating Components](02.1-frontend-pages.md#isolating-components)
    - [Sign Up Page](02.1-frontend-pages.md#sign-up-page)
    - [Using Unform](02.1-frontend-pages.md#using-unform)
    - [Input Usability](02.1-frontend-pages.md#input-usability)
    - [Validating Input](02.1-frontend-pages.md#validating-input)
    - [Showing the Validation Errors](02.1-frontend-pages.md#showing-the-validation-errors)
    - [Creating Errors' Tooltips](02.1-frontend-pages.md#creating-errors-tooltips)
    - [Validating Login](02.1-frontend-pages.md#validating-login)


