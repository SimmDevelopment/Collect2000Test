SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spEvaluatePCCs]
AS
BEGIN

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @return_value INT;

DECLARE @NextQueueDate VARCHAR(8)

IF DATEPART(HOUR, GETDATE()) <= 8 
	SET @NextQueueDate = CONVERT(VARCHAR(8),GETDATE(),112)
	ELSE	SET @NextQueueDate = CONVERT(VARCHAR(8),DATEADD(DAY, 1, GETDATE()),112)

PRINT('Populating pending pccs.')

IF NOT OBJECT_ID('TEMPDB..#Pendingpccs') IS NULL DROP TABLE #Pendingpccs


BEGIN TRY

SELECT [PCC].[AcctID] 
	,Max([PCC].[PCConAcct]) AS [PCConAcct]
	,[PCC].[Link] 
	,[PCC].[LinkDriver] 
	,[PCC].[Status] 
	,[PCC].[AcctIsActive]
	,[PCC].[DueDate] 
	,Max([PCC].[Amount]) as [Amount]

INTO #Pendingpccs
FROM

(

SELECT ISNULL([PCCDetails].[AccountID],[PCC].[Number]) AS [AcctID],
	1 AS [PCConAcct],
	ISNULL([Master].[Link],0) AS [LINK],
	ISNULL([Master].[LinkDriver],0) AS [LINKDRIVER],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[PCC].[DepositDate] AS [DueDate],
	SUM([PCC].[Amount]) AS [Amount]
FROM [dbo].[DebtorCreditCards] AS [PCC]
LEFT OUTER JOIN [dbo].[Debtorcreditcarddetails] AS [PCCDetails] ON [PCC].[ID] = [PCCDetails].[DebtorcreditcardID]
INNER JOIN [dbo].[master] ON ISNULL([PCCDetails].[AccountID],[PCC].[Number]) = [master].[number]
WHERE [PCC].[IsActive] = 1
AND [PCC].[OnHoldDate] IS NULL
--AND [PCC].[ApprovedBy] IS NOT NULL
GROUP BY ISNULL([PCCDetails].[AccountID],[PCC].[Number]),[Master].[Link],[Master].[LinkDriver],[Master].[Status],[Master].[Qlevel],[PCC].[DepositDate]

UNION

SELECT [Master].[Number] AS [AcctID],
	0 AS [PCConAcct],
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[LinkedPCC].[DueDate] AS [DueDate],
	SUM([LinkedPCC].[Amount]) AS [Amount]

FROM [dbo].[master]

RIGHT OUTER JOIN 

(SELECT [PCC].[Number] AS [AcctID],
	0 as [PCConAcct],
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[PCC].[DepositDate] AS [DueDate],
	SUM([PCC].[Amount]) AS [Amount]

FROM [dbo].[DebtorCreditCards] AS [PCC]
INNER JOIN [dbo].[master]
ON [PCC].[Number] = [master].[number]
WHERE [PCC].[IsActive] = 1
AND [PCC].[OnHoldDate] IS NULL
--AND [PCC].[ApprovedBy] IS NOT NULL
GROUP BY [PCC].[Number],[Master].[Link],[Master].[LinkDriver],[Master].[Status],[Master].[Qlevel],[PCC].[DepositDate]
) AS [LinkedPCC]

ON [LinkedPCC].[Link] = [master].[Link]

WHERE [master].[Link] IS NOT NULL
AND	[master].[Link] <> 0

GROUP BY [Master].[Number],[Master].[Link],[Master].[LinkDriver],[Master].[Status],[Master].[Qlevel],[LinkedPCC].[DueDate]

) [PCC]


GROUP BY [PCC].[AcctID],[PCC].[Link],[PCC].[LinkDriver],[PCC].[Status],[PCC].[AcctIsActive],[PCC].[DueDate]


END TRY
BEGIN CATCH
    select * from [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH


PRINT('Reset accounts in PCC status with no PCCs.');

BEGIN TRY

BEGIN TRANSACTION

EXEC	@return_value = [dbo].[RefreshScheduledPaymentCount]

UPDATE m
	SET m.[qlevel]=isnull(spc.qlevel,'011'), 
		m.[status]=ISNULL(spc.status,'ACT'), 
		m.[qdate]=@NextQueueDate
FROM dbo.[master] m JOIN dbo.ScheduledPaymentCount spc ON m.number = spc.AccountID
LEFT OUTER JOIN #Pendingpccs AS [PendingPCCs]
ON [PendingPCCs].[AcctID] = m.[number]

WHERE  (m.[qlevel] = '840' OR m.[status]='PCC') 
	AND [PendingPCCs].[AcctID] IS NULL
	AND (m.[link] = 0 OR m.[link] IS NULL)


UPDATE m
	SET m.[qlevel]= CASE WHEN m.[linkdriver] = 1 THEN ISNULL(spc.Qlevel,'011') ELSE '875' END, 
		m.[status]= ISNULL(spc.status, 'ACT'), 
		m.[qdate]=@NextQueueDate
FROM dbo.[master] m JOIN dbo.ScheduledPaymentCount spc ON m.number = spc.AccountID

LEFT OUTER JOIN #Pendingpccs ON m.[link] = #Pendingpccs.[link]

WHERE  (m.[qlevel] = '840' OR m.[status]='PCC') 
	AND #Pendingpccs.[link] IS NULL
	AND (m.[link] <> 0 AND m.[link] IS NOT NULL)

PRINT('Ensure accounts with PCCs are in PCC status ');

UPDATE dbo.[master]
	SET [master].[qlevel] = '840'
		,[master].[qdate] = dbo.MakeQDate([PendingPCCs].[DueDate])
		,[master].[status] = 'PCC'
	
FROM dbo.[master]
INNER JOIN #Pendingpccs AS [PendingPCCs]
ON [PendingPCCs].[AcctID] = [master].[number]

WHERE  ([master].[qlevel] <> '840' OR [master].[status] <> 'PCC')
	AND ([master].[link] = 0 OR [master].[link] IS NULL)
	AND [master].[qlevel] NOT IN ('998','999')
	AND [Master].[status] NOT IN  ('NPC','NSF')


--Driver and Follower Accounts
UPDATE dbo.[master]
	SET [master].[qlevel] = 
		 CASE WHEN #Pendingpccs.[LinkDriver] = 1 then '840' 
			  WHEN #Pendingpccs.[PCConAcct] = 1 then '840' 
		 ELSE '875' END
		,[master].[qdate] = dbo.MakeQDate(#Pendingpccs.[DueDate])
		,[master].[status] = 'PCC' 	
FROM dbo.[master]
	INNER JOIN #Pendingpccs ON [master].[number] = #Pendingpccs.[AcctID]
	INNER JOIN 
		(select [master].[link],MAX(#Pendingpccs.[status]) as Status from dbo.master
			join dbo.[debtorcreditcards] on [debtorcreditcards].[number] = [master].[number]
			join #Pendingpccs on #Pendingpccs.[acctid] = [master].[number]
			where #Pendingpccs.[AcctIsActive] = 1 GROUP BY [master].[link]) AS [PCC]
		ON [PCC].[link] = [master].[link]

WHERE  ([master].[qlevel] <> '840' OR [master].[status] <> 'PCC') 
	AND ([master].[link] <> 0 AND [master].[link] IS NOT NULL)
	AND [master].[qlevel] NOT IN ('998','999','019','012')
	AND [PCC].[status] <= 3


END TRY
BEGIN CATCH
    select * from [dbo].[fnGetErrorInfo]()
	ROLLBACK TRANSACTION
	RETURN 1
END CATCH;

COMMIT TRANSACTION;

RETURN 0;

END

GO
