# HTTP
[✏️](https://github.com/meleu/my-notes/edit/master/http.md)


## HTTP verbs:

-  `GET http://minhaapi.com/users` - requests something
-  `POST http://minhaapi.com/users` - sends new data
-  `PUT http://minhaapi.com/users/1` - sends data for updating
-  `DELETE http://minhaapi.com/users/1` - requests a deletion


## basic structure of a HTTP request

```
GET http://api.com/company/1/users?page=2
# route -----------^       ^ ^     ^
# route parameter ---------' |     |
# route ---------------------'     |
# query parameters ----------------'
```

The `POST` and `PUT` methods also use the `body` field.

Another commonly used field is the `Header`.


## HTTP Status Codes

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

