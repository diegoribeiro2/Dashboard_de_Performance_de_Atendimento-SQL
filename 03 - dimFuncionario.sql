-- criando a tabela dimFuncionario

CREATE TABLE dbo.dimFuncionario (
    idFuncionario INT IDENTITY(1,1) PRIMARY KEY,
    NomeAgen VARCHAR(200)
);

-- inserindo os dados na tabela dimFuncionario

INSERT INTO dbo.dimFuncionario (NomeAgen)
SELECT DISTINCT NomeAgen
FROM dbo.histCasosTrabalhados
WHERE NomeAgen IS NOT NULL