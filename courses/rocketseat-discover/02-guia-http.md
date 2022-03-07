# Guia Estelar de HTTP

<https://app.rocketseat.com.br/node/guia-estelar-de-http>


## Visualizando a comunicação

- <https://app.rocketseat.com.br/node/guia-estelar-de-http/group/entendendo/lesson/visualizando-a-comunicacao>

Uma maneira de visualizar as requisições do browser é usando o netcat e
colocando-o para escutar numa porta. E então colocar o browser para acessar
aquela porta.

Exemplo:
```sh
nc -l 8080
# vai no browser e acessa localhost:8080
# volta no terminal e veja a requisição do browser como foi
```

Outra visualização interessante: pegue o output do netcat acima (que na verdade
é a requisição do browser) e salva numa variável. Em seguida envie esse conteúdo
para google.com, conforme no exemplo abaixo:
```sh
echo "${request}" | nc google.com 80
# veja a resposta do servidor, incluindo os cabeçalhos (Headers)
```

## DevTools & cURL

- <https://app.rocketseat.com.br/node/guia-estelar-de-http/group/entendendo/lesson/visualizando-com-dev-tools>
- <https://app.rocketseat.com.br/node/guia-estelar-de-http/group/entendendo/lesson/visualizando-com-c-url>

```sh
# a opção -i mostra os cabeçalhos
curl -i https://google.com/

# a opção -v (verbose) mostra inclusive informações
# sobre a request que está sendo enviada
curl -v https://google.com/
```

## URI

- <https://app.rocketseat.com.br/node/guia-estelar-de-http/group/uri/lesson/url>

Toda URL é uma URI, mas nem toda URI é uma URL.

Uma URL possui vários componentes.

- Componentes obrigatórios:
    - protocolo
    - domínio
- Componentes opcionais:
    - subdomínio
    - path
    - parâmetros
    - porta
    - âncora