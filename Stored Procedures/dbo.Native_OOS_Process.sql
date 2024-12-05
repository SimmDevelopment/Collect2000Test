SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Native_OOS_Process]
	@OnlyConsiderLastPaid BIT = 0
AS
BEGIN

	CREATE TABLE #temp
	(
		number INT,
		StartDate DATETIME,
		ColumnName VARCHAR(30),
		customer VARCHAR(7),
		[State] VARCHAR(3)
	)

	INSERT INTO #temp
	SELECT m.number, cc.JudgementDate [StartDate], 'Judgment Date' [ColumnName], m.customer, m.[State]
	FROM #WorkFlowAcct w
	INNER JOIN master m
	ON w.AccountID = m.number
	INNER JOIN CourtCases cc
	ON cc.AccountID = m.number
	WHERE m.customer NOT IN ('0002337', '0002338', '0002366', '0001759') AND cc.JudgementDate IS NOT NULL AND @OnlyConsiderLastPaid = 0

	INSERT INTO #temp
	SELECT *
	FROM (
		SELECT m.number, m.lastpaid [StartDate], 'Last Paid Date' [ColumnName], m.customer, m.[State]
		FROM dbo.[master] m
		INNER JOIN #WorkFlowAcct
		ON AccountID = m.number
		WHERE m.customer NOT IN ('0002337', '0002338', '0002366') AND m.lastpaid IS NOT NULL
		UNION ALL
		SELECT m.number, CASE WHEN m.[State] = 'NY' THEN DATEADD(MONTH, 3, m.ChargeOffDate) ELSE m.ChargeOffDate END [StartDate], 'Charge Off Date' [ColumnName], m.customer, m.[State]
		FROM dbo.[master] m
		INNER JOIN #WorkFlowAcct
		ON AccountID = m.number
		WHERE @OnlyConsiderLastPaid = 0 AND m.ChargeOffDate IS NOT NULL AND m.customer <> '0001759'
		UNION ALL
		SELECT m.number, m.clidlp [StartDate], 'Client Date Last Paid' [ColumnName], m.customer, m.[State]
		FROM dbo.[master] m
		INNER JOIN #WorkFlowAcct
		ON AccountID = m.number
		WHERE @OnlyConsiderLastPaid = 0 AND m.customer NOT IN ('0002337', '0002338', '0002366', '0001759') AND m.clidlp IS NOT NULL AND m.clidlp <> '1900-01-01 00:00:00.000'
		UNION ALL
		SELECT m.number, m.ContractDate [StartDate], 'Contract Date' [ColumnName], m.customer, m.[State]
		FROM dbo.[master] m
		INNER JOIN #WorkFlowAcct
		ON AccountID = m.number
		WHERE @OnlyConsiderLastPaid = 0 AND m.customer NOT IN ('0002337', '0002338', '0002366', '0001759') AND m.ContractDate IS NOT NULL
		UNION ALL
		SELECT m.number, m.Delinquencydate [StartDate], 'Delinquency Date' [ColumnName], m.customer, m.[State]
		FROM dbo.[master] m
		INNER JOIN #WorkFlowAcct
		ON AccountID = m.number
		WHERE @OnlyConsiderLastPaid = 0 AND m.customer NOT IN ('0002337', '0002338', '0002366') AND m.Delinquencydate IS NOT NULL
	) x
	WHERE x.number NOT IN (SELECT number from #temp)

	DECLARE @workflowid UNIQUEIDENTIFIER = (SELECT ID from WorkFlows WHERE Name = 'OOS Process')
	
	SELECT x.number
		,x.StartDate
		,t.ColumnName
		,DATEADD(YEAR, COALESCE(ov.Years, s.Years), x.StartDate) [OOSDate]
		,CAST((CASE WHEN DATEADD(YEAR, COALESCE(ov.Years, s.Years), x.StartDate) <= GETDATE() THEN 1 ELSE 0 END) AS BIT) [IsOOS]
		,cob.COB
		,ooscob.OOSTypeId
		,t.[State]
		,GETDATE() [DateCalculated]
		,(SELECT TOP 1 EventName FROM WorkFlow_EventHistory WHERE AccountID = x.number AND WorkFlowID = @workflowid ORDER BY Occurred DESC) [WorkflowTrigger]
	INTO #history
	FROM (
		SELECT number, MAX(StartDate) [StartDate]
		FROM #temp
		GROUP BY number
	) x
	INNER JOIN #temp t
	ON t.number = x.number
	AND t.StartDate = x.StartDate
	INNER JOIN vCustomerCOB cob
	ON cob.customer = t.customer
	INNER JOIN Native_OOS_COBs ooscob
	ON ooscob.COB = cob.COB
	INNER JOIN Native_OOS_Types oost
	ON oost.Id = ooscob.OOSTypeId
	INNER JOIN Native_OOS_States s
	ON s.[State] = t.[State]
	AND s.OOSTypeId = oost.Id
	LEFT OUTER JOIN Native_OOS_CustOverride ov
	ON ov.customer = t.customer
	AND (ov.[State] = t.[State] OR ov.[State] IS NULL)

	UPDATE oos
	SET OOSDate = h.OOSDate
	FROM Native_OOS_Accounts oos
	INNER JOIN #history h
	ON h.number = oos.number

	IF @OnlyConsiderLastPaid = 0
	BEGIN
		INSERT INTO Native_OOS_Accounts (number, OOSDate)
		SELECT DISTINCT h.number, h.OOSDate
		FROM #history h
		LEFT OUTER JOIN Native_OOS_Accounts acc
		ON acc.number = h.number
		WHERE acc.OOSDate IS NULL
	END

	--MERGE dbo.Native_OOS_Accounts AS TARGET
	--USING #history AS SOURCE
	--ON TARGET.number = SOURCE.number
	--WHEN MATCHED THEN UPDATE SET TARGET.OOSDate = SOURCE.OOSDate
	--WHEN NOT MATCHED BY TARGET THEN INSERT (number, OOSDate) VALUES (SOURCE.number, SOURCE.OOSDate);

	INSERT INTO Native_OOS_AccountHistory
	SELECT * FROM #history

	DROP TABLE #temp
	DROP TABLE #history

END
GO
