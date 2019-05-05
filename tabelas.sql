CREATE OR REPLACE TYPE TP_CLIENTE
  AS
    OBJECT
    (
        CPF char(11),
        COD_ENDERECO INTEGER,
        NOME varchar2(50),
        EMAIL varchar2(50),
        DATA_NASCIMENTO date,
        CONSTRUCTOR FUNCTION TP_CLIENTE(X TP_CLIENTE) RETURN SELF AS RESULT
    );
--------------------------------------------------------------------------------
CREATE TABLE TB_CLIENTE OF TP_CLIENTE
(
  CPF PRIMARY KEY
);
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_PERIODO
  AS OBJECT
    (
      DATA_FIN DATE,
      DATA_INICIO DATE,
      CONSTRUCTOR FUNCTION TP_PERIODO(X TP_PERIODO) RETURN SELF AS RESULT
    );
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_PROMOCAO
  AS OBJECT
    (
      COD_PROMOCAO INTEGER,
      DESCRICAO varchar2(10),
      PERIODO TP_PERIODO,
      CONSTRUCTOR FUNCTION TP_PROMOCAO(X TP_PROMOCAO) RETURN SELF AS RESULT
    );
--------------------------------------------------------------------------------
CREATE TABLE TB_PROMOCAO OF TP_PROMOCAO
(
  COD_PROMOCAO PRIMARY KEY
);
--------------------------------------------------------------------------------
create or replace TYPE TP_ATORES AS OBJECT
(
    NOME VARCHAR2(50)
);
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_NT_ATORES AS TABLE OF TP_ATORES;
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_FILME
AS
OBJECT
(
  COD_FILME INTEGER,
  TITULO varchar2(50),
  GENERO varchar2(50),
  DIRETOR varchar2(50),
  DESCRICAO varchar2(50),
  CLASSIFICACAO varchar2(20),
  DURACAO INTEGER,
  ATORES TP_NT_ATORES,
  CONSTRUCTOR FUNCTION TP_FILME(X TP_FILME) RETURN SELF AS RESULT,
  FINAL MAP MEMBER FUNCTION COMPARE_COD_FILME RETURN INTEGER
);
--------------------------------------------------------------------------------
CREATE TABLE TB_FILME OF TP_FILME
(
  COD_FILME PRIMARY KEY
)NESTED TABLE ATORES STORE AS TB_LISTA_ATORES;
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_TELEFONE
    AS
      OBJECT
      (
        DDD_TELEFONE VARCHAR2(2),
        NUMERO_TELEFONE VARCHAR2(20),
        CONSTRUCTOR FUNCTION TP_TELEFONE(X TP_TELEFONE) RETURN SELF AS RESULT,
        FINAL MAP MEMBER FUNCTION COMPARA_TELEFONE RETURN INTEGER
      );
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_TELEFONE_FUNCIONARIO AS VARRAY(2) OF TP_TELEFONE;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_ENDERECO
AS
  OBJECT
  (
    RUA VARCHAR2(50),
    NUMERO INTEGER,
    BAIRRO VARCHAR2(100),
    CEP VARCHAR2(10),
    CIDADE VARCHAR2(50),
    CONSTRUCTOR FUNCTION TP_ENDERECO(X TP_ENDERECO) RETURN SELF AS RESULT
  )NOT FINAL;
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_FUNCIONARIO AS OBJECT
  (
    NOME VARCHAR2(100),
    CPF VARCHAR2(11),
    EMAIL VARCHAR2(50),
    TELEFONE TP_TELEFONE_FUNCIONARIO,
    ENDERECO TP_ENDERECO,
    SUPERVISOR REF TP_FUNCIONARIO,
    CONSTRUCTOR FUNCTION TP_FUNCIONARIO RETURN SELF AS RESULT,

    ORDER MEMBER FUNCTION COMPARE(FUNCIONARIO TP_FUNCIONARIO) RETURN INTEGER,

    CONSTRUCTOR FUNCTION TP_FUNCIONARIO(

        NOME IN VARCHAR2,
        CPF IN VARCHAR2,
        EMAIL IN VARCHAR2,
        TELEFONE in TP_TELEFONE,
        ENDERECO IN TP_ENDERECO
    )RETURN SELF AS RESULT

  )NOT FINAL;
  ------------------------------------------------------------------------------
  CREATE OR REPLACE TYPE TP_PRODUCTO
   AS
    OBJECT
    (
     COD_PRODUCTO integer,
     DESCRICAO varchar2(50),
     VALOR float(2),
     QUANTIDADE integer,
     CONSTRUCTOR FUNCTION TP_PRODUCTO(X TP_PRODUCTO) RETURN SELF AS RESULT,
     MEMBER PROCEDURE EXIBIR_DETALHES(SELF TP_PRODUCTO),
     MAP MEMBER FUNCTION PRODUCTOTOINT RETURN INTEGER
    );
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_NT_PRODUCTO AS TABLE OF TP_PRODUCTO;
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_LANCHONETE UNDER TP_FUNCIONARIO();
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_LIMPEZA UNDER TP_FUNCIONARIO();
--------------------------------------------------------------------------------
CREATE TABLE TB_LIMPEZA OF TP_LIMPEZA
(
  CPF PRIMARY KEY,
  SUPERVISOR WITH ROWID REFERENCES TB_TICKET
);
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_TICKET UNDER TP_FUNCIONARIO();
--------------------------------------------------------------------------------
CREATE TABLE TB_TICKET OF TP_TICKET
(
  CPF PRIMARY KEY,
  SUPERVISOR WITH ROWID REFERENCES TB_TICKET
);
--------------------------------------------------------------------------------
CREATE TABLE TB_LANCHONETE OF TP_LANCHONETE
(
  CPF PRIMARY KEY,
  SUPERVISOR WITH ROWID REFERENCES TB_TICKET
);
--------------------------------------------------------------------------------
CREATE TABLE TB_VENDA(
  COD_VENDA INTEGER,
  FUNCIONARIO_LANCHONETE REF TP_LANCHANETTE,
  CLIENTE REF TP_CLIENTE,
  LISTA_PRODUCTOS TP_NT_PRODUCTO,
  CONSTRAINT PK_VENDA PRIMARY KEY(COD_VENDA)
  ) NESTED TABLE LISTA_PRODUCTOS STORE AS TB_LISTA_PRODUCTO;
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_SALA
AS
OBJECT
(
  NUMERO INTEGER,
  CAPACIDADE INTEGER,
  CONSTRUCTOR FUNCTION TP_SALA(X TP_SALA) RETURN SELF AS RESULT,
  FINAL MEMBER FUNCTION COMPARE_NUMERO_SALA RETURN INTEGER
);
--------------------------------------------------------------------------------
CREATE TABLE TB_SALA OF TP_SALA
(
  NUMERO PRIMARY KEY
);
--------------------------------------------------------------------------------
CREATE TABLE TB_LIMPEZA_SALA
(
  SALA REF TP_SALA,
  LIMPEZA REF TP_LIMPEZA
);
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_SESSAO
AS
OBJECT
(
  COD_SESSAO integer,
  DATA_HORA_INICIO date,
  FILME REF TP_FILME,
  SALA REF TP_SALA,
  CONSTRUCTOR FUNCTION TP_SESSAO(X TP_SESSAO) RETURN SELF AS RESULT,
  MEMBER FUNCTION COMPARE_COD_SESSAO RETURN INTEGER
);
--------------------------------------------------------------------------------
CREATE TABLE TB_SESSAO OF TP_SESSAO
(
  COD_SESSAO PRIMARY KEY
);
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE TP_INGRESSO
AS
OBJECT
(
  COD_INGRESSO integer,
  PROMOCAO REF TP_PROMOCAO,
  TIPO varchar2(10),
  POLTRONA int,
  VALOR float(2),
  DATA_COMPRA date,
  FORMA_PAGAMENTO char(1),
  CONSTRUCTOR FUNCTION TP_INGRESSO(X TP_INGRESSO) RETURN SELF AS RESULT,
  MEMBER FUNCTION COMPARE_COD_INGRESSO RETURN INTEGER
);

ALTER TYPE TP_INGRESSO ADD ATTRIBUTE (SESSAO REF TP_SESSAO) CASCADE;
--------------------------------------------------------------------------------
CREATE TABLE TB_INGRESSO OF TP_INGRESSO
(
  COD_INGRESSO PRIMARY KEY
);
--------------------------------------------------------------------------------
CREATE TABLE TB_FUNCIONARIO_INGRESSO_CLIENTE
(
  TICKET REF TP_TICKET,
  INGRESSO REF TP_INGRESSO,
  CLIENTE REF TP_CLIENTE
);
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE BODY TP_PRODUCTO AS
     CONSTRUCTOR FUNCTION TP_PRODUCTO(X TP_PRODUCTO) RETURN SELF AS RESULT IS
      BEGIN
        COD_PRODUCTO := X.COD_PRODUCTO;
        DESCRICAO := X.DESCRICAO;
        VALOR := X.VALOR;
        QUANTIDADE := X.QUANTIDADE;
      END;
     MEMBER PROCEDURE EXIBIR_DETALHES(SELF TP_PRODUCTO) IS
     BEGIN
      DBMS_OUTPUT.PUT_LINE('Detalhes de um Producto');
      DBMS_OUTPUT.PUT_LINE('CÓDIGO: ' || TO_CHAR(COD_PRODUCTO));
      DBMS_OUTPUT.PUT_LINE('DESCRIÇÃO: ' || DESCRICAO);
      DBMS_OUTPUT.PUT_LINE('VALOR: ' || 'R$. ' || TO_CHAR( VALOR));
      DBMS_OUTPUT.PUT_LINE('QUANTIDADE:' || TO_CHAR( valor));
     END;

     MAP MEMBER FUNCTION PRODUCTOTOINT RETURN INTEGER IS
     P INTEGER := COD_PRODUCTO;
     BEGIN
      RETURN P;
     END;
END;
/
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE BODY TP_ENDERECO AS
  CONSTRUCTOR FUNCTION TP_ENDERECO(X TP_ENDERECO) RETURN SELF AS RESULT IS
    BEGIN
      RUA := X.RUA;
      NUMERO := X.NUMERO;
      BAIRRO := X.BAIRRO;
      CEP := X.CEP;
      CIDADE := X.CIDADE;
    END;
END;
/
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE BODY TP_TELEFONE AS
  CONSTRUCTOR FUNCTION TP_TELEFONE(X TP_TELEFONE) RETURN SELF AS RESULT IS
    BEGIN
      DDD_TELEFONE := X.DDD_TELEFONE;
      NUMERO_TELEFONE := X.NUMERO_TELEFONE;
    END;
    FINAL MAP MEMBER FUNCTION COMPARA_TELEFONE RETURN INTEGER IS
    P INTEGER := TO_NUMBER(DDD_TELEFONE) + TO_NUMBER(NUMERO_TELEFONE);
    BEGIN
      RETURN P;
    END;
END;
/
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE BODY TP_CLIENTE AS
   CONSTRUCTOR FUNCTION TP_CLIENTE(X TP_CLIENTE) RETURN SELF AS RESULT IS
    BEGIN
      CPF := X.CPF;
      COD_ENDERECO := X.COD_ENDERECO;
      NOME := X.NOME;
      EMAIL := X.EMAIL;
      DATA_NASCIMENTO := X.DATA_NASCIMENTO;
    END;
END;
/
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE BODY TP_PERIODO AS
 CONSTRUCTOR FUNCTION TP_PERIODO(X TP_PERIODO) RETURN SELF AS RESULT IS
  BEGIN
    DATA_FIN := X.DATA_FIN;
    DATA_INICIO := X.DATA_INICIO;
  END;
END;
/
--------------------------------------------------------------------------------
CREATE OR REPLACE TYPE BODY TP_PROMOCAO AS
CONSTRUCTOR FUNCTION TP_PROMOCAO(X TP_PROMOCAO) RETURN SELF AS RESULT IS
  BEGIN
    COD_PROMOCAO := X.COD_PROMOCAO;
    DESCRICAO := X.DESCRICAO;
    PERIODO := X.PERIODO;
  END;
END;
/
