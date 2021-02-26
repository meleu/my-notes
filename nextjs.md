# NextJS
[✏️](https://github.com/meleu/my-notes/edit/master/nextjs.md)

## Diferenças SSG x SPA x SSR

### Static Site Generation

#### Vantagens

- uso quase nulo do servidor
- pode ser servido numa CDN
- melhor performance
- flexibilidade para usar qualquer servidor

#### Desvantagens

- tempo de build pode ser grande
- dificuldade de escalar apps grandes
- dificuldade de atualização constante


### Single Page Application

#### Vantagens

- permite páginas ricas em interações sem recarregar
- site rápido após o load inicial
- ótimo para aplicações web
- possui diversas bibliotecas

#### Desvantagens

- loading inicial pode ser demorado
- performance imprevisível
- dificuldades no SEO (a maioria do conteúdo não é indexado)

### Servidor Side Rendering

#### Vantagens

- ótimo para SEO
- meta tags com previews mais adequados
- melhor performance para o usuário
- código compartilhado com o backend em node
- menor processamento no lado do usuário

#### Desvantagens

- TTFB (Time to First Byte) maior, o servidor vai preparar todo o conteúdo para entregar.
- html maior (desvantagem?)
- reload completo nas mudanças de rota


### Quando usar cada um?

#### SSG

- site simples sem muita interação
- uma única pessoa publicando conteúdo
- se o conteúdo muda pouco
- site simples, sem tantas páginas
- quando performance é o foco

exemplos: landing pages, blogs, portfólios

#### SPA

- indexar no google não é tão importante
- o usuário faz muitas interações na página e não quer refreshes
- informações vão ser diferentes para cada usuário

exemplos: área administrativa, twitter web, facebook web, spotify web.

#### SSR

- necessito de um SPA, mas preciso de um loading mais rápido
- conteúdo muda frequentemente
- grande número de páginas
- boa indexação no google é importante

exemplos: ecommerce, sites de notícias


