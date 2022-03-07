# Mergulho Spring REST - Módulo 2

- Código: <https://github.com/algaworks/curso-mergulho-spring-rest>

## Configurando o Flyway


### reiniciar a aplicação a cada alteração de código

(similar ao `nodemon`)

 Projeto -> click direito -> Spring -> Add DevTools
 
 Isso adicionará o `spring-boot-devtools` no `pom.xml`
 

### Conectando ao Banco de Dados

Projeto -> click direito -> Spring -> Add Starter  -> Instalar `Spring Data JPA` e `MySQL Driver`-> [ ] pom.xml -> Finish

`src/main/resources/application.properties`:
```
spring.datasource.url=jdbc:mysql://localhost/algalog?createDatabaseIfNotExist=true&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=
```

Ao iniciar a aplicação, o BD `algalog` será criado (ainda sem tabela alguma).


### Instalando Flyway

Projeto -> click direito -> Spring -> Add Starter  -> `Flyway migration`

Criar um diretório `src/main/resources/db/migration`.

Criar um arquivo que começa com `V` (V maiúsculo) seguida de uma sequência numérica, seguido de `__` (dois underscores), seguido de um nome descritivo, seguido de `.sql`. Exemplo: `V001__cria-tabela-clientes.sql`

Se abrir em um editor fora do STS, click direito -> Open With -> Text Editor.

```sql
create table clients (
  id bigint not null auto_increment,
  nome varchar(60) not null,
  email varchar(255) not null,
  telefone varchar(20) not null,
  
  primary key (id)
);
```

 
## Usando Jakarta Persistence (JPA) 

**Nota:** hibernate é a implementação da especificação do Jakarta Persistence. O hibernate é uma dependência que já vem junto com o `spring-boot-starter-data-jpa`.

No código do `Cliente.java`, logo abaixo dos annotations do lombok (`@Setter`), colocar o `@Entity` (de `javax.persistence`). **Obs.:** uma entidade, é uma classe associada a uma tabela do BD. Se não especificar o nome, então a associação se dá pelo nome da classe -> nome da tabela.

Caso houvesse necessidade de especificar o nome da tabela:
```java
// Table de javax.persistence
@Table(name = "nome_da_tabela")
```

### `equals()` e `hashCode()`

**Sem lombok**:

click direito na linha abaixo de `telefone` -> Source -> Generate hashCode() and equals() -> selecionar apenas `id`

**Com lombok**:

### `Cliente.java`

**Observação**: Verificar direitinho o nome da classe vs. nome da tabela no BD.
`Cliente.java`
```java
// ...
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Getter
@Setter
@Entity
public class Cliente {

  @EqualsAndHashCode.Include
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  
  private String nome;
  
  private String email; 
  
  //@Column(name = "fone")
  private String telefone;
  
}
```


### `ClienteController.java`

obs.: esse código será alterado a seguir, para usar entidades.
```java
// ...

@RestController
public class ClienteController {

  @PersistenceContext
  private EntityManager manager;
  
  @GetMapping("/clientes")
  public List<Cliente> listar() {
    return manager.createQuery("from Cliente", Cliente.class)
      .getResultList();
  }
}
```

Testar no postman -> deve retornar um array vazio.

Vai no MySQL Workbench (ou dbeaver), e adicione duas entradas na tabela de clientes. Em seguida confira no postman se estas entradas serão retornadas.

### SQL Debugging

**Obs:** não usar em produção, apenas para debugação em desenvolvimento.

`src/main/resources/application.properties`:
```
spring.jpa.show-sql=true
```


## Usando Spring Data JPA

O Spring Data JPA é uma biblioteca que nos ajuda a criar repositórios para usar o Jakarta Persistence.

 Projeto `com.algaworks.algalog` -> click direito -> New -> Interface
 
 - Package: com.algaworks.algalog.domain.repository
 - Name: ClienteRepository
 
```java
// ...

@Repository
public interface ClienteRepository extends JpaRepository<Cliente, Long> {

  List<Cliente> findByNome(String nome);
  List<Cliente> findByNomeContaining(String nome);
  Optional<Cliente> findByEmail(String email);
  
}
```

`Cliente.java`:
```java
// ...

@AllArgsConstructor
@RestController
public class ClienteController {

  private ClienteRepository clienteRepository;
  
  @GetMapping("/clientes")
  public List<Cliente> listar() {
    return clienteRepository.findAll();
  }
}
```


## Implementando o CRUD de cliente

No Postman, criar novas requests:

- Clientes - Obter
    - `GET`: /clientes/:id
- Clientes - Adicionar
    - `POST`: /clientes/
    - body:
```json
{
  "nome": "Fernando",
  "email": "fernando@algaworks.com",
  "telefone": "23 99999-8888"
}
```
- Clientes - Atualizar
    - `PUT`: /clientes/:id
    - body:
```json
{
  "nome": "Fernando",
  "email": "fernando@algaworks.com",
  "telefone": "23 99999-8888"
}
```
- Clientes - Excluir
    - `GET`: /clientes/:id

`ClienteController.java`:
```java
// ...

@AllArgsConstructor
@RestController
@RequestMapping("/clientes")
public class ClienteController {

  private ClienteRepository clienteRepository;
  
  @GetMapping
  public List<Cliente> listar() {
    return clienteRepository.findAll();
  }
  
  @GetMapping("/{clienteId}")
  public ResponseEntity<Cliente> buscar(@PathVariable Long clienteId) {
    return clienteRepository.findById(clienteId)
      .map(ResponseEntity::ok)
      .orElse(ResponseEntity.notFound().build());
  }
  
  @PostMapping
  @ResponseStatus(HttpStatus.CREATED)
  public Cliente adicionar(@RequestBody Cliente cliente) {
    return clienteRepository.save(cliente);
  }
  
  @PutMapping("/{clienteId}")
  public ResponseEntity<Cliente> atualizar(
    @PathVariable Long clienteId,
    @RequestBody Cliente cliente
  ) {
    if (!clienteRepository.existsById(clienteId)) {
      return ResponseEntity.notFound().build();
    }
    
    cliente.setId(clienteId);
    cliente = clienteRepository.save(cliente);
    
    return ResponseEntity.ok(cliente);
  }
  
  @DeleteMapping("/{clienteId}")
  public ResponseEntity<Void> remover(@PathVariable Long clienteId) {
    if (!clienteRepository.existsById(clienteId)) {
      return ResponseEntity.notFound().build();
    }
    
    clienteRepository.deleteById(clienteId);
    
    return ResponseEntity.noContent().build();
  }
}
```


## Validando com Bean Validation

- <https://jakarta.ee/specifications/bean-validation/>

Projeto -> click direito -> Spring -> Add Starters -> validation -> [ ] pom.xml

modelo `Cliente.java`
```java
// ...
public class Cliente {
  // ...
  private Long id;
  
  @NotBlank
  @Size(max = 60)
  private String nome;
  
  @NotBlank
  @Email
  @Size(max = 255)
  private String email;
  
  @NotBlank
  @Size(max = 20)
  @Column(name = "fone")
  private String telefone;
}
```

Testar enviar uma requisição para criar usuário com  `"nome": null`


no `ClienteController.java`, nos métodos `adicionar()` e `atualizar()` que recebem `Cliente cliente` como argumento, adicionar o annotation `@Valid`.

Exemplo:
```java
public Cliente adicionar(@Valid @RequestBody Cliente cliente)
```



## Implementando Exception Handler

Projeto -> pacote `exceptionhandler` -> New -> Java Class

- Name: Problema

```java
// ...

@JsonInclude(Include.NON_NULL)
@Getter
@Setter
public class Problema {
  private Integer status;
  private LocalDateTime dataHora;
  private String titulo;
  private List<Campo> campos;
  
  @AllArgsConstructor
  @Getter
  public static class Campo {
    private String nome;
    private String mensagem;
  }
}
```

Projeto -> com.algaworks.algalog -> click direito -> New -> Java Class

- Package: com.algaworks.algalog.api.exceptionhandler
- Name: ApiExceptionHandler

`ApiExceptionHandler.java`
```java

@AllArgsConstructor
@ControllerAdvice
public class ApiExceptionHandler extends ResponseEntityExceptionHandler {

  private MessageSource messageSource;

  @Override
  protected ResponseEntity<Object> handleMethodArgumentNotValid(
    // os parâmetros definidos na Classe pai
  ) {
    List<Problema.Campo> campos = new ArrayList<>();
    
    for (ObjectError error : ex.getBindingResult().getAllErrors()) {
      String nome ((FieldError) error).getField();
      String mensagem = error.getDefaultMessage();
      
      campos.add(new Problema.Campo(nome, mensagem));
    }
    
    Problema problema = new Problema();
    problema.setStatus(status.value());
    problema.setDataHora(LocalDateTime.now());
    problema.setTitulo("Um ou mais campos inválidos");
    problema.setCampos(campos);
    
    return handleExceptionInternal(ex, problema, headers, status, request);
  }
}
```


Projeto -> `src/main/resources` -> New -> File

- File name: messages.properties

```
NotBlank=é obrigatório
NotNull=é obrigatório
Size=deve ter no mínimo {2} e no máximo {1} caracteres
Email=deve ser um email válido
```

Configurar o STS para que os arquivos `.properties` sejam UTF-8:

menu Window -> Preferences -> General -> Content Types

- em `Content types:`, escolher Text -> Java Properties File
- em `Default encoding`, digitar `UTF-8` e clicar em `[Update]`
- `[Apply and Close]`

Reiniciar a aplicação.

Fazer alguns testes com dados inválidos.



## Implementando Domain Services

Regras de Negócio dentro do controlador não é considerado uma boa prática. A função é pegar requisições, delegar à algum componente que vai lidar com isso, e devolver a resposta ao cliente.

Parte das regras de negócio podem (e devem) ficar dentro das entidades, de forma que estas não sejam apenas uma estrutura de dados (classes precisam ter "inteligência" e responsabilidades). No entanto estas regras lidam apenas com a entidade em questão.

Para lidar com regras de negócio envolvendo relações entre mais de uma entidade, recomenda-se a utilização de classes de serviço.

### Impedindo criação de usuários com email duplicado

#### `ClienteRepository.java`

Certifique-se que no `ClienteRepository.java` existe o método `findByEmail()`.

#### `NegocioException.java`

 Projeto -> com.algaworks.algalog.domain -> click direito -> New -> Class
 
 - Package: com.algaworks.algalog.domain.exception
 - Name: NegocioException (opção: DomainException)
 
```java
//...
public class NegocioException extends RuntimeException {
// clicar na lâmpada com warning -> 'Add default serial version ID'  
// ver post no blog da algaworks explicando isso

  private static final long serialVersionUID = 1L;
  
  public NegocioException(String message) {
    super(message);
  }

}
```


#### `ApiExceptionHandler.java`

```java
// adicionar este método ao final da classe
public ResponseEntity<Object> handleNegocio(
  NegocioException ex,
  WebRequest request
) {
  HttpStatus status = HttpStatus.BAD_REQUEST;
  
  Problema problema = new Problema();
  problema.setStatus(status.value());
  problema.setDataHora(LocalDateTime.now());
  problema.setTitulo(ex.getMessage());
  
  return handleExceptionInternal(
    ex,
    problema,
    new HttpHeaders(),
    status,
    request
  );
}
```
 
 
 #### `CatalogoClienteService.java`

 Projeto -> com.algaworks.algalog.domain -> click direito -> New -> Class
 
 - Package: com.algaworks.algalog.domain.service
 - Name: CatalogoClienteService

`CatalogoClienteService.java`
```java
// ...

@AllArgsConstructor
@Service
public class CatalogoClienteService {
  private ClienteRepository clienteRepository;
  
  public Cliente buscar(Long clienteId) {
    return clienteRepository.findById(clienteId)
      .orElseThrow(() -> new NegocioException("Cliente não encontrado"));
  }
  
  @Transactional
  public Cliente salvar(Cliente cliente) {
    boolean emailEmUso = clienteRepository
      .findByEmail(cliente.getEmail())
      .stream()
      .anyMatch(c -> !c.equals(cliente))
      
    if (emailEmUso) {
      throw new NegocioException("email em uso.");
    }
    return clienteRepository.save(cliente)
  }
  
  @Transactional
  public void excluir(Long clientId) {
    clienteRepository.deleteById(clienteId);
  }
}
```


Em `ClienteController.java`:
```java
//...
public class ClienteController {

  private CatalogoClienteService catalogoClienteService;
  
  // substituir onde tem:
  // clienteRepository.save(cliente);
  // por:
  // catalogoClienteService.salvar(cliente);
  
  // substituir onde tem:
  // clienteRepository.deleteById(clienteId);
  // por:
  // catalogoClienteService.excluir(clienteId);  
}
```


Testar cadastrar clientes com email repetido, inválido, etc.