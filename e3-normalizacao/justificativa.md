# Sujeito

```sql
CREATE TABLE IF NOT EXISTS Sujeito (
    doc_legal_primario TEXT NOT NULL PRIMARY KEY,
    tipo_sujeito TEXT NOT NULL,
    nome_legal TEXT NOT NULL,
    CHECK (
        (tipo_sujeito = 'pessoa_fisica')
    OR
        (tipo_sujeito IN ('pessoa_juridica', 'uniao', 'estado', 'municipio', 'tribunal'))
    )
);
```

Dependências funcionais:
- `doc_legal_primario` → `tipo_sujeito` (total)
- `doc_legal_primario` → `nome_legal` (total)

Forma Normal: **BCNF**
- Chave candidata única: `{doc_legal_primario}`
- Todos os atributos dependem exclusivamente da chave primária de forma total e direta.
- Não há dependências parciais, transitivas ou multivaloradas.

---

# Advogado

```sql
CREATE TABLE IF NOT EXISTS Advogado (
    doc_legal_primario TEXT NOT NULL PRIMARY KEY REFERENCES Sujeito(doc_legal_primario),
    oab_numero TEXT NOT NULL,
    oab_uf TEXT NOT NULL,
    email TEXT NOT NULL,
    telefone_comercial TEXT NOT NULL
);
```

Dependências funcionais:
- `doc_legal_primario` → `oab_numero` (total)
- `doc_legal_primario` → `oab_uf` (total)
- `doc_legal_primario` → `email` (total)
- `doc_legal_primario` → `telefone_comercial` (total)
- `{oab_numero, oab_uf}` → `doc_legal_primario` (chave candidata alternativa: número OAB é único por UF)

Forma Normal: **BCNF**
- Chaves candidatas: `{doc_legal_primario}` e `{oab_numero, oab_uf}`
- Todos os determinantes são chaves candidatas.
- Não há dependências parciais nem transitivas.

---

# Cliente

```sql
CREATE TABLE IF NOT EXISTS Cliente (
    doc_legal_primario TEXT NOT NULL PRIMARY KEY REFERENCES Sujeito(doc_legal_primario),
    nome_social TEXT NOT NULL,
    email_para_contato TEXT NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone_para_contato TEXT NOT NULL
);
```

Dependências funcionais:
- `doc_legal_primario` → `nome_social` (total)
- `doc_legal_primario` → `email_para_contato` (total)
- `doc_legal_primario` → `data_nascimento` (total)
- `doc_legal_primario` → `telefone_para_contato` (total)

Forma Normal: **BCNF**
- Chave candidata única: `{doc_legal_primario}`
- Todos os atributos dependem exclusivamente da chave primária de forma total e direta.
- Não há dependências parciais, transitivas ou multivaloradas.

---

# Caso

```sql
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
```

Dependências funcionais:
- `num` → `data_abertura` (total)
- `num` → `descricao` (total)
- `num` → `titulo` (total)
- `num` → `data_fechamento` (total, parcialmente nula por regra de negócio)
- `num` → `status` (total)

Forma Normal: **BCNF**
- Chave candidata única: `{num}`
- Todos os atributos são determinados exclusivamente pela chave primária.
- A restrição CHECK sobre `data_fechamento` é uma regra de integridade, não uma dependência funcional.

---

# Documento

```sql
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
```

Dependências funcionais:
- `num` → `data_criacao` (total)
- `num` → `tipo_arquivo` (total)
- `num` → `data_upload` (total)
- `num` → `tipo_documento` (total)
- `num` → `nome_original` (total)
- `num` → `descricao` (total)
- `num` → `hash` (total)
- `num` → `link_acesso` (total)
- `hash` → `num` (chave candidata alternativa: hash identifica unicamente o conteúdo do arquivo)
- `link_acesso` → `num` (chave candidata alternativa: link de acesso é único por documento)

Forma Normal: **BCNF**
- Chaves candidatas: `{num}`, `{hash}`, `{link_acesso}`
- Todos os determinantes são chaves candidatas.
- Não há dependências parciais nem transitivas.

---

# Processo

```sql
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
```

Dependências funcionais:
- `num` → `descricao` (total)
- `num` → `valor_causa` (total)
- `num` → `data_abertura` (total)
- `num` → `status` (total)
- `num` → `data_encerramento` (total, parcialmente nula por regra de negócio)
- `num` → `titulo` (total)
- `num` → `motivo_encerramento` (total, parcialmente nulo por regra de negócio)

Nota: `data_encerramento` e `motivo_encerramento` são funcionalmente co-dependentes entre si (`data_encerramento IS NULL ↔ motivo_encerramento IS NULL`), porém ambos são determinados por `num`. Isso é uma restrição de integridade, não uma dependência funcional que viole a normalização.

Forma Normal: **BCNF**
- Chave candidata única: `{num}`
- Todos os atributos são determinados exclusivamente pela chave primária.
- As restrições CHECK são regras de integridade de negócio, não dependências funcionais adicionais.

---

# Parte

```sql
CREATE TABLE IF NOT EXISTS Parte (
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Sujeito(doc_legal_primario),
    processo_numero BIGINT NOT NULL REFERENCES Processo(num),
    data_inclusao_em_processo TIMESTAMPTZ NOT NULL,
    motivo_inclusao_em_processo TEXT NOT NULL,
    papel_em_processo TEXT NOT NULL,
    status_no_processo TEXT NOT NULL,
    CHECK (motivo_inclusao_em_processo in ('sorteio', 'intimado', 'citado', 'habilitado', 'nomeado', 'denunciado')),
    CHECK (papel_em_processo in ('reu', 'juiz', 'advogado', 'oficial_de_justica', 'autor', 'promotor', 'perito', 'testemunha', 'tribunal')),
    CHECK (status_no_processo in ('ativo', 'substituido', 'dispensado')),
    PRIMARY KEY (papel_em_processo, sujeito_doc_legal_primario, processo_numero)
);
```

Dependências funcionais:
- `{sujeito_doc_legal_primario, processo_numero, papel_em_processo}` → `data_inclusao_em_processo` (total)
- `{sujeito_doc_legal_primario, processo_numero, papel_em_processo}` → `motivo_inclusao_em_processo` (total)
- `{sujeito_doc_legal_primario, processo_numero, papel_em_processo}` → `status_no_processo` (total)

Forma Normal: **BCNF**
- Chave candidata única: `{sujeito_doc_legal_primario, processo_numero, papel_em_processo}`
- Todos os atributos não-chave dependem da chave completa.
- Não há dependências parciais (todos os atributos dependem da chave inteira, não de subconjunto dela) nem transitivas.

---

# Movimentacao

```sql
CREATE TABLE IF NOT EXISTS Movimentacao (
    num BIGINT PRIMARY KEY,
    tipo TEXT NOT NULL,
    data_que_ocorreu TIMESTAMPTZ NOT NULL,
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
```

Dependências funcionais:
- `num` → `tipo` (total)
- `num` → `data_que_ocorreu` (total)
- `num` → `observacoes` (total, parcialmente nula)
- `num` → `processo_numero` (total)
- `num` → `parte_doc_legal_primario` (total)
- `num` → `parte_papel_em_processo` (total)

Nota: `processo_numero` é redundante como FK direta — já está implícito na FK composta para `Parte(processo_numero, sujeito_doc_legal_primario, papel_em_processo)`. A FK `contemplada_por` garante consistência adicional de forma explícita, mas não introduz nova dependência funcional.

Forma Normal: **BCNF**
- Chave candidata única: `{num}`
- Todos os atributos dependem exclusivamente da chave primária.
- Não há dependências parciais nem transitivas.

---

# Caso_Gera_Processo

```sql
CREATE TABLE IF NOT EXISTS Caso_Gera_Processo (
    processo_numero BIGINT NOT NULL REFERENCES Processo(num),
    caso_num BIGINT NOT NULL REFERENCES Caso(num),
    PRIMARY KEY (processo_numero, caso_num)
);
```
Dependências funcionais:

Nenhuma dependência funcional não-trivial (tabela de associação pura M:N sem atributos não-chave).

Forma Normal: **4NF** (trivialmente em todas as formas normais até 4NF)

---

# Anexo_Caso

```sql
CREATE TABLE IF NOT EXISTS Anexo_Caso (
    documento_id BIGINT NOT NULL REFERENCES Documento(num),
    caso_num BIGINT NOT NULL REFERENCES Caso(num),
    em TIMESTAMPTZ NOT NULL,
    PRIMARY KEY (documento_id, caso_num)
);
```

Dependências funcionais:
- `{documento_id, caso_num}` → `em` (total)

Forma Normal: **BCNF**
- Chave candidata única: `{documento_id, caso_num}`
- O único atributo não-chave (`em`) depende da chave completa.
- Não há dependências parciais nem transitivas.

---

# Anexo_Movimentacao

```sql
CREATE TABLE IF NOT EXISTS Anexo_Movimentacao (
    documento_id BIGINT NOT NULL REFERENCES Documento(num),
    movimentacao_id BIGINT NOT NULL REFERENCES Movimentacao(num),
    em TIMESTAMPTZ NOT NULL,
    PRIMARY KEY (documento_id, movimentacao_id)
);
```

Dependências funcionais:
- `{documento_id, movimentacao_id}` → `em` (total)

Forma Normal: **BCNF**
- Chave candidata única: `{documento_id, movimentacao_id}`
- O único atributo não-chave (`em`) depende da chave completa.
- Não há dependências parciais nem transitivas.

---

# Assinatura

```sql
CREATE TABLE IF NOT EXISTS Assinatura (
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Sujeito(doc_legal_primario),
    documento_id BIGINT NOT NULL REFERENCES Documento(num),
    em_data TIMESTAMPTZ NOT NULL,
    em_municipio TEXT NOT NULL,
    PRIMARY KEY (sujeito_doc_legal_primario, documento_id)
);
```

Dependências funcionais:
- `{sujeito_doc_legal_primario, documento_id}` → `em_data` (total)
- `{sujeito_doc_legal_primario, documento_id}` → `em_municipio` (total)

Forma Normal: **BCNF**
- Chave candidata única: `{sujeito_doc_legal_primario, documento_id}`
- Todos os atributos não-chave dependem da chave completa.
- Não há dependências parciais nem transitivas.

---

# Solicitacao_Abertura

```sql
CREATE TABLE IF NOT EXISTS Solicitacao_Abertura (
    caso_num BIGINT NOT NULL REFERENCES Caso(num),
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Cliente(doc_legal_primario),
    PRIMARY KEY (caso_num, sujeito_doc_legal_primario)
);
```

Dependências funcionais:
- Nenhuma dependência funcional não-trivial (tabela de associação pura sem atributos não-chave).

Forma Normal: **4NF** (trivialmente em todas as formas normais até 4NF)

---

# Atribuido_A

```sql
CREATE TABLE IF NOT EXISTS Atribuido_A (
    caso_num BIGINT NOT NULL REFERENCES Caso(num),
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Advogado(doc_legal_primario),
    PRIMARY KEY (caso_num, sujeito_doc_legal_primario)
);
```

Dependências funcionais:
- Nenhuma dependência funcional não-trivial (tabela de associação pura sem atributos não-chave).

Forma Normal: **4NF** (trivialmente em todas as formas normais até 4NF)


# Conclusão

O schema como um todo está em **BCNF**. Todas as tabelas com atributos não-chave (`Sujeito`, `Advogado`, `Cliente`, `Caso`, `Documento`, `Processo`, `Parte`, `Movimentacao`, `Anexo_Caso`, `Anexo_Movimentacao`, `Assinatura`) têm todos os seus determinantes como chaves candidatas, sem dependências parciais nem transitivas. As tabelas de associação puras (`Caso_Gera_Processo`, `Solicitacao_Abertura`, `Atribuido_A`) alcançam trivialmente 4NF por ausência de dependências multivaloradas não-triviais.
 

