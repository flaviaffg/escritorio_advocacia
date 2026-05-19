
DROP INDEX IF EXISTS Parte_id_fraco;
DROP TABLE IF EXISTS Sujeito, Advogado, Cliente, Caso, Documento, Processo, Parte, Movimentacao, Caso_Gera_Processo, Anexo_Caso, Anexo_Movimentacao, Assinatura, Solicitacao_Abertura, Atribuido_A;
CREATE TABLE IF NOT EXISTS Sujeito (
    doc_legal TEXT NOT NULL PRIMARY KEY,
    tipo_sujeito TEXT NOT NULL,
    nome_legal TEXT NOT NULL,
    CHECK (
        (tipo_sujeito = 'pessoa_fisica')
    OR
        (tipo_sujeito IN ('pessoa_juridica', 'uniao', 'estado', 'municipio', 'tribunal'))
)
);

CREATE TABLE IF NOT EXISTS Advogado (
    doc_legal_primario TEXT NOT NULL PRIMARY KEY REFERENCES Sujeito(doc_legal),
    oab_numero TEXT NOT NULL,
    oab_uf TEXT NOT NULL,
    email TEXT NOT NULL,
    telefone_comercial TEXT NOT NULL
);


CREATE TABLE IF NOT EXISTS Cliente (
    doc_legal_primario TEXT NOT NULL PRIMARY KEY REFERENCES Sujeito(doc_legal),
    nome_social TEXT NOT NULL,
    email_para_contato TEXT NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone_para_contato TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Caso (
    num BIGINT PRIMARY KEY,
    data_abertura TIMESTAMPTZ NOT NULL,
    descricao TEXT NOT NULL,
    titulo TEXT NOT NULL,
    data_fechamento TIMESTAMPTZ,
    status TEXT NOT NULL,
    CHECK ( status in ('analise', 'iniciado', 'encerrado', 'rejeitado') ),
    CHECK ( status not in ('encerrado', 'rejeitado') OR data_fechamento IS NOT NULL )
);

CREATE TABLE IF NOT EXISTS Documento (
    num BIGINT PRIMARY KEY,
    data_criacao TIMESTAMPTZ NOT NULL,
    tipo_arquivo TEXT NOT NULL,
    data_upload TIMESTAMPTZ NOT NULL,
    tipo_documento TEXT NOT NULL,
    nome_original TEXT NOT NULL,
    descricao TEXT NOT NULL,
    hash TEXT NOT NULL,
    link_acesso TEXT NOT NULL,
    CHECK (tipo_arquivo IN ('imagem', 'audio', 'video', 'documento')),
    CHECK (tipo_documento IN ('prova', 'transcricao', 'ata', 'acordo', 'peticao', 'decisao', 'sentenca', 'contrato', 'procuracao', 'laudo', 'intimacao', 'recurso'))
);

CREATE TABLE IF NOT EXISTS Processo (
    num BIGINT PRIMARY KEY,
    descricao TEXT NOT NULL,
    valor_causa NUMERIC(32,2) NOT NULL,
    data_abertura TIMESTAMPTZ NOT NULL,
    status TEXT NOT NULL,
    data_encerramento TIMESTAMPTZ,
    titulo TEXT NOT NULL,
    motivo_encerramento TEXT,
    CHECK (status in ('protocolado', 'aberto', 'fechado')),
    CHECK (motivo_encerramento IS NULL OR motivo_encerramento in ('arquivado', 'encerrado')),
    CHECK ((motivo_encerramento IS NULL) = (data_encerramento IS NULL)),
    CHECK (status != 'fechado' OR (motivo_encerramento IS NOT NULL AND data_encerramento IS NOT NULL))
);

CREATE TABLE IF NOT EXISTS Parte (
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Sujeito(doc_legal),
    processo_numero BIGINT NOT NULL REFERENCES Processo(num),
    data_inclusao_em_processo timestamptz NOT NULL,
    motivo_inclusao_em_processo TEXT NOT NULL,
    papel_em_processo TEXT NOT NULL,
    status_no_processo TEXT NOT NULL,
    CHECK (motivo_inclusao_em_processo in ('sorteio', 'intimado', 'citado', 'habilitado', 'nomeado', 'denunciado')),
    CHECK (papel_em_processo in ('reu', 'juiz', 'advogado', 'oficial_de_justica', 'autor', 'promotor', 'perito', 'testemunha', 'tribunal')),
    CHECK (status_no_processo in ('ativo', 'substituido', 'dispensado')),
    PRIMARY KEY (papel_em_processo, sujeito_doc_legal_primario, processo_numero)
);
CREATE UNIQUE INDEX IF NOT EXISTS Parte_id_fraco ON Parte (sujeito_doc_legal_primario, processo_numero, papel_em_processo);


CREATE TABLE IF NOT EXISTS Movimentacao (
    num BIGINT PRIMARY KEY,
    tipo TEXT NOT NULL,
    data_que_ocorreu timestamptz NOT NULL,
    observacoes TEXT,
    processo_numero BIGINT NOT NULL,
    parte_doc_legal_primario TEXT NOT NULL,
    parte_papel_em_processo TEXT NOT NULL,
    CONSTRAINT contemplada_por
      FOREIGN KEY (processo_numero)
      REFERENCES Processo(num),
    CONSTRAINT protocolada_por
      FOREIGN KEY (processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
      REFERENCES Parte(processo_numero, sujeito_doc_legal_primario, papel_em_processo),
    CHECK (tipo IN ('audiencia', 'peticao', 'intimacao', 'decisao', 'despacho', 'sentenca', 'recurso', 'embargo', 'citacao', 'laudo', 'acordo'))
);

CREATE TABLE IF NOT EXISTS Caso_Gera_Processo (
    processo_numero BIGINT NOT NULL REFERENCES Processo(num),
    caso_num BIGINT NOT NULL REFERENCES Caso(num),
    PRIMARY KEY (processo_numero, caso_num)
);

CREATE TABLE IF NOT EXISTS Anexo_Caso (
    documento_id BIGINT NOT NULL REFERENCES Documento(num),
    caso_num BIGINT NOT NULL REFERENCES Caso(num),
    em timestamptz NOT NULL,
    PRIMARY KEY (documento_id, caso_num)
);


CREATE TABLE IF NOT EXISTS Anexo_Movimentacao (
    documento_id BIGINT NOT NULL REFERENCES Documento(num),
    movimentacao_id BIGINT NOT NULL REFERENCES Movimentacao(num),
    em timestamptz NOT NULL,
    PRIMARY KEY (documento_id, movimentacao_id)
);

CREATE TABLE IF NOT EXISTS Assinatura (
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Sujeito(doc_legal),
    documento_id BIGINT NOT NULL REFERENCES Documento(num),
    em_data timestamptz NOT NULL,
    em_municipio TEXT NOT NULL,
    PRIMARY KEY (sujeito_doc_legal_primario, documento_id)
);

CREATE TABLE IF NOT EXISTS Solicitacao_Abertura (
    caso_num BIGINT NOT NULL REFERENCES Caso(num),
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Cliente(doc_legal_primario),
    PRIMARY KEY (caso_num, sujeito_doc_legal_primario)
);


CREATE TABLE IF NOT EXISTS Atribuido_A (
    caso_num BIGINT NOT NULL REFERENCES Caso(num),
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Advogado(doc_legal_primario),
    PRIMARY KEY (caso_num, sujeito_doc_legal_primario)
);

-- ============================================================
-- COMMENT ON TABLE / COMMENT ON COLUMN
-- ============================================================

-- ------------------------------------------------------------
-- Sujeito
-- ------------------------------------------------------------
COMMENT ON TABLE Sujeito IS
  'Entidade jurídica genérica que pode atuar em qualquer papel no sistema (pessoa física, pessoa jurídica, ente público ou tribunal). Toda entidade identificável por documento legal herda desta tabela.';

COMMENT ON COLUMN Sujeito.doc_legal IS
  'Documento legal primário do sujeito (CPF para pessoa física; CNPJ para pessoa jurídica; identificador próprio para entes públicos e tribunais). Chave primária natural.';

COMMENT ON COLUMN Sujeito.tipo_sujeito IS
  'Categoria jurídica do sujeito. Valores permitidos: ''pessoa_fisica'', ''pessoa_juridica'', ''uniao'', ''estado'', ''municipio'', ''tribunal''.';

COMMENT ON COLUMN Sujeito.nome_legal IS
  'Nome completo conforme registro legal (razão social para PJ, nome civil para PF, denominação oficial para entes públicos).';


-- ------------------------------------------------------------
-- Advogado
-- ------------------------------------------------------------
COMMENT ON TABLE Advogado IS
  'Profissional habilitado na OAB que pode ser atribuído a casos e figurar como parte em processos. Especializa Sujeito — o doc_legal_primario referencia Sujeito.doc_legal.';

COMMENT ON COLUMN Advogado.doc_legal_primario IS
  'Chave primária e estrangeira para Sujeito.doc_legal. Identifica o documento legal do advogado.';

COMMENT ON COLUMN Advogado.oab_numero IS
  'Número de inscrição do advogado na seccional da OAB correspondente.';

COMMENT ON COLUMN Advogado.oab_uf IS
  'Unidade federativa da seccional da OAB onde o advogado está inscrito (sigla, ex.: ''SP'', ''RJ'').';

COMMENT ON COLUMN Advogado.email IS
  'Endereço de e-mail profissional utilizado para comunicações do escritório.';

COMMENT ON COLUMN Advogado.telefone_comercial IS
  'Telefone comercial do advogado, incluindo DDD.';


-- ------------------------------------------------------------
-- Cliente
-- ------------------------------------------------------------
COMMENT ON TABLE Cliente IS
  'Pessoa física ou jurídica que contrata os serviços do escritório e pode solicitar a abertura de casos. Especializa Sujeito.';

COMMENT ON COLUMN Cliente.doc_legal_primario IS
  'Chave primária e estrangeira para Sujeito.doc_legal. Identifica o documento legal do cliente.';

COMMENT ON COLUMN Cliente.nome_social IS
  'Nome social ou nome pelo qual o cliente prefere ser identificado nas comunicações internas do escritório.';

COMMENT ON COLUMN Cliente.email_para_contato IS
  'E-mail preferencial do cliente para recebimento de notificações e comunicações sobre seus casos.';

COMMENT ON COLUMN Cliente.data_nascimento IS
  'Data de nascimento (PF) ou data de constituição/fundação (PJ) do cliente.';

COMMENT ON COLUMN Cliente.telefone_para_contato IS
  'Telefone principal do cliente para contato direto, incluindo DDD.';


-- ------------------------------------------------------------
-- Caso
-- ------------------------------------------------------------
COMMENT ON TABLE Caso IS
  'Representa a demanda jurídica aberta pelo cliente junto ao escritório, antes ou independentemente da existência de um processo judicial formal. Um caso pode gerar um ou mais processos.';

COMMENT ON COLUMN Caso.num IS
  'Identificador sequencial interno do caso. Chave primária.';

COMMENT ON COLUMN Caso.data_abertura IS
  'Data e hora (com fuso horário) em que o caso foi registrado no sistema.';

COMMENT ON COLUMN Caso.descricao IS
  'Descrição detalhada da demanda do cliente, contexto jurídico e informações relevantes para análise inicial.';

COMMENT ON COLUMN Caso.titulo IS
  'Título resumido do caso para identificação rápida nas listagens do sistema.';

COMMENT ON COLUMN Caso.data_fechamento IS
  'Data e hora do encerramento ou rejeição do caso. Obrigatória quando status é ''encerrado'' ou ''rejeitado''; nula nos demais estados.';

COMMENT ON COLUMN Caso.status IS
  'Estado atual do caso no fluxo do escritório. Valores: ''analise'' (em avaliação inicial), ''iniciado'' (aceito e em andamento), ''encerrado'' (concluído com êxito ou acordo), ''rejeitado'' (recusado pelo escritório).';


-- ------------------------------------------------------------
-- Documento
-- ------------------------------------------------------------
COMMENT ON TABLE Documento IS
  'Arquivo digital armazenado no sistema, podendo ser anexado a casos ou a movimentações processuais. Registra metadados, hash de integridade e link de acesso.';

COMMENT ON COLUMN Documento.num IS
  'Identificador sequencial interno do documento. Chave primária.';

COMMENT ON COLUMN Documento.data_criacao IS
  'Data e hora originais de criação do arquivo (conforme metadado do próprio arquivo, quando disponível).';

COMMENT ON COLUMN Documento.tipo_arquivo IS
  'Formato/mídia do arquivo. Valores: ''imagem'', ''audio'', ''video'', ''documento''.';

COMMENT ON COLUMN Documento.data_upload IS
  'Data e hora em que o arquivo foi enviado e registrado no sistema.';

COMMENT ON COLUMN Documento.tipo_documento IS
  'Classificação jurídica do conteúdo. Valores: ''prova'', ''transcricao'', ''ata'', ''acordo'', ''peticao'', ''decisao'', ''sentenca'', ''contrato'', ''procuracao'', ''laudo'', ''intimacao'', ''recurso''.';

COMMENT ON COLUMN Documento.nome_original IS
  'Nome original do arquivo conforme enviado pelo usuário.';

COMMENT ON COLUMN Documento.descricao IS
  'Descrição ou observações sobre o conteúdo e finalidade do documento no contexto do caso ou processo.';

COMMENT ON COLUMN Documento.hash IS
  'Hash criptográfico do conteúdo do arquivo (ex.: SHA-256) para verificação de integridade e detecção de adulterações.';

COMMENT ON COLUMN Documento.link_acesso IS
  'URL ou caminho de acesso ao arquivo no sistema de armazenamento (storage interno ou nuvem).';


-- ------------------------------------------------------------
-- Processo
-- ------------------------------------------------------------
COMMENT ON TABLE Processo IS
  'Processo judicial formal, com número próprio, gerado a partir de um ou mais casos do escritório. Contém as movimentações processuais e as partes envolvidas.';

COMMENT ON COLUMN Processo.num IS
  'Número único do processo no sistema. Chave primária (pode espelhar o número CNJ ou ser um identificador interno).';

COMMENT ON COLUMN Processo.descricao IS
  'Descrição do objeto da ação judicial e das principais questões de mérito e processuais.';

COMMENT ON COLUMN Processo.valor_causa IS
  'Valor atribuído à causa em reais, com até 32 dígitos inteiros e 2 casas decimais.';

COMMENT ON COLUMN Processo.data_abertura IS
  'Data e hora do protocolo ou autuação inicial do processo.';

COMMENT ON COLUMN Processo.status IS
  'Estado atual do processo. Valores: ''protocolado'' (petição enviada, aguardando autuação), ''aberto'' (em tramitação), ''fechado'' (encerrado por sentença, acordo ou arquivamento).';

COMMENT ON COLUMN Processo.data_encerramento IS
  'Data e hora do encerramento do processo. Deve ser nula se e somente se motivo_encerramento for nulo.';

COMMENT ON COLUMN Processo.titulo IS
  'Título descritivo do processo para identificação rápida (ex.: "Ação de Indenização – Fulano x Empresa X").';

COMMENT ON COLUMN Processo.motivo_encerramento IS
  'Motivo pelo qual o processo foi encerrado. Valores: ''arquivado'' (extinção sem resolução de mérito ou abandono), ''encerrado'' (resolução definitiva). Nulo enquanto o processo estiver aberto ou protocolado.';


-- ------------------------------------------------------------
-- Parte
-- ------------------------------------------------------------
COMMENT ON TABLE Parte IS
  'Associa um sujeito a um processo com um papel específico (réu, autor, juiz, advogado etc.), registrando o motivo e a data de inclusão e seu status atual no feito.';

COMMENT ON COLUMN Parte.sujeito_doc_legal_primario IS
  'Documento legal do sujeito que figura como parte. Referencia Sujeito.doc_legal.';

COMMENT ON COLUMN Parte.processo_numero IS
  'Número do processo ao qual esta parte está vinculada. Referencia Processo.num.';

COMMENT ON COLUMN Parte.data_inclusao_em_processo IS
  'Data e hora em que o sujeito passou a figurar neste papel no processo.';

COMMENT ON COLUMN Parte.motivo_inclusao_em_processo IS
  'Razão jurídica pela qual o sujeito foi incluído no processo neste papel. Valores: ''sorteio'', ''intimado'', ''citado'', ''habilitado'', ''nomeado'', ''denunciado''.';

COMMENT ON COLUMN Parte.papel_em_processo IS
  'Papel jurídico-processual do sujeito. Valores: ''reu'', ''juiz'', ''advogado'', ''oficial_de_justica'', ''autor'', ''promotor'', ''perito'', ''testemunha'', ''tribunal''.';

COMMENT ON COLUMN Parte.status_no_processo IS
  'Situação atual da parte no processo. Valores: ''ativo'' (atuando), ''substituido'' (substituído por outra parte equivalente), ''dispensado'' (liberado do processo).';


-- ------------------------------------------------------------
-- Movimentacao
-- ------------------------------------------------------------
COMMENT ON TABLE Movimentacao IS
  'Registro de um evento processual ocorrido em um processo, protocolado por uma parte específica. Exemplos: audiência, petição, sentença, recurso.';

COMMENT ON COLUMN Movimentacao.num IS
  'Identificador sequencial interno da movimentação. Chave primária.';

COMMENT ON COLUMN Movimentacao.tipo IS
  'Tipo do evento processual. Valores: ''audiencia'', ''peticao'', ''intimacao'', ''decisao'', ''despacho'', ''sentenca'', ''recurso'', ''embargo'', ''citacao'', ''laudo'', ''acordo''.';

COMMENT ON COLUMN Movimentacao.data_que_ocorreu IS
  'Data e hora em que o evento processual efetivamente ocorreu (distinta da data de upload de eventual documento).';

COMMENT ON COLUMN Movimentacao.observacoes IS
  'Notas livres sobre a movimentação, registradas pelo operador do sistema.';

COMMENT ON COLUMN Movimentacao.processo_numero IS
  'Número do processo ao qual a movimentação pertence. Referencia Processo.num (constraint contemplada_por).';

COMMENT ON COLUMN Movimentacao.parte_doc_legal_primario IS
  'Documento legal do sujeito (parte) que protocolou ou originou esta movimentação.';

COMMENT ON COLUMN Movimentacao.parte_papel_em_processo IS
  'Papel da parte que protocolou a movimentação, em conjunto com parte_doc_legal_primario e processo_numero, referencia a chave de Parte (constraint protocolada_por).';


-- ------------------------------------------------------------
-- Caso_Gera_Processo
-- ------------------------------------------------------------
COMMENT ON TABLE Caso_Gera_Processo IS
  'Relacionamento N:N entre Caso e Processo. Registra quais casos do escritório deram origem a quais processos judiciais. Um caso pode gerar múltiplos processos; um processo pode ter sido originado por múltiplos casos.';

COMMENT ON COLUMN Caso_Gera_Processo.processo_numero IS
  'Número do processo gerado. Referencia Processo.num.';

COMMENT ON COLUMN Caso_Gera_Processo.caso_num IS
  'Número do caso de origem. Referencia Caso.num.';


-- ------------------------------------------------------------
-- Anexo_Caso
-- ------------------------------------------------------------
COMMENT ON TABLE Anexo_Caso IS
  'Relacionamento N:N entre Documento e Caso. Registra os documentos anexados diretamente a um caso (e não a uma movimentação processual específica), com a data em que o anexo foi realizado.';

COMMENT ON COLUMN Anexo_Caso.documento_id IS
  'Identificador do documento anexado. Referencia Documento.num.';

COMMENT ON COLUMN Anexo_Caso.caso_num IS
  'Número do caso ao qual o documento foi anexado. Referencia Caso.num.';

COMMENT ON COLUMN Anexo_Caso.em IS
  'Data e hora em que o documento foi anexado ao caso.';


-- ------------------------------------------------------------
-- Anexo_Movimentacao
-- ------------------------------------------------------------
COMMENT ON TABLE Anexo_Movimentacao IS
  'Relacionamento N:N entre Documento e Movimentacao. Registra os documentos que comprovam ou integram uma movimentação processual específica, com a data do anexo.';

COMMENT ON COLUMN Anexo_Movimentacao.documento_id IS
  'Identificador do documento anexado. Referencia Documento.num.';

COMMENT ON COLUMN Anexo_Movimentacao.movimentacao_id IS
  'Identificador da movimentação à qual o documento foi anexado. Referencia Movimentacao.num.';

COMMENT ON COLUMN Anexo_Movimentacao.em IS
  'Data e hora em que o documento foi anexado à movimentação.';


-- ------------------------------------------------------------
-- Assinatura
-- ------------------------------------------------------------
COMMENT ON TABLE Assinatura IS
  'Registra a assinatura de um sujeito em um documento, incluindo data, hora e município onde a assinatura foi aposta (eletrônica ou física).';

COMMENT ON COLUMN Assinatura.sujeito_doc_legal_primario IS
  'Documento legal do sujeito que assinou. Referencia Sujeito.doc_legal.';

COMMENT ON COLUMN Assinatura.documento_id IS
  'Identificador do documento assinado. Referencia Documento.num.';

COMMENT ON COLUMN Assinatura.em_data IS
  'Data e hora em que a assinatura foi aposta.';

COMMENT ON COLUMN Assinatura.em_municipio IS
  'Município onde a assinatura foi realizada, conforme declarado no ato de assinatura.';


-- ------------------------------------------------------------
-- Solicitacao_Abertura
-- ------------------------------------------------------------
COMMENT ON TABLE Solicitacao_Abertura IS
  'Registra qual(is) cliente(s) solicitou(aram) a abertura de um caso. Permite múltiplos clientes por caso (litisconsórcio ativo na demanda ao escritório) e múltiplos casos por cliente.';

COMMENT ON COLUMN Solicitacao_Abertura.caso_num IS
  'Número do caso cuja abertura foi solicitada. Referencia Caso.num.';

COMMENT ON COLUMN Solicitacao_Abertura.sujeito_doc_legal_primario IS
  'Documento legal do cliente solicitante. Referencia Cliente.doc_legal_primario.';


-- ------------------------------------------------------------
-- Atribuido_A
-- ------------------------------------------------------------
COMMENT ON TABLE Atribuido_A IS
  'Registra a atribuição de advogados a casos. Um caso pode ter múltiplos advogados responsáveis; um advogado pode ser responsável por múltiplos casos.';

COMMENT ON COLUMN Atribuido_A.caso_num IS
  'Número do caso ao qual o advogado foi atribuído. Referencia Caso.num.';

COMMENT ON COLUMN Atribuido_A.sujeito_doc_legal_primario IS
  'Documento legal do advogado atribuído. Referencia Advogado.doc_legal_primario.';
