SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_HandleNonLinkedAccountUpdates] @AccountID INTEGER
AS
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	
	--TRUNCATE TABLE [dbo].[AccountAndArrangementIds];
	--TRUNCATE TABLE [dbo].[ArrangementCorrections];
	DECLARE @ArrangementCorrections TABLE(
		[Id] [INT] IDENTITY(1, 1), 
		[AccountId] INTEGER NOT NULL,
		[Link] INTEGER);
	
	DECLARE @AccountAndArrangementIds TABLE(
		[Id] [INT] IDENTITY(1, 1), 
		[AccountId] INTEGER NOT NULL,
		[PaymentType] VARCHAR(3),
		[ArrangementId] INTEGER NULL,
		[Qlevel] VARCHAR(3),
		[Status] VARCHAR(5),
		[Link] INTEGER,
		[LinkDriver] INTEGER,
		[PlacedOnHold] [BIT],
		[HandledQlevelChange] [BIT],
		[NextDueDate] DATETIME,
		[LinkDriverIsClosed] BIT,
		[NextPaymentType] VARCHAR(3),
		[NextAmount] MONEY,
		[NextPaymentTypeForArrangement] VARCHAR(3),
		[NextAmountForArrangement] MONEY,
		[NextDueDateForArrangement] DATETIME,
		[Reason] VARCHAR(50),
		[AllAccountsAreInArrangement] BIT);
	
	DECLARE @today DATETIME;
	SELECT @today = CAST({ fn CURDATE() } AS DATETIME);
	DECLARE @ActiveArrangement VARCHAR(50);
	DECLARE @NotInActiveArrangement VARCHAR(50);
	DECLARE @PreviousActiveArrangement VARCHAR(50);
	SET @ActiveArrangement = 'Active Arrangement';
	SET @NotInActiveArrangement = 'Not in Active Arrangement';
	SET @PreviousActiveArrangement = 'Previous Active Arrangement'
	
	DECLARE @ArrangementIds TABLE (
		[ArrangementId] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);
	
	
	--select OnHoldDate from dbo.debtorcreditcards -- AND [OnHoldDate] IS NULL
	--select [onHold] from dbo.pdc-- AND [onHold] IS NULL
	--select suspended from dbo.promises --AND ISNULL([suspended],0) = 0
	
	INSERT INTO @ArrangementIds ([ArrangementId])
	SELECT DISTINCT A.[ArrangementId]
	FROM (
		SELECT [ArrangementId]
		FROM [dbo].[debtorcreditcards] AS d
		INNER JOIN [dbo].[debtorcreditcarddetails] AS dd
			ON dd.[DebtorCreditCardId] = d.[ID]
		WHERE [ArrangementId] IS NOT NULL AND [IsActive] = 1 AND [OnHoldDate] IS NULL
		AND [AccountId] = @AccountId
		GROUP BY [ArrangementId]
		  
		UNION ALL
		
		SELECT [ArrangementId]
		FROM [dbo].[pdc] AS p
		INNER JOIN [dbo].[pdcdetails] AS d
		ON d.[PdcId] = p.[UID]
		WHERE [ArrangementId] IS NOT NULL AND [active] = 1 AND [onHold] IS NULL
		AND [AccountId] = @AccountId
		GROUP BY [ArrangementId]

		UNION ALL 
		
		SELECT [ArrangementId]
		FROM [dbo].[promises] AS p
		INNER JOIN [dbo].[promisedetails] AS d
			ON d.[PromiseId] = p.[Id]
		WHERE [ArrangementId] IS NOT NULL AND [active] = 1 AND ISNULL([suspended],0) = 0
		AND [AccountId]  = @AccountId
		GROUP BY [ArrangementId]
) AS A;
	
	INSERT INTO @AccountAndArrangementIds([AccountId], [PaymentType], [ArrangementId], [Qlevel], [Status], [Link], [Reason])
      
	SELECT DISTINCT A.number, A.PaymentType, A.ArrangementID, m.Qlevel, m.Status, -m.number, @ActiveArrangement
						
	FROM (	SELECT d.arrangementid, dd.accountid as number,'CC' as paymenttype
            FROM [dbo].[debtorcreditcards] d 
            INNER JOIN [dbo].[debtorcreditcarddetails] dd
                ON dd.debtorcreditcardid = d.id
            WHERE arrangementid IS NOT NULL AND isactive=1
			AND arrangementid IN (SELECT [ArrangementId] FROM @ArrangementIds)
            GROUP BY d.arrangementid, dd.accountid
              
            UNION ALL
              
            SELECT p.arrangementid, pd.accountid as number,'PDC' as paymenttype
            FROM [dbo].[pdc] p
            INNER JOIN [dbo].[pdcdetails] as pd
                ON pd.pdcid = p.uid
            WHERE arrangementid IS NOT NULL AND active=1
			AND arrangementid IN (SELECT [ArrangementId] FROM @ArrangementIds)
            GROUP BY p.arrangementid, pd.accountid

			UNION ALL

			SELECT p.arrangementid, pd.[AccountID] as number, 'PRM' as paymenttype
			FROM [dbo].[promises] as p
			INNER JOIN [dbo].[promisedetails] as pd
			  ON pd.promiseid = p.id
			WHERE arrangementid IS NOT NULL AND active=1
			AND arrangementid IN (SELECT [ArrangementId] FROM @ArrangementIds)			
			GROUP BY p.arrangementid,pd.[AccountId]
              ) AS A
	INNER JOIN [dbo].[master] AS m
		ON m.[number] = A.[number]
    
	-- Now handle Qlevel, status problems-----------------------------------------------------------------------------------------------------------------------------
	-- Find the Dates For Each Payment type
	UPDATE @AccountAndArrangementIds
		SET [NextDueDate] = A3.DueDate,
			[NextAmount] = A3.[Amount],
			[NextPaymentType] = [PType]
		FROM @AccountAndArrangementIds AS A						
		INNER JOIN( SELECT A2.[Link], A2.[pkey], A2.[DueDate], A2.[amount], A2.[Ptype], 
							ROW_NUMBER() OVER (Partition By A2.Link ORDER BY a2.duedate, a2.pkey, a2.amount desc) AS ordering
							FROM (      SELECT 2 as pkey, [Link], [duedate] AS [Duedate],[amount], 'PRM' AS [PType]
										FROM [dbo].[promises] AS P
										INNER JOIN @AccountAndArrangementIds AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [active] = 1  -- AND [Suspended] != 1
										
										UNION ALL 
										
										SELECT 1 as pkey, [Link], [Deposit] AS [DueDate], [amount], 'PDC' AS [PType]
										FROM [dbo].[Pdc] AS P
										INNER JOIN @AccountAndArrangementIds AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [Active] = 1 
										
										UNION ALL
																			
										SELECT 1 as pkey, [Link], [depositdate] AS [DueDate], [amount], 'CC' AS [PType]
										FROM [dbo].[DebtorCreditCards] AS P
										INNER JOIN @AccountAndArrangementIds AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [IsActive] = 1
							) AS A2 
				) AS A3
	ON A3.[Link] = A.[Link]	AND A3.[Ordering] = 1;
	
	--SELECT * FROM @AccountAndArrangementIds;
	--RETURN;
	UPDATE [dbo].[master]
	SET [Status] = CASE A.[NextPaymentType] WHEN 'PRM' THEN 'PPA' WHEN 'PDC' THEN 'PDC' ELSE 'PCC' END,
	[Qlevel] = 	CASE WHEN A.[NextPaymentType] IN ('PRM') THEN '820' 
					ELSE
						CASE WHEN A.[NextAmount] >= 500 THEN '018'
							WHEN A.[NextPaymentType] IN ('PDC') THEN '830'
								ELSE '840'
						END
				END
	OUTPUT inserted.number,inserted.link
	INTO @ArrangementCorrections([AccountID], [Link])

	FROM [dbo].[master] AS [master]
	INNER JOIN @AccountAndArrangementIds AS A
		ON A.[AccountId] = [master].[number]
	WHERE [master].[Qlevel] NOT IN ('998','999')
		AND A.[ArrangementId] IS NOT NULL
		AND A.[NextPaymentType] IS NOT NULL 
		AND A.[NextDueDate] IS NOT NULL AND A.[NextAmount] IS NOT NULL

	RETURN 0;
GO
