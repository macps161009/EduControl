-- ==========================================
-- 1. CRIAR BANCO DE DADOS
-- ==========================================

CREATE DATABASE IF NOT EXISTS tcc_rfid
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE tcc_rfid;


-- ==========================================
-- 2. TABELA SALA
-- ==========================================

CREATE TABLE sala (
    numero INT PRIMARY KEY,
    capacidade INT NOT NULL,
    andar VARCHAR(40),
    status VARCHAR(40) NOT NULL
);

-- ==========================================
-- INSERIR SALAS
-- ==========================================

INSERT INTO sala (numero, capacidade, andar, status)
VALUES
(101, 35, '1º Andar', 'ATIVA'),
(102, 35, '1º Andar', 'ATIVA'),
(201, 35, '2º Andar', 'ATIVA'),
(202, 35, '2º Andar', 'ATIVA'),
(301, 35, '3º Andar', 'ATIVA');

-- ==========================================
-- CONSULTAR SALAS
-- ==========================================

SELECT * FROM sala;



-- ==========================================
-- 3. TABELA TURMA
-- ==========================================

CREATE TABLE turma (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    curso VARCHAR(150),
    turno VARCHAR(30),
    sala_numero INT,

    CONSTRAINT fk_turma_sala
    FOREIGN KEY (sala_numero)
    REFERENCES sala(numero)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);

-- ==========================================
-- INSERIR TURMAS
-- ==========================================

INSERT INTO turma (nome, curso, turno, sala_numero)
VALUES
('1 Ano A', 'Ensino Fundamental', 'Matutino', 101),
('1 Ano B', 'Ensino Fundamental', 'Vespertino', 102),
('2 Ano A', 'Ensino Fundamental', 'Matutino', 201),
('3 Ano A', 'Ensino Fundamental', 'Matutino', 202),
('6 Ano A', 'Ensino Fundamental', 'Vespertino', 301);

-- ==========================================
-- CONSULTAR TURMAS
-- ==========================================

SELECT * FROM turma;

-- ==========================================
-- CONSULTAR TURMAS COM SUAS SALAS
-- ==========================================

SELECT
    turma.id,
    turma.nome,
    turma.curso,
    turma.turno,
    sala.numero AS numero_sala,
    sala.capacidade,
    sala.andar,
    sala.status AS status_sala
FROM turma
INNER JOIN sala
ON turma.sala_numero = sala.numero;



-- ==========================================
-- 4. TABELA ALUNO
-- ==========================================

CREATE TABLE aluno (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    matricula VARCHAR(30) NOT NULL UNIQUE,
    data_nascimento DATE,
    cartao_uid VARCHAR(64) UNIQUE,
    cpf VARCHAR(14) UNIQUE,
    turma_id INT,
    turno VARCHAR(30),
    responsavel_nome VARCHAR(150),
    parentesco VARCHAR(60),
    responsavel_telefone VARCHAR(30),
    responsavel_email VARCHAR(150),
    endereco VARCHAR(255),
    data_matricula DATE,

    CONSTRAINT fk_aluno_turma
    FOREIGN KEY (turma_id)
    REFERENCES turma(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);

-- ==========================================
-- INSERIR ALUNOS
-- ==========================================

INSERT INTO aluno (
    nome, matricula, data_nascimento, cartao_uid,
    cpf, turma_id, turno, responsavel_nome,
    parentesco, responsavel_telefone,
    responsavel_email, endereco, data_matricula
)
VALUES
(
    'Joao Pedro', '2026001', '2012-05-15', 'RFID001',
    NULL, (SELECT id FROM turma WHERE nome = '1 Ano A'),
    'Matutino', 'Maria Silva', 'Mae',
    '35999990001', 'maria@email.com',
    'Rua das Flores, 100', '2026-01-20'
),
(
    'Ana Clara', '2026002', '2013-08-22', 'RFID002',
    NULL, (SELECT id FROM turma WHERE nome = '1 Ano B'),
    'Vespertino', 'Carlos Souza', 'Pai',
    '35999990002', 'carlos@email.com',
    'Rua Central, 200', '2026-01-20'
),
(
    'Pedro Henrique', '2026003', '2011-03-10', 'RFID003',
    NULL, (SELECT id FROM turma WHERE nome = '2 Ano A'),
    'Matutino', 'Juliana Oliveira', 'Mae',
    '35999990003', 'juliana@email.com',
    'Avenida Brasil, 300', '2026-01-21'
),
(
    'Lucas Gabriel', '2026004', '2010-11-05', 'RFID004',
    NULL, (SELECT id FROM turma WHERE nome = '3 Ano A'),
    'Matutino', 'Roberto Santos', 'Pai',
    '35999990004', 'roberto@email.com',
    'Rua Primavera, 400', '2026-01-21'
),
(
    'Mariana Costa', '2026005', '2012-07-18', 'RFID005',
    NULL, (SELECT id FROM turma WHERE nome = '6 Ano A'),
    'Vespertino', 'Fernanda Costa', 'Mae',
    '35999990005', 'fernanda@email.com',
    'Rua das Acacias, 500', '2026-01-22'
);

-- ==========================================
-- CONSULTAR ALUNOS
-- ==========================================

SELECT * FROM aluno;

-- ==========================================
-- CONSULTAR ALUNOS E SUAS TURMAS
-- ==========================================

SELECT
    aluno.id,
    aluno.nome,
    aluno.matricula,
    turma.nome AS turma,
    aluno.turno
FROM aluno
INNER JOIN turma
ON aluno.turma_id = turma.id;



-- ==========================================
-- 5. TABELA CARTAO RFID
-- ==========================================

CREATE TABLE cartao_rfid (
    uid VARCHAR(64) PRIMARY KEY,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    aluno_id INT UNIQUE,

    CONSTRAINT fk_cartao_aluno
    FOREIGN KEY (aluno_id)
    REFERENCES aluno(id)
    ON UPDATE CASCADE
    ON DELETE SET NULL
);

-- ==========================================
-- INSERIR CARTOES RFID
-- ==========================================

INSERT INTO cartao_rfid (uid, ativo, aluno_id)
VALUES
(
    'RFID001', TRUE,
    (SELECT id FROM aluno WHERE matricula = '2026001')
),
(
    'RFID002', TRUE,
    (SELECT id FROM aluno WHERE matricula = '2026002')
),
(
    'RFID003', TRUE,
    (SELECT id FROM aluno WHERE matricula = '2026003')
),
(
    'RFID004', TRUE,
    (SELECT id FROM aluno WHERE matricula = '2026004')
),
(
    'RFID005', TRUE,
    (SELECT id FROM aluno WHERE matricula = '2026005')
);

-- ==========================================
-- CONSULTAR CARTOES RFID
-- ==========================================

SELECT * FROM cartao_rfid;

-- ==========================================
-- CONSULTAR CARTOES E ALUNOS
-- ==========================================

SELECT
    cartao_rfid.uid,
    cartao_rfid.ativo,
    aluno.nome,
    aluno.matricula
FROM cartao_rfid
INNER JOIN aluno
ON cartao_rfid.aluno_id = aluno.id;



-- ==========================================
-- 6. TABELA REGISTRO DE PRESENCA
-- ==========================================

CREATE TABLE registro_presenca (
    id SERIAL PRIMARY KEY,
    data DATE NOT NULL,
    horario TIME NOT NULL,
    status VARCHAR(30) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    origem VARCHAR(30) NOT NULL,
    aluno_id INT NOT NULL,

    CONSTRAINT fk_presenca_aluno
    FOREIGN KEY (aluno_id)
    REFERENCES aluno(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- ==========================================
-- CRIAR INDICES
-- ==========================================

CREATE INDEX idx_presenca_data
ON registro_presenca(data);

CREATE INDEX idx_presenca_aluno_data
ON registro_presenca(aluno_id, data);

-- ==========================================
-- INSERIR REGISTROS DE PRESENCA
-- ==========================================

INSERT INTO registro_presenca (
    data, horario, status, tipo, origem, aluno_id
)
VALUES
(
    '2026-02-10', '07:00:00', 'PRESENTE',
    'ENTRADA', 'RFID',
    (SELECT id FROM aluno WHERE matricula = '2026001')
),
(
    '2026-02-10', '07:15:00', 'ATRASADO',
    'ENTRADA', 'RFID',
    (SELECT id FROM aluno WHERE matricula = '2026002')
),
(
    '2026-02-10', '07:05:00', 'PRESENTE',
    'ENTRADA', 'RFID',
    (SELECT id FROM aluno WHERE matricula = '2026003')
),
(
    '2026-02-10', '07:20:00', 'ATRASADO',
    'ENTRADA', 'MANUAL',
    (SELECT id FROM aluno WHERE matricula = '2026004')
),
(
    '2026-02-10', '07:02:00', 'PRESENTE',
    'ENTRADA', 'RFID',
    (SELECT id FROM aluno WHERE matricula = '2026005')
);

-- ==========================================
-- CONSULTAR REGISTROS
-- ==========================================

SELECT * FROM registro_presenca;

-- ==========================================
-- CONSULTAR POR DATA E HORARIO
-- ==========================================

SELECT *
FROM registro_presenca
ORDER BY data DESC, horario ASC;


-- ==========================================
-- 7. TABELA TEAM
-- ==========================================

CREATE TABLE team (
    id SERIAL PRIMARY KEY,
    matricula VARCHAR(30) NOT NULL UNIQUE,
    nome VARCHAR(150) NOT NULL,
    data_nascimento DATE,
    cpf VARCHAR(14) UNIQUE,
    status VARCHAR(30) NOT NULL,
    tipo_vinculo VARCHAR(50),
    cargo VARCHAR(100),
    setor VARCHAR(100),
    data_admissao DATE,
    jornada_semanal INT,
    telefone VARCHAR(30),
    email VARCHAR(150) UNIQUE,
    endereco VARCHAR(255),
    senha VARCHAR(255) NOT NULL,
    tipo_acesso VARCHAR(40) NOT NULL,
    acesso_ativo BOOLEAN NOT NULL DEFAULT TRUE,
    foto_perfil VARCHAR(500),
    ultimo_acesso TIMESTAMP,
    data_criacao_conta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_alteracao_senha TIMESTAMP
);

-- ==========================================
-- INSERIR FUNCIONÁRIOS
-- ==========================================

INSERT INTO team (
    matricula, nome, data_nascimento, cpf, status,
    tipo_vinculo, cargo, setor, data_admissao,
    jornada_semanal, telefone, email, endereco,
    senha, tipo_acesso, acesso_ativo, foto_perfil
)
VALUES
(
    'FUNC001', 'Marcos Silva', '1990-05-10', NULL,
    'ATIVO', 'CLT', 'Professor', 'Educacao',
    '2025-01-10', 40, '35999991111',
    'marcos@escola.com', 'Rua A, 100',
    'SUBSTITUIR_POR_HASH_BCRYPT', 'ADMIN', TRUE, NULL
),
(
    'FUNC002', 'Ana Souza', '1988-03-15', NULL,
    'ATIVO', 'CLT', 'Secretaria', 'Administrativo',
    '2025-02-01', 40, '35999992222',
    'ana@escola.com', 'Rua B, 200',
    'SUBSTITUIR_POR_HASH_BCRYPT', 'FUNCIONARIO', TRUE, NULL
),
(
    'FUNC003', 'Carlos Santos', '1985-09-20', NULL,
    'ATIVO', 'CLT', 'Professor', 'Educacao',
    '2024-08-01', 30, '35999993333',
    'carlos@escola.com', 'Rua C, 300',
    'SUBSTITUIR_POR_HASH_BCRYPT', 'FUNCIONARIO', TRUE, NULL
);

-- ==========================================
-- CONSULTAR FUNCIONÁRIOS
-- ==========================================

SELECT * FROM team;

-- ==========================================
-- CONSULTAR FUNCIONÁRIOS ATIVOS
-- ==========================================

SELECT *
FROM team
WHERE acesso_ativo = TRUE
ORDER BY nome ASC;



-- ==========================================
-- 8. TABELA PERFIL
-- ==========================================

CREATE TABLE perfil (
    id INT PRIMARY KEY,
    nome VARCHAR(150),
    email VARCHAR(150),
    cargo VARCHAR(100),
    telefone VARCHAR(30),
    foto_perfil VARCHAR(500),
    tipo_acesso VARCHAR(40),
    acesso_ativo BOOLEAN NOT NULL DEFAULT TRUE,
    ultimo_acesso TIMESTAMP,
    data_criacao_conta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_alteracao_senha TIMESTAMP
);

INSERT INTO perfil (
    id, nome, email, cargo, telefone,
    foto_perfil, tipo_acesso, acesso_ativo
)
VALUES
(1, 'Marcos Silva', 'marcos@escola.com', 'Professor',
 '35999991111', NULL, 'ADMIN', TRUE),

(2, 'Ana Souza', 'ana@escola.com', 'Secretaria',
 '35999992222', NULL, 'FUNCIONARIO', TRUE),

(3, 'Carlos Santos', 'carlos@escola.com', 'Professor',
 '35999993333', NULL, 'FUNCIONARIO', TRUE);

 SELECT * FROM perfil;



-- ==========================================
-- 9. TABELA NOTIFICACAO
-- ==========================================

CREATE TABLE notificacao (
    id VARCHAR(64) PRIMARY KEY,
    tipo VARCHAR(60) NOT NULL,
    titulo VARCHAR(180) NOT NULL,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    lida BOOLEAN NOT NULL DEFAULT FALSE,
    aluno_id INT NULL,
    rota VARCHAR(500),

    CONSTRAINT fk_notificacao_aluno
        FOREIGN KEY (aluno_id)
        REFERENCES aluno(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE INDEX idx_notificacao_lida
ON notificacao(lida);

CREATE INDEX idx_notificacao_data
ON notificacao(data_hora);


INSERT INTO notificacao (
    id, tipo, titulo, mensagem,
    data_hora, lida, aluno_id, rota
)
VALUES
(
    'NOT001',
    'PRESENCA',
    'Presenca registrada',
    'A entrada do aluno Joao Pedro foi registrada.',
    '2026-02-10 07:00:00',
    FALSE,
    (SELECT id FROM aluno WHERE matricula = '2026001'),
    '/presencas'
),
(
    'NOT002',
    'ATRASO',
    'Aluno atrasado',
    'A aluna Ana Clara chegou atrasada.',
    '2026-02-10 07:15:00',
    FALSE,
    (SELECT id FROM aluno WHERE matricula = '2026002'),
    '/alunos'
),
(
    'NOT003',
    'SISTEMA',
    'Novo aviso',
    'O sistema foi atualizado.',
    '2026-02-10 08:00:00',
    TRUE,
    NULL,
    '/dashboard'
);

SELECT * FROM notificacao;

-- ==========================================
-- 9. TABELA NOTIFICACAO
-- ==========================================

CREATE TABLE notificacao (
    id VARCHAR(64) PRIMARY KEY,
    tipo VARCHAR(60) NOT NULL,
    titulo VARCHAR(180) NOT NULL,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    lida BOOLEAN NOT NULL DEFAULT FALSE,
    aluno_id INT NULL,
    rota VARCHAR(500),

    CONSTRAINT fk_notificacao_aluno
        FOREIGN KEY (aluno_id)
        REFERENCES aluno(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE INDEX idx_notificacao_lida
ON notificacao(lida);

CREATE INDEX idx_notificacao_data
ON notificacao(data_hora);


INSERT INTO notificacao (
    id, tipo, titulo, mensagem,
    data_hora, lida, aluno_id, rota
)
VALUES
(
    'NOT001',
    'PRESENCA',
    'Presenca registrada',
    'A entrada do aluno Joao Pedro foi registrada.',
    '2026-02-10 07:00:00',
    FALSE,
    (SELECT id FROM aluno WHERE matricula = '2026001'),
    '/presencas'
),
(
    'NOT002',
    'ATRASO',
    'Aluno atrasado',
    'A aluna Ana Clara chegou atrasada.',
    '2026-02-10 07:15:00',
    FALSE,
    (SELECT id FROM aluno WHERE matricula = '2026002'),
    '/alunos'
),
(
    'NOT003',
    'SISTEMA',
    'Novo aviso',
    'O sistema foi atualizado.',
    '2026-02-10 08:00:00',
    TRUE,
    NULL,
    '/dashboard'
);

SELECT * FROM notificacao;

-- ==========================================
-- 10. TABELA CONFIGURACAO GERAL
-- ==========================================

CREATE TABLE configuracao_geral (
    id SERIAL PRIMARY KEY,
    aparencia VARCHAR(40) NOT NULL,
    idioma VARCHAR(20) NOT NULL
);

INSERT INTO configuracao_geral (aparencia, idioma)
VALUES
('CLARO', 'pt-BR'),
('ESCURO', 'pt-BR');

SELECT * FROM configuracao_geral;


-- ==========================================
-- 11. TABELA CONFIGURACAO RFID
-- ==========================================

CREATE TABLE configuracao_rfid (
    id SERIAL PRIMARY KEY,
    leitor_ativo BOOLEAN NOT NULL DEFAULT TRUE
);

INSERT INTO configuracao_rfid (leitor_ativo)
VALUES (TRUE);

SELECT * FROM configuracao_rfid;


-- ==========================================
-- 13. TABELA REGRAS DA ESCOLA
-- ==========================================

CREATE TABLE regras_escola (
    id SERIAL PRIMARY KEY,
    horario_limite TIME NOT NULL,
    ano_letivo INT NOT NULL,
    turno VARCHAR(30) NOT NULL
);

INSERT INTO regras_escola (
    horario_limite,
    ano_letivo,
    turno
)
VALUES
('07:10:00', 2026, 'Matutino'),
('13:10:00', 2026, 'Vespertino'),
('19:10:00', 2026, 'Noturno');

SELECT * FROM regras_escola;


-- ==========================================
-- 15. CONSULTAS FINAIS
-- ==========================================


-- 1. ALUNOS E SUAS TURMAS

SELECT
    aluno.nome AS aluno,
    aluno.matricula,
    turma.nome AS turma,
    turma.turno
FROM aluno
INNER JOIN turma
    ON aluno.turma_id = turma.id
ORDER BY aluno.nome ASC;


-- 2. TURMAS E SUAS SALAS

SELECT
    turma.nome AS turma,
    sala.numero AS numero_sala,
    sala.capacidade,
    sala.andar
FROM turma
INNER JOIN sala
    ON turma.sala_numero = sala.numero
ORDER BY turma.nome ASC;


-- 3. PRESENCAS E NOMES DOS ALUNOS

SELECT
    aluno.nome AS aluno,
    aluno.matricula,
    registro_presenca.data,
    registro_presenca.horario,
    registro_presenca.status,
    registro_presenca.origem
FROM registro_presenca
INNER JOIN aluno
    ON registro_presenca.aluno_id = aluno.id
ORDER BY registro_presenca.data DESC,
         registro_presenca.horario DESC;


-- 4. CARTOES RFID E SEUS ALUNOS

SELECT
    aluno.nome AS aluno,
    aluno.matricula,
    cartao_rfid.uid,
    cartao_rfid.ativo
FROM cartao_rfid
INNER JOIN aluno
    ON cartao_rfid.aluno_id = aluno.id
ORDER BY aluno.nome ASC;


-- 5. FUNCIONARIOS COM ACESSO ATIVO

SELECT *
FROM team
WHERE acesso_ativo = TRUE
ORDER BY nome ASC;