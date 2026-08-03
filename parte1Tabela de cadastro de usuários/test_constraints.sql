-- ============================================================================
-- test_constraints.sql
-- Testa as constraints da tabela usuarios (e da FK para perfis_acesso).
-- Rode este arquivo APOS o schema.sql, no mesmo banco.
--
-- Convencao: cada bloco tem um INSERT valido (deve funcionar) seguido de um
-- INSERT invalido (deve ser REJEITADO pela constraint indicada).
-- Em psql, rode com "ON_ERROR_STOP=0" (ou o parametro -v abaixo) para que a
-- execucao continue mesmo apos os erros esperados:
--
--   psql -v ON_ERROR_STOP=0 -d nome_do_banco -f test_constraints.sql
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 0) Registro base valido, usado como referencia nos testes de duplicidade
-- ----------------------------------------------------------------------------
INSERT INTO usuarios
    (nome_completo, endereco, cep, rg, cpf, email, telefone, senha_hash, perfil_id)
VALUES
    ('Ana Paula Souza', 'Rua das Flores, 123', '01310-100', '12.345.678-9',
     '123.456.789-00', 'ana.souza@example.com', '(11) 91234-5678',
     '$2b$12$hashdeexemplo0000000000000000000000000000000000000000', 1);
-- Esperado: SUCESSO (1 linha inserida)


-- ----------------------------------------------------------------------------
-- 1) CPF duplicado -> deve violar a UNIQUE constraint de cpf
-- ----------------------------------------------------------------------------
INSERT INTO usuarios
    (nome_completo, endereco, cep, rg, cpf, email, telefone, senha_hash, perfil_id)
VALUES
    ('Bruno Lima', 'Av. Central, 456', '02020-200', '98.765.432-1',
     '123.456.789-00', 'bruno.lima@example.com', '(11) 99999-0000',
     '$2b$12$hashdeexemplo1111111111111111111111111111111111111111', 2);
-- Esperado: ERRO -> duplicate key value violates unique constraint "usuarios_cpf_key"


-- ----------------------------------------------------------------------------
-- 2) Email duplicado -> deve violar a UNIQUE constraint de email
-- ----------------------------------------------------------------------------
INSERT INTO usuarios
    (nome_completo, endereco, cep, rg, cpf, email, telefone, senha_hash, perfil_id)
VALUES
    ('Carla Mendes', 'Rua Nova, 789', '03030-300', '11.222.333-4',
     '987.654.321-00', 'ana.souza@example.com', '(11) 98888-7777',
     '$2b$12$hashdeexemplo2222222222222222222222222222222222222222', 1);
-- Esperado: ERRO -> duplicate key value violates unique constraint "usuarios_email_key"


-- ----------------------------------------------------------------------------
-- 2b) RG duplicado -> deve violar a UNIQUE constraint de rg
-- ----------------------------------------------------------------------------
INSERT INTO usuarios
    (nome_completo, endereco, cep, rg, cpf, email, telefone, senha_hash, perfil_id)
VALUES
    ('Daniela Alves', 'Rua Alpha, 10', '04040-400', '12.345.678-9',
     '111.222.333-44', 'daniela.alves@example.com', '(11) 97777-6666',
     '$2b$12$hashdeexemplo3333333333333333333333333333333333333333', 2);
-- Esperado: ERRO -> duplicate key value violates unique constraint "usuarios_rg_key"


-- ----------------------------------------------------------------------------
-- 3) Campo obrigatorio ausente (nome_completo NULL) -> deve violar NOT NULL
-- ----------------------------------------------------------------------------
INSERT INTO usuarios
    (nome_completo, endereco, cep, rg, cpf, email, telefone, senha_hash, perfil_id)
VALUES
    (NULL, 'Rua Beta, 20', '05050-500', '22.333.444-5',
     '222.333.444-55', 'sem.nome@example.com', '(11) 96666-5555',
     '$2b$12$hashdeexemplo4444444444444444444444444444444444444444', 1);
-- Esperado: ERRO -> null value in column "nome_completo" violates not-null constraint


-- ----------------------------------------------------------------------------
-- 3b) Campo obrigatorio ausente (senha_hash omitida do INSERT) -> viola NOT NULL
-- ----------------------------------------------------------------------------
INSERT INTO usuarios
    (nome_completo, endereco, cep, rg, cpf, email, telefone, perfil_id)
VALUES
    ('Eduardo Ramos', 'Rua Gama, 30', '06060-600', '33.444.555-6',
     '333.444.555-66', 'eduardo.ramos@example.com', '(11) 95555-4444', 1);
-- Esperado: ERRO -> null value in column "senha_hash" violates not-null constraint


-- ----------------------------------------------------------------------------
-- 4) perfil_id inexistente -> deve violar a FOREIGN KEY para perfis_acesso
-- ----------------------------------------------------------------------------
INSERT INTO usuarios
    (nome_completo, endereco, cep, rg, cpf, email, telefone, senha_hash, perfil_id)
VALUES
    ('Fernanda Costa', 'Rua Delta, 40', '07070-700', '44.555.666-7',
     '444.555.666-77', 'fernanda.costa@example.com', '(11) 94444-3333',
     '$2b$12$hashdeexemplo5555555555555555555555555555555555555555', 999);
-- Esperado: ERRO -> insert or update on table "usuarios" violates foreign key
--           constraint "fk_usuarios_perfil"


-- ----------------------------------------------------------------------------
-- 5) nome de perfil duplicado em perfis_acesso -> deve violar UNIQUE(nome)
-- ----------------------------------------------------------------------------
INSERT INTO perfis_acesso (nome, descricao) VALUES
    ('MASTER', 'Tentativa de duplicar perfil existente');
-- Esperado: ERRO -> duplicate key value violates unique constraint "perfis_acesso_nome_key"


-- ----------------------------------------------------------------------------
-- 6) Confirmacao final: apenas o registro do passo 0 deve existir
-- ----------------------------------------------------------------------------
SELECT id, nome_completo, cpf, email, perfil_id FROM usuarios;
-- Esperado: 1 linha (Ana Paula Souza) - todos os INSERTs invalidos foram rejeitados
