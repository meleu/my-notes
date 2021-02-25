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

