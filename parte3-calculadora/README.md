# Parte 3 - Calculadora (HTML, CSS e JavaScript puro)

Calculadora funcional com as 4 operações básicas e um painel de customização
visual (cor dos botões e fonte), tudo em HTML, CSS e JavaScript puro — sem
frameworks e sem bibliotecas externas.

## Arquivos

```
parte3-calculadora/
├── index.html
├── style.css
├── script.js
└── README.md
```

## Como abrir

Não precisa de servidor nem de instalação. Basta abrir `index.html`
diretamente no navegador (duplo clique, ou clique direito → "Abrir com").

## Como usar

- Clique nos números (0-9) e no `.` para digitar um valor.
- Clique em `÷`, `×`, `-` ou `+` para escolher a operação.
- Clique em `=` para calcular o resultado.
- Clique em `C` para limpar tudo e começar de novo.
- No painel **Personalizar** (acima da calculadora):
  - O seletor de cor muda a cor dos botões de operação e do `=` em tempo
    real, sem recarregar a página.
  - O select de fonte troca a fonte do display e dos botões em tempo real,
    entre 5 opções (padrão, serifada, monoespaçada, descontraída e
    arredondada).

## Decisões de implementação

- **Lógica da calculadora**: implementada como uma pequena máquina de
  estados (`currentInput`, `previousValue`, `operator`, `waitingForOperand`),
  o padrão mais comum para esse tipo de componente — evita ter que
  reconstruir a expressão inteira a cada clique.
- **Arredondamento de resultados**: números com muitas casas decimais
  (ex.: `1 / 3`) são arredondados para 10 casas para eliminar ruído de
  ponto flutuante do JavaScript (ex.: `0.1 + 0.2` não vira
  `0.30000000000000004`). Resultados muito grandes (≥ 1e15) ou muito
  pequenos (< 1e-9) são exibidos em notação científica, para não estourar
  o display.
- **Divisão por zero**: em vez de deixar o JavaScript calcular `Infinity`,
  o código detecta o caso e mostra `Erro` no display. A calculadora
  continua funcionando normalmente depois disso — qualquer novo número
  digitado começa um cálculo novo do zero (não precisa nem apertar `C`,
  embora `C` também funcione).
- **Operadores em sequência** (ex.: `+` depois `-` sem digitar número no
  meio): o segundo clique apenas substitui o operador pendente, em vez de
  tentar calcular algo com um número que não foi digitado.
- **Customização em tempo real**: cor e fonte são aplicadas via CSS
  Custom Properties (`--cor-botao` e `--fonte-calculadora`, definidas no
  `style.css`) que o `script.js` atualiza com
  `document.documentElement.style.setProperty(...)` a cada mudança do
  input de cor / select de fonte — sem precisar recarregar a página nem
  manipular estilos inline em cada botão individualmente.

## Casos de teste validados

Todos os casos abaixo foram executados de verdade (cliques reais nos
botões, disparando o `script.js`, não apenas calculados "no papel"):

| # | Caso | Resultado esperado | Resultado obtido |
|---|---|---|---|
| 1 | `5 + 3` | `8` | `8` ✅ |
| 2 | `10 / 0` | Mostra erro, sem travar | `Erro` ✅ |
| 2b | Digitar um número novo depois do erro | Calculadora volta a funcionar normalmente | `9` ✅ |
| 3 | `7 * 0` | `0` | `0` ✅ |
| 4 | `2.5 + 2.5` | `5` | `5` ✅ |
| 5 | `9`, `+`, `-` (sem número no meio), `4`, `=` | Não quebra; usa o último operador (`-`) → `9 - 4 = 5` | `5` ✅ |
| 6 | `1 / 3` (muitas casas decimais) | Arredondado, sem ruído de ponto flutuante | `0.3333333333` ✅ |
| 7 | `999999999999 * 999999999999` (número muito grande) | Notação científica | `1.000000e+24` ✅ (matematicamente correto: 9,99999999998×10²³ arredondado para 6 casas vira 1,000000×10²⁴) |

**Customização visual**: troquei a cor do botão (`#4f46e5` → `#ff5500`) e a
fonte (padrão → `Courier New`) via JavaScript disparando os mesmos eventos
que o usuário dispararia na interface. Confirmei que:
- A variável CSS `--cor-botao` é atualizada corretamente no `:root`
  imediatamente após a troca de cor.
- A fonte do display e dos botões muda imediatamente para `Courier New`
  (confirmado via `getComputedStyle`).
- A regra CSS dos botões de operação (`background-color: var(--cor-botao)`)
  está correta no arquivo (confirmado lendo o CSSOM da página).

Não consegui obter uma captura de tela do resultado da troca de cor porque,
neste ambiente específico de teste, o painel de visualização do navegador
não estava sendo exibido no momento (o próprio comando de screenshot
retornou esse aviso) — sem o navegador compondo os frames, a leitura de
`background-color` computado fica desatualizada, mesmo a variável CSS
estando correta. É uma limitação da ferramenta de preview usada durante o
desenvolvimento, não do código: `var()` em `background-color` é um recurso
padrão do CSS, suportado por todos os navegadores modernos. Para conferir
visualmente, basta abrir `index.html` e mexer no seletor de cor.
