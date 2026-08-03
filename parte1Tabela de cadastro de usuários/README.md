# Parte 1 - SQL (PostgreSQL)

Script de banco de dados para um sistema financeiro de cadastro de usuários e
perfis de acesso.

## Arquivos

| Arquivo | Descrição |
|---|---|
| `schema.sql` | Cria as tabelas `perfis_acesso` e `usuarios`, com os 3 perfis já inseridos. |
| `test_constraints.sql` | Bateria de INSERTs que testam cada constraint da tabela `usuarios` (deve ser executado **depois** do `schema.sql`). |
| `README.md` | Este arquivo. |

## Estrutura das tabelas

### `perfis_acesso`

| Coluna | Tipo | Regra |
|---|---|---|
| `id` | `SERIAL PRIMARY KEY` | Chave primária autoincremental. |
| `nome` | `VARCHAR(20) NOT NULL UNIQUE` | Nome do perfil (`ASSISTENTE`, `GESTOR`, `MASTER`). `UNIQUE` evita perfis duplicados; `NOT NULL` porque todo perfil precisa de um nome para ser referenciado no sistema. |
| `descricao` | `VARCHAR(100)` | Texto livre explicando o perfil. Opcional, por isso sem `NOT NULL`. |

Os 3 perfis (`ASSISTENTE`, `GESTOR`, `MASTER`) já são inseridos pelo próprio
`schema.sql`, já que são valores fixos de domínio da aplicação (não fazem
sentido "vazios").

### `usuarios`

| Coluna | Tipo | Regra e motivo |
|---|---|---|
| `id` | `SERIAL PRIMARY KEY` | Identificador interno, nunca exposto como CPF/RG. |
| `nome_completo` | `VARCHAR(150) NOT NULL` | Campo obrigatório de cadastro. |
| `endereco` | `VARCHAR(200) NOT NULL` | Necessário para KYC (Know Your Customer) em sistema financeiro. |
| `cep` | `VARCHAR(9) NOT NULL` | Guardado como texto (não numérico) para preservar o zero à esquerda e o formato `00000-000`. |
| `rg` | `VARCHAR(15) NOT NULL UNIQUE` | Documento pessoal; `UNIQUE` impede que o mesmo RG seja cadastrado duas vezes. `VARCHAR` porque o RG pode conter letras (dígito verificador) e pontuação. |
| `cpf` | `VARCHAR(14) NOT NULL UNIQUE` | Documento fiscal único por pessoa; em sistema financeiro é a chave natural do usuário, por isso `UNIQUE` é uma regra de negócio crítica (evita duplicidade de identidade/fraude). Guardado como texto para preservar zeros à esquerda e a máscara `000.000.000-00`. |
| `email` | `VARCHAR(150) NOT NULL UNIQUE` | Usado como login/contato; `UNIQUE` evita duas contas com o mesmo e-mail. |
| `telefone` | `VARCHAR(20) NOT NULL` | Contato obrigatório; texto para suportar DDI/máscara. |
| `senha_hash` | `VARCHAR(255) NOT NULL` | **Nunca a senha em texto puro** — armazena o hash (ex.: bcrypt), daí o tamanho generoso (255) e o `NOT NULL`. |
| `ativo` | `BOOLEAN NOT NULL DEFAULT TRUE` | Permite desativar (soft-disable) um usuário sem apagar o histórico/registro — importante em sistema financeiro por auditoria. |
| `perfil_id` | `INTEGER NOT NULL` + `FOREIGN KEY -> perfis_acesso(id)` | Todo usuário precisa ter um perfil de acesso válido; a FK garante integridade referencial (não é possível referenciar um perfil que não existe). |
| `data_cadastro` | `TIMESTAMP NOT NULL DEFAULT NOW()` | Data de criação do registro, preenchida automaticamente pelo banco. |
| `data_atualizacao` | `TIMESTAMP` | Nula até a primeira atualização; fica a cargo da aplicação (ou de um trigger, se desejado) atualizar esse campo. |

## Como rodar

### Com Docker

```bash
docker run --name pg-teste -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:16
docker exec -i pg-teste psql -U postgres -c "CREATE DATABASE teste_tecnico;"
docker exec -i pg-teste psql -U postgres -d teste_tecnico < schema.sql
docker exec -i pg-teste psql -U postgres -d teste_tecnico -v ON_ERROR_STOP=0 < test_constraints.sql
```

### Com PostgreSQL instalado localmente

```bash
createdb teste_tecnico
psql -d teste_tecnico -f schema.sql
psql -d teste_tecnico -v ON_ERROR_STOP=0 -f test_constraints.sql
```

`-v ON_ERROR_STOP=0` é importante no segundo comando: o `test_constraints.sql`
**espera** que vários INSERTs falhem (é o propósito do arquivo), então essa
flag evita que o `psql` aborte no primeiro erro.

## Validação deste script

Neste ambiente não havia Docker nem um PostgreSQL local disponíveis, então a
validação de sintaxe/execução foi feita com **SQLite** como fallback (conforme
combinado), adaptando apenas duas diferenças de dialeto só para o teste local
(o `schema.sql` entregue continua 100% PostgreSQL, sem alterações):

- `SERIAL PRIMARY KEY` → `INTEGER PRIMARY KEY AUTOINCREMENT`
- `DEFAULT NOW()` → `DEFAULT CURRENT_TIMESTAMP`

Resultado:
- `schema.sql`: executou sem erros, criou as duas tabelas e inseriu os 3
  perfis (`ASSISTENTE`, `GESTOR`, `MASTER`).
- `test_constraints.sql`: o INSERT válido (linha de base) foi aceito; os 7
  INSERTs inválidos (CPF duplicado, e-mail duplicado, RG duplicado, dois casos
  de campo obrigatório ausente, `perfil_id` inexistente e nome de perfil
  duplicado) foram todos corretamente rejeitados pelas constraints.
