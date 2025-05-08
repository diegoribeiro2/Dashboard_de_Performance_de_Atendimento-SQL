-- importando os dados da tabela BaseCaso.csv

BULK INSERT dbo.histCasosTrabalhados
FROM 'C:\Users\diego\OneDrive\Área de Trabalho\Case Grupo Elo - BI e MIS\BaseCasos.csv'
WITH (
    FIRSTROW = 2,  -- pulando o cabeçalho
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n',
    CODEPAGE = 'ACP',  -- aceitando acentos e simbolos
    TABLOCK 
)