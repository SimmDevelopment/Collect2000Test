SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[EvaluateArrangementsLinkedAccounts]
@Hold_Linked_Arrangements_Containing_Closed_Account [BIT] = 0
AS 
BEGIN
	SET NOCOUNT ON;
	TRUNCATE TABLE [dbo].[AccountAndArrangementIds];
	TRUNCATE TABLE [dbo].[ArrangementCorrections];
	
	DECLARE @today DATETIME;
	SELECT @today = CAST({ fn CURDATE() } AS DATETIME);
	DECLARE @ActiveArrangement VARCHAR(50);
	DECLARE @NotInActiveArrangement VARCHAR(50);
	DECLARE @PreviousActiveArrangement VARCHAR(50);
	SET @ActiveArrangement = 'Active Arrangement';
	SET @NotInActiveArrangement = 'Not in Active Arrangement';
	SET @PreviousActiveArrangement = 'Previous Active Arrangement'

	INSERT INTO [dbo].[AccountAndArrangementIds]([AccountId], [PaymentType], [ArrangementId], [Qlevel], [Status], [Link], 
		[LinkDriver], [PlacedOnHold], [HandledQlevelChange], [LinkDriverIsClosed], [Reason])
      

	--select OnHoldDate from dbo.debtorcreditcards -- AND [OnHoldDate] IS NULL
	--select [onHold] from dbo.pdc-- AND [onHold] IS NULL
	--select suspended from dbo.promises --AND ISNULL([suspended],0) = 0

	SELECT DISTINCT A.number, A.PaymentType, A.ArrangementID, m.Qlevel, m.Status, m.link,
	m.linkdriver, 0, 0, CASE WHEN ISNULL(m.LinkDriver,0) = 1 THEN
							CASE WHEN m.Qlevel IN ('999','998') THEN 1 ELSE 0 END
							ELSE 0
						END, @ActiveArrangement
						

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
			GROUP BY p.arrangementid,pd.[AccountId]
              ) AS A
	INNER JOIN [dbo].[master] AS m
		ON m.[number] = A.[number]
	WHERE [Link] IN (SELECT [link] FROM [dbo].[master] WHERE ISNULL([link],0) != 0 GROUP BY [link] HAVING COUNT(*) > 1);  --MAYBE MAYBE?????********************************************** We have found some accounts that have a link value that are not really linked???? 
    
	-- Get accounts related to arrangements that don't have entries.	 
	INSERT INTO [dbo].[AccountAndArrangementIds](
	[AccountId], [PaymentType], [ArrangementId], [Qlevel], [Status], [Link], 
	[LinkDriver], [PlacedOnHold], [HandledQlevelChange], [LinkDriverIsClosed], [Reason])
            
	SELECT DISTINCT m.number, 'NA', NULL, m.Qlevel, m.Status, m.link, 
	m.linkdriver, 0, 0,CASE WHEN ISNULL(m.LinkDriver,0) = 1 THEN
							CASE WHEN m.Qlevel IN ('999','998') THEN 1 ELSE 0 END
							ELSE 0
						END,@NotInActiveArrangement
	FROM [dbo].[master] AS m
	WHERE ISNULL(link,0) != 0
	AND [Link] IN (SELECT [Link] FROM [dbo].[AccountAndArrangementIds] 
				 WHERE [Link] >  0)
	AND [number] NOT IN ( SELECT [AccountId] FROM [dbo].[AccountAndArrangementIds] 
						WHERE [Link] >  0);
	
	-- Remove Accounts entered above that are closed and are not the driver they will not need to be updated and should not count as an Incommplete Arrangement Link Group.
	DELETE FROM [dbo].[AccountAndArrangementIds]
	WHERE [LinkDriver] != 1 AND [ArrangementId] IS NULL AND [QLevel] IN ('998','999');
	
	-- Update the drivers so that we can tell if all open accounts are in an arrangement.
	UPDATE [dbo].[AccountAndArrangementIds]
	SET [AllAccountsAreInArrangement] = 0
	WHERE [LinkDriver] = 1 
	AND [Link] IN (SELECT [Link] FROM [dbo].[AccountAndArrangementIds] WHERE [ArrangementId] IS NULL);
	
	-- Get Accounts that were in 018, 830 or 840 status that may have to be set for no more postdates.
	-- Qlevel 014 will override 013,018, 820,830 or 840, Qlevel 010,012,019 are maintained until account is worked, 
	-- 013 gets determined by no more futures if driver was 018,820,830,840					

	INSERT INTO [dbo].[AccountAndArrangementIds]
	([AccountId], [PaymentType], [ArrangementId], [Qlevel], [Status], [Link], 
	[LinkDriver], [PlacedOnHold], [HandledQlevelChange], [LinkDriverIsClosed], [Reason])
            
	SELECT DISTINCT m.number, 'NA', NULL, m.Qlevel, m.Status, m.link, 
	m.linkdriver, 0, 0,CASE WHEN ISNULL(m.LinkDriver,0) = 1 THEN
							CASE WHEN m.Qlevel IN ('999','998') THEN 1 ELSE 0 END
							ELSE 0
						END,@PreviousActiveArrangement
	FROM [dbo].[master] AS m
	WHERE ISNULL(link,0) != 0
	AND [Qlevel] IN ('014','018','820','830','840') 
	AND [Link] IN (SELECT [link] FROM [dbo].[master] WHERE ISNULL([link],0) != 0 GROUP BY [link] HAVING COUNT(*) > 1)
	AND [number] NOT IN (SELECT [AccountId] FROM [dbo].[AccountAndArrangementIds]);
	
	-- Add any missing linked accounts from above.
	INSERT INTO [dbo].[AccountAndArrangementIds]([AccountId], [PaymentType], [ArrangementId], [Qlevel], [Status], [Link], 
		[LinkDriver], [PlacedOnHold], [HandledQlevelChange], [LinkDriverIsClosed], [Reason])

	SELECT DISTINCT m.number, 'NA', NULL, m.Qlevel, m.Status, m.link, 
	m.linkdriver, 0, 0,CASE WHEN ISNULL(m.LinkDriver,0) = 1 THEN
							CASE WHEN m.Qlevel IN ('999','998') THEN 1 ELSE 0 END
							ELSE 0
						END,@PreviousActiveArrangement
	FROM [dbo].[master] AS m
	WHERE ISNULL(link,0) != 0
	--AND [Qlevel] IN ('830','840') 
	AND [Link] IN (SELECT [Link] FROM [dbo].[AccountAndArrangementIds])
	AND [number] NOT IN (SELECT [AccountId] FROM [dbo].[AccountAndArrangementIds]);
	
	EXEC [dbo].[EvaluateArrangementsPlacePaymentsOnHold] @Hold_Linked_Arrangements_Containing_Closed_Account;
	
	--RETURN 0;

	-- Now handle Qlevel, status problems-----------------------------------------------------------------------------------------------------------------------------
	-- Find the Dates For Each Payment type
	-- Update the table for the next payment information for the link group....
	UPDATE [dbo].[AccountAndArrangementIds]
		SET [NextDueDate] = A3.DueDate,
			[NextAmount] = A3.[Amount],
			[NextPaymentType] = A3.[Ptype]
		FROM [dbo].[AccountAndArrangementIds] AS A						
		INNER JOIN( SELECT A2.[Link], A2.[pkey], A2.[DueDate], A2.[amount], A2.[ptype],
							ROW_NUMBER() OVER (Partition By A2.Link ORDER BY a2.duedate, a2.pkey, a2.amount desc) AS ordering
							FROM (      SELECT 2 as pkey, [Link], [duedate] AS [Duedate],[amount], 'PRM' AS [ptype]
										FROM [dbo].[promises] AS P
										INNER JOIN [dbo].[AccountAndArrangementIds] AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [active] = 1 AND ISNULL([suspended],0) = 0
										
										UNION ALL 
										
										SELECT 1 as pkey, [Link], [Deposit] AS [DueDate], [amount], 'PDC' AS [ptype] 
										FROM [dbo].[Pdc] AS P
										INNER JOIN [dbo].[AccountAndArrangementIds] AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [Active] = 1 AND [onHold] IS NULL
										
										UNION ALL
																			
										SELECT 1 as pkey, [Link], [depositdate] AS [DueDate], [amount], 'CC' AS [ptype]  
										FROM [dbo].[DebtorCreditCards] AS P
										INNER JOIN [dbo].[AccountAndArrangementIds] AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [IsActive] = 1 AND [OnHoldDate] IS NULL
							) AS A2 
				) AS A3
	ON A3.[Link] = A.[Link]	AND A3.[Ordering] = 1;
	
	-- Update the table for the next payment information for the individual arrangements....
	UPDATE [dbo].[AccountAndArrangementIds]
		SET [NextDueDateForArrangement] = A3.DueDate,
			[NextAmountForArrangement] = A3.[Amount],
			[NextPaymentTypeForArrangement] = A3.[Ptype]
		FROM [dbo].[AccountAndArrangementIds] AS A						
		INNER JOIN(	SELECT A2.[ArrangementId], A2.[pkey], A2.[DueDate], A2.[amount], A2.[ptype],
					ROW_NUMBER() OVER (Partition By A2.ArrangementId ORDER BY a2.duedate, a2.pkey, a2.amount desc) AS ordering
							FROM (      SELECT 2 as pkey, P.[ArrangementId], [duedate] AS [Duedate],[amount], 'PRM' AS [ptype] 
										FROM [dbo].[promises] AS P
										INNER JOIN [dbo].[AccountAndArrangementIds] AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [active] = 1 AND ISNULL([suspended],0) = 0
										
										UNION ALL 
										
										SELECT 1 as pkey, P.[ArrangementId], [Deposit] AS [DueDate], [amount], 'PDC' AS [ptype] 
										FROM [dbo].[Pdc] AS P
										INNER JOIN [dbo].[AccountAndArrangementIds] AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [Active] = 1 AND [onHold] IS NULL
										
										UNION ALL
																			
										SELECT 1 as pkey, P.[ArrangementId], [depositdate] AS [DueDate], [amount], 'CC' AS [ptype] 
										FROM [dbo].[DebtorCreditCards] AS P
										INNER JOIN [dbo].[AccountAndArrangementIds] AS A
											ON A.[ArrangementId] = P.[ArrangementId]
										WHERE [IsActive] = 1 AND [OnHoldDate] IS NULL
						) AS A2 
				) AS A3
	ON A3.[ArrangementId] = A.[ArrangementId]	AND A3.[Ordering] = 1;
	--return;
							
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
    INTO [dbo].[ArrangementCorrections]([AccountID], [Link])

	FROM [dbo].[master] AS [master]
	INNER JOIN [dbo].[AccountAndArrangementIds] AS A
		ON A.[AccountId] = [master].[number]
	WHERE [master].[Qlevel] NOT IN ('010','012','019','998','999') 	-- DON'T UPDATE THESE
																	-- These Qlevels should not be updated
																	--010 - Broken Promse
																	--012 - Bounced Checks
																	--998 - Closed
																	--999 - Returned
																	--019 - NSF STILL HAS PDCS ON FILE
		AND A.[ArrangementId] IS NOT NULL
		AND A.[NextPaymentType] IS NOT NULL 
		AND A.[NextDueDate] IS NOT NULL AND A.[NextAmount] IS NOT NULL
		AND A.[LinkDriver] = 1;
		
	--SELECT * FROM [dbo].[ArrangementCorrections];
	
	-- Now using what we adjusted for the drivers above do updates for the links.
	UPDATE [dbo].[master]
	SET [Qlevel] = '875',
	[Status] = CASE 
					WHEN A.[ArrangementId] IS NULL THEN 'ILA'
					ELSE 
						CASE A.[NextPaymentTypeForArrangement] WHEN 'PRM' THEN 'PPA' WHEN 'PDC' THEN 'PDC' ELSE 'PCC' END
					END

	OUTPUT inserted.number,inserted.link
    INTO [dbo].[ArrangementCorrections]([AccountID], [Link])
	
	FROM [dbo].[master] AS [master]
	INNER JOIN [dbo].[AccountAndArrangementIds] AS A
		ON A.[AccountId] = [master].[number]
	WHERE [master].[Qlevel] NOT IN ('010','012','019','998','999')  -- DON'T UPDATE THESE
																	-- These Qlevels should not be updated
																	--010 - Broken Promse
																	--012 - Bounced Checks
																	--998 - Closed
																	--999 - Returned
																	--019 - NSF STILL HAS PDCS ON FILE
	AND [master].[Link] IN (SELECT [Link] FROM [dbo].[ArrangementCorrections])
	AND [master].[LinkDriver] != 1;
				   
	--return;
	-- Remove Records we just updated
	DELETE FROM [dbo].[AccountAndArrangementIds]
	WHERE [Link] IN (SELECT [Link] FROM [dbo].[ArrangementCorrections]);
	
	DELETE FROM [dbo].[ArrangementCorrections];
	
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
    INTO [dbo].[ArrangementCorrections]([AccountID], [Link])

	FROM [dbo].[master] AS [master]
	INNER JOIN [dbo].[AccountAndArrangementIds] AS A
		ON A.[AccountId] = [master].[number]
	WHERE [master].[Qlevel] NOT IN ('010','012','019','998','999')  -- DON'T UPDATE THESE
																	-- These Qlevels should not be updated
																	--010 - Broken Promse
																	--012 - Bounced Checks
																	--998 - Closed
																	--999 - Returned
																	--019 - NSF STILL HAS PDCS ON FILE
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
    INTO [dbo].[ArrangementCorrections]([AccountID], [Link])
	
	FROM [dbo].[master] AS [master]
	INNER JOIN [dbo].[AccountAndArrangementIds] AS A
		ON A.[AccountId] = [master].[number]
	WHERE [master].[Qlevel] NOT IN ('010','012','019','998','999')  -- DON'T UPDATE THESE
																	-- These Qlevels should not be updated
																	--010 - Broken Promse
																	--012 - Bounced Checks
																	--998 - Closed
																	--999 - Returned
																	--019 - NSF STILL HAS PDCS ON FILE
	AND [master].[Link] IN (SELECT [Link] FROM [dbo].[ArrangementCorrections])
	AND [master].[LinkDriver] != 1;
						
	-- Remove Records we just updated
	DELETE FROM [dbo].[AccountAndArrangementIds]
	WHERE [Link] IN (SELECT [Link] FROM [dbo].[ArrangementCorrections]);
	DELETE FROM [dbo].[ArrangementCorrections];

	-- Handle when the Link Driver is closed. We just need to update the links if needed....
	INSERT INTO [dbo].[ArrangementCorrections]([AccountId], [Link])
	SELECT [AccountId], [Link]
	FROM [dbo].[AccountAndArrangementIds]
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
    INTO [dbo].[ArrangementCorrections]([AccountID], [Link])
	
	FROM [dbo].[master] AS [master]
	INNER JOIN [dbo].[AccountAndArrangementIds] AS A
		ON A.[AccountId] = [master].[number]
	WHERE [master].[Qlevel] NOT IN ('998','999','010','012')
	AND [master].[Link] IN (SELECT [Link] FROM [dbo].[ArrangementCorrections])
	AND [master].[LinkDriver] != 1;

	-- Remove Records we just updated
	DELETE FROM [dbo].[AccountAndArrangementIds]
	WHERE [Link] IN (SELECT [Link] FROM [dbo].[ArrangementCorrections]);
	DELETE FROM [dbo].[ArrangementCorrections];
	
	-- Now update open drivers for which there was a previous active arrangement
	UPDATE [dbo].[master]
	SET [Qlevel] = 
	CASE A.[LinkDriver] WHEN 1 THEN '011' ELSE '875' END,[Status] = 'ACT'
	FROM [dbo].[master] AS [master]
	INNER JOIN [dbo].[AccountAndArrangementIds] AS A
		ON A.[AccountId] = [master].[number]
	WHERE [Reason] = @PreviousActiveArrangement AND [master].[Qlevel] NOT IN ('998','999');
	
END
GO
