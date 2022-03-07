# Mergulho Spring REST - Módulo 3

- Código: <https://github.com/algaworks/curso-mergulho-spring-rest>


## Implementando solicitação de entrega

Projeto -> com.algaworks.algalog.domain -> click direito -> New -> Class

- Name: Entrega

`Entrega.java`:
```java
@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Entity
public class Entrega {

  @EqualsAndHashCode.Include
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Valid
  @NotNull
  @ManyToOne
  private Cliente cliente;

  @Valid
  @NotNull
  @Embedded
  private Destinatario destinatario;

  @NotNull
  private BigDecimal taxa;

  @JsonProperty(access = Access.READ_ONLY)
  @Enumerated(EnumType.STRING)
  private StatusEntrega status;

  @JsonProperty(access = Access.READ_ONLY)
  private LocalDateTime dataPedido;
  
  @JsonProperty(access = Access.READ_ONLY)
  private LocalDateTime dataFinalizacao;

}
```
 
Criar uma enumeração `StatusEntrega.java`:
```java
package com.algaworks.algalog.domain.model;

public enum StatusEntrega {
  PENDENTE,
  FINALIZADA,
  CANCELADA
}
```

Observação: na classe `Destinatario.java` vamos atribuir o nome das colunas usando `@Column(name = "column_name")` pois os dados do destinatário ficarão na tabela de `clientes` no BD.
`Destinatario.java`:
```java
package com.algaworks.algalog.domain.model;

@Getter
@Setter
@Embeddable
public class Destinatario {

  @NotBlank
  @Column(name = "destinatario_nome")
  private String nome;

  @NotBlank
  @Column(name = "destinatario_logradouro")
  private String logradouro;

  @NotBlank
  @Column(name = "destinatario_numero")
  private String numero;

  @NotBlank
  @Column(name = "destinatario_complemento")
  private String complemento;

  @NotBlank
  @Column(name = "destinatario_bairro")
  private String bairro;
}
```

Criar uma migration para adicionar campos do destinatário.

projeto -> src/main/resources/db/migration -> click direito -> New -> File

- File name: `V003__cria-tabela-entrega.sql`

```sql
create table entrega(
  id bigint not null auto_increment,
  cliente_id bigint not null,
  taxa decimal(10,2) not null,
  status varchar(20) not null,
  data_pedido datetime not null,
  data_finalizacao datetime,
  
  destinatario_nome varchar(60) not null,
  destinatario_logradouro varchar(255) not null,
  destinatario_numero varchar(30) not null,
  destinatario_complemento varchar(60),
  destinatario_bairro varchar(30) not null,

  primary key (id)
);

 alter table entrega add constraint fk_entrega_cliente
 foreign key (cliente_id) references cliente (id);
```

Executar a aplicação para rodar a migration.


Criar um repositório de entrega:

projeto -> repository -> click direito -> New -> Interface

- Name: EntregaRepository

```java
// ...

@Repository
public interface EntregaRepository extends JpaRepository<Entrega, Long> {
}
```

Criar um service para representar o caso de uso de criação de uma entrega.

projeto -> service -> click direito -> New -> Class

- Name: SolicitacaoEntregaService

```java
// ...
@AllArgsConstructor
@Service
public class SolicitacaoEntregaService {

  private CatalogoClienteService catalogoClienteService;
  private EntregaRepository entregaRepository;
  
  @Transactional
  public Entrega solicitar(Entrega entrega) {
    Cliente cliente = catalogoClienteService.buscar(entrega.getCliente().getId());
    
    entrega.setCliente(cliente);
    entrega.setStatus(StatusEntrega.PENDENTE);
    entrega.setDataPedido(LocalDateTime.now());
    
    return entregaRepository.save(entrega);
  }
}
```

Criar um controller para entrega:

projeto -> controller -> click direito -> New -> Class

- Name: EntregaController

```java
// ...
@AllArgsConstructor
@RestController
@RequestMapping("/entregas")
public class EntregaController {

  private EntregaRepository entregaRepository;
  private SolicitacaoEntregaService solicitacaoEntregaService;
  
  @PostMapping
  @ResponseStatus(HttpStatus.CREATED)
  public Entrega solicitar(@Valid @RequestBody Entrega entrega) {
    return solicitacaoEntregaService.solicitar(entrega);
  }
  
  @GetMapping
  public List<Entrega> listar() {
    return entregaRepository.findAll();
  }
  
  @GetMapping("/{entregaId}")
  public ResponseEntity<Entrega> buscar(@PathVariable Long entregaId) {
    return entregaRepository.findById(entregaId)
      .map(ResponseEntity::ok)
      .orElse(ReponseEntity.notFound().build());
  }
}
```

No Postman/Insomnia criar uma pasta para Clientes e mover as requisições para lá.

Criar uma pasta para Entregas. Testar Criar entrega

```json
{
  "cliente": {
    "id": 2
  },
  "destinatario": {
    "nome": "Joaquim da Silva",
    "logradouro": "Rua das Goiabas",
    "numero": "100",
    "bairro": "Centro"
  },
  "taxa": 100.50
}
```

- Testar também com um cliente.id que não existe.
- Testar sem cliente 
- Testar sem Data


## Validação em cascata e Validation Groups

Projeto -> domain -> click direito -> New -> Interface

- Name: ValidationGroups

```java
public interface ValidationGroups {

  public interface ClienteId { }

} 
```

Modelo `Cliente.java`
```java
// ...
public class Cliente {

  @NotNull(groups = ValidationGroups.ClienteId.class)
  @EqualsAndHashCode.Include
  @Id
  @GeratedValue(strategy = GenerationType.IDENTITY)
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

`Entrega.java`:
```java
// ...
public class Entrega {

  // ...

  @Valid
  @ConvertGroup(from = Default.class, to = ValidationGroups.ClienteId.class)
  @NotNull
  @ManyToOne
  private Cliente cliente;

  // ...
}  
```

Testar:

- criar cliente normalmente
- criar cliente sem id
- criar Entrega com cliente, sem id
- listar todas as entregas
- listar apenas uma entrega


## Boas práticas para trabalhar com data hora

Substituir em todos os arquivos, `LocalDateTime` por `OffsetDateTime`.

- `Entrega.java`
- `Problema.java`
- `ApiExceptionHandler.java`
- `SolicitacaoEntregaService.java`


## Isolando Domain Model do Representation Model

projeto -> com.algaworks.algalog.api -> click direito -> New -> Class

- Package: com.algaworks.algalog.api.model
- Name: EntregaModel

`EntregaModel.java`:
```java
// ...
@Getter
@Setter
public class EntregaModel {
  private Long id;
  private String nomeCliente;
  private DestinatarioModel destinatario;
  private BigDecimal taxa;
  private StatusEntrega status;
  private OffsetDateTime dataPedido;
  private OffsetDateTime dataFinalizacao;
}
```

Criar a class `DestinatarioModel` dentro do mesmo pacote.

`DestinatarioModel.java`:
```java
// ...
@Getter
@Setter
public class DestinatarioModel {
  private String nome;
  private String logradouro;
  private String numero;
  private String complemento;
  private String bairro;
}
```

Como agora já temos o `EntregaModel`, já podemos utilizar essa classe como retorno de `EntregaController.buscar()` (observação: esse código verboso será substituído logo a seguir, não precisa digitá-lo)
```java
public ResponseEntity<EntregaModel> buscar(@PathVariable Long entregaId) { 
  return entregaRepository.findById(entregaId)
    .map(entrega -> {
      EntregaModel entregaModel = new EntregaModel();
      entregaModel.setId(entrega.getId());
      entregaModel.setNomeCliente(entrega.getCliente().getNome());
      entregaModel.setDestinatario(new DestinatarioModel());
      entregaModel.getDestinatario().setNome(entrega.getDestinatario().getNome());
      entregaModel.getDestinatario().setLogradouro(entrega.getDestinatario().getLogradouro());
      entregaModel.getDestinatario().setNumero(entrega.getDestinatario().getNumero());
      entregaModel.getDestinatario().setComplemento(entrega.getDestinatario().getComplemento());
      entregaModel.getDestinatario().setBairro(entrega.getDestinatario().getBairro());
      entregaModel.setTaxa(entrega.taxa());
      entregaModel.setStatus(entrega.getStatus());
      entregaModel.setDataPedido(entrega.getDataPedido());
      entregaModel.setDataFinalizacao(entrega.getDataFinalizacao());
      
      return ResponseEntity.ok(entregaModel);
    }).orElse(ReponseEntity.notFound().build());
}
```


## Simplificando a transformação de objetos com ModelMapper

- <https://modelmapper.org/downloads/>

Ver o xml a ser inserido no `pom.xml` no site, copiar, e colar no seu `pom.xml`.

Vamos criar para o Model Mapper uma classe com definições de beans.

Projeto -> com.algaworks.algalog -> click direito -> New -> Class

- Package: com.algaworks.algalog.common
- Name: ModelMapperConfig

`ModelMapperConfig.java`:
```java
// ...
@Configuration
public class ModelMapperConfig {
  @Bean
  public ModelMapper modelMapper() {
    return new ModelMapper();
  }
}
```

No `EntregaController.java`, injetar uma propriedade do Model Mapper:
```java
public class EntregaController {
  // ...
  private ModelMapper modelMapper;

  // ...
  public ResponseEntity<EntregaModel> buscar(@PathVariable Long entregaId) {
    return entregaRepository.findById(entregaId)
      .map(entrega -> {
        EntregaModel entregaModel = modelMapper.map(entrega, EntregaModel.class);
        
        return ResponseEntity.ok(entregaModel);
      }).orElse(ResponseEntity.notFound().build());
  }
}
```

Testar obter uma entrega para ver se os campos recebidos estarão devidamente convertidos.

### refatorando para tirar o Model Mapper de dentro de `EntregaController.java`

projeto -> com.algaworks.algalog.api -> click direito -> New -> Class

- Package: com.algaworks.algalog.api.assembler
- Name: EntregaAssembler

`EntregaAssembler.java`:
```java
// ...
@AllArgsConstructor
@Component
public class EntregaAssembler {
  private ModelMapper modelMapper;
  
  public EntregaModel toModel(Entrega entrega) {
    return modelMapper.map(entrega, EntregaModel.class);
  }
  
  public List<EntregaModel> toCollectionModel(List<Entrega> entregas) {
  return entrega
    .stream()
    .map(this::toModel)
    .collect(Collectors.toList());
  }
}
```

E aí no `EntregaController.java`, ao invés de injetar o Model Mapper, use:
```java
public class EntregaController {
  // ...
  private EntregaAssembler entregaAssembler;
  
  // ...
  public EntregaModel solicitar(@Valid @RequestBody Entrega entrega) {
    Entrega entregaSolicitada = solicitacaoEntregaService.solicitar(entrega);
    return entregaAssembler.toModel(entregaSolicitada);
  }
  
  // ...
  public List<EntregaModel> listar() {
    return entregaAssembler.toCollectionModel(entregaRepository.findAll());
  }

  // ...
  public ResponseEntity<EntregaModel> buscar(@PathVariable Long entregaId) {
    return entregaRepository.findById(entregaId)
      .map(entrega -> ResponseEntity.ok(entregaAssembler.toModel(entrega)))
      .orElse(ResponseEntity.notFound().build());
  }
} 
```

Testar requisições de entregas (listar, obter).


### Criando `ClienteResumoModel`

Isso é útil para mostrar mais informações a respeito do cliente (e não somente o ID).

Em `EntregaModel.java`, substituir:
```java
  private String nomeCliente;
```
por:
```java
  private ClienteResumoModel cliente;
```

projeto ... model -> click direito -> New -> Class

`ClienteResumoModel.java`:
```java
// ...
@Getter
@Setter
public class ClienteResumoModel {
  private Long id;
  private String nome;
}
```

Testar requisições de entregas (listar, obter).


### Criando um modelo de input

projeto ... model -> New -> Class

- Package: com.algaworks.algalog.api.model.input
- Name: ClienteIdInput

`ClienteIdInput.java`:
```java
// ...
@Getter
@Setter
public class ClienteIdInput {
  @NotNull
  private Long id;
}
```


projeto ... model -> New -> Class

- Package: com.algaworks.algalog.api.model.input
- Name: DestinatarioInput

`DestinatarioIdInput.java`:
```java
// ...
@Getter
@Setter
public class DestinatarioIdInput {
  @NotBlank
  private String nome;
  
  @NotBlank
  private String logradouro;
  
  @NotBlank
  private String numero;
  
  @NotBlank
  private String complemento;
  
  @NotBlank
  private String bairro;
  
}
```


projeto ... model -> New -> Class

- Package: com.algaworks.algalog.api.model.input
- Name: EntregaInput

`EntregaInput.java`:
```java
// ...

@Getter
@Setter
public class EntregaInput {

  @Valid
  @NotNull
  private ClienteIdInput cliente;
  
  @Valid
  @NotNull
  private DestinatarioInput destinatario;
  
  @NotNull
  private BigDecimal taxa;
}
```

Volta no `EntregaAssembler.java` e adiciona o seguinte método:

```java
public Entrega toEntity(EntregaInput entregaInput) {
  return modelMapper.map(entregaInput, Entrega.class);
}
```

No `EntregaController.java`, alterar o parâmetro do método `solicitar()`:
```java
public EntregaModel solicitar(@Valid @RequestBody EntregaInput entregaInput) {
  Entrega novaEntrega = entregaAssembler.toEntity(entregaInput);
  Entrega entregaSolicitada = solicitacaoEntregaService.solicitar(novaEntrega);
  
  return entregaAssembler.toModel(entregaSolicitada);
}
```

Agora no model `Entrega.java` não precisamos de tantas validações:

`Entrega.java`:
```java
// ...
public class Entrega {

  @EqualsAndHashCode.Include
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne
  private Cliente cliente;

  @Embedded
  private Destinatario destinatario;

  private BigDecimal taxa;

  @Enumerated(EnumType.STRING)
  private StatusEntrega status;

  private LocalDateTime dataPedido;
  
  private LocalDateTime dataFinalizacao;

}
```

Na model `Cliente.java` remover:
```java
@NotNull(groups = ValidationGroups.ClienteId.class)
```


## Implementando sub recursos

Criar o migration `V004__cria-tabela-ocorrencia.sql`:
```sql
create table ocorrencia (
  id bigint not null auto_increment,
  entrega_id bigint not null,
  descricao text not null,
  data_registro datetime not null,
  
  primary key (id)
);

alter table ocorrencia add constraint fk_ocorrencia_entrega
foreign key (entrega_id) references entrega (id);
```

Criar uma classe `Ocorrencia` no domain.model.
`Ocorrencia.java`:
```java
// ...

@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
@Entity
public class Ocorrencia {

  @EqualsAndHashCode.Include
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  
  @ManyToOne
  private Entrega entrega;
  
  private String descricao;
  private OffsetDateTime dataRegistro;
}
```


Editar `Entrega.java`, adicionando uma lista de ocorrencias e um método para adicionar ocorrencias.
```java
public class Entrega {
  // ... private BigDecimal taxa;
  @OneToMany(mappedBy = "entrega", cascade = CascadeType.ALL)
  private List<Ocorrencia> ocorrencias = new ArrayList<>();
  
  public Ocorrencia adicionarOcorrencia(String descricao) {
    Ocorrencia ocorrencia = Ocorrencia();
    
    ocorrencia.setDescricao(descricao);
    ocorrencia.setDataRegistro(OffsetDateTime.now());
    ocorrencia.setEntrega(this);
    
    this.getOcorrencias().add(ocorrencia);
    
    return ocorrencia;
  }
}
```


Criar uma classe exception `EntidadeNaoEncontradaException.java` em ...domain.exception:
```java
public class EntidadeNaoEncontradaException extends NegocioException {
  private static final long serialVersionUID = 1L;
  
  public EntidadeNaoEncontradaException(String message) {
    super(message);
  }
}
```

No `ApiExceptionHandler.java`, criar o método `handleEntidadeNaoEncontrada`:
```java
@ExceptionHandler(EntidadeNaoEncontradaException.class)
public ResponseEntity<Object> handleEntidadeNaoEncontrada(
  EntidadeNaoEncontradaException ex,
  WebRequest request
) {
  HttpStatus status = HttpStatus.NOT_FOUND;
  
  Problema problema = new Problema();
  problema.setStatus(status.value());
  problema.setDataHora(OffsetDateTime.now());
  problema.setTitulo(ex.getMessage());
  
  return handleExceptionInternal(ex, problema, new HttpHeaders(), status, request);
}
```


Criar um serviço `BuscaEntregaService.java`:
```java
// ...
 
@AllArgsConstructor
@Service
public class BuscaEntregaService {
  private EntregaRepository entregaRepository;
  
  public Entrega buscar(Long entregaId) {
    return entregaRepository
      .findById(entregaId)
      .orElseThrow(() -> new EntidadeNaoEncontradaException("Entrega não encontrada"));
  }
}
```

Criar uma classe `RegistroOcorrenciaService.java` em domain.service:
```java
@AllArgsConstructor
@Service
public class RegistroOcorrenciaService {
  private BuscaEntregaService buscaEntregaService;

  @Transactional
  public Ocorrencia registrar(Long entregaId, String descricao) {
    Entrega entrega = buscaEntregaService.buscar(entregaId);
      
    return entrega.adicionarOcorrencia(descricao);
  }
}
```

Criar class `OcorrenciaModel.java` em ...api.model:
```java
// ...
@Getter
@Setter
public class OcorrenciaModel {
  private Long id;
  private String descricao;
  private OffsetDateTime dataRegistro;
}
```

Criar classe `OcorrenciaInput.java` em ...api.model.input:
```java
// ...
@Getter
@Setter
public class OcorrenciaInput {
  @NotBlank
  private String descricao;
}
```


Criar classe `OcorrenciaAssembler.java` em ...api.assembler:
```java
@AllArgsConstructor
@Component
public class OcorrenciaAssembler {

  private ModelMapper modelMapper;
  
  public OcorrenciaModel toModel(Ocorrencia ocorrencia) {
    return modelMapper.map(ocorrencia, OcorrenciaModel.class);
  }
  
  public List<OcorrenciaModel> toCollectionModel(List<Ocorrencia> ocorrencias) {
    return ocorrencias.stream()
      .map(this::toModel)
      .collect(Collectors.toList());
  }

}
```

Criar classe `OcorrenciaController.java` em ...api.controller:
```java
// ...
@AllArgsConstructor
@RestController
@RequestMapping("/entregas/{entregaId}/ocorrencias")
public class OcorrenciaController {

  private RegistroOcorrenciaService registroOcorrenciaService;
  private OcorrenciaAssembler ocorrenciaAssembler;
  
  @PostMapping
  @ResponseStatus(HttpStatus.CREATED)
  public OcorrenciaModel registrar(
    @PathVariable Long entregaId,
    @Valid @RequestBody OcorrenciaInput ocorrenciaInput
  ) {
    Ocorencia ocorrenciaRegistrada = registroOcorrenciaService
      .registrar(entregaId, ocorrenciaInput.getDescricao());

    return ocorrenciaAssembler.toModel(ocorrenciaRegistrada);
  }
}
```


Na classe `OcorrenciaController.java`, criar o método `()`:
```java
// ...
private BuscaEntregaService buscaEntregaService;

// ...
  @GetMapping
  public List<OcorrenciaModel> listar(@PathVariable Long entregaId) {
    Entrega entrega = buscaEntregaService.buscar(entregaId);
    
    return ocorrenciaAssembler.toCollectionModel(entrega.getOcorrencias());
  }
```


Testar criação, atualização, e listagem de status de entregas existentes/inexistentes.


## Implementando ação não CRUD

Criar uma classe `FinalizacaoEntregaService.java` em ...domain.service:
```java
// ...
@AllArgsConstructor
@Service
public class FinalizacaoEntregaService {
  private EntregaRepository entregaRepository;
  private BuscaEntregaService buscaEntregaService;
  
  @Transactional
  public void finalizar(Long entregaId) {
    Entrega entrega = buscaEntregaService.buscar(entregaId);
    
    entrega.finalizar();
    
    entregaRepository.save(entrega);
  }
}
```


Na classe`Entrega.java`, implementar o método `finalizar()`:
```java
public void finalizar() {
  if (!podeSerFinalizada()) {
    throw new NegocioException("Entrega não pode ser finalizada");
  }
  
  setStatus(StatusEntrega.FINALIZADA);
  setDataFinalizacao(OffsetDateTime.now());
}

public boolean podeSerFinalizada() {
  return StatusEntrega.PENDENTE.equals(getStatus());
}
```


O recurso que ficará disponível para finalizar uma entrega será o `PUT /entregas/{entragaId}/finalizacao`.

> Diferença do `PUT` e o `POST`: o `PUT` é idempotente.

Na classe `EntregaController.java`, adicionar o método `finalizar()`:
```java
// ...
private FinalizacaoEntregaService finalizacaoEntregaService;

// ...
@PutMapping("/{entregaId}/finalizacao")
@ResponseStatus(HttpStatus.NO_CONTENT)
public void finalizar(@PathVariable Long entregaId) {
  finalizacaoEntregaService.finalizar(entregaId);
}
```

Testar finalização de uma entrega.

