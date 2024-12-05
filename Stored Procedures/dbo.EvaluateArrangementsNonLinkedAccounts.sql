SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[EvaluateArrangementsNonLinkedAccounts]

AS 
BEGIN
	SET NOCOUNT ON;
	
	TRUNCATE TABLE [dbo].[AccountAndArrangementIds];
	
	DECLARE @today DATETIME;
	SELECT @today = CAST({ fn CURDATE() } AS DATETIME);
	
	INSERT INTO [dbo].[AccountAndArrangementIds]([AccountId], [PaymentType], [ArrangementId], [Qlevel], [Status], [Link], 
		[LinkDriver], [PlacedOnHold], [HandledQlevelChange], [LinkDriverIsClosed])


	--select OnHoldDate from dbo.debtorcreditcards -- AND [OnHoldDate] IS NULL
	--select [onHold] from dbo.pdc-- AND [onHold] IS NULL
	--select suspended from dbo.promises --AND ISNULL([suspended],0) = 0
		
	SELECT DISTINCT A.number, A.PaymentType, A.ArrangementID, m.Qlevel, m.Status, m.link,
	m.linkdriver, 0, 0, CASE WHEN ISNULL(m.LinkDriver,0) = 1 THEN
							CASE WHEN m.Qlevel IN ('999','998') THEN 1 ELSE 0 END
							ELSE 0
						END

	FROM (	SELECT d.arrangementid, dd.accountid as number,'CC' as paymenttype
            FROM [dbo].[debtorcreditcards] d 
            INNER JOIN [dbo].[debtorcreditcarddetails] dd
                ON dd.debtorcreditcardid = d.id
            WHERE arrangementid IS NOT NULL AND isactive=1 AND [OnHoldDate] IS NULL
            GROUP BY d.arrangementid, dd.accountid
              
            UNION ALL
              
            SELECT p.arrangementid, pd.accountid as number,'PDC' as paymenttype
            FROM [dbo].[pdc] p
            INNER JOIN [dbo].[pdcdetails] as pd
                ON pd.pdcid = p.uid
            WHERE arrangementid IS NOT NULL AND active=1 AND [onHold] IS NULL
            GROUP BY p.arrangementid, pd.accountid
		  
			UNION ALL
		  
			SELECT p.arrangementid, pd.[AccountID] as number, 'PRM' as paymenttype
			FROM [dbo].[promises] as p
			INNER JOIN [dbo].[promisedetails] as pd
				ON pd.promiseid = p.id
			WHERE arrangementid IS NOT NULL AND active=1 AND ISNULL([suspended],0) = 0
			GROUP BY p.arrangementid,pd.[AccountId]) AS A
	INNER JOIN [dbo].[master] AS m
		ON m.[number] = A.[number]
	WHERE ISNULL(m.link,0) = 0
	OR m.link IN (SELECT [link] FROM [dbo].[master] GROUP BY [link] HAVING COUNT(*) = 1); --MAYBE MAYBE?????********************************************** We have found some accounts that have a link value that are not really linked???? 
	-- AND m.[Qlevel] NOT IN () --- TODO There are some changes made by the promise routine in which we don't want to update accounts....
    
	-- Need to find accounts that were in 014 018,820,830,840 status to so that we can set no more postdates..
	INSERT INTO [dbo].[AccountAndArrangementIds]([AccountId], [PaymentType], [ArrangementId], [Qlevel], [Status], [Link], 
		[LinkDriver], [PlacedOnHold], [HandledQlevelChange], [LinkDriverIsClosed])
      
	SELECT DISTINCT m.number, 'NA', NULL, m.Qlevel, m.Status, m.link,
	m.linkdriver, 0, 0, CASE WHEN ISNULL(m.LinkDriver,0) = 1 THEN
							CASE WHEN m.Qlevel IN ('999','998') THEN 1 ELSE 0 END
							ELSE 0
						END
	FROM [dbo].[master] AS m
	WHERE( ISNULL(m.link,0) = 0
	OR m.link IN (SELECT [link] FROM [dbo].[master] GROUP BY [link] HAVING COUNT(*) = 1)) -- We have found some accounts that have a link value that are not really linked???? 
	AND m.[Qlevel] IN ('014','018','820','830','840')
	AND m.[number] NOT IN (SELECT [AccountId] FROM [dbo].[AccountAndArrangementIds]);
	
	-- Should we place arrangements on hold????
	EXEC [dbo].[EvaluateArrangementsPlacePaymentsOnHold] 0;
	
	-- Update the table for the next payment information....
	UPDATE [dbo].[AccountAndArrangementIds]
	SET [NextDueDate] = A3.DueDate,
		[NextAmount] = A3.[Amount],
		[NextPaymentType] = A3.[Ptype]
	FROM [dbo].[AccountAndArrangementIds] AS A
	INNER JOIN (SELECT A2.[AccountId], A2.[pkey], A2.[DueDate], A2.[amount], A2.[Ptype],
						ROW_NUMBER() OVER (Partition By A2.AccountId ORDER BY a2.duedate, a2.pkey, a2.amount desc) AS ordering
						FROM (      SELECT 2 as pkey, [AcctId] AS AccountId, [duedate] AS [Duedate],[amount], 'PRM' as [PType] FROM [dbo].[promises] 
									WHERE [active] = 1 AND ISNULL([suspended],0) = 0 AND [ArrangementId] IN (SELECT [ArrangementId] FROM [dbo].[AccountAndArrangementIds])
									
									UNION ALL 
									SELECT 1 as pkey, [Number] AS AccountId, [Deposit] AS [DueDate], [amount], 'PDC' as [PType] FROM [dbo].[Pdc] 
									WHERE [Active] = 1 AND [onHold] IS NULL AND [ArrangementId] IN (SELECT [ArrangementId] FROM [dbo].[AccountAndArrangementIds])
									
									UNION ALL
																		
									SELECT 1 as pkey, [Number] AS AccountId, [depositdate] AS [DueDate], [amount], 'CC' as [PType] FROM [dbo].[DebtorCreditCards]
									WHERE [IsActive] = 1  AND [OnHoldDate] IS NULL AND [ArrangementId] IN (SELECT [ArrangementId] FROM [dbo].[AccountAndArrangementIds])
						) AS A2 
	) AS A3 
		ON A3.[AccountId] = A.[AccountId] AND A3.[Ordering] = 1
	--RETURN 0;
	
	-- These Qlevels should not be updated
	--010 - Broken Promse
	--012 - Bounced Checks
	--998 - Closed
	--999 - Returned
	--019 - NSF STILL HAS PDCS ON FILE
	-- Now we can update accounts to proper QLevel Status 
	-- Logic for Qlevel and Status is as follows �
	-- Determine next payment type (promise, pdc or pcc) set Qlevel and Status appropriately (820,830,840 and PPA, PDC, PCC)
	-- 018 will only be set if the next payment is a pdc and is > 500
	UPDATE [dbo].[master]
	SET [Status] = CASE A.[NextPaymentType] WHEN 'PRM' THEN 'PPA' WHEN 'PDC' THEN 'PDC' ELSE 'PCC' END,
	[Qlevel] = CASE WHEN A.[NextPaymentType] IN ('PRM') THEN '820' 
				    ELSE
						CASE WHEN A.[NextAmount] >= 500 THEN '018'
							WHEN A.[NextPaymentType] IN ('PDC') THEN '830'
							ELSE '840'
						END
					END
	FROM [dbo].[master] AS [master]
	INNER JOIN [dbo].[AccountAndArrangementIds] AS A
		ON A.[AccountId] = [master].[number]
	
	WHERE [master].[Qlevel] NOT IN ('010','012','019','998','999')
		AND A.[ArrangementId] IS NOT NULL
		AND A.[NextPaymentType] IS NOT NULL 
		AND A.[NextDueDate] IS NOT NULL AND A.[NextAmount] IS NOT NULL;
		
	-- For any accounts having Qlevel of 018, 820, 830 or 840 but do not have an arrangement id we need to update to no more postdates Qlevel
	UPDATE [dbo].[master]
	SET [Qlevel] = '011',[status] = 'ACT'
	FROM [dbo].[master] AS [master]
	INNER JOIN [dbo].[AccountAndArrangementIds] AS A
		ON A.[AccountId] = [master].[number]
	WHERE [master].[Qlevel] IN ('018','820','830','840')
		AND A.[ArrangementId] IS NULL;

END
GO
