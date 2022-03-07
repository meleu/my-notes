# Mergulho Spring REST - Módulo 1

- Código: <https://github.com/algaworks/curso-mergulho-spring-rest>

## Fundamentos de REST

Paradigma criado por Roy Fielding em sua tese de PhD entitulada "Architectural Styles and the Design of Network-based Software Architectures".

<https://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm>

### Constraints

- Cliente-Servidor
- Stateless
- Cache
- Interface uniforme
- Sistema em camadas
- Código sob demanda

### HTTP

#### Requisição HTTP

```
[MÉTODO] [URI] HTTP/[VERSÃO]
[CABEÇALHOS]

[CORPO/PAYLOAD]
```

Exemplo:
```
POST /produtos HTTP/1.1
Content-Type: application/json
Accept: application/json

{
  "nome": "Notebook i7",
  "preco": 2100.0
}
```

#### Resposta HTTP

```
HTTP/[VERSÃO] [STATUS]
[CABEÇALHOS]

[CORPO]
```

Exemplo:
```
HTTP/1.1 201 Created
Location: /produts/331
Content-Type: application/json

{
  "codigo": 331,
  "nome": "Notebook i7",
  "preco": 2100.0
}
```


### Recursos HTTP

#### URI vs URL

URL é um tipo de URI.

- URI: Uniform Resource Identifier - ou seja, é um identificador
- URL: Uniform Resource Location - ou seja, é um localizador

Uma URL diz onde está um recurso e como chegar até ele. Exemplo: https://something.com/produtos/331



## Criando o projeto Spring Boot

### UML do projeto

![](../../assets/mergulho-spring-rest-uml.png)


### Começando

Package Explorer -> click direito -> New -> Spring Starter Project

![](../../assets/mergulho-spring-rest-starter.png)

Na tela de "New Spring Starter Project Dependencies":

- Spring Boot Version: 2.4.5
- buscar por "Spring Web"

Next -> Finish

**Debug**: Se der algum erro no download (algo vermelhinho no "Package Explorer"), dê um click direito -> Maven -> Update Project -> marcar [ ] Force Update of Snapshots/Releases

**Observação**: Se tiver usando alguma outra IDE, baixar esse "Starter" de https://start.spring.io/


### POM - Project Object Model

`pom.xml` - arquivo onde estão listadas as dependências.

Ao abrir o `pom.xml` dentro do STS, observe as abinhas na parte inferior do editor. Uma dessas abas é o `Dependency Hierarchy`. Isso pode ser útil para ajudar a encontrar dependências transientes que forem detectadas como vulneráveis pelo SAST.


### Fat JAR

click direito no projeto -> Run As -> Maven build... -> Goals: `clean package` -> [Run]

Isso vai gerar alguns arquivos e colocá-los no diretório `target/`.

É possível iniciar a aplicação por dentro do STS, através do `Boot Dashboard`.



## Implementando Collection Resource

Observação: ter o Postman ou o Insomnia instalado (eu prefiro Insomnia).

Dentro do Insomnia, criar uma nova Collection

- AlgaLog
  - `GET`: Clientes - Listar


De volta ao STS: `src/main/java` -> `com.algaworks.algalog` -> click direito -> New -> Java class

- Package: com.algaworks.algalog.api.controller
- Name: `ClienteController`

```java
package com.algaworks.algalog.api.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ClienteController {
  @GetMapping("/clientes")
  public String list() {
    return "Teste";
  }
}
```

Testar no Insomnia. Ao mandar uma request para `/clientes`, deve-se receber a string `Teste` e status code 200.


Criar uma nova classe:

- Package: com.algaworks.algalog.domain.model
- Name: `Cliente`

Instalar o lombok: Package Explorer -> click direito -> Spring -> Add Starters -> escolher lombok -> Next -> marcar `[ ] pom.xml`

```java
package com.algaworks.algalog.domain.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Cliente {
  private Long id;
  private String nome;
  private String email;
  private String telefone;
}
```

Alterar o `ClienteController` com o seguinte conteúdo:
```java
public List<Cliente> list() {
  // Observação essa notação com constructor na verdade deveria ser utilizando setters
  var cliente1 = new Cliente(1L, "João", "34 99999-1111", "joao@algaworks.com");
  var cliente1 = new Cliente(2L, "Maria", "34 97777-2222", "maria@algaworks.com");

  return Arrays.asList(client1, client2);
}
```

## Content Negotiation

No Insomnia, atribuir o Header `Accept: application/json` e enviar. Provavelmente receberá um 200.

Agora se atribuir um Header `Accept: application/xml`, o servidor resonderá um 406 (Not Acceptable), pois não é um formato que o servidor tem pra responder.

Se quiser adicionar suporte a XML, basta adicionar a seguinte dependência ao seu `pom.xml`:
```xml
<dependency>
  <groupId>com.fasterxml.jackson.dataformat</groupId>
  <artifactId>jackson-dataformat-xml</artifactId>
</dependency>
```

No entanto, neste curso é utilizado apenas o formato JSON.

