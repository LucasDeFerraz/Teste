# Parte 2 - HTML e CSS (Página de Supermercado)

Página estática de um supermercado fictício ("Mercado Bom Preço"), construída
apenas com **HTML5 semântico e CSS puro** — sem JavaScript, sem frameworks
(Bootstrap, Tailwind, etc.) e sem bibliotecas externas.

## Arquivos

```
Parte 2 Supermercado/
├── index.html
├── style.css
├── images/        (20 imagens placeholder, uma por produto)
└── README.md
```

As imagens em `images/` são placeholders gerados em https://placehold.co/,
um por produto, cada um com uma cor de fundo diferente por categoria (verde
para Frutas e Verduras, azul para Laticínios, laranja para Mercearia, roxo
para Bebidas e verde-água para Limpeza), só para facilitar a identificação
visual sem depender de fotos reais.

## Estrutura HTML

- `<header>` fixo no topo, com o nome do mercado e um indicador de carrinho
  decorativo (ícone + contador zerado) — puramente visual, não interativo.
- `<main>` contendo uma introdução e 5 `<section>`, uma por categoria
  (Frutas e Verduras, Laticínios, Mercearia, Bebidas, Limpeza), cada uma com
  seu próprio `<h2>`.
- Dentro de cada seção, um grid de `<article>` — um por produto — contendo
  imagem, nome (`<h3>`), preço e o botão "Adicionar ao carrinho" (`<button>`
  sem `type="submit"` e sem JS associado, ou seja, existe só visualmente).
- `<footer>` com informações genéricas de rodapé.

Uso de tags semânticas (`header`, `main`, `section`, `article`, `footer`) em
vez de `div` genérica em todo lugar, para deixar a estrutura clara tanto para
leitura humana quanto para leitores de tela.

## Decisões de layout (CSS)

- **CSS Grid** (`display: grid` + `repeat(auto-fill, minmax(220px, 1fr))`)
  para os cards de produto: o grid se ajusta sozinho ao número de colunas que
  cabem na tela, sem precisar de media query para cada breakpoint intermediário.
- **Paleta suave**: fundo cinza bem claro (`#f4f6f5`), cards brancos, verde
  como cor de destaque (header, preços, botão) — remete a supermercado/hortifruti
  sem ser um verde muito saturado.
- **Cards com sombra leve** (`box-shadow` sutil) que aumenta no `:hover`,
  dando uma sensação de profundidade discreta, sem exagero.
- **Espaçamento consistente** usando `gap` no grid e um `--raio` de borda
  padronizado via CSS custom property, reaproveitado no card e na imagem.
- **Header fixo** (`position: fixed`) com `main` recebendo `padding-top`
  suficiente para o conteúdo não ficar escondido atrás dele.
- **Responsividade** via `media queries`:
  - Acima de 768px: grid flexível (quantas colunas couberem, mínimo 220px cada).
  - Até 768px (tablet): colunas um pouco mais estreitas (mínimo 160px).
  - Até 480px (celular): grid fixo de 2 colunas, fontes e paddings reduzidos,
    e mais espaço reservado no topo para o header (que quebra linha no celular).
  - Até 340px (celulares bem pequenos): 1 produto por linha.

## Como abrir

Não precisa de servidor nem de instalação de nada. Basta abrir o arquivo
`index.html` diretamente no navegador (duplo clique no arquivo, ou clique
direito → "Abrir com" → navegador de sua preferência).
