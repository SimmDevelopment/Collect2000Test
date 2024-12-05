SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spEvaluatePDCs]
AS
BEGIN

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
DECLARE @return_value INT;

DECLARE @NextQueueDate VARCHAR(8)

IF DATEPART(HOUR, GETDATE()) <= 8 
	SET @NextQueueDate = CONVERT(VARCHAR(8),GETDATE(),112)
	ELSE	SET @NextQueueDate = CONVERT(VARCHAR(8),DATEADD(DAY, 1, GETDATE()),112)

PRINT('Populating pending pdcs.')

IF NOT OBJECT_ID('TEMPDB..#Pendingpdcs') IS NULL DROP TABLE #Pendingpdcs


BEGIN TRY

SELECT [PDC].[AcctID] 
	,Max([PDC].[PDConAcct]) AS [PDConAcct]
	,[PDC].[Link] 
	,[PDC].[LinkDriver] 
	,[PDC].[Status] 
	,[PDC].[AcctIsActive]
	,[PDC].[DueDate] 
	,Max([PDC].[Amount]) as [Amount]

INTO #Pendingpdcs
FROM

(

SELECT ISNULL([PDCDetails].[AccountID],[PDC].[Number]) AS [AcctID],
	1 AS [PDConAcct],
	ISNULL([Master].[Link],0) AS [LINK],
	ISNULL([Master].[LinkDriver],0) AS [LINKDRIVER],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[PDC].[Deposit] AS [DueDate],
	SUM([PDC].[Amount]) AS [Amount]
FROM [dbo].[PDC]
LEFT OUTER JOIN [dbo].[PDCDetails] ON [PDCDetails].[PDCID] = [PDC].[Uid]
INNER JOIN [dbo].[master] ON ISNULL([PDCDetails].[AccountID],[PDC].[Number]) = [master].[number]
WHERE [PDC].[Active] = 1
AND [PDC].[OnHold] IS NULL
--AND [PDC].[ApprovedBy] IS NOT NULL
GROUP BY ISNULL([PDCDetails].[AccountID],[PDC].[Number]),[Master].[Link],[Master].[LinkDriver],[Master].[Status],[Master].[Qlevel],[PDC].[Deposit]

UNION

SELECT [Master].[Number] AS [AcctID],
	0 AS [PDConAcct],
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[LinkedPDC].[DueDate] AS [DueDate],
	SUM([LinkedPDC].[Amount]) AS [Amount]

FROM [dbo].[master]

RIGHT OUTER JOIN 

(SELECT [PDC].[Number] AS [AcctID],
	0 AS [PDConAcct],
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[PDC].[Deposit] AS [DueDate],
	SUM([PDC].[Amount]) AS [Amount]

FROM [dbo].[PDC]
INNER JOIN [dbo].[master]
ON [PDC].[Number] = [master].[number]
WHERE [PDC].[Active] = 1
AND [PDC].[OnHold] IS NULL
--AND [PDC].[ApprovedBy] IS NOT NULL
GROUP BY [PDC].[Number],[Master].[Link],[Master].[LinkDriver],[Master].[Status],[Master].[Qlevel],[PDC].[Deposit]
) AS [LinkedPDC]

ON [LinkedPDC].[Link] = [master].[Link]

WHERE [master].[Link] IS NOT NULL
AND	[master].[Link] <> 0

GROUP BY [Master].[Number],[Master].[Link],[Master].[LinkDriver],[Master].[Status],[Master].[Qlevel],[LinkedPDC].[DueDate]

) [PDC]


GROUP BY [PDC].[AcctID],[PDC].[Link],[PDC].[LinkDriver],[PDC].[Status],[PDC].[AcctIsActive],[PDC].[DueDate]


END TRY
BEGIN CATCH
    select * from [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH


PRINT('Reset accounts in PDC status with no PDCs.');

BEGIN TRY

BEGIN TRANSACTION

EXEC	@return_value = [dbo].[RefreshScheduledPaymentCount]

UPDATE m
	SET m.[qlevel]=isnull(spc.qlevel,'011'), 
		m.[status]=ISNULL(spc.status,'ACT'), 
		m.[qdate]=@NextQueueDate
FROM dbo.[master] m JOIN dbo.ScheduledPaymentCount spc ON m.number = spc.AccountID
LEFT OUTER JOIN #Pendingpdcs AS [PendingPDCs]
ON [PendingPDCs].[AcctID] = m.[number]

WHERE  (m.[qlevel] in ('830','018') OR m.[status]='PDC') 
	AND [PendingPDCs].[AcctID] IS NULL
	AND (m.[link] = 0 OR m.[link] IS NULL)


UPDATE m
	SET m.[qlevel]= CASE WHEN m.[linkdriver] = 1 THEN ISNULL(spc.qlevel,'011') ELSE '875' END, 
		m.[status]=ISNULL(spc.status,'ACT'), 
		m.[qdate]=@NextQueueDate
FROM dbo.[master] m JOIN dbo.ScheduledPaymentCount spc ON m.number = spc.AccountID

LEFT OUTER JOIN #PendingPDCs ON m.[link] = #PendingPDCs.[link]

WHERE  (m.[qlevel] in ('830','018') OR m.[status]='PDC') 
	AND #PendingPDCs.[link] IS NULL
	AND (m.[link] <> 0 AND m.[link] IS NOT NULL)

PRINT('Ensure accounts with PDCs are in PDC status ');

UPDATE dbo.[master]
	SET [master].[qlevel] = 
			CASE WHEN [PendingPDCs].[Amount] >=500 THEN '018'
				ELSE '830'
		     END
		,[master].[qdate] = dbo.MakeQDate([PendingPDCs].[DueDate])
		,[master].[status] = 'PDC'
	
FROM dbo.[master]
INNER JOIN #Pendingpdcs AS [PendingPDCs]
ON [PendingPDCs].[AcctID] = [master].[number]

WHERE  ([master].[qlevel] NOT IN ('830','018') OR [master].[status] <> 'PDC') 
	AND ([master].[link] = 0 OR [master].[link] IS NULL)
	AND [master].[qlevel] NOT IN ('998','999','840')
	AND [Master].[status] NOT IN  ('PCC','NPC','NSF')


--Driver and Follower Accounts
UPDATE dbo.[master]
	SET [master].[qlevel] = 
			CASE WHEN #PendingPDCs.[Amount] >=500 AND (#PendingPDCs.[PDConAcct] = 1 OR #PendingPDCs.[LinkDriver] = 1) THEN '018'
				 WHEN #PendingPDCs.[LinkDriver] = 1 then '830' 
				 WHEN #PendingPDCs.[PDConAcct] = 1 THEN '830' ELSE '875' 
		     END
		,[master].[qdate] = dbo.MakeQDate(#PendingPDCs.[DueDate])
		,[master].[status] = 'PDC' 	
		
FROM dbo.[master]

	INNER JOIN #PendingPDCs ON [master].[number] = #PendingPDCs.[AcctID]
	INNER JOIN 
		(select [master].[link],MAX(#Pendingpdcs.[status]) as Status from dbo.master
			join #PendingPDCs on #PendingPDCs.[acctid] = [master].[number]
			where #PendingPDCs.[AcctIsActive] = 1 Group BY [master].[link]) AS [PDC]
		ON [PDC].[link] = [master].[link]

WHERE  (([master].[qlevel] NOT IN ('830','018','875') AND [master].[status] = 'PDC') 
		OR
		[master].[status] <> 'PDC')
	AND ([master].[link] <> 0 AND [master].[link] IS NOT NULL)
	AND [master].[qlevel] NOT IN ('998','999','840','019','012')
	AND [PDC].[status] <= 2


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
