-- criando a tabela dimStatus

CREATE TABLE dbo.dimStatus (
    idStatus INT IDENTITY(1,1) PRIMARY KEY,
    Status VARCHAR(50)
);

-- inserindo os dados na tabela dimStatus

INSERT INTO dbo.dimStatus (Status)
SELECT DISTINCT Status
FROM dbo.histCasosTrabalhados
WHERE Status IS NOT NULL