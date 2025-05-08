-- importando os dados da tabela BaseCaso.csv

BULK INSERT dbo.histCasosTrabalhados
FROM 'C:\Users\diego\OneDrive\�rea de Trabalho\Case Grupo Elo - BI e MIS\BaseCasos.csv'
WITH (
    FIRSTROW = 2,  -- pulando o cabe�alho
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    CODEPAGE = 'ACP',  -- aceitando acentos e simbolos
    TABLOCK 
)