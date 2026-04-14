CREATE TABLE IF NOT EXISTS Sujeito (
    doc_legal_primario TEXT NOT NULL PRIMARY KEY
);

CREATE TABLE IF NOT EXISTS Advogado (
    doc_legal_primario TEXT NOT NULL PRIMARY KEY REFERENCES Sujeito(doc_legal_primario)
);


CREATE TABLE IF NOT EXISTS Cliente (
    doc_legal_primario TEXT NOT NULL PRIMARY KEY REFERENCES Sujeito(doc_legal_primario)
);

CREATE TABLE IF NOT EXISTS Caso (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS identity
);

CREATE TABLE IF NOT EXISTS Documento (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS identity
);

CREATE TABLE IF NOT EXISTS Processo (
    numero BIGINT PRIMARY KEY GENERATED ALWAYS AS identity
);

CREATE TABLE IF NOT EXISTS Parte (
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Sujeito(doc_legal_primario),
    processo_numero BIGINT NOT NULL REFERENCES Processo(numero),
    papel_em_processo TEXT NOT NULL,
    PRIMARY KEY (sujeito_doc_legal_primario, processo_numero, papel_em_processo)
);
CREATE UNIQUE INDEX IF NOT EXISTS Parte_id_fraco ON Parte (sujeito_doc_legal_primario, processo_numero, papel_em_processo);


CREATE TABLE IF NOT EXISTS Movimentacao (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS identity,
    processo_numero BIGINT NOT NULL,
    parte_sujeito_doc_legal_primario TEXT NOT NULL,
    parte_papel_em_processo TEXT NOT NULL,
    CONSTRAINT contemplada_por
      FOREIGN KEY (processo_numero)
      REFERENCES Processo(numero),
    CONSTRAINT protocolada_por
      FOREIGN KEY (parte_sujeito_doc_legal_primario, processo_numero, parte_papel_em_processo)
      REFERENCES Parte(sujeito_doc_legal_primario, processo_numero, papel_em_processo)
);

CREATE TABLE IF NOT EXISTS Caso_Gera_Processo (
    processo_numero BIGINT NOT NULL REFERENCES Processo(numero),
    caso_id BIGINT NOT NULL REFERENCES Caso(id),
    PRIMARY KEY (processo_numero, caso_id)
);

CREATE TABLE IF NOT EXISTS Anexo_Caso (
    documento_id BIGINT NOT NULL REFERENCES Documento(id),
    caso_id BIGINT NOT NULL REFERENCES Caso(id),
    PRIMARY KEY (documento_id, caso_id)
);


CREATE TABLE IF NOT EXISTS Anexo_Movimentacao (
    documento_id BIGINT NOT NULL REFERENCES Documento(id),
    movimentacao_id BIGINT NOT NULL REFERENCES Movimentacao(id),
    PRIMARY KEY (documento_id, movimentacao_id)
);

CREATE TABLE IF NOT EXISTS Assinatura (
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Sujeito(doc_legal_primario),
    documento_id BIGINT NOT NULL REFERENCES Documento(id),
    PRIMARY KEY (sujeito_doc_legal_primario, documento_id)
);

CREATE TABLE IF NOT EXISTS Solicitacao_Abertura (
    caso_id BIGINT NOT NULL REFERENCES Caso(id),
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Cliente(doc_legal_primario),
    PRIMARY KEY (caso_id, sujeito_doc_legal_primario)
);


CREATE TABLE IF NOT EXISTS Atribuido_A (
    caso_id BIGINT NOT NULL REFERENCES Caso(id),
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Advogado(doc_legal_primario),
    PRIMARY KEY (caso_id, sujeito_doc_legal_primario)
);

DROP TABLE IF EXISTS Sujeito, Advogado, Cliente, Caso, Documento, Processo, Parte, Movimentacao, Caso_Gera_Processo, Anexo_Caso, Anexo_Movimentacao, Assinatura, Solicitacao_Abertura, Atribuido_A;


