SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [dbo].[Simm_ppa_sweep]
as

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;

DECLARE @BPDate DATETIME;
DECLARE @PaidDate DATETIME;
DECLARE @Days INTEGER;
DECLARE @MoveDesk VARCHAR(10);

SET @MoveDesk = 'PPA';

SET @BPDate = { fn CURDATE() };
SET @Days = 0;

-- Loop backwards 7 weekdays
WHILE @Days < 7 BEGIN
	SET @BPDate = DATEADD(DAY, -1, @BPDate);
	IF DATEPART(WEEKDAY, @BPDATE) NOT IN (1, 7) SET @Days = @Days + 1;
END;

SET @PaidDate = DATEADD(DAY, -45, { fn CURDATE() });

DECLARE @AccountsToMove TABLE (
	[number] INTEGER NOT NULL PRIMARY KEY NONCLUSTERED,
	[desk] VARCHAR(10) NOT NULL,
	[branch] VARCHAR(5) NOT NULL,
	[qlevel] VARCHAR(3) NOT NULL,
	[qdate] VARCHAR(8) NOT NULL
);

INSERT INTO @AccountsToMove ([number], [desk], [branch], [qlevel], [qdate])
SELECT [master].[number], [master].[desk], [desk].[Branch], [master].[qlevel], [master].[qdate]
FROM [dbo].[master]
INNER JOIN [dbo].[desk]
ON [master].[desk] = [desk].[code]
INNER JOIN [dbo].[BranchCodes]
ON [desk].[Branch] = [BranchCodes].[Code]
WHERE [master].[qlevel] = '010'
AND [master].[BPDate] = @BPDate
AND [desk].[desktype] = 'COLLECTOR'
-- Accounts that have broken promises on the collector's desk
AND EXISTS (SELECT *
	FROM [dbo].[Promises]
	WHERE [Promises].[AcctID] = [master].[number]
	AND [Promises].[Active] = 0
	AND [Promises].[Kept] = 0
	AND [Promises].[DateUpdated] BETWEEN [master].[BPDate] AND DATEADD(DAY, 1, [master].[BPDate])
	AND [master].[desk] = [Promises].[desk])
AND (
-- Does not have a promise, PDC or PCC created after the broken promise date
	NOT EXISTS (SELECT 1
		FROM [dbo].[Promises]
		WHERE [Promises].[AcctID] = [master].[number]
		AND ([Promises].[Suspended] = 0
			OR [Promises].[Suspended] IS NULL)
		AND [Promises].[DateCreated] > [master].[BPDate]
		AND [Promises].[Active] = 1
		UNION
		SELECT 1
		FROM [dbo].[pdc]
		WHERE [pdc].[number] = [master].[number]
		AND [pdc].[onhold] IS NULL
		AND [pdc].[DateCreated] > [master].[BPDate]
		AND [pdc].[Active] = 1
		UNION
		SELECT 1
		FROM [dbo].[DebtorCreditCards]
		WHERE [DebtorCreditCards].[Number] = [master].[number]
		AND [DebtorCreditCards].[OnHoldDate] IS NULL
		AND [DebtorCreditCards].[DateCreated] > [master].[BPDate]
		AND [DebtorCreditCards].[IsActive] = 1)
-- Account does not have a payment within the last 45 days
	OR NOT EXISTS (SELECT 1
		FROM [dbo].[payhistory]
		WHERE [payhistory].[number] = [master].[number]
		AND [payhistory].[batchtype] LIKE 'P_'
		AND [payhistory].[datepaid] >= @PaidDate)
);

delete from @accountstomove where number in (select number from payhistory where batchtype in ('pur','par','pcr') and uid in (select max(uid) from payhistory where batchtype in ('pu','pur','pc','pcr','pa','par')
and (iscorrection = 0 or iscorrection is null)
group by number));
delete from @accountstomove where number in (select number from master with (nolock) where status = 'REF');

delete from @accountstomove where number in (select number from master with (nolock) where customer = '0000969')


BEGIN TRANSACTION;

UPDATE [dbo].[master]
SET [desk] = @MoveDesk,
	[qlevel] = '100',
	[qdate] = CONVERT(VARCHAR(8), GETDATE(), 112)
FROM [dbo].[master]
INNER JOIN @AccountsToMove AS [AccountsToMove]
ON [AccountsToMove].[number] = [master].[number];

INSERT INTO [dbo].[notes] ([number], [created], [UtcCreated], [user0], [action], [result], [comment])
SELECT [AccountsToMove].[number], GETDATE(), GETUTCDATE(), 'PPASweep', 'DESK', 'CHNG', 'Desk Changed from ' + [AccountsToMove].[desk] + ' to ' + @MoveDesk
FROM @AccountsToMove AS [AccountsToMove];

DECLARE @JobNumber VARCHAR(50);
SET @JobNumber = CAST(NEWID() AS VARCHAR(50));

INSERT INTO [dbo].[DeskChangeHistory] ([Number], [JobNumber], [OldDesk], [NewDesk], [OldQLevel], [NewQLevel], [OldQDate], [NewQDate], [OldBranch], [NewBranch], [User], [DMDateStamp])
SELECT [AccountsToMove].[number], @JobNumber, [AccountsToMove].[desk], @MoveDesk, [AccountsToMove].[qlevel], '100', [AccountsToMove].[qdate], CONVERT(VARCHAR(8), GETDATE(), 112), [AccountsToMove].[branch], [desk].[Branch], 'PPASweep', GETDATE()
FROM @AccountsToMove AS [AccountsToMove]
CROSS JOIN [dbo].[desk]
WHERE [desk].[code] = @MoveDesk;

COMMIT TRANSACTION;
GO
