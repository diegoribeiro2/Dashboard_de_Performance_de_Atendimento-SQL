-- criando a tabela dimCalendario

CREATE TABLE dbo.dimCalendario (
    idCalendario INT IDENTITY(1,1) PRIMARY KEY,
    Data DATE,
    Ano INT,
    Mes INT,
    Dia INT
);

-- inserindos dados na tabela dimCalendario

INSERT INTO dbo.dimCalendario (Data, Ano, Mes, Dia)
SELECT DISTINCT 
    CAST(Data_Hora_Cria��o AS DATE), 
    YEAR(Data_Hora_Cria��o) AS Ano,
    MONTH(Data_Hora_Cria��o) AS Mes,
    DAY(Data_Hora_Cria��o) AS Dia
FROM dbo.histCasosTrabalhados