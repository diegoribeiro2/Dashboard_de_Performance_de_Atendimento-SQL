-- criando a tabela dimSupervisor

CREATE TABLE dbo.dimSupervisor (
    idSupervisor INT IDENTITY(1,1) PRIMARY KEY,
    NomeSupe VARCHAR(200)
);

-- inserindo os dados na tabela dimSupervisor

INSERT INTO dbo.dimSupervisor (NomeSupe)
SELECT DISTINCT NomeSupe
FROM dbo.histCasosTrabalhados
WHERE NomeSupe IS NOT NULL