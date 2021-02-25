# 3 Practices for Effective DevOps Adoption

- <https://youtu.be/MCPrtYxuVPU>
- Speaker: Dr Eoin Woods, CTO at Endava
- Slides: <https://files.gotocon.com/uploads/slides/conference_32/1456/original/Woods-DevOps-ThreePractices-GOTOpia-202009.pdf>


## Reminder: what is "DevOps"? - 03:55

Why DevOps? Why Now?

- agility > moving faster > regular change > containers & services > operational complexity

Defining DevOps at Endava: "Cross-functional teams, delivering and operating software as a visible, measurable flow of value in a continuous and sustainable way."

(not primarily about automation - we call that "continous delivery")

"Continuous delivery is the technology, DevOps is the way of working."

- 09:20 - CALMS
    - Culture
    - Automation
    - Lean
    - Measurement
    - Sharing


### Insights

#### Agilidade como pré-requisito para DevOps

Metodologias ágeis começaram no início dos anos 2000s.

Metodologias ágeis permitem que os desenvolvedores produzam de maneira mais rápida. No entanto, o trabalho dos desenvolvedores precisa ser colocado em produção pelo pessoal de operações.

Um grupo de desenvolvedores usando bem as metodologias ágeis, ainda vai esbarrar no time de Operações na hora de entregar valor (colocar código em produção).

DevOps é uma maneira de trazer o pessoal de Operações para dentro da Agilidade.

Um problema que vem ocorrendo é que muitas empresas ficam sabendo de como "O DevOps" está trazendo sucesso para muitas companhias, e portanto também querem implementar DevOps em suas respectivas empresas. No entanto, se ainda não há uma maturidade na utilização das metodologias ágeis, a jornada DevOps será bastante árdua.

Se uma organização está focando apenas em automação, talvez o mais adequado seria usar o termo "entrega contínua/continuous delivery".

Podemos dizer que entrega contínua é a tecnologia, DevOps é a maneira de trabalhar.


#### DevOps é CALMS

- Culture/Cultura
    - Foco nas pessoas.
    - Adotar experimentação.
- Automation/Automação
    - Entrega contínua.
    - Infraestrutura como Código
- Lean/Enxuta
    - Produz valor para o usuário final.
    - Lotes pequenos.
- Measurement/Medição
    - Medir tudo.
    - Mostrar as melhorias com dados.
- Sharing/Compartilhamento
    - Compartilhar informação abertamente.
    - Colaboração e comunicação.



## Common problems in DevOps adoption - 10:07

5 main groups of problems with DevOps adoption

- Expectations
    - every IT person has a different expectation.
- Culture
    - Specialities create groups, which then create different cultures.
- Silos
    - DevOps Center-of-Excelence (COE) becomes a silo itself.
- Tools Focus
    - Same as above ("DevOps Team" is another silo).
- Organisational Environment
    - It's important to be used to agile methodologies.



## 3 practices for DevOps adoption - 13:12

- Agile Working
    - Functional agile teams with effective product owners. Enables the reliable flow of useful change, crucial for DevOps working.
- Pipelines
    - Automated, validating, single-route to production for all code changes. Technical artefact shared between Dev and Ops, contributes to reliability and efficiency.
- Enabler Teams
    - Technical teams providing transitional expertise and transferring knowledge. Help to build and evolve critical new infrastructure and coach & lead other teams.


### Agile Working - 14:08

DevOps needs a regular, sustainable and predictable flow of valuable changes.


### Pipelines - 16:08

- Single automated path from commit to production.

- Visible manifestation of your path-to-production.

- Increases confidence stage by stage (stability 7 confidence).
    - Includes manual checkpoints where needed.

- build > unit test > package > test deploy > integration test > non-functional test > acceptance test > deploy


### Enabler Teams - 22:20

DevOps implementation is not trivial, it's actually difficult... and it's never a technology problem.

There's a lot to learn... a lot of culture to instill... a lot of behaviour to encourage.

The Enabler Teams are one way we've found to help with this.

Enabler teams work as peer-team within the overall engineering team to:

- Develop culture by example.
- Bring and transfer technical knowledge.
- Build useful shared things that make everyone more productive.

### Some Enabler Teams Models - 24:11

#### Nurturing

Expert team working with all scrum teams to foster practice & transfer knowledge.

once DevOps ways of working embedded, dissolve into teams or move on.


#### Building

Team that demonstrates DevOps working by delivering and owning an enabling shared source "product" (pipeline, deployment platform, ...)

Long standing team, membership rotating through scrum teams.

[That's the kind of team I'm in (February/2021), except that we don't rotate]

#### Fixing

Tecnical expertise team goaled with bounded task to unblock transformation (e.g. "fix the tests").

Form the team, fix the problem, evangelize approach, transfer knowledge, dissolve.


### Enabler teams typically dissolve - 26:15

You don't want some sort of a super team in the middle that everyone says "it's their problem. they do the devops".

You also don't want the situation where they're seen as they own all that sort of magic "DevOps technology".

That's a bad outcome, and if it's heading that way you need to dissolve the enabler team.


## Conclusions - 26:56

### The DevOps era is here

DevOps is not only that Dev and Ops can work together for its own sake. DevOps exist so we can move faster, so we can support agility.

Agility makes DevOps relevant. DevOps makes agility impactful.


### Some practices to consider - 27:53

- Agile Working
    - Get agile working first.
    - Look for evidence of outputs not ceremonies.
    - Small regular deliveries provide DevOps inputs.
- Pipelines
    - Pipelines provide reliability, efficiency, consistency, ...
    - Shared tools lead to collaboration (perhaps surprisingly).
    - Useful for non-technical stakeholders too once visualised.
- Enabler Teams
    - A lot to learn for any team.
    - Develop culture, transfer knowledge, build useful things.
    - Dissolve or rotate staff frequently.

### For your DevOps journey


---



## Por que DevOps?

Até cerca de 10 anos atrás, grandes projetos de software eram lançados em ciclos que duravam meses. Uma nova release a era lançada a cada 6 meses, ou se fosse um projeto rápido, a cada 3 meses.

Um grande problema dessa maneira de desenvolver software é que desde quando começamos o planejamento e levantamento de requisitos até a entrega do produto 6 meses depois, o "mundo mudou". Requisitos julgados como importantes já não são tão necessários assim.

Em 2001 um grupo de pioneiros em desenvolvimento de software publicou o **Manifesto para Desenvolvimento Ágil de Software**, desde então as chamadas "metodologias ágeis" começaram a ganhar força e mostrar resultados expressivos. Principalmente devido a um de seus valores mais fundamentais: responder a mudanças mais que seguir um plano.

As Metodologias Ágeis permitem que os desenvolvedores (Dev) produzam de maneira mais rápida. E rapidamente coletando feedback valioso que dá novos direcionamentos ao projeto.

No entanto, por mais fiéis que sejam aos princípios de agilidade, o resultado desse trabalho ainda demora um tempo para ser colocado em produção, pois o time de Operações (Ops) trabalha com objetivos distintos (manter segurança e estabilidade).

- TODO: Graças a tecnologias de (???) "containers & services" (???) foi possível o desenvolvimento de ferramentas que começaram a permitir a automação de muitas tarefas repetitivas desempenhadas pelo pessoal de Operações/Infraestrutura.

O movimento DevOps é uma maneira de trazer o pessoal de Operações para dentro das metodologias ágeis, através destas ferramentas de automação.



## Problemas comuns que aparecem durante a jornada DevOps

Um fenômeno que vem ocorrendo recentemente é que muitas empresas ficam sabendo de como "esse tal de DevOps" está trazendo sucesso para muitas companhias, e portanto também querem implementar a mesma metodologia em suas respectivas organizações. No entanto, se ainda não há uma maturidade na utilização de metodologias ágeis na organização, a jornada DevOps será bastante árdua.

Alguns dos problemas mais comuns:

- Silos
    - Dev
    - Ops
    - Segurança
    - [Marketing]
    - [Finanças]

- Expectativas
    - TODO: ???
    - TODO: ???

- Cultura e ambiente organizacional
    - TODO: ???
    - TODO: ???

- Foco nas ferramentas
    - O CoE pode acabar ele próprio se tornando mais um silo



## Práticas para adoção de DevOps

- Agilidade
- Pipelines
- Time habilitador (COE-TECH)

OBS.: Por que "pipeline" e "time habilitador" são tópicos distintos? Pois no médio/longo prazo, o time habilitador entrega a pipeline para o squad de desenvolvimento e este tem maturidade e autonomia para ser responsável pela manutenção da pipeline.


### Agilidade

Functional agile teams with effective product owners. Enables the reliable flow of useful change, crucial for DevOps working.

DevOps needs a regular, sustainable and predictable flow of valuable changes.


### Pipelines

Automated, validating, single-route to production for all code changes. Technical artefact shared between Dev and Ops, contributes to reliability and efficiency.

- Single automated path from commit to production.

- Visible manifestation of your path-to-production.

- Increases confidence stage by stage (stability 7 confidence).
    - Includes manual checkpoints where needed.

- build > unit test > package > test deploy > integration test > non-functional test > acceptance test > deploy



### Time habilitador

Technical teams providing transitional expertise and transferring knowledge. Help to build and evolve critical new infrastructure and coach & lead other teams.

DevOps implementation is not trivial, it's actually difficult... and it's never a technology problem.

There's a lot to learn... a lot of culture to instill... a lot of behaviour to encourage.

The Enabler Teams are one way we've found to help with this.

Enabler teams work as peer-team within the overall engineering team to:

- Develop culture by example.
- Bring and transfer technical knowledge.
- Build useful shared things that make everyone more productive.



