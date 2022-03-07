# Chapter 1: Conceitos


## Conceitos do Node

- Permite JavaScript fora do browser.
- v8 + libuv + conjunto de módulos

### Características do Node.js

- Arquitetura Event Loop
    - Call Stack
- Single thread (o event loop)
- Non-blocking I/O
- Módulos próprios
    - http
    - fs
    - etc...


## REST API

- REST: REpresentation State Transfer

- 6 Regras
    1. client-server
    2. stateless
    3. cache
    4. interface uniforme
        1. identificação dos recursos (rotas)
        2. representação dos recursos (JSON)
        3. mensagens auto-descritivas
        4. HATEOAS (Hypertext As The Engine Of Application State)
5. camadas
6. código sob demanda

## Métodos de Requisições - HTTP Verbs

- `GET` - leitura
- `POST` - criação
- `PUT` - atualização
- `DELETE` - deleção
- `PATCH` - atualização parcial


## HTTP Codes

- `1xx` - informativo
- `2xx` - confirmação
    - `200` - sucesso
    - `201` - created
- `3xx` - redirecionamento
    - `301` - moved permanently
    - `302` - moved
- `4xx` - erro do cliente
    - `400` - bad request
    - `401` - unauthorized
    - `403` - forbidden
    - `404` - not found
    - `422` - unprocessable entity
- `5xx` - erro no servidor
    - `500` - internal server error
    - `502` - bad gateway


## Boas práticas REST APIs

1. utilização correta dos métodos HTTP (GET, POST, DELETE...)
2. utilização correta dos status de retorno (200, 404, 502...)
3. padrão de nomeclatura (`dominio/users/1/address`)



## Enviando Dados nas Requisições

- header
- query
- route
- body


