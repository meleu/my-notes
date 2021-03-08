# CSS
[✏️](https://github.com/meleu/my-notes/edit/master/css.md)

## course

- <https://css-for-js.dev/> - this seems to be an awesome course (CSS aimed to JS developers).

## smooth scrolling

```css
scroll-behavior: smooth;
```

## CSS variables

From <https://www.w3schools.com/css/css3_variables.asp>

> Variables in CSS should be declared within a CSS selector that defines its scope. For a global scope you can use either the `:root` or the `body` selector.
> 
> The variable name must begin with two dashes (--) and is case sensitive!
> 
> The syntax of the var() function is as follows:
>
> `var(custom-name, value)`
> - `custom-name`: Required. The custom property's name (must start with two dashes)
> - `value`: Optional. The fallback value (used if the custom property is invalid)


## flexbox way to position something in the center of the screen

```css
html, body, #container {
  height: 100vh;
}

#container {
  display: flex;
  align-items: center;
  justify-content: center;
}
```


## background perfeitamente ajustado

Truque aprendido em [https://css-tricks.com/perfect-full-page-background-image/](https://css-tricks.com/perfect-full-page-background-image/)

O objetivo é usar uma imagem com plano de fundo de uma página web, cobrindo toda a janela.

Premissas:
- preencher toda a página com a imagem, sem espaços em branco;
- redimensionar a imagem se necessário;
- manter a proporção da imagem (_aspect ratio_);
- imagem centralizada na página;
- imagem não provoca o aparecimento de barras de rolagem;
- funciona ~~em qualquer~~ na esmagadora maioria dos navegadores.

Eis o código CSS:
```css
html {
  background: url("background.jpg") no-repeat center center fixed;
  background-size: cover;
}
```

## transition e transform


Isso é um resumo do que eu aprendi lendo esse artigo: [https://thoughtbot.com/blog/transitions-and-transforms#transition-timing-optional](https://thoughtbot.com/blog/transitions-and-transforms#transition-timing-optional)

- `transform`: move ou muda a aparência de um elemento.
- `transition`: faz o elemento mudar suave e gradualmente.

Estas duas propriedades são combinadas fazem com que o `transition` torne as mudanças causadas pelo `transform` ocorrerem de forma suave e agradável (caso contrário a mudança seria abrupta).

Aqui está um exemplo ridiculamente simples de HTML/CSS para ir brincando com as possibilidades:
```html
<!DOCTYPE html>
<html lang="en">

<head>
  <style>
    .container {
      display: flex;
      justify-content: center;
    }

    .box {
      width: 50px;
      height: 50px;
      background-color: red;
      transition: all 1s;
    }

    .box:hover {
      transform: scale(2);
    }
  </style>
  <title>Document</title>
</head>

<body>
  <h1>praticando transition e transform</h1>

  <div class="container">
    <div class="box"></div>
  </div>
</body>

</html>
```


### `transition`

Duas propriedades são necessárias para o `transition` fazer efeito:

1. `transition-property`
2. `transition-duration`

Existem outras, mas essas são obrigatórias. A propósito, o mais usual é usar a versão resumida de definir todas essas propriedades:

```css
selector {
  transition: [property] [duration] [timing-function] [delay];
}
```

#### `transition-property` (obrigatória)

Especifica em que propriedade CSS a `transition` será aplicada.

É comum usar simplesmente `all`, mas também pode ser específico (ex.: `background-color`).

Exemplo:
```css
div {
  transition-property: background-color;
}
```

#### `transition-duration` (obrigatória)

Especifica o intervalo de tempo da transição.

Pode ser em `s` (segundos) ou `ms` (milisegundos).

Exemplo:
```css
div {
  transition-duration: 300ms;
}
```

No entanto o mais usual é usar simplesmente `transition` e declarar os valores de `-property` e `-duration` numa única linha:
```css
div {
  transition: all 2s;
}
```

#### `transition-timing-function` (opcional)

Permite que você defina o comportamento da velocidade da transição durante a sua duração.

O padrão é `ease`. O comportamento de cada um é descrito a seguir:

- `ease`: acelera rapidamente e vai desacelerando no final.
- `linear`: velocidade constante.
- `ease-in`: acelera progressivamente até parar abruptamene no fim.
- `ease-out`: começa de maneira abrupta e desacelera no fim.
- `ease-in-out`: começa acelerando e termina desacelerando (semelhante ao `ease`, porém a aceleração inicial é um pouco mais suave).
- `cubic-bezier()`: uma forma avançada de `-timing-function`. Documentada em detalhes [aqui](https://developer.mozilla.org/en-US/docs/Web/CSS/easing-function).

Examplos:
```css
div {
  transition-timing-function: ease-in-out;
}

/* formato simplificado */
div {
  transition: all 3s ease-in-out;
}
```

The `transition-delay` property allows you to specify when the transform will start. By default, the transition starts as soon as it is triggered (e.g., on mouse hover). However, if you want to transition to start after it is triggered you can use the transition delay property. 

#### `transition-delay` (opcional)

Permite especificar quando a transformação se inicia. Por padrão a transição inicia assim que ela é disparada (ex.: on mouse hover).

No formato simplificado, se o `timing-function` é omitido, o terceiro argumento ´e o `-delay`:
```css
div {
  transition: all 3s 1s;
}
```

### `transform`

Abordaremos aqui apenas algumas transformações 2D.

Transformações são disparadas quando um elemento muda de estado, tais como clicar com o mouse (on mouse click) e posicionar o cursor do mouse no elemento (on mouse hover).

#### `scale`

Aumenta o tamanho do elemento.

Exemplo:
```css
div:hover {
  transform: scale(1.2);
}
```

Um valor de `2`, por exemplo, vai dobrar o tamanho do elemento. Um valor de `0.5`, vai encolher o elemento para metade do seu tamanho original.

Também é possível aplicar `scale` apenas na largura (eixo X) ou altura (eixo Y) do elemento.

```css
/* somente no eixo X */
div:hover {
  transform: scaleX(2);
}

/* aplicando valores diferentes para X e Y */
div:hover {
  transform: scale(2, 4);
}
```

#### `rotate`

Rotaciona o elemento no sentido horário.

O argumento é passado em número de graus a ser rotacionado, ex.: `90deg`. Valores negativos fazem a rotação acontecer no sentido anti-horário.

```css
div:hover {
  transform: rotate(-180deg);
}
```

#### `translate`

Desloca um elemento nos X e/ou Y.

Valores positivos para X desloca o elemento para a direita (negativo, para a esquerda). Valores positivos para Y desloca o elemento para baixo (negativo, para cima).

No exemplo a seguir o deslocamento é feito diagonalmente para baixo e para a direita.
```css
div:hover {
  transform: translate(20px, 20px);
}
```

#### `skew`

Inclina o elemento baseado nos valores passados para o eixo X e Y (valores em graus).

Uma coisa que achei estranho é que um valor positivo em X causa uma inclinação no sentido anti-horário (negativo, sentido horário). No entanto um valor positivo em Y causa uma inclinação no sentido horário (negativo, sentido anti-horário).

Exemplos:
```css
div:hover {
  transform: skewX(-20deg);
}

/* sintaxe resumida */
div:hover {
  transform: skew(20deg, 10deg);
}
```

**Observação**: ao usar `skew` todos os elementos filho também serão inclinados. Para fazê-los voltar a posição original use `skew` nos filhos com o valor oposto do que foi usado no elemento pai.

### `transform-origin`

Permite especificar a localização, no elemento, a partir da qual a transformação acontecerá. Por padrão a origem é no centro do elemento.

A localização é especificada em porcentagem do tamanho do elemento, onde `0% 0%` significa `left top`, e `100% 100%` significa `right bottom`.

É uma propriedade separada do `transform` mas trabalha em conjunto com ela (da mesma forma que o `transition`).

Exemplo:
```css
div {
  transition: transform 1s;
  transform-origin: left top;
}

div:hover {
  transform: rotate(720deg);
}
```

### Combinando transformações

Também é possível fazer bizarrices como:
```css
div {
  transform: rotate(90deg) scale(2) translate(50%, -50%);
}
```

Também existe um método chamado de _matrix method_, mas não cheguei e verificar como é. Documentação: [https://developer.mozilla.org/en-US/docs/Web/CSS/transform#matrix](https://developer.mozilla.org/en-US/docs/Web/CSS/transform#matrix)

### Indo além

Básico de animações com CSS: [https://thoughtbot.com/blog/css-animation-for-beginners](https://thoughtbot.com/blog/css-animation-for-beginners)

[http://codepen.io/](http://codepen.io/) - um _CSS sandbox_ para testar o código e ver os resultados na hora.

