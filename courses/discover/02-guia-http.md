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