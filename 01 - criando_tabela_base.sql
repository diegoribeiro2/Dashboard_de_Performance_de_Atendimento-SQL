USE [Desafio_Elo];
GO

-- criando a tabela fato (histCasosTrabalhados)

CREATE TABLE dbo.histCasosTrabalhados (
    Id_Caso VARCHAR (10),
    País VARCHAR(10),
    Canal_Entrada VARCHAR(50),
    Status VARCHAR(50),
    Resolução VARCHAR(100),
    Motivo_Chamador VARCHAR(200),
    NomeAgen VARCHAR(200),
    NomeSupe VARCHAR(200),
    Data_Hora_Criação DATETIME,
    Data_Hora_Atualização DATETIME,
    Data_Hora_Fechamento DATETIME
)