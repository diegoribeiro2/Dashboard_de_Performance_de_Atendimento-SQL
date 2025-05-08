-- criando a tabela dimPais

CREATE TABLE dbo.dimPais (
    idPais INT IDENTITY(1,1) PRIMARY KEY,
    País VARCHAR(10)
);

-- inserindo os dados na tabela dimPais

INSERT INTO dbo.dimPais (País)
SELECT DISTINCT País
FROM dbo.histCasosTrabalhados
WHERE País IS NOT NULL