-- criando a tabela dimCanalEntrada

CREATE TABLE dbo.dimCanalEntrada (
    idCanalEntrada INT IDENTITY(1,1) PRIMARY KEY,
    Canal_Entrada VARCHAR(50)
);

-- inserindo os dados na tabela dimCanalEntrada

INSERT INTO dbo.dimCanalEntrada (Canal_Entrada)
SELECT DISTINCT Canal_Entrada
FROM dbo.histCasosTrabalhados
WHERE Canal_Entrada IS NOT NULL