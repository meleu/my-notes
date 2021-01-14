# Document Object Model
[✏️](https://github.com/meleu/my-notes/edit/master/dom.md)

O mais básico do básico de DOM manipulation.

Todos os exemplos mencionados aqui podem ser testados no console do seu browser. Basta abrir o "Developer Tools" (geralmente a tecla `F12` abre o DevTools).

## Resumo

1. Acessar os elementos com `document.querySelector()` ou `querySelectorAll()`.
2. Manipular atributos com `.setAttribute()`/`.getAttribute()`, **exceto para estilização**.
3. Manipular estilização:
    1. preferencialmente através de classes utilizando `.classList.add()`, `.classList.remove()` e `.classList.toggle()`.
    2. em último caso utilizar `.style.propertyName = newValue` (`propertyName` equivale a `property-name` no CSS).
4. Lidar com eventos: `addEventListener()`.


## acessando elementos

```js
// métodos de document

getElementsByTagName()
getElementsByClassName()
getElementById()

querySelector()
querySelectorAll()
```
**DICA**: É preferível usar `querySelector/querySelectorAll`, pois a sintaxe é similar aos seletores CSS.

### exemplos:

```js
document.getElementsByTagName('li');
// vai retornar um HTMLCollection com todos os elementos 'li' que existirem

document.getElementsByTagName('li')[0];
// acessando o primeiro elemento individualmente

document.getElementById('idName');
// retorna o elemento com o 'id="idName"'
// OBS.:  os ids são/deveriam ser únicos. Se houver duplicação
//        apenas a primeira ocorrência é retornada.

// ----------
// ATENÇÃO! o uso de querySelector/querySelectorAll é bem mais cômodo!
// Pois funciona como um seletor CSS
// ----------

document.querySelector('ul.customList > li');
// retorna a primeira ocorrência de 'li' presente
// no 'ul' cuja classe é 'customList'

document.querySelectorAll('ul > li');
// retorna um NodeList (similar a um Array) com
// todos os 'li's filhos de 'ul's

```

## manipulando atributos

Uma vez que obtemos um elemento, podemos manipular seus atributos:

```js
// métodos de um element
getAttribute()
setAttribute()
```

**Observação**: resista a tentação de usar `get/setAttribute` para manipular a estilização. Veja [Estilização](#estilização) mais abaixo e entenda o motivo.

### exemplos

```js
let link = document.querySelector('a');

link.getAttribute('href');

link.setAttribute('https://meleu.sh/');

// NÃO FAÇA ESTILIZAÇÃO!:
link.setAttribute('style', 'background-color: yellow');
// para manipular estilização prefira o método explicado abaixo.
```


## manipulando estilização

Uma vez que temos um elemento já devidamente selecionado, podemos manipular sua estilização usando as seguintes propriedades:
```js
// manipulando a propriedade CSS diretamente
style.{propertyName}
// propertyName é uma versão camelCase de uma propriedade CSS.
// ex.: backgroundColor == background-color

// manipulando estilo através de classes é mais elegante...
className   // string com as classes separadas por espaço
classList   // "Array" onde cada item é uma classe
            // (na verdade classList é um DOMTokenList, e não um Array)

// manipular estilização através dos métodos de classList é bem mais cômodo
classList.add()
classList.remove()
classList.toggle()
```
Apesar de podermos manipular a estilização de um elemento diretamente usando, por exemplo, `element.style.backgroundColor`, uma melhor prática é fazer a estilização através de classes e então adicionar/remover a classe através dos métodos de `classList`. Vejamos isso nos exemplos a seguir.

### exemplos

```js
let link = document.querySelector('a');

// <a style="background: red">
link.style.backgroundColor = 'red';

// o mais organizado (e considerado boa prática)
// é fazer estilização através de classes
link.classList.add('className');
link.classList.remove('classToBeRemoved');

// e o legal é que dá pra ligar/desligar uma classe
link.classList.toggle('done');
```

## lidando com eventos

Podemos disparar uma ação (executar uma função) através de eventos como click do mouse, pressionamento de uma tecla, scroll da tela, etc.

Boa referência para ver lista de eventos observáveis: <https://developer.mozilla.org/en-US/docs/Web/Events>

Para fazer com que um elemento do DOM fique monitorando por um determinado evento, usamos o método `addEventListener()`. O que este método faz é definir uma função que será executada quando um determinado evento ocorrer naquele elemento.

```js
target.addEventListener(eventType, eventListenerCallback);
// obs 1: eventType é uma string (veja documentação linkada acima)
// obs 2: eventListenerCallback recebe o evento como primeiro argumento
```

Maiores detalhes sobre `addEventListener`: <https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener>


### exemplos

Vamos colocar um background vermelho quando clicarmos no primeiro `<p>` do documento.

```js
const paragrafo = document.querySelector('p');

function handleClickParagrafo(event) {
  this.style.backgroundColor = 'red';
  // também poderia ser:
  // event.currentTarget.style.backgroundColor = 'red';
}

paragrafo.addEventListener('click', handleClickParagrafo);
```
