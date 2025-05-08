CREATE PROCEDURE dbo.sp_Atualizar_DW_Casos
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- 1. Atualizar tabelas de dimensões
        -- DimCalendario (atualização incremental)
        INSERT INTO dbo.dimCalendario (Data, Ano, Mes, Dia)
        SELECT DISTINCT
            CAST(h.Data_Hora_Criacao AS DATE) AS Data,
            YEAR(h.Data_Hora_Criacao) AS Ano,
            MONTH(h.Data_Hora_Criacao) AS Mes,
            DAY(h.Data_Hora_Criacao) AS Dia
        FROM dbo.HistCasosTrabalhados h
        LEFT JOIN dbo.dimCalendario c ON CAST(h.Data_Hora_Criacao AS DATE) = c.Data
        WHERE c.idCalendario IS NULL
        AND h.Data_Hora_Criacao IS NOT NULL;
        
        -- DimCanalEntrada
        MERGE INTO dbo.dimCanalEntrada AS target
        USING (
            SELECT DISTINCT Canal_Entrada
            FROM dbo.HistCasosTrabalhados
            WHERE Canal_Entrada IS NOT NULL
        ) AS source
        ON target.Canal_Entrada = source.Canal_Entrada
        WHEN NOT MATCHED THEN
            INSERT (Canal_Entrada) VALUES (source.Canal_Entrada);
        
        -- DimFuncionario
        MERGE INTO dbo.dimFuncionario AS target
        USING (
            SELECT DISTINCT NomeAgen
            FROM dbo.HistCasosTrabalhados
            WHERE NomeAgen IS NOT NULL
        ) AS source
        ON target.NomeAgen = source.NomeAgen
        WHEN NOT MATCHED THEN
            INSERT (NomeAgen) VALUES (source.NomeAgen);
        
        -- DimMotiChamador
        MERGE INTO dbo.dimMotiChamador AS target
        USING (
            SELECT DISTINCT Motivo_Chamador
            FROM dbo.HistCasosTrabalhados
            WHERE Motivo_Chamador IS NOT NULL
        ) AS source
        ON target.Motivo_Chamador = source.Motivo_Chamador
        WHEN NOT MATCHED THEN
            INSERT (Motivo_Chamador) VALUES (source.Motivo_Chamador);
        
        -- DimPais
        MERGE INTO dbo.dimPais AS target
        USING (
            SELECT DISTINCT País
            FROM dbo.HistCasosTrabalhados
            WHERE País IS NOT NULL
        ) AS source
        ON target.País = source.País
        WHEN NOT MATCHED THEN
            INSERT (País) VALUES (source.País);
        
        -- DimStatus
        MERGE INTO dbo.dimStatus AS target
        USING (
            SELECT DISTINCT Status
            FROM dbo.HistCasosTrabalhados
            WHERE Status IS NOT NULL
        ) AS source
        ON target.Status = source.Status
        WHEN NOT MATCHED THEN
            INSERT (Status) VALUES (source.Status);
        
        -- DimSupervisor
        MERGE INTO dbo.dimSupervisor AS target
        USING (
            SELECT DISTINCT NomeSupe
            FROM dbo.HistCasosTrabalhados
            WHERE NomeSupe IS NOT NULL
        ) AS source
        ON target.NomeSupe = source.NomeSupe
        WHEN NOT MATCHED THEN
            INSERT (NomeSupe) VALUES (source.NomeSupe);
        
        -- 2. Atualizar tabela fato (carga completa)
        TRUNCATE TABLE dbo.fatoCasos;
        
        INSERT INTO dbo.fatoCasos (
            Data, Funcionario, Supervisor, MotiChamador, Status,
            CanalEntrada, Pais, ResolucaoPercentual, TotalCasosFechados,
            TotalCasosAbertos, TempoMedioAtualizacaoHoras, TempoMedioFechamentoHoras, ID_Fato
        )
        SELECT
            c.idCalendario AS Data,
            f.idFuncionario AS Funcionario,
            s.idSupervisor AS Supervisor,
            m.idMotivo AS MotiChamador,
            st.idStatus AS Status,
            ce.idCanalEntrada AS CanalEntrada,
            p.idPais AS Pais,
            CAST(100.0 * SUM(CASE WHEN h.Resolução = 'Yes' THEN 1 ELSE 0 END) / 
                NULLIF(SUM(CASE WHEN h.Resolução IN ('Yes', 'No') THEN 1 ELSE 0 END), 0) AS DECIMAL(5,2)) AS ResolucaoPercentual,
            SUM(CASE WHEN h.Status = 'Done' THEN 1 ELSE 0 END) AS TotalCasosFechados,
            SUM(CASE WHEN h.Status != 'Done' THEN 1 ELSE 0 END) AS TotalCasosAbertos,
            AVG(DATEDIFF(MINUTE, h.Data_Hora_Criação, h.Data_Hora_Atualização) / 60.0 AS TempoMedioAtualizacaoHoras,
            AVG(CASE 
                WHEN h.Data_Hora_Fechamento > h.Data_Hora_Criação THEN
                    DATEDIFF(MINUTE, h.Data_Hora_Criação, h.Data_Hora_Fechamento) / 60.0
                ELSE NULL
            END) AS TempoMedioFechamentoHoras,
            NEWID() AS ID_Fato
        FROM dbo.HistCasosTrabalhados h
        JOIN dbo.dimCalendario c ON CAST(h.Data_Hora_Criacao AS DATE) = c.Data
        JOIN dbo.dimFuncionario f ON h.NomeAgen = f.NomeAgen
        JOIN dbo.dimSupervisor s ON h.NomeSupe = s.NomeSupe
        JOIN dbo.dimMotiChamador m ON h.Motivo_Chamador = m.Motivo_Chamador
        JOIN dbo.dimStatus st ON h.Status = st.Status
        JOIN dbo.dimCanalEntrada ce ON h.Canal_Entrada = ce.Canal_Entrada
        JOIN dbo.dimPais p ON h.País = p.País
        GROUP BY
            c.idCalendario,
            f.idFuncionario,
            s.idSupervisor,
            m.idMotivo,
            st.idStatus,
            ce.idCanalEntrada,
            p.idPais;
        
        COMMIT TRANSACTION;
        
        -- Log de sucesso
        INSERT INTO dbo.LogProcessamento (Processo, DataHora, Status, Mensagem)
        VALUES ('sp_Atualizar_DW_Casos', GETDATE(), 'Sucesso', 'Atualização concluída com sucesso');
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Log de erro
        INSERT INTO dbo.LogProcessamento (Processo, DataHora, Status, Mensagem)
        VALUES ('sp_Atualizar_DW_Casos', GETDATE(), 'Erro', 
                'Erro: ' + ERROR_MESSAGE() + ' | Linha: ' + CAST(ERROR_LINE() AS VARCHAR));
        
        -- Retornar informações do erro
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH;
END;