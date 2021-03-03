# Jenkins vs GitLab

[✏️](https://github.com/meleu/my-notes/edit/master/jenkins-vs-gitlab.md)


## links

- <https://about.gitlab.com/devops-tools/jenkins-vs-gitlab/jenkins-gaps/>
- <https://about.gitlab.com/devops-tools/jenkins-vs-gitlab/gitlab-differentiators/>


A seguir temos a tradução livre dos artigos acima. Em seguida eu escrevo a [minha opinião](#minha-opiniao) final mostrando os principais pontos que tornam o GitLab uma melhor opção para a implementação de DevOps em uma organização.

OBSERVAÇÃO: nas traduções, os textos [entre colchetes] são colocações minhas.


## Lacunas do Jenkins

Texto original: <https://about.gitlab.com/devops-tools/jenkins-vs-gitlab/jenkins-gaps/>


### Não é uma única aplicação DevOps

Jenkins não é uma plataforma "end to end" para todo o ciclo de vida DevOps.


### Plugins

Para extender as funcionalidades nativas do Jenkins é necessário a instalação de plugins. E Plugins são caros de se manter seguros e atualizados.

> A maioria das organizações que conversamos nos dizem que o gerenciamento de plugins do Jenkins é um pesadelo. Cada um tem seu próprio ciclo de vida de desenvolviemnto, e toda vez que um novo plugin chega eles precião re-testar toda a cadeia de ferramentas.
>
> Ouvimos histórias tipo Grupo precisa do Plugin A, e administrador do Jenkins instala, e então descobre que tal plugin depende de uma versão nova (e incompatível) de uma biblioteca que o requerida pelo Plugin B, que é usado pelo Grupo B.
>
> Solução? Dar a cada grupo seu próprio servidor Jenkins? Mas então você acaba com o espalhamento do Jenkins (mais servidores para administrar). Sem mencionar toda a manutenção e testes exigidos por todas as ferramentas integradas externamente na cadeia de ferramentas.

[Achei estranho o fato deste relato não ter referência alguma a quem o fez. Mas me parece que pessoas acostumadas com o Jenkins irão concordar.]


### Alta Manutenção

- Jenkins requer recursos dedicados com conhecimento de Groovy.
- A manutenção de plugins de terceiros pode ser difícil.


### Developer Experience

Jenkins rapidamente se estabeleceu como uma ferramenta líder em orquestração de builds logo após sua criação em 2005 e continuou ganhando força antes que o termo "DevOps" e "CI/CD" fossem essa loucura que se ouve falar hoje em dia. Como diz o ditado, "o tempo não pára para ninguém" e estamos vendo avanços na tecnologia de desenvolvimento de software mais rápidos do que nunca.

Os padrões de 20 anos atrás parecem estranhos e o que funcionou 5 anos atrás provavelmente não será mais considerado a melhor prática. Estamos tendo que nos adaptar rapidamente para permanecermos relevantes e competir no atual clima tecnológico.

Infelizmente para o Jenkins, o que funcionou tão bem 15 anos atrás não resistiu ao teste do tempo. E a falta de inovação para se manter atualizado e melhorar o projeto afetou sua comunidade aparentemente cada vez menor de usuários e colaboradores, pelo menos em comparação com o quão próspera a comunidade já foi.

Os dois principais diferenciais do Jenkins:

- Jenkins sendo o "canivete suíço da automação" com flexibilidade aparentemente ilimitada por causa de seu ecossistema de plugins.
- Uma comunidade de colaboradores muito ativa, animada e próspera.

Este pontos se tornaram um cenário de faca de dois gumes, onde o ecossistema de plugins cresceu a uma escala que é difícil de manter, mas ainda assim um fator crítico para suprir necessidades que o Jenkins não suporta nativamente.

O Jenkins por si só é uma aplicação java com uma UI/UX ultrapassada, e problemas desta natureza são agravantes para desenvolvedores que tentam usá-lo com eficiência e eficácia - uma batalha constante. Além disso, a comunidade, que já foi próspera, tem visto uma diminuição consistentemente significativa na atividade e na adoção.

Embora o Jenkins seja ótimo para automatizar algumas coisas, ele é muito frágil e prejudica a experiência do desenvolvedor. Especificamente:

- Possui configurações e interfaces de usuário frágeis.
- Número de plugins desatualizados e sem manutenção continuam a crescer.
- O impacto na experiência do desenvolvedor e em sua produtividade está levando a uma dificuldade em reter talentos para operar o Jenkins.


[Achei uma análise um pouco enviesada e carente de fontes. Por exemplo: De onde vem os dados que comprovam que a adoção e a comunidade de colaboradores está diminuindo?]


### Risco Aumentado

- Integrar plugins de terceiros cria exposições e introduz riscos de segurança.
- A atualização do Jenkins podem causar downtime devido às integrações com plugins.


### Pronto para a Indústria

- Jenkins requer plugins de terceiros para suportar _analytics_.
- Com o Jenkings, os requisitos de auditoria e conformidade não são fáceis de cumprir. Não é fácil rastrear mudanças em um novo _release_.

[Dúvida: GitLab suporta essas features? Analytics e rastreamento de releases?]


### Jenkins X

Jenkins X tem altos requisitos de sistema, deployment limitado apenas a clusters Kubernetes. Só tem interface de linha de comando (no momento) e ainda usa Groovy.

[Achei o arumento bem fraco.]


### Suporte a Kubernetes

Do GitLab PMM:

> Jenkins teve que construir um novo projeto separado para trabalhar com o Kubernetes. O GitLab adotou nativamente o Kubernetes desde o início.



## Diferenciadores do GitLab

Texto original: <https://about.gitlab.com/devops-tools/jenkins-vs-gitlab/gitlab-differentiators/>


### Única Aplicação

GitLab provê mais do que o Jenkins espera evoluir, fornecendo uma única aplicação totalmente integrada para todo o ciclo de vida DevOps.

Mais do que os objetivos do Jenkins, o GitLab também fornece planejamento, SCM (controle de versionamento de código), empacotamento, _release_, configuração e monitoramento (além do CI/CD que é o foco do Jenkins).

Com GitLab, não há necessidade de plugins e customização. Ao contrário do Jenkins, o GitLab é um núcleo aberto e qualquer pessoa pode contribuir com alterações diretamente para a base de código, que, uma vez mesclada, seria automaticamente testada e mantida com cada alteração.



### Manutenção

- GitLab é fácil de manter e atualizar. Para atualizar, apenas substitua uma imagem docker. Quando você atualiza uma versão, ele atualiza tudo.

- Manter as definições da pipeline é mais fácil e mais limpo do que no Jenkins. O arquivo de configuração do GitLab CI/CD (`.gitlab-ci.yml`):
    - Usa o formato YAML estruturado;
    - Tem uma curva de aprendizado menor - mais simples de colocar em funcionamento;
    - Previne complexidade irrestrita - o que pode tornar seus arquivos de pipeline do Jenkins difíceis de entender e gerenciar. [meleu: eu estou notando que os nossos `.gitlab-ci.yml` também estão correndo risco de ficarem difíceis de manter.]
    - Versionado num repositório junto com o código da própria aplicação - torna mais fácil de ser mantido e atualizado pelos próprios desenvolvedores.


### Otimizado para desenvolvimento nativo em nuvem

GitLab possui:

- Um container registry embutido
- Integração com Kubernetes
- Lógica CI/CD de Microsserviços
- Monitoramento de cluster


### Visibilidade e Intuitividade

- Desenvolvedores possuem visibilidade de todo o ciclo de vida do desenvolvimento.
- Interface moderna e fácil de usar.


### Melhor arquitetura de execução

O GitLab Runner, que executa seus trabalhos CI/CD, tem uma arquitetura de execução mais adaptável que o Jenkins.

- Escrito em Go para portabilidade - distribuído como um binário simples, sem qualquer outra dependência.
- Suporte nativo a Docker - trabalhos são executados em containers. O GitLab Runner baixa as imagens com as ferramentas necessárias, executam os jobs, e removem os containers.
- Nenhuma ferramenta extra é necessária nas máquinas Runner
- Auto-escalagem embutida - máquinas criadas sob demanda para atender à demanda do trabalho. Permite economia de custos de forma mais dinâmica.


### Modelo de Permissões

GitLab possui um modelo de permissão única que torna mais fácil a configuração de funções e permissões.


---


## Minha Opinião

Os pontos diferenciais "matadores" em favor do GitLab são:

- Aplicação end-to-end sem precisar da instalação de plugins de terceiros. O GitLab nativamente (sem necessidade de plugins) já provê:
    - [Controle de versão](https://about.gitlab.com/stages-devops-lifecycle/create/)
    - [CI/CD](https://docs.gitlab.com/ee/ci/) (única coisa oferecida nativamente pelo Jenkins)
    - [Planejamento](https://about.gitlab.com/stages-devops-lifecycle/plan/)
    - [Empacotamento](https://about.gitlab.com/stages-devops-lifecycle/package/)
    - [Release](https://about.gitlab.com/stages-devops-lifecycle/release/)
    - [Configuração](https://about.gitlab.com/stages-devops-lifecycle/configure/)
    - [Monitoramento](https://about.gitlab.com/stages-devops-lifecycle/monitor/)
- Tirando CI/CD, todas essas funcionalidades no Jenkins só seriam conseguidas através de plugins de terceiros, o que traria uma grande carga de trabalho para manter seguro e atualizado.

- Configuração da pipeline feita em um arquivo `.gitlab-ci.yml` armazenado no mesmo repositório do código da aplicação.
    - _Configuration as Code_
    - Dá autonomia aos devs - que é um dos objetivos finais do DevOps
    - Melhor rastreabilidade de mudanças na pipeline

