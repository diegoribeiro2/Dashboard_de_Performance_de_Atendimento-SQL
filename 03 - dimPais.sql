-- criando a tabela dimPais

CREATE TABLE dbo.dimPais (
    idPais INT IDENTITY(1,1) PRIMARY KEY,
    Pa�s VARCHAR(10)
);

-- inserindo os dados na tabela dimPais

INSERT INTO dbo.dimPais (Pa�s)
SELECT DISTINCT Pa�s
FROM dbo.histCasosTrabalhados
WHERE Pa�s IS NOT NULL