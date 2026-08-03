# Parte 4 - Laravel (versão melhorada do supermercado)

Versão "melhorada" da página do supermercado (mesmo catálogo de produtos e
categorias da `parte2-html-css`), reconstruída como uma aplicação Laravel,
usando **Bootstrap** para a estrutura geral e **Tailwind CSS** para os
ajustes finos de estilo.

## Stack

- **Laravel 13** (PHP 8.4)
- **Bootstrap 5** — instalado via npm, responsável pela estrutura: grid
  (`container` / `row` / `col-*`), o componente `navbar` do header fixo, e o
  componente `card` dos produtos.
- **Tailwind CSS v4** — já vem configurado por padrão no Laravel 13 (via
  `@tailwindcss/vite`), usado só para ajustes finos que o Bootstrap não
  cobre: cores específicas (indigo), espaçamento exato do offset do header
  fixo (`pt-24`), etc.
- **JavaScript puro** (sem lib) para pequenas interações visuais (destaque
  do card no hover, feedback "Adicionado ✓" ao clicar no botão) — sem
  lógica de carrinho real.

### Por que Bootstrap *e* Tailwind, sem redundância

Os dois entram com papéis diferentes e não sobrepostos:

- O **preflight/reset** do Tailwind foi desativado (`resources/css/app.css`
  importa só `tailwindcss/theme` e `tailwindcss/utilities`, não
  `tailwindcss/preflight`), para não brigar com o reset (Reboot) do
  Bootstrap.
- **Bootstrap** decide layout/estrutura: grid responsivo e os componentes
  prontos (navbar, card, botão base).
- **Tailwind** só adiciona classes utilitárias pontuais em cima disso
  (cor, espaçamento fino, `aspect-ratio` da imagem via CSS customizado).

Nenhum dos dois duplica grid ou reset do outro.

## Estrutura do projeto (o que interessa para este teste)

```
parte4-laravel/
├── app/Http/Controllers/ProdutoController.php   ← Controller (dados dos produtos/categorias)
├── routes/web.php                                ← Rota da página principal
├── resources/
│   ├── views/
│   │   ├── layouts/app.blade.php                 ← Layout base (head, @vite, estrutura HTML)
│   │   └── produtos/index.blade.php               ← View da página do supermercado
│   ├── css/
│   │   ├── bootstrap.css                          ← Import do Bootstrap (via npm)
│   │   └── app.css                                 ← Tailwind (theme+utilities) + CSS customizado
│   └── js/app.js                                   ← Hover/clique decorativos (sem backend)
├── public/images/                                 ← Imagens dos produtos (mesmas da parte2-html-css)
└── vite.config.js                                 ← Registra bootstrap.css, app.css e app.js no build
```

- **Rota**: `routes/web.php` define `GET /` apontando para
  `ProdutoController@index`.
- **Controller**: `app/Http/Controllers/ProdutoController.php` monta um
  array de categorias (cada uma com nome + lista de produtos com nome,
  preço e nome do arquivo de imagem) e passa para a view via
  `view('produtos.index', compact('categorias'))`.
- **View**: `resources/views/produtos/index.blade.php` estende
  `layouts/app.blade.php` e itera as categorias/produtos com `@foreach`,
  formatando o preço com `number_format($produto['preco'], 2, ',', '.')`
  para o padrão `R$ 00,00`.

## Como rodar o projeto do zero

Pré-requisitos: PHP 8.2+, Composer, Node.js/npm.

```bash
cd teste-tecnico/parte4-laravel

# instala dependências PHP
composer install

# instala dependências JS (Bootstrap, Tailwind, Vite)
npm install

# cria o .env e a chave da aplicação (se ainda não existir)
cp .env.example .env
php artisan key:generate

# compila os assets (Bootstrap + Tailwind + JS) para public/build
npm run build

# sobe o servidor local
php artisan serve
```

Depois é só abrir **http://127.0.0.1:8000** no navegador.

> Durante o desenvolvimento, se quiser hot-reload dos assets em vez de
> rebuildar manualmente, rode `npm run dev` em um terminal e
> `php artisan serve` em outro.

## Verificação feita

- `npm run build` rodou sem erros e gerou `bootstrap.css` (~230KB),
  `app.css` (Tailwind + customizações) e `app.js` em `public/build/`.
- `php artisan serve` subiu o servidor e a rota `/` respondeu **200 OK**,
  sem erros no console do navegador.
- Os 20 produtos, nas 5 categorias (Frutas e Verduras, Laticínios,
  Mercearia, Bebidas, Limpeza), aparecem com nome, imagem, preço no formato
  `R$ 00,00` e botão "Adicionar ao carrinho".
- Testado via clique real no botão: o texto muda para "Adicionado ✓"
  temporariamente (feedback visual, sem chamada ao backend) e o hover no
  card aplica/remove a classe de destaque corretamente.
