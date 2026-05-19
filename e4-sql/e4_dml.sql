-- ============================================================
-- SEED DATA ESTENDIDO
-- Contém: 14 sujeitos, 15 documentos, 12 movimentações,
--         3 casos, 3 processos (com relações N:N entre casos e processos)
-- ============================================================

-- ------------------------------------------------------------
-- SUJEITOS (14 no total)
-- ------------------------------------------------------------

-- Clientes
INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('77711198899', 'pessoa_fisica', 'Pedro Morato Kalil');

INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('99988877766', 'pessoa_fisica', 'Mariana Souza Ferreira');

INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('55544433322', 'pessoa_fisica', 'Carlos Eduardo Braga');

-- Advogados
INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('11122233345', 'pessoa_fisica', 'Jose Arthur');

INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('33333333345', 'pessoa_fisica', 'Danilo Monteiro Alves Antonio');

INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('44455566678', 'pessoa_fisica', 'Fernanda Lopes Tavares');

-- Réus / Empresas
INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('22222222222', 'pessoa_juridica', 'OndaLogica Inteligencia S.A.');

INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('88899900011', 'pessoa_juridica', 'Construtora Horizonte Ltda.');

INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('66677788899', 'pessoa_juridica', 'Banco Nacional de Credito S.A.');

-- Tribunais
INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('11111111111', 'tribunal', '3o Tribunal de Belo Horizonte');

INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('11111111112', 'tribunal', '5a Vara Civel de Contagem');

-- Promotor e Perito
INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('77788899900', 'pessoa_fisica', 'Roberto Caixeta Drummond');

INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('12312312312', 'pessoa_fisica', 'Silvia Mendes Parreiras');

-- Oficial de Justiça
INSERT INTO sujeito (doc_legal, tipo_sujeito, nome_legal)
VALUES ('98798798700', 'pessoa_fisica', 'Antonio Pereira Nunes');


-- ------------------------------------------------------------
-- CLIENTES
-- ------------------------------------------------------------

INSERT INTO cliente (doc_legal_primario, nome_social, email_para_contato, data_nascimento, telefone_para_contato)
VALUES ('77711198899', 'Pedro Morato Kalil', 'kalil@gmail.com', '2003-03-06', '31986114826');

INSERT INTO cliente (doc_legal_primario, nome_social, email_para_contato, data_nascimento, telefone_para_contato)
VALUES ('99988877766', 'Mariana Souza', 'mariana.souza@outlook.com', '1990-11-22', '31987654321');

INSERT INTO cliente (doc_legal_primario, nome_social, email_para_contato, data_nascimento, telefone_para_contato)
VALUES ('55544433322', 'Carlos Braga', 'carlos.braga@hotmail.com', '1978-05-10', '31912345678');


-- ------------------------------------------------------------
-- ADVOGADOS
-- ------------------------------------------------------------

INSERT INTO advogado (doc_legal_primario, oab_numero, oab_uf, email, telefone_comercial)
VALUES ('11122233345', '231321231441', 'MG', 'jose.arthur@escritorio.com', '3122337755');

INSERT INTO advogado (doc_legal_primario, oab_numero, oab_uf, email, telefone_comercial)
VALUES ('33333333345', '112233445566', 'MG', 'danilo.antonio@escritorio.com', '3133445566');

INSERT INTO advogado (doc_legal_primario, oab_numero, oab_uf, email, telefone_comercial)
VALUES ('44455566678', '998877665544', 'MG', 'fernanda.tavares@escritorio.com', '3144556677');


-- ------------------------------------------------------------
-- CASOS (3 casos)
-- Caso 1: trabalhista Pedro vs OndaLogica
-- Caso 2: dano material Mariana vs Construtora Horizonte
-- Caso 3: revisão contratual Carlos vs Banco Nacional
-- ------------------------------------------------------------

INSERT INTO caso (num, data_abertura, descricao, titulo, data_fechamento, status)
VALUES (1, '2025-08-07', 'Reclamacao trabalhista por horas extras nao pagas e reducao indevida de salario.',
        'Pedro Kalil vs OndaLogica', NULL, 'iniciado');

INSERT INTO caso (num, data_abertura, descricao, titulo, data_fechamento, status)
VALUES (2, '2025-08-10', 'Acao de indenizacao por danos materiais e morais decorrentes de atraso na entrega de imovel.',
        'Mariana Ferreira vs Construtora Horizonte', NULL, 'iniciado');

INSERT INTO caso (num, data_abertura, descricao, titulo, data_fechamento, status)
VALUES (3, '2025-08-12', 'Revisao de clausulas abusivas em contrato de financiamento imobiliario.',
        'Carlos Braga vs Banco Nacional de Credito', NULL, 'analise');


-- ------------------------------------------------------------
-- SOLICITACOES DE ABERTURA
-- ------------------------------------------------------------

INSERT INTO solicitacao_abertura (caso_num, sujeito_doc_legal_primario)
VALUES (1, '77711198899');

INSERT INTO solicitacao_abertura (caso_num, sujeito_doc_legal_primario)
VALUES (2, '99988877766');

-- Caso 3 foi aberto conjuntamente por dois clientes (litisconsórcio)
INSERT INTO solicitacao_abertura (caso_num, sujeito_doc_legal_primario)
VALUES (3, '55544433322');

INSERT INTO solicitacao_abertura (caso_num, sujeito_doc_legal_primario)
VALUES (3, '99988877766');


-- ------------------------------------------------------------
-- ATRIBUICOES DE ADVOGADOS A CASOS
-- ------------------------------------------------------------

INSERT INTO atribuido_a (caso_num, sujeito_doc_legal_primario)
VALUES (1, '11122233345');

INSERT INTO atribuido_a (caso_num, sujeito_doc_legal_primario)
VALUES (2, '44455566678');

-- Caso 3 tem dois advogados
INSERT INTO atribuido_a (caso_num, sujeito_doc_legal_primario)
VALUES (3, '11122233345');

INSERT INTO atribuido_a (caso_num, sujeito_doc_legal_primario)
VALUES (3, '33333333345');


-- ------------------------------------------------------------
-- DOCUMENTOS (15 no total)
-- ------------------------------------------------------------

-- Caso 1 – Pedro vs OndaLogica
INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (1, '2025-05-09', 'imagem', '2025-08-07 14:25:00-03', 'prova',
        'ROUBO_1.PNG', 'Captura de tela de pix com valor indevido de salario', 'AABBCC01==', 'https://drive.example.com/doc1.png');

INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (2, '2025-05-09', 'documento', '2025-08-07 14:28:00-03', 'contrato',
        'CONTRATO_SERVICO.PDF', 'Contrato de servico com o cliente', 'AABBCC02==', 'https://drive.example.com/doc2.pdf');

INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (3, '2025-08-07', 'documento', '2025-08-07 14:35:00-03', 'procuracao',
        'PROCURACAO_PEDRO.PDF', 'Procuracao outorgada pelo cliente Pedro a Jose Arthur', 'AABBCC03==', 'https://drive.example.com/doc3.pdf');

INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (4, '2025-08-07', 'documento', '2025-08-07 15:35:00-03', 'peticao',
        'PETICAO_ABERTURA_1.PDF', 'Peticao inicial - reclamacao trabalhista', 'AABBCC04==', 'https://drive.example.com/doc4.pdf');

INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (5, '2025-08-20', 'documento', '2025-08-20 10:00:00-03', 'laudo',
        'LAUDO_PERICIAL_TRABALHISTA.PDF', 'Laudo pericial contabil sobre horas extras e descontos indevidos', 'AABBCC05==', 'https://drive.example.com/doc5.pdf');

INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (6, '2025-09-05', 'documento', '2025-09-05 09:15:00-03', 'recurso',
        'RECURSO_ORDINARIO_1.PDF', 'Recurso ordinario interposto pelo reclamante', 'AABBCC06==', 'https://drive.example.com/doc6.pdf');

-- Caso 2 – Mariana vs Construtora
INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (7, '2025-08-10', 'documento', '2025-08-10 09:00:00-03', 'contrato',
        'CONTRATO_COMPRA_IMOVEL.PDF', 'Contrato de compra e venda do imovel com prazo de entrega', 'AABBCC07==', 'https://drive.example.com/doc7.pdf');

INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (8, '2025-08-10', 'documento', '2025-08-10 09:20:00-03', 'procuracao',
        'PROCURACAO_MARIANA.PDF', 'Procuracao outorgada por Mariana a Fernanda Tavares', 'AABBCC08==', 'https://drive.example.com/doc8.pdf');

INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (9, '2025-08-11', 'documento', '2025-08-11 14:00:00-03', 'peticao',
        'PETICAO_INICIAL_DANO_MATERIAL.PDF', 'Peticao inicial - acao indenizatoria por atraso na entrega', 'AABBCC09==', 'https://drive.example.com/doc9.pdf');

INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (10, '2025-08-25', 'imagem', '2025-08-25 16:30:00-03', 'prova',
        'FOTO_OBRA_INACABADA.PNG', 'Fotografia da obra ainda nao concluida apos prazo contratual', 'AABBCC10==', 'https://drive.example.com/doc10.png');

-- Caso 3 – Carlos vs Banco Nacional (e compartilhado entre processos)
INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (11, '2025-08-12', 'documento', '2025-08-12 10:00:00-03', 'contrato',
        'CONTRATO_FINANCIAMENTO.PDF', 'Contrato de financiamento imobiliario com clausulas contestadas', 'AABBCC11==', 'https://drive.example.com/doc11.pdf');

INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (12, '2025-08-12', 'documento', '2025-08-12 10:30:00-03', 'procuracao',
        'PROCURACAO_CARLOS.PDF', 'Procuracao outorgada por Carlos a Jose Arthur e Danilo Antonio', 'AABBCC12==', 'https://drive.example.com/doc12.pdf');

INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (13, '2025-09-01', 'documento', '2025-09-01 11:00:00-03', 'decisao',
        'DECISAO_LIMINAR_P2.PDF', 'Decisao liminar concedendo tutela de urgencia no processo 2', 'AABBCC13==', 'https://drive.example.com/doc13.pdf');

INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (14, '2025-09-10', 'audio', '2025-09-10 08:45:00-03', 'transcricao',
        'AUDIENCIA_CONCILIACAO_P1.MP3', 'Gravacao da audiencia de conciliacao do processo 1', 'AABBCC14==', 'https://drive.example.com/doc14.mp3');

INSERT INTO documento (num, data_criacao, tipo_arquivo, data_upload, tipo_documento, nome_original, descricao, hash, link_acesso)
VALUES (15, '2025-09-15', 'documento', '2025-09-15 17:00:00-03', 'sentenca',
        'SENTENCA_P2.PDF', 'Sentenca de primeiro grau - processo 2 Mariana vs Construtora', 'AABBCC15==', 'https://drive.example.com/doc15.pdf');


-- ------------------------------------------------------------
-- ASSINATURAS
-- ------------------------------------------------------------

-- Doc 1 (prova) – assinado pelo cliente Pedro
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('77711198899', 1, '2025-08-07 14:25:00-03', 'Belo Horizonte, Minas Gerais, Brasil');

-- Doc 2 (contrato) – cliente + advogado
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('77711198899', 2, '2025-08-07 14:28:00-03', 'Belo Horizonte, Minas Gerais, Brasil');
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('11122233345', 2, '2025-08-07 14:28:00-03', 'Belo Horizonte, Minas Gerais, Brasil');

-- Doc 3 (procuração Pedro) – cliente + advogado
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('77711198899', 3, '2025-08-07 14:35:00-03', 'Belo Horizonte, Minas Gerais, Brasil');
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('11122233345', 3, '2025-08-07 14:35:00-03', 'Belo Horizonte, Minas Gerais, Brasil');

-- Doc 4 (petição inicial 1) – advogado
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('11122233345', 4, '2025-08-07 15:35:00-03', 'Belo Horizonte, Minas Gerais, Brasil');

-- Doc 5 (laudo pericial) – perito
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('12312312312', 5, '2025-08-20 10:00:00-03', 'Belo Horizonte, Minas Gerais, Brasil');

-- Doc 7 (contrato imóvel) – cliente Mariana
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('99988877766', 7, '2025-08-10 09:00:00-03', 'Contagem, Minas Gerais, Brasil');

-- Doc 8 (procuração Mariana) – cliente + advogada
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('99988877766', 8, '2025-08-10 09:20:00-03', 'Contagem, Minas Gerais, Brasil');
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('44455566678', 8, '2025-08-10 09:20:00-03', 'Contagem, Minas Gerais, Brasil');

-- Doc 9 (petição inicial 2) – advogada Fernanda
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('44455566678', 9, '2025-08-11 14:00:00-03', 'Contagem, Minas Gerais, Brasil');

-- Doc 12 (procuração Carlos) – cliente + dois advogados
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('55544433322', 12, '2025-08-12 10:30:00-03', 'Belo Horizonte, Minas Gerais, Brasil');
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('11122233345', 12, '2025-08-12 10:30:00-03', 'Belo Horizonte, Minas Gerais, Brasil');
INSERT INTO assinatura (sujeito_doc_legal_primario, documento_id, em_data, em_municipio)
VALUES ('33333333345', 12, '2025-08-12 10:30:00-03', 'Belo Horizonte, Minas Gerais, Brasil');


-- ------------------------------------------------------------
-- ANEXOS A CASOS
-- ------------------------------------------------------------

-- Caso 1
INSERT INTO anexo_caso (documento_id, caso_num, em) VALUES (1, 1, '2025-08-07 14:25:00-03');
INSERT INTO anexo_caso (documento_id, caso_num, em) VALUES (2, 1, '2025-08-07 14:28:00-03');
INSERT INTO anexo_caso (documento_id, caso_num, em) VALUES (3, 1, '2025-08-07 14:35:00-03');
INSERT INTO anexo_caso (documento_id, caso_num, em) VALUES (4, 1, '2025-08-07 15:35:00-03');

-- Caso 2
INSERT INTO anexo_caso (documento_id, caso_num, em) VALUES (7, 2, '2025-08-10 09:00:00-03');
INSERT INTO anexo_caso (documento_id, caso_num, em) VALUES (8, 2, '2025-08-10 09:20:00-03');
INSERT INTO anexo_caso (documento_id, caso_num, em) VALUES (9, 2, '2025-08-11 14:00:00-03');
INSERT INTO anexo_caso (documento_id, caso_num, em) VALUES (10, 2, '2025-08-25 16:30:00-03');

-- Caso 3
INSERT INTO anexo_caso (documento_id, caso_num, em) VALUES (11, 3, '2025-08-12 10:00:00-03');
INSERT INTO anexo_caso (documento_id, caso_num, em) VALUES (12, 3, '2025-08-12 10:30:00-03');


-- ------------------------------------------------------------
-- PROCESSOS (3 processos)
-- Processo 1 – originado do Caso 1 (trabalhista)
-- Processo 2 – originado dos Casos 2 E 3 (indenizatorio + revisional conexos)
-- Processo 3 – originado do Caso 3 (revisional banco, vara cível distinta)
-- ------------------------------------------------------------

INSERT INTO processo (num, descricao, valor_causa, data_abertura, status, data_encerramento, titulo, motivo_encerramento)
VALUES (1, 'Reclamacao trabalhista: horas extras, FGTS e reducao salarial indevida.',
        37000.00, '2025-08-10', 'aberto', NULL, 'Pedro Kalil vs OndaLogica', NULL);

INSERT INTO processo (num, descricao, valor_causa, data_abertura, status, data_encerramento, titulo, motivo_encerramento)
VALUES (2, 'Acao de indenizacao por danos materiais e morais por atraso de obra, com pedido de revisao de multa contratual.',
        120000.00, '2025-08-13', 'aberto', NULL, 'Mariana Ferreira vs Construtora Horizonte', NULL);

INSERT INTO processo (num, descricao, valor_causa, data_abertura, status, data_encerramento, titulo, motivo_encerramento)
VALUES (3, 'Acao revisional de clausulas abusivas e pedido de repeticao de indebito em contrato de financiamento.',
        85000.00, '2025-08-15', 'protocolado', NULL, 'Carlos Braga vs Banco Nacional de Credito', NULL);


-- ------------------------------------------------------------
-- CASO_GERA_PROCESSO
-- Relacao N:N: Caso 2 e Caso 3 geraram o Processo 2 (conexao)
-- Caso 3 tambem gerou o Processo 3 (vara diferente)
-- ------------------------------------------------------------

INSERT INTO caso_gera_processo (processo_numero, caso_num) VALUES (1, 1);
INSERT INTO caso_gera_processo (processo_numero, caso_num) VALUES (2, 2);
INSERT INTO caso_gera_processo (processo_numero, caso_num) VALUES (2, 3); -- caso 3 conexo ao processo 2
INSERT INTO caso_gera_processo (processo_numero, caso_num) VALUES (3, 3); -- caso 3 tambem gerou processo 3


-- ------------------------------------------------------------
-- PARTES
-- ------------------------------------------------------------

-- Processo 1: Pedro vs OndaLogica
INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('77711198899', 1, '2025-08-10', 'intimado', 'autor', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('22222222222', 1, '2025-08-10', 'intimado', 'reu', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('11122233345', 1, '2025-08-10', 'nomeado', 'advogado', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('33333333345', 1, '2025-08-10', 'nomeado', 'advogado', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('11111111111', 1, '2025-08-10', 'sorteio', 'tribunal', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('12312312312', 1, '2025-08-18', 'nomeado', 'perito', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('98798798700', 1, '2025-08-10', 'nomeado', 'oficial_de_justica', 'ativo');

-- Processo 2: Mariana vs Construtora (+ Carlos conexo)
INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('99988877766', 2, '2025-08-13', 'citado', 'autor', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('88899900011', 2, '2025-08-13', 'citado', 'reu', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('44455566678', 2, '2025-08-13', 'nomeado', 'advogado', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('11111111112', 2, '2025-08-13', 'sorteio', 'tribunal', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('77788899900', 2, '2025-08-14', 'nomeado', 'promotor', 'ativo');

-- Processo 3: Carlos vs Banco Nacional
INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('55544433322', 3, '2025-08-15', 'habilitado', 'autor', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('66677788899', 3, '2025-08-15', 'citado', 'reu', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('11122233345', 3, '2025-08-15', 'nomeado', 'advogado', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('33333333345', 3, '2025-08-15', 'nomeado', 'advogado', 'ativo');

INSERT INTO parte (sujeito_doc_legal_primario, processo_numero, data_inclusao_em_processo, motivo_inclusao_em_processo, papel_em_processo, status_no_processo)
VALUES ('11111111112', 3, '2025-08-15', 'sorteio', 'tribunal', 'ativo');


-- ------------------------------------------------------------
-- MOVIMENTACOES (12 no total)
-- ------------------------------------------------------------

-- Processo 1 – trabalhista
INSERT INTO movimentacao (num, tipo, data_que_ocorreu, observacoes, processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
VALUES (1, 'peticao', '2025-08-10', 'Peticao inicial protocolada pelo autor',
        1, '77711198899', 'autor');

INSERT INTO movimentacao (num, tipo, data_que_ocorreu, observacoes, processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
VALUES (2, 'citacao', '2025-08-12', 'Citacao da reclamada OndaLogica realizada por oficial de justica',
        1, '98798798700', 'oficial_de_justica');

INSERT INTO movimentacao (num, tipo, data_que_ocorreu, observacoes, processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
VALUES (3, 'despacho', '2025-08-14', 'Despacho designando audiencia de conciliacao para 10/09/2025',
        1, '11111111111', 'tribunal');

INSERT INTO movimentacao (num, tipo, data_que_ocorreu, observacoes, processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
VALUES (4, 'laudo', '2025-08-20', 'Laudo pericial contabil juntado aos autos',
        1, '12312312312', 'perito');

INSERT INTO movimentacao (num, tipo, data_que_ocorreu, observacoes, processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
VALUES (5, 'audiencia', '2025-09-10', 'Audiencia de conciliacao realizada sem acordo entre as partes',
        1, '11111111111', 'tribunal');

INSERT INTO movimentacao (num, tipo, data_que_ocorreu, observacoes, processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
VALUES (6, 'recurso', '2025-09-05', 'Recurso ordinario interposto pelo reclamante apos despacho desfavoravel',
        1, '77711198899', 'autor');

-- Processo 2 – indenizatório
INSERT INTO movimentacao (num, tipo, data_que_ocorreu, observacoes, processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
VALUES (7, 'peticao', '2025-08-13', 'Peticao inicial com pedido de tutela de urgencia',
        2, '99988877766', 'autor');

INSERT INTO movimentacao (num, tipo, data_que_ocorreu, observacoes, processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
VALUES (8, 'decisao', '2025-09-01', 'Decisao interlocutoria deferindo liminar de bloqueio de valores',
        2, '11111111112', 'tribunal');

INSERT INTO movimentacao (num, tipo, data_que_ocorreu, observacoes, processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
VALUES (9, 'intimacao', '2025-09-03', 'Intimacao da parte ré para cumprimento da liminar em 48h',
        2, '11111111112', 'tribunal');

INSERT INTO movimentacao (num, tipo, data_que_ocorreu, observacoes, processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
VALUES (10, 'sentenca', '2025-09-15', 'Sentenca de primeiro grau julgando procedente o pedido indenizatorio',
        2, '11111111112', 'tribunal');

-- Processo 3 – revisional
INSERT INTO movimentacao (num, tipo, data_que_ocorreu, observacoes, processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
VALUES (11, 'peticao', '2025-08-15', 'Peticao inicial com pedido de revisao contratual e repeticao de indebito',
        3, '55544433322', 'autor');

INSERT INTO movimentacao (num, tipo, data_que_ocorreu, observacoes, processo_numero, parte_doc_legal_primario, parte_papel_em_processo)
VALUES (12, 'despacho', '2025-08-18', 'Despacho determinando emenda a peticao inicial para esclarecer valor atualizado do indebito',
        3, '11111111112', 'tribunal');


-- ------------------------------------------------------------
-- ANEXOS A MOVIMENTACOES
-- ------------------------------------------------------------

-- Mov 1 (petição inicial P1) – procuração + petição
INSERT INTO anexo_movimentacao (documento_id, movimentacao_id, em) VALUES (3, 1, '2025-08-10');
INSERT INTO anexo_movimentacao (documento_id, movimentacao_id, em) VALUES (4, 1, '2025-08-10');

-- Mov 4 (laudo pericial)
INSERT INTO anexo_movimentacao (documento_id, movimentacao_id, em) VALUES (5, 4, '2025-08-20');

-- Mov 5 (audiência de conciliação) – áudio da audiência
INSERT INTO anexo_movimentacao (documento_id, movimentacao_id, em) VALUES (14, 5, '2025-09-10');

-- Mov 6 (recurso ordinário)
INSERT INTO anexo_movimentacao (documento_id, movimentacao_id, em) VALUES (6, 6, '2025-09-05');

-- Mov 7 (petição inicial P2) – procuração + petição
INSERT INTO anexo_movimentacao (documento_id, movimentacao_id, em) VALUES (8, 7, '2025-08-13');
INSERT INTO anexo_movimentacao (documento_id, movimentacao_id, em) VALUES (9, 7, '2025-08-13');

-- Mov 8 (decisão liminar P2)
INSERT INTO anexo_movimentacao (documento_id, movimentacao_id, em) VALUES (13, 8, '2025-09-01');

-- Mov 10 (sentença P2)
INSERT INTO anexo_movimentacao (documento_id, movimentacao_id, em) VALUES (15, 10, '2025-09-15');

-- Mov 11 (petição inicial P3) – contrato + procuração
INSERT INTO anexo_movimentacao (documento_id, movimentacao_id, em) VALUES (11, 11, '2025-08-15');
INSERT INTO anexo_movimentacao (documento_id, movimentacao_id, em) VALUES (12, 11, '2025-08-15');


-- Q1 - Sujeitos que contém Pedro
SELECT *
FROM sujeito s
WHERE nome_legal like '%Pedro%';

-- Q2 - processos trabalhistas
SELECT *
FROM processo p
WHERE descricao like '%trabalhista%';

-- Q3 - nome de sujeitos + numero e motivo de inclusão em cada um de seus processos
SELECT nome_legal, processo_numero, motivo_inclusao_em_processo
FROM sujeito s
JOIN parte on s.doc_legal = sujeito_doc_legal_primario;


-- Q4 - titulo e numero processo + tipo e observacoes de todas movimentacoes
SELECT observacoes, tipo, titulo, processo_numero
FROM processo p
JOIN movimentacao on p.num = movimentacao.processo_numero;

-- Q5 - Todos os casos e seus processos (casos sem processo também aparecem)
SELECT
    c.num        AS caso_num,
    c.titulo     AS caso_titulo,
    c.status     AS caso_status,
    p.num        AS processo_num,
    p.status     AS processo_status
FROM caso c
LEFT OUTER JOIN caso_gera_processo cgp ON cgp.caso_num = c.num
LEFT OUTER JOIN processo p             ON p.num = cgp.processo_numero;

-- Q6 - Quantos processos cada sujeito participa
SELECT nome_legal, sujeito_doc_legal_primario, count(processo_numero)
from sujeito
join parte p on p.sujeito_doc_legal_primario = doc_legal
group by sujeito_doc_legal_primario, nome_legal;

-- Q7 - Papel mais comum em processo
SELECT *
from (
    SELECT p.papel_em_processo as papel, count(processo_numero) as count_per_papel
    from parte p
    group by p.papel_em_processo
) as numero_de_processos_por_papel
ORDER BY  count_per_papel DESC
limit 1;

-- Q8 - Todos clientes que ja abriram processo
SELECT *
from cliente c
where EXISTS(select from parte p where papel_em_processo = 'autor' AND c.doc_legal_primario = p.sujeito_doc_legal_primario);

-- Q9 - Papel mais comum em processo

with numero_de_processos_por_papel AS (
    SELECT p.papel_em_processo as papel, count(processo_numero) as count_per_papel
    from parte p
    group by p.papel_em_processo
)
SELECT *
from numero_de_processos_por_papel
ORDER BY  count_per_papel DESC
limit 1;

-- Q10 - Todos os documentos que os advogados da firma assinaram
SELECT *
from documento d
JOIN assinatura a on a.documento_id = d.num
where EXISTS(select * from advogado where doc_legal_primario = a.sujeito_doc_legal_primario);
