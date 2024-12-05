SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--Changes:
--		10/31/2022 BGM do not change status back to PPA on accounts in VAL or DSP status.


CREATE PROCEDURE [dbo].[spEvaluatePromises]
	@BeginEvaluateDays INTEGER,
	@EndEvaluateDays INTEGER,
	@PaidClientSatisfiesPromise BIT,
	@LogPromiseOperations BIT,
	@AllowPromiseKeptOnDayCreated BIT
AS
	
--This procedure is primarily responsible for breaking unfullfilled promises.  
--In addition, satisfied promises not kept by payment processing will kept by this procedure 
--provided the respective PromiseAppliedAmt on payhistory is not populated.

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @return_value INT;

DECLARE @DueDate DATETIME
DECLARE @NextQueueDate VARCHAR(8)

SET @DueDate=CONVERT(VARCHAR(8),GETDATE(),112)

SET @NextQueueDate = CONVERT(VARCHAR(8),DATEADD(DAY, 1, @DueDate),112)

PRINT('Populating pending promises.')

IF NOT OBJECT_ID('TEMPDB..#Pendingpromises') IS NULL DROP TABLE #Pendingpromises

BEGIN TRY

SELECT [Promises].[ID] as [ID]
	,[Promises].[AcctID] as [AcctID]
	,[Promises].[PromiseOnAcct] as [PromiseOnAcct]
	,[Promises].[Link] as [Link]
	,[Promises].[LinkDriver] as [LinkDriver]
	,[Promises].[Status] as [Status]
	,[Promises].[AcctIsActive] as [AcctIsActive]
	,[Promises].[DueDate] as [DueDate]
	,Max([Promises].[Amount]) as [Amount]
	,[Promises].[Begin] as [Begin]
	,[Promises].[Grace] as [Grace]
	,[Promises].[Today] as [Today]
	,SUM(ISNULL([Payhistory].[Totalpaid],0)) as [Paid]
	,ISNULL([Payhistory].[DatePaid],'19000101') as [DatePaid]
	,CASE
		WHEN SUM(ISNULL([Payhistory].[Totalpaid],0)) >= Max([Promises].[Amount])  THEN 1
		ELSE 0
	 END AS [Kept]
	,CASE
		WHEN SUM(ISNULL([Payhistory].[Totalpaid],0)) > 0 AND SUM(ISNULL([Payhistory].[Totalpaid],0)) < Max([Promises].[Amount]) AND [Grace] <= [Today] THEN 1
		ELSE 0
	 END AS [Short]
	,CASE
		WHEN (SUM(ISNULL([Payhistory].[Totalpaid],0)) = 0 ) AND [Grace] <= [Today] THEN 1
		ELSE 0
	 END AS [Broken]
	,[Promises].[PaymentLinkUID]
	,[Promises].[Created]

INTO #PendingPromises
FROM

(

SELECT [Promises].[ID],
	[Promises].[AcctID] AS [AcctID],
	CASE WHEN [Promises].[AcctID] = ISNULL([PromiseDetails].[AccountID],0) THEN 1 ELSE 0 END AS [PromiseOnAcct], 
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[Promises].[DueDate],
	[Promises].[Amount],
	DATEADD(DAY, -@BeginEvaluateDays, [Promises].[DueDate]) AS [Begin],
	DATEADD(DAY, @EndEvaluateDays, [Promises].[DueDate]) AS [Grace],
	@DueDate AS [Today],
	0 AS [Paid],
	[Promises].[PaymentLinkUID],
	CASE WHEN @AllowPromiseKeptOnDayCreated = 0 THEN [Promises].[Entered] ELSE '19000101' END AS [Created]
FROM [dbo].[Promises]
LEFT OUTER JOIN [dbo].[PromiseDetails] 
ON [Promises].[ID] = [PromiseDetails].[PromiseID]
INNER JOIN [dbo].[master]
ON ISNULL([PromiseDetails].[AccountID],[Promises].[AcctID]) = [master].[number]
WHERE 
([Promises].[Suspended] IS NULL
	OR [Promises].[Suspended] = 0
)
AND [Promises].[Active] = 1
AND ([master].[link] = 0 OR [master].[link] IS NULL) 

UNION

SELECT [LinkedPromises].[ID],
	[Master].[Number] AS [AcctID],
	CASE WHEN [master].[number] = [LinkedPromises].[AcctID] THEN 1 ELSE 0 END [PromiseOnAcct], 
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[LinkedPromises].[DueDate],
	[LinkedPromises].[Amount],
	DATEADD(DAY, -@BeginEvaluateDays, [LinkedPromises].[DueDate]) AS [Begin],
	DATEADD(DAY, @EndEvaluateDays, [LinkedPromises].[DueDate]) AS [Grace],
	@DueDate AS [Today],
	0 AS [Paid],
	[LinkedPromises].[PaymentLinkUID],
	[LinkedPromises].[Created]
FROM [dbo].[master]

RIGHT OUTER JOIN 

(SELECT [Promises].[ID],
	[Promises].[AcctID],
	1 AS 	[PromiseOnAcct], 
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[Promises].[DueDate],
	[Promises].[Amount],
	DATEADD(DAY, -@BeginEvaluateDays, [Promises].[DueDate]) AS [Begin],
	DATEADD(DAY, @EndEvaluateDays, [Promises].[DueDate]) AS [Grace],
	@DueDate AS [Today],
	0 AS [Paid],
	[Promises].[PaymentLinkUID],
	CASE WHEN @AllowPromiseKeptOnDayCreated = 0 THEN [Promises].[Entered] ELSE '19000101' END AS [Created]
FROM [dbo].[Promises]
INNER JOIN [dbo].[master]
ON [Promises].[AcctID] = [master].[number]
WHERE 
([Promises].[Suspended] IS NULL
	OR [Promises].[Suspended] = 0
)
AND [Promises].[Active] = 1
) AS [LinkedPromises]

ON [LinkedPromises].[Link] = [master].[Link]

WHERE [master].[Link] IS NOT NULL
AND	[master].[Link] <> 0

) [Promises]

LEFT OUTER JOIN [dbo].[payhistory]
ON ([payhistory].[number] = [Promises].[AcctID] )
AND [payhistory].[datepaid] BETWEEN [Begin] AND [Grace]
AND [payhistory].[datepaid] > [Promises].[Created] 
AND (
	[payhistory].[batchtype] = 'PU'
	OR (
		[payhistory].[batchtype] = 'PC'
		AND @PaidClientSatisfiesPromise = 1
	)
AND ([payhistory].[PromiseAppliedAmt] IS NULL OR [payhistory].[PromiseAppliedAmt] = 0)
AND ([Promises].[PaymentLinkUID] IS NULL OR [Promises].[PaymentLinkUID] = 0)
AND ([payhistory].[PostDateUID] IS NULL OR [payhistory].[PostDateUID] = 0)
)

GROUP BY [Promises].[ID],[Promises].[AcctID],[Promises].[PaymentLinkUID],[Promises].[Link],[Promises].[PromiseOnAcct],[Promises].[LinkDriver],[Promises].[Status],[Promises].[AcctIsActive],[Promises].[DueDate],[Promises].[Begin],[Promises].[Grace],[Promises].[Today],[Payhistory].[DatePaid],[Promises].[Created]

UNION

SELECT [Promises].[ID] as [ID]
	,[Promises].[AcctID] as [AcctID]
	,[Promises].[PromiseOnAcct] as [PromiseOnAcct]
	,[Promises].[Link] as [Link]
	,[Promises].[LinkDriver] as [LinkDriver]
	,[Promises].[Status] as [Status]
	,[Promises].[AcctIsActive] as [AcctIsActive]
	,[Promises].[DueDate] as [DueDate]
	,Max([Promises].[Amount]) as [Amount]
	,[Promises].[Begin] as [Begin]
	,[Promises].[Grace] as [Grace]
	,[Promises].[Today] as [Today]
	,SUM(ISNULL([Payhistory].[Totalpaid],0)) as [Paid]
	,ISNULL([Payhistory].[DatePaid],'19000101') as [DatePaid]
	,CASE
		WHEN SUM(ISNULL([Payhistory].[Totalpaid],0)) >= Max([Promises].[Amount])  THEN 1
		ELSE 0
	 END AS [Kept]
	,CASE
		WHEN SUM(ISNULL([Payhistory].[Totalpaid],0)) > 0 AND SUM(ISNULL([Payhistory].[Totalpaid],0)) < Max([Promises].[Amount]) AND [Grace] <= [Today] THEN 1
		ELSE 0
	 END AS [Short]
	,CASE
		WHEN (SUM(ISNULL([Payhistory].[Totalpaid],0)) = 0 ) AND [Grace] <= [Today] THEN 1
		ELSE 0
	 END AS [Broken]
	,[Promises].[PaymentLinkUID]
	,[Promises].[Created]

FROM

(

SELECT [Promises].[ID],
	[Promises].[AcctID] AS [AcctID],
	CASE WHEN [Promises].[AcctID] = ISNULL([PromiseDetails].[AccountID],0) THEN 1 ELSE 0 END AS [PromiseOnAcct], 
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[Promises].[DueDate],
	[Promises].[Amount],
	DATEADD(DAY, -@BeginEvaluateDays, [Promises].[DueDate]) AS [Begin],
	DATEADD(DAY, @EndEvaluateDays, [Promises].[DueDate]) AS [Grace],
	@DueDate AS [Today],
	0 AS [Paid],
	[Promises].[PaymentLinkUID],
	CASE WHEN @AllowPromiseKeptOnDayCreated = 0 THEN [Promises].[Entered] ELSE '19000101' END AS [Created]
FROM [dbo].[Promises]
LEFT OUTER JOIN [dbo].[PromiseDetails] 
ON [Promises].[ID] = [PromiseDetails].[PromiseID]
INNER JOIN [dbo].[master]
ON ISNULL([PromiseDetails].[AccountID],[Promises].[AcctID]) = [master].[number]
WHERE 
([Promises].[Suspended] IS NULL
	OR [Promises].[Suspended] = 0
)
AND [Promises].[Active] = 1
AND ([master].[link] = 0 OR [master].[link] IS NULL) 

UNION

SELECT [LinkedPromises].[ID],
	[Master].[Number] AS [AcctID],
	CASE WHEN [master].[number] = [LinkedPromises].[AcctID] THEN 1 ELSE 0 END [PromiseOnAcct], 
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[LinkedPromises].[DueDate],
	[LinkedPromises].[Amount],
	DATEADD(DAY, -@BeginEvaluateDays, [LinkedPromises].[DueDate]) AS [Begin],
	DATEADD(DAY, @EndEvaluateDays, [LinkedPromises].[DueDate]) AS [Grace],
	@DueDate AS [Today],
	0 AS [Paid],
	[LinkedPromises].[PaymentLinkUID],
	[LinkedPromises].[Created]
FROM [dbo].[master]

RIGHT OUTER JOIN 

(SELECT [Promises].[ID],
	[Promises].[AcctID],
	1 AS 	[PromiseOnAcct], 
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[Promises].[DueDate],
	[Promises].[Amount],
	DATEADD(DAY, -@BeginEvaluateDays, [Promises].[DueDate]) AS [Begin],
	DATEADD(DAY, @EndEvaluateDays, [Promises].[DueDate]) AS [Grace],
	@DueDate AS [Today],
	0 AS [Paid],
	[Promises].[PaymentLinkUID],
	CASE WHEN @AllowPromiseKeptOnDayCreated = 0 THEN [Promises].[Entered] ELSE '19000101' END AS [Created]
FROM [dbo].[Promises]
INNER JOIN [dbo].[master]
ON [Promises].[AcctID] = [master].[number]
WHERE 
([Promises].[Suspended] IS NULL
	OR [Promises].[Suspended] = 0
)
AND [Promises].[Active] = 1
) AS [LinkedPromises]

ON [LinkedPromises].[Link] = [master].[Link]

WHERE [master].[Link] IS NOT NULL
AND	[master].[Link] <> 0

) [Promises]

INNER JOIN [dbo].[payhistory]
ON ([payhistory].[PaymentLinkUID] = [Promises].[PaymentLinkUID] )
AND [payhistory].[datepaid] BETWEEN [Begin] AND [Grace] 
AND [payhistory].[datepaid] > [Promises].[Created] 
AND (
	[payhistory].[batchtype] = 'PU'
	OR (
		[payhistory].[batchtype] = 'PC'
		AND @PaidClientSatisfiesPromise = 1
	)
AND ([payhistory].[PromiseAppliedAmt] IS NULL OR [payhistory].[PromiseAppliedAmt] = 0)
and ([payhistory].[PostDateUID] is NULL OR [payhistory].[PostDateUID] = 0)
)

GROUP BY [Promises].[ID],[Promises].[AcctID],[Promises].[PaymentLinkUID],[Promises].[Link],[Promises].[PromiseOnAcct],[Promises].[LinkDriver],[Promises].[Status],[Promises].[AcctIsActive],[Promises].[DueDate],[Promises].[Begin],[Promises].[Grace],[Promises].[Today],[Payhistory].[DatePaid],[Promises].[Created]

END TRY
BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH


BEGIN TRY

BEGIN TRANSACTION

IF EXISTS (SELECT TOP 1 * FROM #PendingPromises) BEGIN
	PRINT('Evaluating broken/short promises')

	-- Set the promise record to inactive and unkept
	UPDATE [dbo].[Promises]
	SET [Kept] = 0,
		[Active] = 0
	FROM [dbo].[Promises]
	INNER JOIN (SELECT [ID],[Broken],[Short] FROM #PendingPromises GROUP BY [ID],[Broken],[Short]) AS [PendingPromises]
	ON [Promises].[ID] = [PendingPromises].[ID]
	WHERE [PendingPromises].[Broken] = 1
	OR [PendingPromises].[Short] = 1
	

	UPDATE [dbo].[Promises]
	SET [Suspended] = 1
--		[Active] = 0
	FROM [dbo].[Promises]
	INNER JOIN #PendingPromises AS [PendingPromises]
		ON [Promises].[AcctID] = [PendingPromises].[AcctID]
	WHERE (
			[PendingPromises].[Broken] = 1
			OR [PendingPromises].[Short] = 1
	)
	AND [Promises].[Active] = 1
	AND (
		[Promises].[Suspended] IS NULL
		OR [Promises].[Suspended] = 0
	)
	AND [Promises].[DueDate] > @DueDate



--update nonlinked and linkdriver accounts - Broken Promise
	
	UPDATE [dbo].[master]
	SET [status] = 'BKN',
		[qlevel] = '010',
		[ShouldQueue] = 1,
		[qdate] = @NextQueueDate,
		[BPDate] = { fn CURDATE() }
	FROM [dbo].[master]
	INNER JOIN #PendingPromises AS [PendingPromises]
	ON [PendingPromises].[Acctid] = [master].[number]

			join (select  acctid,min(duedate) as duedate from #PendingPromises
				  Group BY acctid) AS CurrentBroken
				ON CurrentBroken.acctid = [PendingPromises].acctid
				AND CurrentBroken.duedate = [PendingPromises].duedate

	WHERE (	[PendingPromises].[Broken] = 1
	OR [PendingPromises].[Short] = 1
	)
	AND [PendingPromises].[AcctIsActive] = 1
	AND [PendingPromises].[status] <= 1
	AND [PendingPromises].[link] = 0 
	AND [Master].[Qlevel] NOT IN ('998','999')

	UPDATE [dbo].[master]
	SET [status] = 'BKN',
		[qlevel] = '010',
		[ShouldQueue] = 1,
		[qdate] = @NextQueueDate,
		[BPDate] = { fn CURDATE() }
	FROM [dbo].[master]
	INNER JOIN 
		(SELECT [link],MAX([status]) AS [status]
			FROM #PendingPromises
			WHERE (#PendingPromises.[Broken] = 1
			OR #PendingPromises.[Short] = 1)
			AND #PendingPromises.[AcctIsActive] = 1  
		  GROUP BY [link]) AS [PendingPromises]
	ON [PendingPromises].[link] = [master].[link]
	INNER JOIN #PendingPromises ON [master].[number] = #PendingPromises.[AcctID]

			join (select  acctid,min(duedate) as duedate from #PendingPromises
				  Group BY acctid) AS CurrentBroken
				ON CurrentBroken.acctid = #PendingPromises.acctid
				AND CurrentBroken.duedate = #PendingPromises.duedate

	WHERE #PendingPromises.[AcctIsActive] = 1
	AND [PendingPromises].[status] <= 1
	AND #PendingPromises.[LinkDriver]=1
	AND [Master].[Qlevel] NOT IN ('998','999')


--update follower accounts - Broken Promise

	UPDATE [dbo].[master]
	SET [status] = 'BKN',
		[qlevel] = CASE WHEN #PendingPromises.[PromiseOnAcct] = 1 THEN '010' ELSE '875' END,
		[ShouldQueue] = 0,
		[BPDate] = { fn CURDATE() }
	FROM [dbo].[master]
	INNER JOIN 
		(SELECT [link],MAX([status]) AS [status]
			FROM #PendingPromises
			WHERE (#PendingPromises.[Broken] = 1
			OR #PendingPromises.[Short] = 1)
			AND #PendingPromises.[AcctIsActive] = 1  
		  GROUP BY [link]) AS [PendingPromises]
	ON [PendingPromises].[link] = [master].[link]
	INNER JOIN #PendingPromises ON [master].[number] = #PendingPromises.[AcctID]

			join (select  acctid,min(duedate) as duedate from #PendingPromises
				  Group BY acctid) AS CurrentBroken
				ON CurrentBroken.acctid = #PendingPromises.acctid
				AND CurrentBroken.duedate = #PendingPromises.duedate

	WHERE  [PendingPromises].[status] <= 1
	AND [Master].[LinkDriver] = 0
	AND [Master].[Link] IS NOT NULL 
	AND [Master].[Link] <> 0
	AND [Master].[Qlevel] NOT IN ('998','999')


	INSERT INTO [dbo].[notes] ([number], [user0], [created], [action], [result], [comment])
	SELECT DISTINCT [PendingPromises].[AcctID],
		'SYSTEM' AS [user0],
		GETDATE() AS [created],
		'PROM' AS [action],
		'EVAL' AS [result],
		CASE
			WHEN [PendingPromises].[Broken] = 1 THEN 'Promise for ' + CONVERT(VARCHAR, [PendingPromises].[Amount], 1) + ' due ' + CONVERT(VARCHAR, [PendingPromises].[DueDate], 101) + ' broken'
			WHEN [PendingPromises].[Short] = 1 THEN 'Payment of ' + CONVERT(VARCHAR, [PendingPromises].[Paid], 1) + ' short of ' + CONVERT(VARCHAR, [PendingPromises].[Amount], 1)
		END AS [comment]
	FROM #PendingPromises AS [PendingPromises]
	INNER JOIN [dbo].[Promises] ON [PendingPromises].[ID] = [Promises].[ID]
	WHERE ([PendingPromises].[Broken] = 1
	OR [PendingPromises].[Short] = 1)
	AND [PendingPromises].[PromiseOnAcct] = 1
	

	PRINT('Evaluating kept promises')
	
	UPDATE [dbo].[Promises]
	SET [Kept] = 1,
		[Active] = 0
	FROM [dbo].[Promises]
	INNER JOIN (SELECT [ID], [Kept] FROM #PendingPromises GROUP BY [ID],[Kept]) AS [PendingPromises]
	ON [Promises].[ID] = [PendingPromises].[ID]
	WHERE [PendingPromises].[Kept] = 1
	

--	Update accounts that have no active promises

	UPDATE m
	SET [qlevel] = isnull(spc.qlevel, '013'),
		[status] = isnull(spc.status, 'BKN'),
		[ShouldQueue] = 1,
		[qdate] = @NextQueueDate
	FROM [dbo].[master] m JOIN dbo.ScheduledPaymentCount spc ON m.number = spc.AccountID
	INNER JOIN #PendingPromises AS [PendingPromises]
	ON m.[number] = [PendingPromises].[AcctID]
	AND [PendingPromises].[Kept] = 1
	AND [PendingPromises].[status] <= 1
	AND [PendingPromises].[AcctIsActive] = 1
	AND [PendingPromises].[link] = 0 

			join (select  acctid,min(duedate) as duedate from #PendingPromises
				  group by acctid) AS CurrentKept
				ON CurrentKept.acctid = [PendingPromises].acctid
				AND CurrentKept.duedate = [PendingPromises].duedate

	LEFT OUTER JOIN [dbo].[Promises]
	ON [PendingPromises].[AcctID] = [Promises].[AcctID]
	AND [Promises].[Duedate] > @Duedate
	AND [Promises].[Active]=1
	AND ISNULL([Promises].[Suspended],0)=0
	WHERE [Promises].[AcctID] IS NULL
	AND m.[qlevel] NOT in ('998','999')
	AND m.[link] = 0
	


	UPDATE m
	SET [qlevel] = isnull(spc.qlevel, '013'),
		[status] = isnull(spc.status, 'BKN'),
		[ShouldQueue] = 1,
		[qdate] = @NextQueueDate
	FROM [dbo].[master] m JOIN dbo.ScheduledPaymentCount spc ON m.number = spc.AccountID
	INNER JOIN 
		(SELECT [link],MAX([status]) AS [status]
			FROM #PendingPromises
			WHERE #PendingPromises.[Kept] = 1
			AND #PendingPromises.[AcctIsActive] = 1  
		  GROUP BY [link]) AS [PendingPromises]
	ON [PendingPromises].[link] = m.[link]
	INNER JOIN #PendingPromises ON m.[number] = #PendingPromises.[AcctID]
	LEFT OUTER JOIN 
		(select [master].[link] from dbo.master
			join dbo.[promises] on [promises].[acctid] = [master].[number]
			join #PendingPromises on #PendingPromises.[acctid] = [master].[number]
			and #PendingPromises.[Kept] = 1
			AND #PendingPromises.[AcctIsActive] = 1
			join (select  acctid,min(duedate) as duedate from #PendingPromises
				  group by acctid) AS CurrentKept
				ON CurrentKept.acctid = #PendingPromises.acctid
				AND CurrentKept.duedate = #PendingPromises.duedate

			where promises.active=1 and promises.duedate>@duedate and isnull([promises].[suspended],0)=0
			) AS [PROMISES]
		ON [promises].[link] = m.[link]
	WHERE  [PendingPromises].[status] <= 1
	AND #PendingPromises.[AcctIsActive] = 1
	AND [Promises].[Link] IS NULL
	AND m.[LinkDriver] = 1
	AND m.[Qlevel] NOT IN ('998','999')


	UPDATE m
	SET [qlevel] = '875',
		[status] = isnull(spc.status, 'ACT'),
		[ShouldQueue] = 1,
		[qdate] = @NextQueueDate
	FROM [dbo].[master] m JOIN dbo.ScheduledPaymentCount spc ON m.number = spc.AccountID
	INNER JOIN 
		(SELECT [link],MAX([status]) AS [status]
			FROM #PendingPromises
			WHERE #PendingPromises.[Kept] = 1
			AND #PendingPromises.[AcctIsActive] = 1  
		  GROUP BY [link]) AS [PendingPromises]
	ON [PendingPromises].[link] = m.[link]
	INNER JOIN #PendingPromises ON m.[number] = #PendingPromises.[AcctID]
	LEFT OUTER JOIN 
		(select [master].[link] from dbo.master
			join dbo.[promises] on [promises].[acctid] = [master].[number]
			join #PendingPromises on #PendingPromises.[acctid] = [master].[number]
			and #PendingPromises.[Kept] = 1
			AND #PendingPromises.[AcctIsActive] = 1
			join (select  acctid,min(duedate) as duedate from #PendingPromises
				  group by acctid) AS CurrentKept
				ON CurrentKept.acctid = #PendingPromises.acctid
				AND CurrentKept.duedate = #PendingPromises.duedate

			where promises.active=1 and promises.duedate>@duedate and isnull([promises].[suspended],0)=0
			) AS [PROMISES]
		ON [promises].[link] = m.[link]
	WHERE  [PendingPromises].[status] <= 1
	AND #PendingPromises.[AcctIsActive] = 1
	AND [Promises].[Link] IS NULL
	AND m.[LinkDriver] = 0
	AND m.[Link] IS NOT NULL 
	AND m.[Link] <> 0
	AND m.[Qlevel] NOT IN ('998','999')
 


	-- Update accounts - active promises, none of which are suspended

	UPDATE [dbo].[master]
	SET [qlevel] = '820',
		[status] = 'PPA',
		[ShouldQueue] = 0
	FROM [dbo].[master]
	INNER JOIN #PendingPromises AS [PendingPromises]
	ON [master].[number] = [PendingPromises].[AcctID]
	AND [PendingPromises].[Kept] = 1
	AND [PendingPromises].[AcctIsActive] = 1
	AND [PendingPromises].[link] = 0 
 	AND [PendingPromises].[status] <= 1

			join (select  acctid,min(duedate) as duedate from #PendingPromises
				  group by acctid) AS CurrentKept
				ON CurrentKept.acctid = [PendingPromises].acctid
				AND CurrentKept.duedate = [PendingPromises].duedate

	INNER JOIN [dbo].[Promises]
	ON [Master].[Number] = [promises].[AcctID]
	WHERE [Promises].[Duedate] > @DueDate
	AND [Promises].[Active] = 1
	AND ISNULL([Promises].[Suspended],0) = 0
	AND [Master].[Qlevel] NOT IN ('998','999')
--Added 10/31/2022 BGM to not change status on accounts in VAL or DSP status for US Bank.
AND [master].[status] NOT IN ('VAL', 'DSP')

	UPDATE [dbo].[master]
	SET [qlevel] = '820',
		[status] = 'PPA',
		[ShouldQueue] = 0
	FROM [dbo].[master]
	INNER JOIN #PendingPromises ON [master].[number] = #PendingPromises.[AcctID]
	INNER JOIN 
		(select [master].[link],Max(#PendingPromises.[Status]) AS Status from dbo.master
			join dbo.[promises] on [promises].[acctid] = [master].[number]
			join #PendingPromises on #PendingPromises.[acctid] = [master].[number]
			and #PendingPromises.[Kept] = 1
			AND #PendingPromises.[AcctIsActive] = 1

			join (select  acctid,min(duedate) as duedate from #PendingPromises
				  group by acctid) AS CurrentKept
				ON CurrentKept.acctid = #PendingPromises.acctid
				AND CurrentKept.duedate = #PendingPromises.duedate


			where promises.active=1 and promises.duedate>@duedate and isnull([promises].[suspended],0)=0
			 Group BY [master].[link]) AS [PROMISES]
		ON [promises].[link] = [master].[link]
	WHERE  [Promises].[status] <= 1
	AND [Master].[Qlevel] NOT IN ('998','999')
	AND [Master].[LinkDriver] = 1
--Added 10/31/2022 BGM to not change status on accounts in VAL or DSP status for US Bank.
AND [master].[status] NOT IN ('VAL', 'DSP')


	--update follower accounts - active promises, none of which are suspended
	--820 for accounts with explicit promise
	--875 for followers without explicit promises

	UPDATE [dbo].[master]
	SET [qlevel] = CASE WHEN [Promises].[AccountID] IS NOT NULL THEN '820' ELSE '875' END,
		[status] = 'PPA',
		[ShouldQueue] = 0
	FROM [dbo].[master]
	INNER JOIN #PendingPromises ON [master].[number] = #PendingPromises.[AcctID]
	INNER JOIN 
		(select [master].[link],MAX(#PendingPromises.[status]) as Status from dbo.master
			join #PendingPromises on #PendingPromises.[acctid] = [master].[number]
			and #PendingPromises.[Kept] = 1
			AND #PendingPromises.[AcctIsActive] = 1 

			join (select  acctid,min(duedate) as duedate from #PendingPromises
				  group by acctid) AS CurrentKept
				ON CurrentKept.acctid = #PendingPromises.acctid
				AND CurrentKept.duedate = #PendingPromises.duedate


			GROUP BY [Master].[link]) AS [KeptPromises]
		ON [KeptPromises].[link] = [master].[link]
		
	INNER JOIN 

	(SELECT [Promisedetails].[AccountID],[Promises].[Active],[Promises].[DueDate],[Promises].[Suspended]
		FROM dbo.[promises]
		INNER JOIN dbo.PromiseDetails ON [Promises].[ID] = [promisedetails].[PromiseID]) AS Promises
		ON Promises.AccountID = [Master].[number]
		AND promises.active=1 
		AND promises.duedate>@duedate 
		AND ISNULL([promises].[suspended],0)=0

	WHERE  [KeptPromises].[status] <= 1
	AND [Master].[LinkDriver] = 0
	AND [Master].[Link] IS NOT NULL 
	AND [Master].[Link] <> 0
	AND [Master].[Qlevel] NOT IN ('998','999')
--Added 10/31/2022 BGM to not change status on accounts in VAL or DSP status for US Bank.
AND [master].[status] NOT IN ('VAL', 'DSP')


			
	INSERT INTO [dbo].[notes] ([number], [user0], [created], [action], [result], [comment])
	SELECT DISTINCT [PendingPromises].[AcctID],
		'SYSTEM' AS [user0],
		GETDATE() AS [created],
		'PROM' AS [action],
		'EVAL' AS [result],
		'Promise for ' + CONVERT(VARCHAR, [PendingPromises].[Amount], 1) + ' due ' + CONVERT(VARCHAR, [PendingPromises].[DueDate], 101) + ' satisfied' AS [comment]
	FROM #PendingPromises AS [PendingPromises]
	INNER JOIN [dbo].[Promises] ON [PendingPromises].[ID] = [Promises].[ID]
	WHERE [PendingPromises].[Kept] = 1
	AND [PendingPromises].[Amount] > 0
	AND [PendingPromises].[PromiseOnAcct] =1 


	IF @LogPromiseOperations = 1 BEGIN
		PRINT 'Logging promise results'
		
		IF NOT EXISTS (SELECT * FROM [dbo].[sysobjects] WHERE [id] = OBJECT_ID(N'dbo.PromiseLog') AND OBJECTPROPERTY([id], N'IsUserTable') = 1) BEGIN
			SELECT [PendingPromises].[ID],
				[PendingPromises].[DueDate],
				[PendingPromises].[Amount],
				[PendingPromises].[Kept]
			INTO [dbo].[PromiseLog]
			FROM #PendingPromises AS [PendingPromises]
			INNER JOIN [dbo].[Promises] ON [PendingPromises].[ID] = [Promises].[ID] AND [PendingPromises].[AcctID] = [Promises].[AcctID]
			WHERE ([PendingPromises].[Kept] = 1
			OR [PendingPromises].[Short] = 1
			OR [PendingPromises].[Broken] = 1)
			AND [PendingPromises].[Amount] > 0
			AND [PendingPromises].[PromiseOnAcct] = 1

		END
		ELSE BEGIN
			INSERT INTO [dbo].[PromiseLog] ([ID], [DueDate], [Amount], [Kept])
			SELECT [PendingPromises].[ID],
				[PendingPromises].[DueDate],
				[PendingPromises].[Amount],
				[PendingPromises].[Kept]
			FROM #PendingPromises AS [PendingPromises]
			INNER JOIN [dbo].[Promises] ON [PendingPromises].[ID] = [Promises].[ID] AND [PendingPromises].[AcctID] = [Promises].[AcctID]
			WHERE ([PendingPromises].[Kept] = 1
			OR [PendingPromises].[Short] = 1
			OR [PendingPromises].[Broken] = 1)
			AND [PendingPromises].[Amount] > 0
			AND [PendingPromises].[PromiseOnAcct] = 1

		END
	END



	UPDATE [dbo].[Payhistory]
	SET [PromiseAppliedAmt] = [payhistory].[totalpaid]
	FROM #PendingPromises [PendingPromises]
	INNER JOIN [dbo].[Payhistory] ON [PendingPromises].[PaymentLinkUID] = [payhistory].[PaymentLinkUID]
	AND [PendingPromises].[AcctID] = [payhistory].[number]
	WHERE [PendingPromises].[Kept] = 1
	AND ([payhistory].[BatchType]  = 'PU'
		OR (
			[payhistory].[batchtype] = 'PC'
			AND @PaidClientSatisfiesPromise = 1)
		)
	AND ([payhistory].[PromiseAppliedAmt] = 0 OR [payhistory].[PromiseAppliedAmt] IS NULL)

	UPDATE [dbo].[Payhistory]
	SET [PromiseAppliedAmt] = [payhistory].[totalpaid]
	FROM #PendingPromises [PendingPromises]
	INNER JOIN [dbo].[Payhistory] ON [PendingPromises].[AcctID] = [payhistory].[number]
	AND [PendingPromises].[DatePaid] = [payhistory].[datepaid]
	WHERE [PendingPromises].[Kept] = 1 AND ([PendingPromises].[PaymentLinkUID] IS NULL OR [PendingPromises].[PaymentLinkUID] = 0)
	AND ([payhistory].[BatchType]  = 'PU'
		OR (
			[payhistory].[batchtype] = 'PC'
			AND @PaidClientSatisfiesPromise = 1)
		)
	AND ([payhistory].[PromiseAppliedAmt] = 0 OR [payhistory].[PromiseAppliedAmt] IS NULL)
		

END

COMMIT TRANSACTION

END TRY
BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	ROLLBACK TRANSACTION
	RETURN 1
END CATCH;

--Scrub all accounts for proper PPA Status and Qlevel:
--This part of the procedure will not consider the promise evaluation date range, it will only look at future promises
--and correct the account status and qlevel of any accounts that qualify
 
 
IF NOT OBJECT_ID('TEMPDB..#FuturePromises') IS NULL  DROP TABLE #FuturePromises

BEGIN TRY

SELECT [Promises].[ID] as [ID]
	,[Promises].[AcctID] as [AcctID]
	,[Promises].[PromiseOnAcct] as [PromiseOnAcct]
	,[Promises].[Link] as [Link]
	,[Promises].[LinkDriver] as [LinkDriver]
	,[Promises].[Status] as [Status]
	,[Promises].[AcctIsActive] as [AcctIsActive]
	,[Promises].[DueDate] as [DueDate]
	,[promises].[status] as [currentstatus]

INTO #FuturePromises
FROM

(

SELECT [Promises].[ID],
	ISNULL([PromiseDetails].[AccountID],[Promises].[AcctID]) AS [AcctID],
	CASE WHEN [Promises].[AcctID] = ISNULL([PromiseDetails].[AccountID],0) THEN 1 ELSE 0 END AS [PromiseOnAcct], 
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[Promises].[DueDate],
	@DueDate AS [Today],
	[master].[status] as [currentstatus]

FROM [dbo].[Promises]
LEFT OUTER JOIN [dbo].[PromiseDetails] 
ON [Promises].[ID] = [PromiseDetails].[PromiseID]
INNER JOIN [dbo].[master]
ON ISNULL([PromiseDetails].[AccountID],[Promises].[AcctID]) = [master].[number]
WHERE [Promises].[DueDate] >= @DueDate
AND ([Promises].[Suspended] IS NULL
	OR [Promises].[Suspended] = 0
)
AND [Promises].[Active] = 1
--Added 10/31/2022 BGM to not change status on accounts in VAL or DSP status.
AND [master].[status] NOT IN ('VAL', 'DSP')

UNION

SELECT [LinkedPromises].[ID],
	[Master].[Number] AS [AcctID],
	CASE WHEN [master].[number] = [LinkedPromises].[AcctID] THEN 1 ELSE 0 END [PromiseOnAcct], 
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[LinkedPromises].[DueDate],
	@DueDate AS [Today],
	[master].[status] as [currentstatus]

FROM [dbo].[master]

RIGHT OUTER JOIN 

(SELECT [Promises].[ID],
	[Promises].[AcctID],
	1 as 	[PromiseOnAcct], 
	ISNULL([Master].[Link],0) AS [Link],
	ISNULL([Master].[LinkDriver],0) AS [LinkDriver],
	CASE WHEN [Master].[Status] = 'NPC' THEN 5
		 WHEN [Master].[Status] = 'NSF' THEN 4
		 WHEN [Master].[Status] = 'PCC' THEN 3
		 WHEN [Master].[Status] = 'PDC' THEN 2
		 WHEN [Master].[Status] = 'PPA' THEN 1
	ELSE 0 END AS [Status],
	CASE WHEN [Master].[Qlevel] in ('998','999') THEN 0 ELSE 1 END AS [AcctIsActive],
	[Promises].[DueDate],
	@DueDate AS [Today],
	[master].[status] as [currentstatus]

FROM [dbo].[Promises]
INNER JOIN [dbo].[master]
ON [Promises].[AcctID] = [master].[number]
WHERE [Promises].[DueDate] >= @DueDate
AND ([Promises].[Suspended] IS NULL
	OR [Promises].[Suspended] = 0
)
AND [Promises].[Active] = 1
) AS [LinkedPromises]

ON [LinkedPromises].[Link] = [master].[Link]

WHERE [master].[Link] IS NOT NULL
AND	[master].[Link] <> 0
--Added 10/31/2022 BGM to not change status on accounts in VAL or DSP status.
AND [master].[status] NOT IN ('VAL', 'DSP') 

) [Promises]


GROUP BY [Promises].[ID],[Promises].[AcctID],[Promises].[Link],[Promises].[PromiseOnAcct],[Promises].[LinkDriver],[Promises].[Status],[Promises].[AcctIsActive],[Promises].[DueDate],[promises].[currentstatus]


END TRY
BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH

BEGIN TRY

BEGIN TRANSACTION
--accounts in ppa status that should not be 
UPDATE master SET status = 'ACT', 
	qlevel=CASE WHEN link IS NULL OR link = 0 THEN '599'
				WHEN link IS NOT NULL AND link>0 AND linkdriver = 1 THEN '599'
				ELSE '875'
		   END
WHERE (status = ('ppa') OR qlevel = '820') 
AND number NOT IN (SELECT acctid FROM #FuturePromises)
AND qlevel not in ('998','999')

--accounts not in ppa status/correct qlevel that should 
UPDATE master SET status = 'PPA',
	qlevel=CASE WHEN link IS NULL OR link = 0 THEN '820'
				WHEN link IS NOT NULL AND link>0 AND linkdriver = 1 THEN '820'
				ELSE '875'
		   END
WHERE (status NOT IN ('ppa','pdc','pcc','pif','sif', 'dis', 'uhd', 'mhd', 'nhd', 'rhd', 'whd', 'whl') OR qlevel NOT IN ('820','830','840')) 
AND number IN  (SELECT acctid FROM #FuturePromises) 
AND qlevel NOT IN ('998','999')

COMMIT TRANSACTION

END TRY
BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	ROLLBACK TRANSACTION
	RETURN 1
END CATCH;

RETURN 0

GO
