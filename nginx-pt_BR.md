# NginX
[✏️](https://github.com/meleu/my-notes/edit/master/nginx-pt_BR.md)

## Introdução

**Importante**: Esse é um resumo bem "grosseiro" do que eu venho aprendendo sobre NginX. Isso aqui não é um texto escrito com o objetivo de "ensinar", é mais um resumo bastante pessoal dos meus estudos. Não me preocupei muito em deixar tudo bem explicadinho.

**Importante 2**: tudo que estou explicando aqui foi feito no Ubuntu Server 18.04. No entanto isso não deve ser de grande relevância (exceto o uso de `apt-get` de vez em quando).

O [NginX.org](https://nginx.org) (ponto org) é o site onde encontramos informações sobre a versão Open Source do NginX. O [Nginx.com](https://nginx.com) (ponto com) é um site onde o(s) criador(es) do NginX vendem o NginX Plus e oferecem outros serviços (nunca investiguei a fundo que serviços são esses).

Apesar de serem sites diferentes, algumas informações valiosas sobre a versão open source do NginX podem ser encontradas no NginX **.com**.


## Instalando

- `apt-get`
- from source
- docker

### via `apt-get`

É possível instalar via `apt-get`, não vou descrever esse processo aqui mas recomendo um doc bacaninha sobre instalação do NginX no Ubuntu 18.04 disponível no [site da Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-18-04)).

### from source

Percebo que power users do NginX costumam compilar o código fonte para ter um maior controle das customizações e dos módulos que serão utilizados (yeah, pra lembrar os velhos tempos do slackware lá do final dos anos 90).

Baixar o código fonte em [http://nginx.org/en/download.html](http://nginx.org/en/download.html) e seguir as instruções do readme.

Provavelmente será necessário instalar algumas bibliotecas:
```
sudo apt-get install libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev
```


Se vamos usar o nginx apenas como servidor web (nada referente a email, por exemplo), pode ser uma boa ideia fornecer algumas flags ao `./configure`, por exemplo:

```
--without-mail_pop3_module --without-mail_smtp_module --without-mail_imap_module --without-http_uwsgi_module --without-http_scgi_module
```

**Nota**: Um módulo interessante para agir como WAF (Web Application Firewall) é o [NAXSI](https://github.com/nbs-system/naxsi). É um método meio "grosseirão" de proteção, mas na correria pode ajudar.

Algumas opções interessantes para usar com o nginx:
```
  -V            : show version and configure options then exit
  -t            : test configuration and exit
  -s signal     : send signal to a master process: stop, quit, reopen, reload
  -c filename   : set configuration file (default: /etc/nginx/nginx.conf)
```


### Iniciar NginX durante o boot com systemd

Para iniciar o NginX via systemd, crie o seguinte arquivo (obtido do [nginx.com](https://www.nginx.com/resources/wiki/start/topics/examples/systemd/)) - **ATENÇÃO**: não se esqueça de fazer as adaptações necessárias no caminho dos arquivos!:
```
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

Após certificar-se que os caminhos dos arquivos na conf acima estão todos corretos, vamos abilitar o serviço para iniciar no boot:
```
sudo systemctl enable nginx
```

### Usando NginX via docker

**Atenção**: o único interesse que tive de usar o NginX via docker foi para estudar/testar as configurações. Não cheguei a estudar "como usar NginX via docker em produção".

Antes de tudo você precisa ter o docker instalado. Faça isso seguindo as orientações em [https://docs.docker.com/install/](https://docs.docker.com/install/), e não esquecer de seguir as orientações de post-install.

Passo a passo rápido e rasteiro de como instalar/usar um container com NginX para praticar e testar as configs que veremos aqui:
```
docker run \
  --name learnNginX \
  --volume /home/meleu/src/htdocs:/usr/share/nginx/html:ro \
  --publish 80:80
  --detach \
  nginx 
```
O comando acima vai fazer o seguinte:
- criar um container chamado `learnNginX`;
- instalar a imagem `nginx`, descrita em [https://hub.docker.com/\_/nginx](https://hub.docker.com/_/nginx);
- fazer com que o diretório `/usr/share/nginx/html` do container, na verdade seja o meu diretório `/home/meleu/src/htdocs` do sistema hospedeiro;
- a porta 80 do hospedeiro vai ser redirecionada para a porta 80 do container (**OBS.**: se usar portas diferentes pode bugar na hora de um redirecionamento);
- o container será executado desacoplado do terminal (_detached_).

Para que possamos editar as configs do nginx no container, vamos precisar iniciar um shell nele e instalar um editor de texto (no meu caso é o `vim`):
```
# iniciar o container de maneira interativa e executar o bash
docker exec -it learnNginX bash

# uma vez "logado" no container, instalar o vim
apt-get update && apt-get install -y vim

# uma vez instalado o vim, podemos editar a config do nginx:
vim /etc/nginx/nginx.conf

# após uma edição, salvar o arquivo e reiniciar o nginx:
nginx -s reload
```

Agora só um breve resuminho de comandos do docker que acho úteis 
```
# listar containers ativos
docker ps

# lista de containers disponíveis na sua maquina
docker ps -a

# inicia containerName
docker start containerName

# inicia containerName acoplado ao seu terminal (no caso
# do nginx, útil para visualizar logs em tempo real)
docker start containerName -a

# encerra containerName
docker stop containerName

# exibe os logs de containerName (no nosso caso do nginx, vai
# exibir o conteúdo de `error.log` em stderr e `access.log` em stdout)
docker logs containerName   # exibe os logs de containerName

# inicia uma sessão interativa no container e executa o bash
docker exec -it containerName bash

# deleta containerName (USE COM CUIDADO! NÃO TEM VOLTA!)
docker container rm containerName

# executa um processo em um novo container
docker run
```

## Conceitos básicos

Uma coisa básica e de extrema importância é entender os seguintes termos:

1. Directive
2. Context

Isso é importante pois são termos extensivamente utilizados na documentação.

### Directive

Trata-se basicamente de um nome e (pelo menos) um valor. Exemplo:
```
server_name mydomain.com
```

Cada diretiva tem um significado especial, [e aqui](http://nginx.org/en/docs/dirindex.html) podemos ver uma lista extensiva de todas elas.

Outra coisa importante de mencionar, é que existem 3 tipos de diretivas:
1. Normais (standard)
2. Array
3. Action

Vou tentar resumir abaixo, mas também achei essa explicação aqui razoavelmente boa: [https://www.javatpoint.com/nginx-directive-and-context](https://www.javatpoint.com/nginx-directive-and-context)

#### Diretivas Normais

- Apenas uma declaração por contexto (duplicações são consideradas inválidas).
- São herdadas pelos contextos filhos.
- Novas declarações em contextos filhos sobrescrevem a declaração anterior.

Exemplo:
```
    gzip on;  
    gzip off; # isso vai bugar: "gzip" directive is duplicate
      
    server {  
      location /downloads {  
        gzip off;  # sobrescrevendo a configuração feita acima
      }  
      
      location /assets {  
        # gzip is in here  
      }  
    }
```

#### Diretivas Array

- Pode ser declarada várias vezes sem sobrescrever declarações anteriores (exceto no contexto filho - ver abaixo).
- Herdado por contextos filhos.
- Declarações em contextos filhos **sobrescrevem declarações herdadas**.

Exemplo
```
    error_log /var/log/nginx/error.log;  
    error_log /var/log/nginx/error_notive.log notice;  
    error_log /var/log/nginx/error_debug.log debug;  
      
    server {  
      location /downloads {  
        # this will override all the parent directives  
        error_log /var/log/nginx/error_downloads.log;  
      }  
    }
```

#### Diretivas de Ação

- São diretivas que retornam algo, finalizando a "execução" da análise da config, ou reiniciam a análise com a requisição reescrita.
- Herança não faz sentido, pois o "fluxo de análise" é interrompido.

Exemplo:
```
    server {
      location / {
        return 200;
        return 404; # <-- essa linha jamais será executada
      }
    }
```

**OBSERVAÇÃO**: a diretiva `rewrite` normalmente é uma diretiva de ação, mas se ela não conseguir "levar a location algum", o fluxo de análise vai simplesmente continuar. Eu falo mais sobre `rewrite` mais abaixo.

### Context

São os blocos onde as diretivas ficam.

Pense em contexto como se fossem o escopo dos blocos de comandos nas linguagens de programação.

Um contexto dentro de outro é chamado de contexto filho, e o filho herda as declarações feitas no contexto pai. Bem como, nas linguagens de programação, um bloco de código interno também visualiza as variáveis declaradas pelo bloco pai.

Exemplo de contexto (nesse caso chamado de "contexto http"):
```
http {
  # aqui vão as diretivas...
}
```

## Configuração Básica

- [listen doc](https://nginx.org/en/docs/http/ngx_http_core_module.html#listen)
- [server_name doc](https://nginx.org/en/docs/http/ngx_http_core_module.html#server_name)
- [root doc](https://nginx.org/en/docs/http/ngx_http_core_module.html#root)
- [include doc](https://nginx.org/en/docs/ngx_core_module.html#include)

Provavelmente o arquivo de configuração estará em `/etc/nginx/nginx.conf`.

A configuração mais básica possível:
```
events {} # o contexto events é necessário

http {
  server {
    listen 80;
    server_name meudominio.com; # também aceita endereço IP e asterisco como coringa
    root /path/to/html/files
  }
}
```

Uma vez concluída a config é interessante testar se a sintaxe está ok:
```
nginx -t
```

E para reiniciar o nginx sem _downtime_, prefira usar:
```
sudo systemctl reload nginx
```
Ou seja: use `reload` no lugar de `restart`.

E No caso de estar fazendo os testes usando o docker container:
```
nginx -s reload
```

Os arquivos html devem estar no `/path/to/html/files` (mude isso para o caminho que você quiser).

**TODO**: adicionar aqui um link para um página bem simples com um CSS basicão, uma imagem e talvez um JavaScript.

**Observação**: se tentarmos hospedar uma página com um CSS em um arquivo externo e tentarmos acessar essa página no via browser, veremos que com aquela config basicona do nginx não permite que o seu browser entenda o CSS (a página vai mostrar apenas o HTML bruto)
Para resolver isso vamos importar/incluir um arquivo que já vem pronto quando instalamos o nginx. Normalmente esse arquivo fica em `/etc/nginx/mime.types`. Portanto basta usarmos um `include` para ajeitar esse problema:
```
  server {
    include mime.types; # considerando que nginx.conf e mime.types estão no mesmo dir
    # ...
  }
```

**TESTE**:
Reinicie o nginx e faça o teste novamente pelo seu browser.


## Blocos location

- [location doc](http://nginx.org/en/docs/http/ngx_http_core_module.html#location)
- [return doc](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return)
- [HTTP status codes](https://restapitutorial.com/httpstatuscodes.html)

Exemplo de um "Hello World!":
```
events {} # o contexto events é necessário

http {
  include mime.types;

  server {
    listen 80;
    server_name 127.0.0.1;

    root /usr/share/nginx/html;

    location /hello {
      return 200 "Hello World!\n";
    }
  }
}
```

**Importante**: na config acima qualquer URI **que comece** com `/hello` vai retornar a mesma coisa (status 200 e string `Hello World\n`).

**TESTE**:
```
$ curl http://localhost/hello
Hello World!
$ curl http://localhost/helloworld
Hello World!
$ curl http://localhost/helloAnything
Hello World!
```

Para um controle melhor do `location` usamos alguns modificadores, a saber:

1. `location = URI` - localização exata
2. `location ^~ URI` - prefixo preferencial
3. `location ~ RegEx` ou `location ~* RegEx` - aceita RegEx, use `~*` para case insensitive.
4. `location URI` - prefixo

A prioridade de qual `location` será resolvida primeiro é exatamente a ordem listada acima.

**Observações**:
- a notação `^~` não envolve RegEx (o uso do til `~` pode causar esta impressão).
- a notação "sem nada" e a notação `^~` fazem a mesmíssima coisa, no entanto a notação `^~` existe única e exclusivamente para fazer com que o prefixo tenha prioridade acima do RegEX (modificadores `~` e `~*`).

Um exemplo "bobo" para testes:
```
events {}

http {

  include mime.types;

  server {

    listen 80;
    server_name 127.0.0.1;
    root /usr/share/nginx/html;

    # Preferential Prefix match
    location ^~ /Greet2 {
      return 200 'Hello from NGINX "/greet" location.';
    }

    # # Exact match
    # location = /greet {
    #   return 200 'Hello from NGINX "/greet" location - EXACT MATCH.';
    # }

    # # REGEX match - case sensitive
    # location ~ /greet[0-9] {
    #   return 200 'Hello from NGINX "/greet" location - REGEX MATCH.';
    # }

    # REGEX match - case insensitive
    location ~* /greet[0-9] {
      return 200 'Hello from NGINX "/greet" location - REGEX MATCH INSENSITIVE.';
    }
  }
}
```

## Variáveis

O NginX fornece algumas variáveis úteis. A lista completa pode ser vista em [http://nginx.org/en/docs/varindex.html](http://nginx.org/en/docs/varindex.html).

Algumas que já usei e achei úteis:
- `$scheme` - diz se requisição é http, https, etc.
- `$request_method` - método HTTP utilizado (GET, POST, PUT, etc.).
- `$binary_remote_addr` - endereço IP do cliente.
- `$host` - o domínio/IP do servidor.
- `$request_uri` - a URI que foi requisitada.
- `$uri` - a URI sendo acessada (pode ser diferente de `$request_uri` se tiver passado por um `rewrite`).
- `$args` - mostra toda a query string passada na URI. Exemplo: se a URI é `/hello?name=meleu&age=18`, então `$args` vale `name=meleu&age=18`.
- `$arg_argname` - **importante**: qualquer variável iniciando com `arg_` é uma referência à variável fonecida como parâmetro na URI. Exemplo: se a URI é `/hello?name=meleu`, então `$arg_name` vale `meleu`.


## Redirecionamento

- [return doc](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#return)
- [HTTP status codes](https://restapitutorial.com/httpstatuscodes.html)

Muito simples:
```
location /something {
  return 301 /something-else;
}
```

O cliente será efetivamente redirecionado para `/something-else`.

Acredito que qualquer status code 3xx vai funcionar, mas só testei com 301 (Moved Permanently) e 307 (Temporary Redirect).

É comum websites redirecionarem tudo que chega via http (porta 80) para https (porta 443):
```
  # Redirect all traffic to HTTPS
  server {
    listen 80;
    server_name mydomain.com;
    return 301 https://$host$request_uri;
  }

  server { # para usar https é necessário certificado, domínio próprio, etc.
    listen 443 ssl http2;
    server_name mydomain.com;
    # ...
  }
```


## Rewrite

- [rewrite doc](http://nginx.org/en/docs/http/ngx_http_rewrite_module.html#rewrite)

Formato:
```
rewrite RegEx replacement [flag];
```

Explicando com um exemplo:
```
rewrite ^/logo$ /images/logo.png;
```

Desta forma, quando o cliente tentar acessar `/logo` ele receberá o conteúdo de `/images/logo.png` e nem perceberá esse fato (portanto isso **não é um redirecionamento**).

**Diferença entre redirecionamento e rewrite**:
- redirecionamento é feito no lado do cliente, rewrite é feito no lado do servidor.
- o redirecionamento diz ao cliente para acessar um outro recurso, o rewrite pega esse outro recurso e já fornece ao cliente.
- o redirecionamento muda a URL na barra de endereços do browser, o rewrite não faz isso (tudo é processado no lado do servidor).


**Observação**: após um `rewrite`, a nova URI (já reescrita) será reavaliada dentro do contexto onde o `rewrite` foi feito.

Um exemplo um pouquinho mais elaborado:
```
rewrite `^/user/(.*) ^/user.php?id=$1 last;
```

O exemplo a seguir é hipotético e serve apenas para ilustrar como que o `rewrite` dentro de um contexto, só consegue enxergar os `location`s que estão dentro do mesmo contexto.
```
events {}

http {
  server {
    listen 80;
    server_name 127.0.0.1;
    root /usr/share/nginx/html;

    rewrite ^/[^fb] /foobar;

    location /foobar {
      rewrite ^ /f; # <-- ao chegar aqui pula direto para 'location ~ /f'
      rewrite ^ /b;
      return 200 '/foobar: $uri\n'; # <-- só é executado se não existir os locations abaixo

      location ~ /f { # <-- se não existisse esse location, o 'rewrite ^ /b' seria executado
        return 200 '/foobar -> /f: $uri\n';
      }

      location ~ /b {
        return 200 '/foobar -> /b: $uri\n';
      }
    }

    location = /f { # <-- nunca será acessado por um rewrite dentro de /foobar
      return 200 '/f: $uri\n';
    }
    
    location = /b {
      return 200 '/b: $uri\n';
    }
  }
}
```

**TESTE**:
```
$ curl http://localhost/anything
/foobar -> /f: /foobar
$ curl http://localhost/f
/f: /f
$ curl http://localhost/b
/b: /b
```

## try_files

- [try_files doc](http://nginx.org/en/docs/http/ngx_http_core_module.html#try_files)

Sintaxe:
```
try_files file1 file2 uri;
try_files file1 fileN =status_code;
```

O `try_files` geralmente é usado dentro de um contexto `location`, e ele vai tentar encontrar os arquivos passados como parâmetro, tomando como caminho inicial aquele que foi declarado na diretiva `root`.

Exemplo hipotético:
```
root /path/to/html;

location /logo {
  try_files /images/logo.png /images/thumb.png =404;
}
```

Isso fará que quando o cliente requisitar `/logo`, o nginx vai tentar encontrar `/path/to/html/images/logo.png` se obtiver sucesso esse arquivo será retornado, em caso de falha o nginx vai tentar o(s) arquivo(s) seguinte(s). Se o último argumento começa com `=`, então o que vem a seguir é um HTTP status code (normalmente 404).

**OBSERVAÇÃO**: o último argumento do `try_files` sempre se comporta como uma URI passada para um `rewrite`. Ou seja, o último argumento será reavaliado pelo nginx como se fosse uma requisição naquela URI (ou seja, não necessariamente será um arquivo dentro de `root`).

**DICA**: Uma configuração comum de se ver em servidores com PHP
```
location ~ \.php$ {
  try_files $uri $uri/ =404;
}
```

Veremos isso no exemplo de "named locations" na seção seguinte...

Para mais detalhes ver a documentação.


## Named Locations

- [location doc](http://nginx.org/en/docs/http/ngx_http_core_module.html#location)

Um named location nada mais é do que um `location` com um arroba `@` no começo. Assim:
```
location @nome {
  # ...
}
```

Um named location né uma maneira de fazer um `rewrite` ir direto para um `location` desejado.

Exemplo:
```
events {}

http {
  include mime.types;

  server {
    listen 80;
    server_name 127.0.0.1;
    root /usr/share/nginx/html;

    try_files $uri /cat.png /greet @friendly_404;

    location @friendly_404 { # <-- isso é um named location
      return 404 "Sorry, that file could not be found.";
    }

    location /greet {
      return 200 "Hello User";
    }
  }
}
```

As requisições com `@named_locations` não são reavaliadas. Ou seja, quando um `rewrite` ou um `try_files` quer acessar um named location, o nginx "pula direto" para o location desejado.



## Worker Processes e Worker Connections

- [worker_processes doc](http://nginx.org/en/docs/ngx_core_module.html#worker_processes)
- [worker_connections doc](http://nginx.org/en/docs/ngx_core_module.html#worker_connections)

Para deixar todos os cores da sua CPU disponíveis para o nginx, é interessante configurar o `work_processes` para um valor identico ao número de cores que você tem disponível (esse número pode ser obtido através do comando `nproc` ou do `lscpu`). Para garantir, o mais fácil é simplesmente usar `auto`:
```
worker_processes auto;
```

O `worker_connections` determina o número máximo de conexões simultâneas que cada worker process pode abrir. Uma boa maneira de que número usar é checando o limite máximo de número de open files que o sistema suporta. Esse número pode ser obtido com `ulimit -n`.

A diretiva `worker_connection` deve ser declarada dentro do contexto `events`:
```
events {
  worker_connections 1024;
}
```
}

## Comprimindo dados com gzip

```
gzip on;
gzip_comp_level 3; # <-- valor maior que 3 prejudica a performance sem muito ganho no tamanho do arquivo
gzip_types text/css; # <-- adicionar outros, como javascript, etc.
```

Para testar, compare uma requisição "normal" com uma requisição aceitando compressão:
```
# normal
curl host/file.css

# aceitando compressão
curl -H "Accept-Encoding: gzip, deflate" host/file.css
```

## Segurança Básica

- [server_tokens doc](http://nginx.org/en/docs/http/ngx_http_core_module.html#server_tokens)
- [add_header doc](http://nginx.org/en/docs/http/ngx_http_headers_module.html#add_header)

```
# não exibe vesão do nginx no cabeçalho, nem na página de 404
server_tokens off;

# não permite que sites externos façam <iframe> do seu site
add_header X-Frame-Options "SAMEORIGIN";

# prevenir Cross-site scripting (XSS)
add_header X-XSS-Protection "1; mode=block";
```

## Autenticação básica (estilo .htpasswd)

Uma autenticação bem bobinha, no estilo do `.htpasswd` do Apache, que mostra um popup pedindo usuário e senha.

Instalar pacote `apache2-utils`, para ter o aplicativo `htpasswd`:
```
apt-get install apache2-utils
```

E então configurar seguindo esse exemplo:
```
sudo htpasswd -c /etc/nginx/.htpasswd USERNAME
# vai pedir uma senha...
```

É interessante dar uma conferida em /etc/nginx/.htpassd para confirmar se o arquivo foi criado corretamente.

Em seguida adicionar ao `nginx.conf`:
```
location /admin {
  auth_basic "Secure Area";
  auth_basic_user_file /etc/nginx/.htpasswd;
  # ...
}
```

## Rate Limiting

Esse é um assunto bem interessante e pra ser sincero foi um dos recursos que me fez cair de amores pelo NginX...

Primeiro temos que definir como será a zona com taxa de requisição limitada. No exemplo a seguir vamos criar uma zona, limitada por IP do cliente, chamada de `RateLimitZone` com 10 megabytes para lidar com esse recurso. E a taxa de limitação é de 60 requisições por minuto (equivalente a uma requisição por segundo):
```
http {
  # ...
  limit_req_zone $binary_remote_addr zone=RateLimitZone:10m rate=60r/m;
  # ...
}
```

Até então nada de diferente acontece. Para efetivamente ativar essa limitação, temos que "chamar" a zona que definimos acima usando a diretiva `limit_req`. Exemplo:
```
location / {
  limit_req zone=RateLimitZone;
  # ...
}
```

Com essa configuração, se um determinado IP solicitar várias requisições em menos de um segundo, apenas a primeiro requisição será processada e todas as outras serão rejeitadas (receberão o status 503 - Service Unavailable). Novas requisições só serão aceitas após um segundo ou após o término da primeira (o que vier primeiro).

**Observação**: a taxa de uma requisição por segundo só faz realmente sentido se a requisição levar mais de um segundo para ser processada. Ou seja, se o nginx é capaz de entregar uma resposta ao cliente em menos de um segundo, ele **NÃO** vai ficar ocioso esperando completar um segundo para só então aceitar uma nova requisição. Se ele está livre, ele aceita novas requisições. Em outras palavras: o NginX nunca quer ficar ocioso. Ele nunca vai recusar requisições a troco de nada.

Vamos ver a mágica acontecendo usando um exemplo prático:
```
events {
}

http {

  include mime.types;

  # definindo uma zona com taxa de requisição limitada por endereço IP do cliente
  limit_req_zone $binary_remote_addr zone=RateLimitZone:10m rate=60r/m;

  # Redirect all traffic to HTTPS
  server {
    listen 80;
    server_name 127.0.0.1;
    root /usr/share/nginx/html;

    location / {
      limit_req zone=RateLimitZone;
      try_files $uri $uri/ =404;
    }
  }
}
```

Para que as requisições demorassem bem e os testes ficassem mais realistas, eu criei um arquivo chamado `video.mp4` com aproximadamente 1 gigabyte.

Para realizar testes vamos usar o `siege` (instalável via `apt-get`). No exemplo abaixo vamos disparar 10 requisições simultâneas (`-c 10`) apenas uma vez (`-r 1`):
```
$ siege -v -r 1 -c 10 http://localhost/thumb.png
HTTP/1.1 503   0.00 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 200   0.38 secs: 1030842709 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.06 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.06 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.06 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.06 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.06 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.06 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.06 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 200   0.48 secs: 1030842709 bytes ==> GET  /video.mp4
```

No output acima observamos que a primeiro requisição levou 0.38 segundos para ser finalizada, e todas as requisições com tempo menor que esse receberam 503.

Outras configs úteis a serem usadas na hora de "chamar" a zona de limitação, são `burst=` e `nodelay`.

O `burst` serve para você criar uma espécie de fila para que as requisições fiquem esperando, ao invés de receberem 503 logo de cara.

Por exemplo, com um `rate=1r/s` (uma requisição/segundo) e um `burst=5`, se o nginx receber uma rajada de 10 requisições, ele vai fazer o seguinte:
- processar a primeira requisição
- enfileirar as próximas 5
- as 4 requisições finais receberão 503
- a fila de requisições será processada numa taxa de uma por segundo
- cada vez que uma requisição da fila é processada uma vaga na fila é liberada

Você vai ver isso na prática. Basta usarmos o mesmo arquivo de configuração acima, porém adicionando a opção `burst` na linha do `limit_req`:
```
    location / {
      limit_req zone=RateLimitZone burst=5;
      # ...
    }
```

Testando com siege:
```
$ siege -v -r 1 -c 10 http://localhost/video.mp4
HTTP/1.1 200   0.44 secs: 1030842709 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.07 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.06 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.07 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 200   1.44 secs: 1030842709 bytes ==> GET  /video.mp4
HTTP/1.1 200   1.54 secs: 1030842709 bytes ==> GET  /video.mp4
HTTP/1.1 200   2.53 secs: 1030842709 bytes ==> GET  /video.mp4
HTTP/1.1 200   3.42 secs: 1030842709 bytes ==> GET  /video.mp4
HTTP/1.1 200   4.47 secs: 1030842709 bytes ==> GET  /video.mp4
HTTP/1.1 200   5.44 secs: 1030842709 bytes ==> GET  /video.mp4
```

Observe o tempo que cada requisição bem sucedida tem aproximadamente um segundo de intervalo entre uma e outra. Isso ocorreu pois o nginx colocou as requisições na fila e foi processando uma a uma numa taxa de uma por segundo.

A opção `nodelay` só funciona junto com a opção `burst` e serve para dizer ao NginX que a fila deve ser processada _as fast as possible_

Vamos testar alterando esse trecho da nossa config:
```
    location / {
      limit_req zone=RateLimitZone burst=5 nodelay;
      # ...
    }
```

Vejamos o resultado do siege:
```
$ siege -v -r 1 -c 10 http://localhost/video.mp4
HTTP/1.1 200   0.77 secs: 1030842709 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.17 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.23 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.24 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 503   0.39 secs:     197 bytes ==> GET  /video.mp4
HTTP/1.1 200   1.43 secs: 1030842709 bytes ==> GET  /video.mp4
HTTP/1.1 200   1.80 secs: 1030842709 bytes ==> GET  /video.mp4
HTTP/1.1 200   2.06 secs: 1030842709 bytes ==> GET  /video.mp4
HTTP/1.1 200   1.23 secs: 1030842709 bytes ==> GET  /video.mp4
HTTP/1.1 200   2.36 secs: 1030842709 bytes ==> GET  /video.mp4
```

Observe como que as requisições foram resolvidas muito mais rápido. Isso ocorreu pois elas foram "executadas" de maneira concorrente.


## TODO: FastCGI caching

## TODO: HTTP2
