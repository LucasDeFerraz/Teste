-- ============================================================================
-- schema.sql
-- Sistema financeiro - cadastro de usuários e perfis de acesso
-- PostgreSQL
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Tabela: perfis_acesso
-- ----------------------------------------------------------------------------
CREATE TABLE perfis_acesso (
    id          SERIAL PRIMARY KEY,
    nome        VARCHAR(20)  NOT NULL UNIQUE,
    descricao   VARCHAR(100)
);

INSERT INTO perfis_acesso (nome, descricao) VALUES
    ('ASSISTENTE', 'Acesso operacional basico, sem permissao de aprovacao'),
    ('GESTOR',     'Acesso de gestao, pode aprovar operacoes da equipe'),
    ('MASTER',     'Acesso administrativo total ao sistema');

-- ----------------------------------------------------------------------------
-- Tabela: usuarios
-- ----------------------------------------------------------------------------
CREATE TABLE usuarios (
    id                  SERIAL PRIMARY KEY,
    nome_completo       VARCHAR(150) NOT NULL,
    endereco            VARCHAR(200) NOT NULL,
    cep                 VARCHAR(9)   NOT NULL,
    rg                  VARCHAR(15)  NOT NULL UNIQUE,
    cpf                 VARCHAR(14)  NOT NULL UNIQUE,
    email               VARCHAR(150) NOT NULL UNIQUE,
    telefone            VARCHAR(20)  NOT NULL,
    senha_hash          VARCHAR(255) NOT NULL,
    ativo               BOOLEAN      NOT NULL DEFAULT TRUE,
    perfil_id           INTEGER      NOT NULL,
    data_cadastro       TIMESTAMP    NOT NULL DEFAULT NOW(),
    data_atualizacao    TIMESTAMP,
    CONSTRAINT fk_usuarios_perfil
        FOREIGN KEY (perfil_id) REFERENCES perfis_acesso (id)
);
