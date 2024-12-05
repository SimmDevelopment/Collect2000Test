SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_HandleLinkedAccountUpdates] @AccountID INTEGER
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
		
	DECLARE @LinkId INT;
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
	
	DECLARE @AccountIds TABLE (
		[AccountId] INTEGER NOT NULL PRIMARY KEY CLUSTERED
	);
	SELECT @LinkId = [link] FROM [dbo].[master] WHERE [number] = @AccountID;
	INSERT INTO @AccountIDs ([AccountID])
	SELECT [master].[number]
	FROM [dbo].[master]
	WHERE [master].[link] = @LinkId;
	
	INSERT INTO @ArrangementIds ([ArrangementId])
	SELECT DISTINCT A.[ArrangementId]
	FROM (
		SELECT [ArrangementId]
		FROM [dbo].[debtorcreditcards] AS d
		INNER JOIN [dbo].[debtorcreditcarddetails] AS dd
			ON dd.[DebtorCreditCardId] = d.[ID]
		WHERE [ArrangementId] IS NOT NULL AND [IsActive] = 1  AND [OnHoldDate] IS NULL
		AND [AccountId] IN (SELECT [AccountId] FROM @AccountIds)
		GROUP BY [ArrangementId]
		  
		UNION ALL
		
		SELECT [ArrangementId]
		FROM [dbo].[pdc] AS p
		INNER JOIN [dbo].[pdcdetails] AS d
		ON d.[PdcId] = p.[UID]
		WHERE [ArrangementId] IS NOT NULL AND [active] = 1 AND [onHold] IS NULL
		AND [AccountId] IN (SELECT [AccountId] FROM @AccountIds)
		GROUP BY [ArrangementId]

		UNION ALL
		
		SELECT [ArrangementId]
		FROM [dbo].[promises] AS p
		INNER JOIN [dbo].[promisedetails] AS d
			ON d.[PromiseId] = p.[Id]
		WHERE [ArrangementId] IS NOT NULL AND [active] = 1 AND ISNULL([suspended],0) = 0
		AND [AccountId] IN (SELECT [AccountId] FROM @AccountIds)
		GROUP BY [ArrangementId]
) AS A;
	
	INSERT INTO @AccountAndArrangementIds([AccountId], [PaymentType], [ArrangementId], [Qlevel], [Status], [Link], 
		[LinkDriver], [PlacedOnHold], [HandledQlevelChange], [LinkDriverIsClosed], [Reason])
      
	SELECT DISTINCT A.number, A.PaymentType, A.ArrangementID, m.Qlevel, m.Status, m.link,
	m.linkdriver, 0, 0, CASE WHEN ISNULL(m.LinkDriver,0) = 1 THEN
							CASE WHEN m.Qlevel IN ('999','998') THEN 1 ELSE 0 END
							ELSE 0
						END, @ActiveArrangement
						

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
    
	-- Get accounts related to arrangements that don't have entries.	 
	INSERT INTO @AccountAndArrangementIds(
	[AccountId], [PaymentType], [ArrangementId], [Qlevel], [Status], [Link], 
	[LinkDriver], [PlacedOnHold], [HandledQlevelChange], [LinkDriverIsClosed], [Reason])
            
	SELECT DISTINCT m.number, 'NA', NULL, m.Qlevel, m.Status, m.link, 
	m.linkdriver, 0, 0,CASE WHEN ISNULL(m.LinkDriver,0) = 1 THEN
							CASE WHEN m.Qlevel IN ('999','998') THEN 1 ELSE 0 END
							ELSE 0
						END,@NotInActiveArrangement
	FROM [dbo].[master] AS m
	WHERE [link] = @LinkId
	AND [number] NOT IN ( SELECT [AccountId] FROM @AccountAndArrangementIds);

	-- Remove Accounts entered above that are closed and are not the driver they will not need to be updated and should not count as an Incommplete Arrangement Link Group.
	DELETE FROM @AccountAndArrangementIds
	WHERE [LinkDriver] != 1 AND [ArrangementId] IS NULL AND [QLevel] IN ('998','999');
	
	-- Update the drivers so that we can tell if all open accounts are in an arrangement.
	UPDATE @AccountAndArrangementIds
	SET [AllAccountsAreInArrangement] = 0
	WHERE [LinkDriver] = 1 
	AND [Link] IN (SELECT [Link] FROM @AccountAndArrangementIds WHERE [ArrangementId] IS NULL);	
	
	-- Now handle Qlevel, status problems-----------------------------------------------------------------------------------------------------------------------------
	-- Find the Dates For Each Payment type
	-- Update the table for the next payment information for the link group....
	UPDATE @AccountAndArrangementIds
		SET [NextDueDate] = A3.DueDate,
			[NextAmount] = A3.[Amount],
			[NextPaymentType] = A3.[Ptype]
		FROM @AccountAndArrangementIds AS A						
		INNER JOIN( SELECT A2.[Link], A2.[pkey], A2.[DueDate], A2.[amount], A2.[Ptype],
							ROW_NUMBER() OVER (Partition By A2.Link ORDER BY a2.duedate, a2.pkey, a2.amount desc) AS ordering
							FROM (      SELECT 2 as pkey, [Link], [duedate] AS [Duedate],[amount], 'PRM' AS [Ptype] 
										FROM [dbo].[promises] AS P
										INNER JOIN @AccountAndArrangementIds AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [active] = 1  -- AND [Suspended] != 1
										
										UNION ALL 
										
										SELECT 1 as pkey, [Link], [Deposit] AS [DueDate], [amount], 'PDC' AS [Ptype]
										FROM [dbo].[Pdc] AS P
										INNER JOIN @AccountAndArrangementIds AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [Active] = 1 
										
										UNION ALL
																			
										SELECT 1 as pkey, [Link], [depositdate] AS [DueDate], [amount], 'CC' AS [Ptype]
										FROM [dbo].[DebtorCreditCards] AS P
										INNER JOIN @AccountAndArrangementIds AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [IsActive] = 1
							) AS A2 
				) AS A3
	ON A3.[Link] = A.[Link]	AND A3.[Ordering] = 1;
	
	-- Update the table for the next payment information for the individual arrangements....
	UPDATE @AccountAndArrangementIds
		SET [NextDueDateForArrangement] = A3.DueDate,
			[NextAmountForArrangement] = A3.[Amount],
			[NextPaymentTypeForArrangement] = A3.[Ptype]
		FROM @AccountAndArrangementIds AS A						
		INNER JOIN(	SELECT A2.[ArrangementId], A2.[pkey], A2.[DueDate], A2.[amount], A2.[Ptype],
					ROW_NUMBER() OVER (Partition By A2.ArrangementId ORDER BY a2.duedate, a2.pkey, a2.amount desc) AS ordering
							FROM (      SELECT 2 as pkey, P.[ArrangementId], [duedate] AS [Duedate],[amount], 'PRM' AS [Ptype]
										FROM [dbo].[promises] AS P
										INNER JOIN @AccountAndArrangementIds AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [active] = 1 -- AND [Suspended] != 1
										
										UNION ALL 
										
										SELECT 1 as pkey, P.[ArrangementId], [Deposit] AS [DueDate], [amount], 'PDC' AS [Ptype]
										FROM [dbo].[Pdc] AS P
										INNER JOIN @AccountAndArrangementIds AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [Active] = 1 
										
										UNION ALL
																			
										SELECT 1 as pkey, P.[ArrangementId], [depositdate] AS [DueDate], [amount], 'CC' AS [Ptype]
										FROM [dbo].[DebtorCreditCards] AS P
										INNER JOIN @AccountAndArrangementIds AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [IsActive] = 1
						) AS A2 
				) AS A3
	ON A3.[ArrangementId] = A.[ArrangementId]	AND A3.[Ordering] = 1;
	
	--SELECT * FROM @AccountAndArrangementIds;
	--RETURN;
	-- Handle Easiest Updates first The Link Driver is not closed and is involved in an active arrangement.
	UPDATE [dbo].[master]
	SET [Status] = CASE A.[NextPaymentTypeForArrangement] WHEN 'PRM' THEN 'PPA' WHEN 'PDC' THEN 'PDC' ELSE 'PCC' END,
	[Qlevel] = 	CASE A.[AllAccountsAreInArrangement]
					WHEN 0 THEN '014'
					ELSE
						CASE WHEN A.[NextPaymentType] IN ('PRM') THEN '820' 
							ELSE
								CASE WHEN A.[NextAmount] >= 500 THEN '018'
									WHEN A.[NextPaymentType] IN ('PDC') THEN '830'
									ELSE '840'
								END
						END
				END
	OUTPUT inserted.number,inserted.link
	INTO @ArrangementCorrections([AccountID], [Link])

	FROM [dbo].[master] AS [master]
	INNER JOIN @AccountAndArrangementIds AS A
		ON A.[AccountId] = [master].[number]
	WHERE [master].[Qlevel] NOT IN ('998','999','010','012')
		AND A.[ArrangementId] IS NOT NULL
		AND A.[NextPaymentType] IS NOT NULL 
		AND A.[NextDueDate] IS NOT NULL AND A.[NextAmount] IS NOT NULL
		AND A.[LinkDriver] = 1;

	-- Now using what we adjusted for the drivers above do updates for the links.
	UPDATE [dbo].[master]
	SET [Qlevel] = '875',
	[Status] = CASE 
					WHEN A.[ArrangementId] IS NULL THEN 'ILA'
					ELSE 
						CASE A.[NextPaymentTypeForArrangement] WHEN 'PRM' THEN 'PPA' WHEN 'PDC' THEN 'PDC' ELSE 'PCC' END
					END

	OUTPUT inserted.number,inserted.link
	INTO @ArrangementCorrections([AccountID], [Link])
	
	FROM [dbo].[master] AS [master]
	INNER JOIN @AccountAndArrangementIds AS A
		ON A.[AccountId] = [master].[number]
	WHERE [master].[Qlevel] NOT IN ('998','999','010','012')
	AND [master].[Link] IN (SELECT [Link] FROM @ArrangementCorrections)
	AND [master].[LinkDriver] != 1;
	
	-- Remove Records we just updated
	DELETE FROM @AccountAndArrangementIds
	WHERE [Link] IN (SELECT [Link] FROM @ArrangementCorrections);

	-- Now do updates for active arrangements for which the link driver was NOT in an arrangement and the link driver is open.
	UPDATE [dbo].[master]
	SET [Status] = 'ILA',
	[Qlevel] = 	CASE A.[AllAccountsAreInArrangement]
					WHEN 0 THEN '014'
					ELSE
						CASE WHEN A.[NextPaymentType] IN ('PRM') THEN '820' 
							ELSE
								CASE WHEN A.[NextAmount] >= 500 THEN '018'
									WHEN A.[NextPaymentType] IN ('PDC') THEN '830'
									ELSE '840'
								END
						END
				END

	OUTPUT inserted.number,inserted.link
	INTO @ArrangementCorrections([AccountID], [Link])

	FROM [dbo].[master] AS [master]
	INNER JOIN @AccountAndArrangementIds AS A
		ON A.[AccountId] = [master].[number]
	WHERE [master].[Qlevel] NOT IN ('998','999','010','012')
		AND A.[ArrangementId] IS NULL 
		AND A.[NextPaymentType] IS NOT NULL 
		AND A.[NextDueDate] IS NOT NULL AND A.[NextAmount] IS NOT NULL
		AND A.[LinkDriver] = 1
		AND A.[Reason] = @NotInActiveArrangement;	
		
	-- Now using what we adjusted for the drivers above do updates for the links.
	UPDATE [dbo].[master]
	SET [Qlevel] = '875',
	[Status] = CASE 
					WHEN A.[ArrangementId] IS NULL THEN 'ILA'
					ELSE 
						CASE A.[NextPaymentTypeForArrangement] WHEN 'PRM' THEN 'PPA' WHEN 'PDC' THEN 'PDC' ELSE 'PCC' END
					END

	OUTPUT inserted.number,inserted.link
	INTO @ArrangementCorrections([AccountID], [Link])
	
	FROM [dbo].[master] AS [master]
	INNER JOIN @AccountAndArrangementIds AS A
		ON A.[AccountId] = [master].[number]
	WHERE [master].[Qlevel] NOT IN ('998','999','010','012')
	AND [master].[Link] IN (SELECT [Link] FROM @ArrangementCorrections)
	AND [master].[LinkDriver] != 1;
						
	-- Remove Records we just updated
	DELETE FROM @AccountAndArrangementIds
	WHERE [Link] IN (SELECT [Link] FROM @ArrangementCorrections);
	DELETE FROM @ArrangementCorrections;
	
	-- Handle when the Link Driver is closed. We just need to update the links if needed....
	INSERT INTO @ArrangementCorrections([AccountId], [Link])
	SELECT [AccountId], [Link]
	FROM @AccountAndArrangementIds
	WHERE [LinkDriver] = 1 AND [QLevel] IN ('999','998')
	AND [Reason] != @PreviousActiveArrangement;
	
	-- Update the Links
	UPDATE [dbo].[master]
	SET [Qlevel] = '875',
	[Status] = CASE 
					WHEN A.[ArrangementId] IS NULL THEN 'ILA'
					ELSE 
						CASE A.[NextPaymentType] WHEN 'PRM' THEN 'PPA' WHEN 'PDC' THEN 'PDC' ELSE 'PCC' END
					END

	OUTPUT inserted.number,inserted.link
	INTO @ArrangementCorrections([AccountID], [Link])
	
	FROM [dbo].[master] AS [master]
	INNER JOIN @AccountAndArrangementIds AS A
		ON A.[AccountId] = [master].[number]
	WHERE [master].[Qlevel] NOT IN ('998','999','010','012')
	AND [master].[Link] IN (SELECT [Link] FROM @ArrangementCorrections)
	AND [master].[LinkDriver] != 1;

	-- Remove Records we just updated
	DELETE FROM @AccountAndArrangementIds
	WHERE [Link] IN (SELECT [Link] FROM @ArrangementCorrections);
	DELETE FROM @ArrangementCorrections;	

	RETURN 0;
GO
