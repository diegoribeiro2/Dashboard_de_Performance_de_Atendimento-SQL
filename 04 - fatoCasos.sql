-- criando a tabela fatoCasos

CREATE TABLE fatoCasos (
   Data DATE,
   Funcionario VARCHAR(100),
   Supervisor VARCHAR(100), 
   MotiChamador VARCHAR(100),
   Status VARCHAR(100),        
   CanalEntrada VARCHAR(100), 
   Pais VARCHAR(100),         
   ResolucaoPercentual FLOAT,
   TotalCasosFechados INT,
   TotalCasosAbertos INT,
   TempoMedioAtualizacaoHoras FLOAT,
   TempoMedioFechamentoHoras FLOAT,
   ID_Fato INT IDENTITY(1,1) PRIMARY KEY 
);

--inserindo os dados na tabela fatoDados

INSERT INTO fatoCasos (
    Data, 
    Funcionario, 
    Supervisor, 
    MotiChamador, 
    Status, 
    CanalEntrada, 
    Pais, 
    ResolucaoPercentual, 
    TotalCasosFechados, 
    TotalCasosAbertos, 
    TempoMedioAtualizacaoHoras, 
    TempoMedioFechamentoHoras
)
SELECT
    c.Data, 
    f.NomeAgen, 
    s.NomeSupe, 
    COALESCE(m.Motivo_Chamador, 'N/A') AS MotiChamador,
    st.Status, 
    ca.Canal_Entrada, 
    COALESCE(p.País, 'N/A') AS País,
    COALESCE(
        CASE 
            WHEN SUM(CASE WHEN h.Resolução IN ('Yes', 'No') THEN 1 ELSE 0 END) = 0 THEN 0
            ELSE SUM(CASE WHEN h.Resolução = 'Yes' THEN 1 ELSE 0 END) * 100.0 
                / NULLIF(SUM(CASE WHEN h.Resolução IN ('Yes', 'No') THEN 1 ELSE 0 END), 0)
        END,
        0
    ) AS ResolucaoPercentual,
    SUM(CASE WHEN h.Status = 'Done' THEN 1 ELSE 0 END) AS TotalCasosFechados,
    SUM(CASE WHEN h.Status <> 'Done' THEN 1 ELSE 0 END) AS TotalCasosAbertos,
    AVG(ABS(DATEDIFF(MINUTE, h.Data_Hora_Criação, h.Data_Hora_Atualização)) / 60.0) AS TempoMedioAtualizacaoHoras,
    AVG(CASE 
            WHEN h.Data_Hora_Fechamento > h.Data_Hora_Criação THEN
                DATEDIFF(MINUTE, h.Data_Hora_Criação, h.Data_Hora_Fechamento) / 60.0 
            ELSE NULL
        END) AS TempoMedioFechamentoHoras
FROM histCasosTrabalhados h

LEFT JOIN dimCalendario c ON CAST(h.Data_Hora_Criação AS DATE) = c.Data
LEFT JOIN dimFuncionario f ON h.NomeAgen = f.NomeAgen
LEFT JOIN dimSupervisor s ON h.NomeSupe = s.NomeSupe
LEFT JOIN dimMotiChamador m ON h.Motivo_Chamador = m.Motivo_Chamador
LEFT JOIN dimStatus st ON h.Status = st.Status
LEFT JOIN dimCanalEntrada ca ON h.Canal_Entrada = ca.Canal_Entrada
LEFT JOIN dimPais p ON h.País = p.País

GROUP BY 
    c.Data, 
    f.NomeAgen, 
    s.NomeSupe, 
    COALESCE(m.Motivo_Chamador, 'N/A'), 
    st.Status, 
    ca.Canal_Entrada, 
    COALESCE(p.País, 'N/A');