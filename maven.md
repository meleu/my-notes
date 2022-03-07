# Maven
[✏️](https://github.com/meleu/my-notes/edit/master/maven.md)

## Opções Utilizadas no Maven

Parâmetros que utilizo no maven dentro de uma pipeline de CI/CD.

Opções Maven que são passadas na linha de comando:

- `--threads 4C`    - executa em 4 threads por CPU
- `--batch-mode`    - executa em modo não-interativo
- `--show-version`  - exibe informações da versão do Maven e da JDK
- `--errors`        - produz mensagens de erro durante a execução
- `--fail-at-end`   - apenas interrompe o build no final (útil para checar se existem várias falhas no build)

Opções Maven que são passadas através da variável de ambiente `$MAVEN_OPTS`:

- `-Dmaven.artifact.threads=15` - abre 15 conexões simultâneas para baixar dependências
- `-Dhttp.tcp.nodelay=true` - um "hack" para diminuir a latência das conexões (detalhes em: <https://eklitzke.org/the-caveats-of-tcp-nodelay>)
- `-Xmx4096M` - aloca 4GB de memória para o Maven
- `-Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=WARN` - deixa o log menos verboso.