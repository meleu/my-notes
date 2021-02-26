# DevOps Ninja: Docker, Kubernetes e Rancher

- <https://www.udemy.com/course/devops-mao-na-massa-docker-kubernetes-rancher>
- github repo: <https://github.com/jonathanbaraldi/devops>

## Containers

### Docker

Permite implantação de aplicativos dentro de containers.

Similar a uma máquina virtual, no entanto o kernel é compartilhado. Ou seja, não há necessidade do overhead de ter toda uma stack de sistema operacional rodando na memória da máquina host.

- Container: virtualiza o sistema operacional.
- Máquina Virtual: virtualiza o hardware.

A ideia é que cada container rode apenas a aplicação ou serviço e que seus dados importantes fiquem persistidos fora do container, tornando possível que o container seja descartável (destruir/recriar o container sem comprometer a integridade da instalação da aplicação/serviço).

> Dúvida:
> O que é um pod?
> Resposta: containers que trabalham em conjunto.

"Um dos gravíssimos erros é ver o pessoal migrar suas aplicações com imagens gigantescas com vários gigas para containers e achar que vai deixar aquilo ligado eternamente. Container não é pra isso. Container é feito para nascer e morrer rápido."
- Jonathan Baraldi

#### Por que usar containers?

- Implementação rápida de aplicativos.
- Portabilidade entre máquinas.
- Controle de versão e reutilização de componentes.
- Imagens otimizadas.
- Compartilhamento de imagens.
- Manutenção simplificada.


### Rancher

O Rancher é um software open source que conecta um conjunto de softwares necessários para o gerenciamento e orquestração de containers via web.

O Rancher aceita tanto hosts Linux de numvem pública, nuvem privada, servidores físicos ou máquinas virtuais, o Rancher não faz distinção em seu uso, implementando uma camada de serviços de infra-estrutura projetados especificamente para facilitar o gerenciamento de aplicações em containers.

Os serviços de infraestrutura do Rancher incluem rede, armazenamento, volumes, balanceador de carga, DNS.

#### Outros Produtos

- <https://k3s.io/>: kubernetes para edge e IoT.
- <https://rancher.com/rancher-cs/>: Sistema Operacional Rancher.
- <https://github.com/longhorn/longhorn/>: Sistema de volume para containers.


### Kubernetes

Kubernetes é uma plataforma open source de gerenciamento de containers de nível enterprise, baseado em 15 anos de experiência do Google e pronto para o mundo multi-cloud: nuvem pública/privada/híbrida. Possui desenho modular e pode ser rodado em quase qualquer lugar.

> <https://research.google/pubs/pub43438/>: um paper falando sobre o Borg, que é a ferramenta que deu origem ao kubernetes. Este documento com conteúdo bastante rico descrevendo os problemas enfretados pela google antes da implementação do kubernetes.
>
> vídeo: <https://youtu.be/7MwxA4Fj2l4>

#### Arquitetura

O kubernetes provê uma arquitetura flexível e com mecanismo desacoplado de service discovery. Como a maioria de plataformas computacionais distribuídas, um cluster consiste de:

- Pelo menos um master
- E múltiplos nodes de computação.

##### Master

O master é responsável pela API, agendamento dos deployments e gerenciamento total do cluster.

```
,-----------------------------------------------,
| kubernetes master                             |
| ,------------,  ,-----------,  ,------------, |
| |            |  |           |  |            | |
| | API Server |  | Scheduler |  | Controller | |
| |            |  |           |  |            | |
| '------------'  '-----------'  '------------' |
| ,-------------------------------------------, |
| |                 etcd                      | |
| '-------------------------------------------' |
'-----------------------------------------------'
```

##### Nodes

Cada node do cluster roda:

- Container runtime, docker ou rocket, com os agnete spara se comunicar com o master (kubelet, kube-proxy).
- Componentes adicionais para logs, monitoramento, service discovery e add-ons opcionais.

Os nodes são os trabalhadores do cluster. Eles expõem os serviços de computação, rede e armazenamento para as aplicações.


#### Componentes

- **Pods**: containers que trabalham em conjunto.
- **Services**: Pods que trabalham em conjunto.
- **Deployments**: Provê uma única declaração para Pods e ReplicaSets.
- **Labels**: Usado para organizar serviços.
- **Daemonsets**: Rodar sempre um ou mais pods por node.
- **Secrets**: Salvar dados sensitivos como senhas de bancos de dados.
- **ConfigMaps**: Arquivo de configurações que suas aplicações usarão.
- **Cron Jobs**: Executar tarefas agendadas.


#### O que podemos fazer?

- Deployment de containers e controle de rollback.
- Empacotamento de recursos.
- Service Discovery e Autoscaling.
- Cluster Heterogêneo.
- Armazenamento persistente.
- HA?: kubernetes é escalável para o planeta Terra (WTF?). Isto requer atenção especial para funcionalidades de HA como mult-master ou cluster federation. Cluster Federation permite conectar clusters em conjunto, para permitir que se um cluster caia, os containers podem automaticamente serem movidos para o outro cluster.


## DevOps na Amazon

Apresentação: **DevOps na AWS: Construindo Sistemas para Entregas Rápidas** - Fernando Sapata - AWS Summit 2018 - DEV301

- Software precisa ser alterado rapidamente. Isso é uma grande vantagem competitiva.


## Arquitetura do Ambiente

- 4 máquinas virtuais
    - 1 Rancher server
    - 3 para cluster kubernetes
    - requisitos para cada máquina:
        - 2-4 vcpu
        - 4-6 gb ram
        - 30 gb

- ter um domínio: testes.dev
    - rancher.<dominio>
    - app1.rancher.<dominio>
    - app2.rancher.<dominio>


> Ingress: é o que responde pela aplicação do kubernetes externamente.

### Prática

- <https://github.com/jonathanbaraldi/devops/blob/master/exercicios/exercicios.md#aula-4---ambiente>

Parte prática inicia aos 13:35.

- Start your free trial with a $100 credit for 60 days: <https://try.digitalocean.com/freetrialoffer/>

Criar 4 máquinas virtuais 4 GB/2 CPUs (máquina de $20 na DigitalOcean):

- rancher
- k8s1
- k8s2
- k8s3

#### Em cada máquina criar o usuário `ubuntu` com acesso via chave SSH

##### Na máquina "local"

criar uma chave pública na máquina que será usada para acessar o host remoto:
```sh
ssh-keygen -t dsa
```

Isso vai gerar o arquivo `/home/USERNAME/.ssh/id_dsa.pub`.

##### No host remoto

```sh
# executar como root
####################

# criar um usuário sem senha
useradd --create-home --home-dir /home/USERNAME --shell /bin/bash USERNAME
usermod -aG sudo ubuntu
ufw allow OpenSSH

# Copiar o conteúdo de `/home/{USER_NAME}/.ssh/id_dsa.pub` **da máquina local**
# e colar **no host remoto** em `/home/ubuntu/.ssh/authorized_keys`.

# Configurar as permissões
chown -R ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/authorized_keys
```

Pode ser uma boa dar uma olhadinha em `/etc/ssh/sshd_config` e certificar-se que `PubkeyAuthentication yes`.

Se tudo der certo agora é possível ir na "máquina local" e se logar sem senha usando o comando:
```
ssh ubuntu@ip.do.host
```

#### Instalando docker em cada máquina

```sh
# executar na sua máquina local
ssh -T ubuntu@ip.do.host << EOF
  sudo su
  curl https://releases.rancher.com/install-docker/19.03.sh | sh
  usermod -aG docker ubuntu
EOF
``` 


#### Configuração DNS

Começa em 21:30 da aula 4.

Lembrar de liberar todas as portas no firewall.


## Construindo sua aplicação

- <https://www.udemy.com/course/devops-mao-na-massa-docker-kubernetes-rancher/learn/lecture/19490614>

Importante: necessário ter uma conta no [docker hub](https://hub.docker.com/). Meu nome de usuário é `meleuzord`.

> Isso parece ser uma dica para remover todos os containers locais:
> ```
> docker rm -f $(docker ps -a -q)
> ```


Comandos a serem executados na máquina do rancher:

```sh
# considerando logado como usuário ubuntu
sudo su
apt-get install git -y
curl -L \
  "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
exit # sair do 'sudo su'

cd # ir para /home/ubuntu
git clone https://github.com/jonathanbaraldi/devops
cd devops/exercicios/app

####################
# container do redis
####################
cd redis
# criando uma imagem no nosso docker hub
docker build -t meleuzord/redis:devops .

# executando o container a partir da imagem criada acima
docker run -d \
  --name redis \
  -p 6379:6379 \
  meleuzord/redis:devops

# conferindo...
docker ps
docker logs redis

###################
# container do node
###################
cd ../node
docker build -t meleuzord/node:devops .

# executando o container ligando-o com o container do redis
docker run -d \
  --name node \
  -p 8080:8080 \
  --link redis meleuzord/node:devops
# com isso temos a aplicação rodando e conectada ao redis.
# para conferir acesse /redis

# conferindo...
docker ps
docker logs node

#################
# container nginx
#################
cd ../nginx
docker build -t meleuzord/nginx:devops

# executando o container ligando-o com o container do node
docker run -d \
  --name nginx \
  -p 80:80 \
  --link node \
  meleuzord/nginx:devops

# conferindo...
docker ps
docker logs nginx

# com isso podemos acessar a aplicação na porta 80 e 8080
```

Após confirmar que estes 3 containers estão servindo a aplicação corretamente, podemos remover todos os containers (para posteriormente chamá-los através do `docker-compose`).

```sh
docker rm -f $(docker ps -a -q)
docker volume rm $(docker volume ls)
```

### docker-compose

```sh
cd ..
vim docker-compose.yml
# editar linhas 8, 18 e 37, colocando username do docker hub

docker-compose -f docker-compose.yml up -d
curl localhost:80
# realizar o mesmo teste com curl na sua máquina local

# testar em /redis, /html e /load

# conferindo...
docker logs

# terminando a aplicação
docker-compose down
```

## Rancher - Single Node

