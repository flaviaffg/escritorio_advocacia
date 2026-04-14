# Sujeito


```sql
CREATE TABLE IF NOT EXISTS Sujeito (
    doc_legal_primario TEXT NOT NULL PRIMARY KEY
);
```

Entidade base Sujeito.

# Advogado

```sql
CREATE TABLE IF NOT EXISTS Advogado (
    doc_legal_primario TEXT NOT NULL PRIMARY KEY REFERENCES Sujeito(doc_legal_primario)
);
```

Especializacao opcional e não exclusiva de Sujeito.

# Cliente

```sql
CREATE TABLE IF NOT EXISTS Cliente (
    doc_legal_primario TEXT NOT NULL PRIMARY KEY REFERENCES Sujeito(doc_legal_primario)
);
```

Especializacao opcional e não exclusiva de Sujeito

# Caso

```sql
CREATE TABLE IF NOT EXISTS Caso (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS identity
);
```

Entidade Caso.

# Documento

```sql
CREATE TABLE IF NOT EXISTS Documento (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS identity
);
```

Entidade Documento

# Processo

```sql
CREATE TABLE IF NOT EXISTS Processo (
    numero BIGINT PRIMARY KEY GENERATED ALWAYS AS identity
);
```

Entidade Processo

# Parte

```sql
CREATE TABLE IF NOT EXISTS Parte (
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Sujeito(doc_legal_primario),
    processo_numero BIGINT NOT NULL REFERENCES Processo(numero),
    papel_em_processo TEXT NOT NULL,
    PRIMARY KEY (sujeito_doc_legal_primario, processo_numero, papel_em_processo)
);
```

Entidade fraca parte, composta de Sujeito + Processo e campo papel_em_processo. Unico por Sujeito + Processo + papel.

# Movimentacao

```sql
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
```

Entidade Movimentacao, protocolada por exatamente uma parte, comtemplada por exatamente um processo. 

# Caso_Gera_Processo

```sql
CREATE TABLE IF NOT EXISTS Caso_Gera_Processo (
    processo_numero BIGINT NOT NULL REFERENCES Processo(numero),
    caso_id BIGINT NOT NULL REFERENCES Caso(id),
    PRIMARY KEY (processo_numero, caso_id)
);
```

Relacao em que um Caso gerou um processo. Pode haver 0..N por Caso. Referencia exatamente um Caso e um Processo. Unico por par Processo + Caso.

# Anexo_Caso

```sql
CREATE TABLE IF NOT EXISTS Anexo_Caso (
    documento_id BIGINT NOT NULL REFERENCES Documento(id),
    caso_id BIGINT NOT NULL REFERENCES Caso(id),
    PRIMARY KEY (documento_id, caso_id)
);
```

Relacao que anexa um documento a um caso. Pode haver 0..N por Caso e por Documento, referencia exatamente um Caso e um Documento. Unica por par Documento + Caso.

# Anexo_Movimentacao
```sql
CREATE TABLE IF NOT EXISTS Anexo_Movimentacao (
    documento_id BIGINT NOT NULL REFERENCES Documento(id),
    movimentacao_id BIGINT NOT NULL REFERENCES Movimentacao(id),
    PRIMARY KEY (documento_id, movimentacao_id)
);
```

Relacao que anexa um documento a uma movimentacao. Pode haver 0..N por Documento e por movmentacao, referencia exatamente uma Movimentacao e um Documento. Unica por par Documento + Movimentacao.

# Assinatura

```sql
CREATE TABLE IF NOT EXISTS Assinatura (
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Sujeito(doc_legal_primario),
    documento_id BIGINT NOT NULL REFERENCES Documento(id),
    PRIMARY KEY (sujeito_doc_legal_primario, documento_id)
);
```

Relacao que declara assinado um documento por um sujeito legal. Pode haver 0..N por Documento e por Sujeito legal, unica por par de Documento + Sujeito.

# Solicitacao_Abertura

```sql
CREATE TABLE IF NOT EXISTS Solicitacao_Abertura (
    caso_id BIGINT NOT NULL REFERENCES Caso(id),
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Cliente(doc_legal_primario),
    PRIMARY KEY (caso_id, sujeito_doc_legal_primario)
);
```

Relacao que declara que um caso foi aberto por um cliente. Pode haver 1..N por Caso e Cliente, unica por par de Cliente + Caso.

# Atribuido_A

```sql
CREATE TABLE IF NOT EXISTS Atribuido_A (
    caso_id BIGINT NOT NULL REFERENCES Caso(id),
    sujeito_doc_legal_primario TEXT NOT NULL REFERENCES Advogado(doc_legal_primario),
    PRIMARY KEY (caso_id, sujeito_doc_legal_primario)
);
```

Relacao que declara um Caso atribuido a um Advogado. Pode haver 1..N por Caso e Advogado, unico por par de Caso + Advogado.
