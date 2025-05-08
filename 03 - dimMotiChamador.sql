-- criando a tabela dimMotiChamador

CREATE TABLE dbo.dimMotiChamador (
    idMotivo INT IDENTITY(1,1) PRIMARY KEY,
    Motivo_Chamador VARCHAR(200)
);

-- inserindo os dados na tabela dimMotiChamador

INSERT INTO dbo.dimMotiChamador (Motivo_Chamador)
SELECT DISTINCT Motivo_Chamador
FROM dbo.histCasosTrabalhados
WHERE Motivo_Chamador IS NOT NULL