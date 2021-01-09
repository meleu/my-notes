
## Jornada DevOps

### Intro

Pilares:

- **Cultura**: colaboração, transparência, confiança...

- **CI/CD**: Integração/Entrega/Implantação Contínua

- **Microsserviços**: APIs, Infrastructure as Code, releases de baixo risco, injeção de falhas (para testar resiliência).

- **Pipeline de Implantação**: automação de testes, TDD.

- **Revisão de Código**: pair programming, gestão de mudança e segurança contínua.

- **Telemetria**: experimentação, feedback contínuo, testes A/B.

- **Lean**: Scrum, definição de pronto, kanban, XP, kata, teoria das restrições.

É mencionado o livro "Toyota kata", como a Toyota consegue disseminar o conhecimento tácito para suas equipes.


### Conceitos Básicos

O que é DevOps?

É um movimento que estimula a colaboração e comunicação entre a área de Desenvolvimento e Operações. Além da colaboração é importante que existam ferramentas de automação para que haja entrega frequente de software com estabilidade e segurança.

Fundamenta-se em Lean, Agilidade e Automação.



### DevOps CALMS

- C - Culture: respeito às pessoas, criar pontes entre Dev e Ops, aceitar mudanças.

- A - Automation: integração e entrega contínua, infra como código, pipeline de implantação, orquestração.

- L - Lean: valor para o cliente (o que não tem valor para o cliente deve ser descartado), lotes pequenos, fluxo contínuo, reduzir WIP e lead time.

- M - Measure: telemetria, controle, melhorias.

- S - Sharing: colaboração, feedback, boa comunicação, transparência.


### Linha do Tempo: do Lean ao DevOps

DevOps é uma evolução natural do Manifesto Ágil (que aplica vários princípios do Lean).

- 1950-60 - Sistema Toyota de Produção e Kanban (Taiichi Ohno).
- 1990 - Lean, no livro "A Máquina que Mudou o Mundo (Womack e Ross).
- 1990-96 - Scrum (Jeff Sutherland e Ken Schwaber) e XP (Ken Beck).
- 1996 - "Pensamento Lean" (Womack e Jones).
- 2001 - Manifesto Ágil
- 2006 - "Entrega Contínua" (Jez Humble e David Farley)
- 2008 - Conferência Ágil: "Princípios ágeis na infraestrutura" (Patrick Debois e Andrew Shafer)
- 2009 - Conferência Velocity: "10 implantações por dia: Cooperação Dev e Ops no Flicker" (Jon Allspaw e Paul Hammond); primeiro DevOps Day na Bélgica (Patrick Debois)
- Surge o termo DevOps CALMS (John Willis e Jez Humble).


### Lean

- Iniciado na Toyota.
- Filosofia que respeita as pessoas.
- Valor para o cliente e elimina desperdício.
- Visita ao Gemba ("o local onde as coisas ocorrem"), Andon, fatos e dados.
- Foco na causa dos problemas.


### Gemba

É uma palavra japonesa que se refere ao local real onde as coisas acontecem/são produzidas.

Todos devem ir ao gemba com frequência para conhecer o "chão de fábrica".

Evitar suposições e cria empatia entre as pessoas.


### Corda de Andon

"Se falhar, puxe a Corda de Andon."

É sobre dar confiança e autonomia para os colaboradores. Se eles encontrarem algo de errado, isso deve ser comunicado tão breve quanto possível para evitar de o problema ser propagado.


### Manifesto Ágil

Descobrir maneiras melhores de desenvolver software, fazendo-o nós mesmos e ajudando outros a fazerem o mesmo.

**Os 12 Princípios** - <http://agilemanifesto.org/principles.html>

1. A maior prioridade do time é satisfazer o cliente...
2. Aceitar mudanças de requisitos, mesmo no fim do desenvolvimento...
3. Entregar software funcionando com frequência...
4. Pessoas relacionadas à negócios e desenvolvedores devem trabalhar em conjunto e diariamente...
5. Construir projetos ao redor de indivíduos motivados...
6. O método mais eficiente e eficaz de transmitir informações para, e por dentro de um time, é através de uma conversa cara a cara.
7. Software funcional é a medida primária de progresso.
8. Processos ágeis promovem um ambiente sustentável... (passos constantes)
9. Contínua atenção à excelência técnica e bom design aumenta a agilidade.
10. Simplicidade: a arte de maximizar a quantidade de trabalho que não precisa ser feito.
11. As melhore arquiteturas, requisitos e designs emergem de times auto-organizáveis.
12. Em intervalos regulares o time reflete em como ficar mais efetivo...


### Ciclos de Vida

#### Tradicional ou Preditivo

Negócio -> Desenvolvimento -> Operação -> Cliente

Usado por muito tempo mas hoje em dia, com o ambiente mudando constantemente, não faz mais sentido.

O produto tem que passar pela fase de planejamento com a equipe de Negócio. Em seguida para a equipe de Desenvolvimento implementar. Em seguida a equipe Operação coloca em produção, para só então entregar valor para o cliente.

Demora-se muito tempo para entregar valor ao cliente.

O tempo gasto com planejamento excessivo pode tornar o produto não mais necessário (algum concorrente já saiu na frente ou o cliente já mudou de ideia).


#### Ágil ou Adaptativo

Negócio+Desenvolvimento+Testes -> Operação -> Cliente

Agiliza a comunicação nas primeiras fases do projeto, mas ainda há um gargalo quando a equipe de Operação precisa colocar em produção.

Equipe de Operação ainda fica a parte, e portanto ainda gerando conflitos/demoras.

#### DevOps

Negócio+Desenvolvimento+Testes+Operação -> Cliente

Nesta configuração é mais rápido entregar valor ao cliente, mesmo que em pequenas doses. Isso permite coletar feedback rapidamente e prontamente se adaptar.


### Origem dos Conflitos

"O Financeiro só quer cortar custos."

"O Marketing só pensa em gastar."

"A Auditoria engessa o processo."

"Os meninos da TI não resolvem os problemas."

"O RH deveria olhar pelos funcionários."

"O pessoal do QA deveria pegar esse erro."


### Cultura Colaborativa

empatia + automação = cultura colaborativa

Criatividade para inovar mantendo estabilidade do ambiente.


### Ferramentas DevOps

OBS.: a prova EXIN não cobra ferramentas, pois estas mudam constantemente.

https://digital.ai/periodic-table-of-devops-tools

A má implementação ou excesso de customização pode destruir uma ótima ferramenta. Incentive a opinião das equipes no "chão de fábrica".

### State of DevOps Report

"State of DevOps Report" é um documento que vale a pena conferir para entender para onde que o mercado está indo.

<https://puppet.com/resources/report/2020-state-of-devops-report>

Ver também: <https://cloud.google.com/devops/>

### Benefícios da Cultura DevOps

1. frequência de deploy.
2. lead time (tempo de entrega de ponta a ponta, desde o pedido até a entrega).
3. redução de downtime.
4. redução do tempo de recuperação (como há uma tolerância para que se falhe o mais cedo possível, adquire-se expertise para recuperar rapidamente).


