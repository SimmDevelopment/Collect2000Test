SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spInterestDeferralAndSettlementOptions]
	-- The number of days before the last arrangement due date to trigger a reminder on the account
	@LastArrangementReminderDays INTEGER = 15,
	-- The number of days after the last payment date to trigger a reminder and a reminder letter on the account
	@NoArrangementReminderDays INTEGER = 15,
	-- The number of days after the last payment date to expect a payment for the reminder letter
	@GhostArrangementDueDays INTEGER = 30,
	-- The number of days after the last payment date to trigger a warning letter on the account
	@WarningLetterDays INTEGER = 35,
	-- The number of days after the last payment date to reinstate interest and disable partial settlement
	@GraceDays INTEGER = 45,
	-- The letter code to send on the account as a reminder for the last arrangement for a promise
	@PpaReminderLetterCode VARCHAR(5) = '00000',
	-- The letter code to send on the account as a reminder for the last arrangement for a post-dated check
	@PdcReminderLetterCode VARCHAR(5) = '00001',
	-- The letter code to send on the account as a reminder for the last arrangement for a post-dated credit card
	@PccReminderLetterCode VARCHAR(5) = '00002',
	-- The letter code to send on the account as a warning regarding reinstatement of deferred interest
	@DeferredLetterCode VARCHAR(5) = '00003',
	-- The letter code to send on the account as a warning regarding voiding of partial settlement
	@SettlementLetterCode VARCHAR(5) = '00004',
	-- The letter code to send on the account as a warning regarding reinstatement of deferred interest and voiding of partial settlement
	@DeferredWithSettlementLetterCode VARCHAR(5) = '00005',
	-- Whether or not any changes (reminders, letters, reinstating interest or voiding settlements) should be made
	@EnactChanges BIT = 1

AS


SET NOCOUNT ON;
SET XACT_ABORT ON;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;



DECLARE @Accounts TABLE (
	[AccountID] INTEGER NOT NULL PRIMARY KEY CLUSTERED,
	[Desk] VARCHAR(10) NOT NULL,
	[Balance] MONEY NOT NULL,
	[RemainingArrangements] INTEGER NOT NULL,
	[NextArrangementDate] DATETIME NULL,
	[NextArrangementType] VARCHAR(3) NULL,
	[NextArrangementAmount] MONEY NULL,
	[LastArrangementType] VARCHAR(3) NULL,
	[ProjectedRemaining] MONEY NULL,
	[LastPaymentDate] DATETIME NULL,
	[LastPaymentAmount] MONEY NULL,
	[Deferred] BIT NOT NULL,
	[Settlement] BIT NOT NULL,
	[Reminder] BIT NOT NULL DEFAULT(0),
	[LetterCode] VARCHAR(5) NULL,
	[DueDate] DATETIME NULL,
	[AmountDue] MONEY NULL,
	[Delete] BIT NOT NULL DEFAULT(0)
);

-- Identify all accounts being tracked due to having deferred interest or a settlement agreement and has one or fewer remaining arrangements
WITH [Arrangements] AS (
	SELECT [Index] AS [Index],
		[AffectedAccountID] AS [AccountID],
		[Type],
		[DueDate],
		[AffectedAmount] AS [Amount],
		[ProjectedCurrent] AS [ProjectedCurrent],
		[ProjectedRemaining] AS [ProjectedRemaining]
	FROM [dbo].[Arrangements_IndexedArrangementsView]
), [RemainingArrangements] AS (
	SELECT
		[Arrangements].[AccountID] AS [AccountID],
		COUNT(*) AS [Remaining]
	FROM [Arrangements]
	GROUP BY [Arrangements].[AccountID]
), [Payments] AS (
	SELECT
		[payhistory].[number] AS [AccountID],
		ROW_NUMBER() OVER(PARTITION BY [payhistory].[number] ORDER BY [payhistory].[datepaid] DESC) AS [Index],
		[payhistory].[datepaid] AS [DatePaid],
		[payhistory].[totalpaid] AS [Amount]
	FROM [dbo].[payhistory]
	WHERE [payhistory].[batchtype] LIKE 'P_'
), [InactiveArrangements] AS (
	SELECT
		'PPA' AS [Type],
		[Promises].[DueDate] AS [Due],
		COALESCE([PromiseDetails].[AccountID], [Promises].[AcctID]) AS [AccountID]
	FROM [dbo].[Promises]
	LEFT OUTER JOIN [dbo].[PromiseDetails]
	ON [PromiseDetails].[PromiseID] = [Promises].[ID]
	WHERE [Promises].[Active] = 0
	AND [Promises].[Kept] = 1
	UNION ALL
	SELECT
		'PDC' AS [Type],
		[pdc].[deposit] AS [Due],
		COALESCE([PdcDetails].[AccountID], [pdc].[number]) AS [AccountID]
	FROM [dbo].[pdc]
	LEFT OUTER JOIN [dbo].[PdcDetails]
	ON [PdcDetails].[PdcID] = [pdc].[UID]
	WHERE [pdc].[Active] = 0
	UNION ALL
	SELECT
		'PCC' AS [Type],
		[DebtorCreditCards].[DepositDate] AS [Due],
		COALESCE([DebtorCreditCardDetails].[AccountID], [DebtorCreditCards].[number]) AS [AccountID]
	FROM [dbo].[DebtorCreditCards]
	LEFT OUTER JOIN [dbo].[DebtorCreditCardDetails]
	ON [DebtorCreditCardDetails].[DebtorCreditCardID] = [DebtorCreditCards].[ID]
	WHERE [DebtorCreditCards].[IsActive] = 0
), [IndexedInactiveArrangements] AS (
	SELECT
		[InactiveArrangements].[AccountID] AS [AccountID],
		ROW_NUMBER() OVER (PARTITION BY [InactiveArrangements].[AccountID] ORDER BY [InactiveArrangements].[Due] DESC) AS [Index],
		[InactiveArrangements].[Type] AS [Type],
		[InactiveArrangements].[Due] AS [Due]
	FROM [InactiveArrangements]
)
INSERT INTO @Accounts ([AccountID], [Desk], [Balance], [RemainingArrangements], [NextArrangementDate], [NextArrangementType], [NextArrangementAmount], [LastArrangementType], [ProjectedRemaining], [LastPaymentDate], [LastPaymentAmount], [Deferred], [Settlement])
SELECT
	[master].[number] AS [AccountID],
	[master].[desk] AS [Desk],
	[master].[current0] AS [Balance],
	COALESCE([RemainingArrangements].[Remaining], 0) AS [RemainingArrangements],
	[NextArrangement].[DueDate] AS [NextArrangementDate],
	[NextArrangement].[Type] AS [NextArrangementType],
	[NextArrangement].[Amount] AS [NextArrangementAmount],
	[IndexedInactiveArrangements].[Type] AS [LastArrangementType],
	[NextArrangement].[ProjectedRemaining] AS [ProjectedRemaining],
	[LastPayment].[DatePaid] AS [LastPaymentDate],
	[LastPayment].[Amount] AS [LastPaymentAmount],
	[master].[IsInterestDeferred] AS [Deferred],
	CASE
		WHEN [Settlement].[ID] IS NOT NULL THEN 1
		ELSE 0
	END AS [Settlement]
FROM [dbo].[master]
LEFT OUTER JOIN [RemainingArrangements]
ON [master].[number] = [RemainingArrangements].[AccountID]
LEFT OUTER JOIN [Arrangements] AS [NextArrangement]
ON [master].[number] = [NextArrangement].[AccountID]
AND [NextArrangement].[Index] = 1
LEFT OUTER JOIN [Payments] AS [LastPayment]
ON [master].[number] = [LastPayment].[AccountID]
AND [LastPayment].[Index] = 1
LEFT OUTER JOIN [IndexedInactiveArrangements]
ON [master].[number] = [IndexedInactiveArrangements].[AccountID]
AND [IndexedInactiveArrangements].[Index] = 1
LEFT OUTER JOIN [dbo].[Settlement]
ON [master].[number] = [Settlement].[AccountID]
AND [master].[SettlementID] = [Settlement].[ID]
WHERE [master].[qlevel] NOT IN ('998', '999')
AND [master].[current0] > 0
AND ([master].[IsInterestDeferred] = 1
	OR [Settlement].[ID] IS NOT NULL);

DECLARE @NextArrangementDate DATETIME;
DECLARE @NoArrangementDate DATETIME;
DECLARE @WarningDate DATETIME;
DECLARE @GraceDate DATETIME;
DECLARE @ErrorMessage NVARCHAR(2048);
DECLARE @ErrorSeverity INTEGER;
DECLARE @ErrorState INTEGER;
SET @NextArrangementDate = DATEADD(DAY, @LastArrangementReminderDays, { fn CURDATE() });
SET @NoArrangementDate = DATEADD(DAY, -@NoArrangementReminderDays, { fn CURDATE() });
SET @WarningDate = DATEADD(DAY, -@WarningLetterDays, { fn CURDATE() });
SET @GraceDate = DATEADD(DAY, -@GraceDays, { fn CURDATE() });

-- Identify accounts that should receive a reminder regarding the final arrangement
UPDATE @Accounts
SET [Reminder] = 1
WHERE [RemainingArrangements] = 1
AND [NextArrangementDate] IS NOT NULL
AND [NextArrangementDate] >= @NextArrangementDate
AND [NextArrangementDate] < DATEADD(DAY, 1, @NextArrangementDate)
AND [ProjectedRemaining] IS NOT NULL
AND [ProjectedRemaining] >= 0.01;

-- Identify accounts that should receive a reminder and a letter after the final arrangement for the "ghost" arrangement
UPDATE @Accounts
SET [Reminder] = 1,
	[LetterCode] = CASE [LastArrangementType]
		WHEN 'PPA' THEN @PpaReminderLetterCode
		WHEN 'PDC' THEN @PdcReminderLetterCode
		WHEN 'PCC' THEN @PccReminderLetterCode
		ELSE NULL
	END,
	[DueDate] = DATEADD(DAY, @GhostArrangementDueDays, [LastPaymentDate]),
	[AmountDue] = CASE
		WHEN [LastPaymentAmount] > [Balance] THEN [Balance]
		ELSE [LastPaymentAmount]
	END
WHERE [RemainingArrangements] = 0
AND [NextArrangementDate] IS NULL
AND [LastPaymentDate] IS NOT NULL
AND [LastPaymentDate] >= @NoArrangementDate
AND [LastPaymentDate] < DATEADD(DAY, 1, @NoArrangementDate);

-- Identify accounts that should receive a warning letter after the "ghost" arrangement due date
UPDATE @Accounts
SET [LetterCode] = CASE
            WHEN [Deferred] = 1 AND [Settlement] = 1 THEN @DeferredWithSettlementLetterCode
            WHEN [Deferred] = 1 THEN @DeferredLetterCode
            WHEN [Settlement] = 1 THEN @SettlementLetterCode
            ELSE NULL
      END,
      [DueDate] = DATEADD(DAY, @GraceDays, [LastPaymentDate]),
      [AmountDue] = CASE
            WHEN [LastPaymentAmount] > [Balance] THEN [Balance]
            ELSE [LastPaymentAmount]
      END
WHERE [LastPaymentDate] IS NOT NULL
AND [LastPaymentDate] >= @WarningDate
AND [LastPaymentDate] < DATEADD(DAY, 1, @WarningDate);



-- Identify accounts that have exceeded the grace period without a payment and should have interest reinstated and settlements voided
UPDATE @Accounts
SET [Delete] = 1,
	[LetterCode] = NULL,
	[Reminder] = 1
WHERE ([LastPaymentDate] IS NULL
	OR [LastPaymentDate] <= @GraceDate)
AND ([RemainingArrangements] IS NULL
	OR [RemainingArrangements] <= 0)
AND [NextArrangementDate] IS NULL;

IF @EnactChanges = 1 BEGIN
	IF EXISTS (SELECT * FROM @Accounts WHERE [Reminder] = 1) BEGIN
		BEGIN TRY
			BEGIN TRANSACTION;

			-- Add reminders to accounts for the current desk
			INSERT INTO [dbo].[Reminders] ([Desk], [AccountID], [Due], [ReminderDate], [FollowAccountDesk])
			SELECT [Accounts].[Desk], [Accounts].[AccountID], GETDATE(), GETDATE(), 1
			FROM @Accounts AS [Accounts]
			WHERE [Accounts].[Reminder] = 1
			AND NOT EXISTS (
				SELECT *
				FROM [dbo].[Reminders]
				WHERE [Reminders].[Desk] = [Accounts].[Desk]
				AND [Reminders].[AccountID] = [Accounts].[AccountID]
			);

			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			SET @ErrorMessage = ERROR_MESSAGE();
			SET @ErrorSeverity = ERROR_SEVERITY();
			SET @ErrorState = ERROR_STATE();
			IF XACT_STATE() <> 0 BEGIN
				ROLLBACK TRANSACTION;
			END;
			RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
			RETURN;
		END CATCH
	END;

	IF EXISTS (SELECT * FROM @Accounts WHERE [LetterCode] IS NOT NULL) BEGIN
		DECLARE @Requests TABLE (
			[AccountID] INTEGER NOT NULL,
			[DebtorID] INTEGER NOT NULL,
			[DebtorSeq] INTEGER NOT NULL,
			[LetterRequestID] INTEGER NOT NULL
		);

		BEGIN TRY
			BEGIN TRANSACTION;
		
			-- Insert the new letter requests
			INSERT INTO [dbo].[LetterRequest] (
				[AccountID],
				[CustomerCode],
				[LetterID],
				[LetterCode],
				[DateRequested],
				[DateProcessed],
				[JobName],
				[DueDate],
				[AmountDue],
				[UserName],
				[Suspend],
				[SifPmt1],
				[SifPmt2],
				[SifPmt3],
				[SifPmt4],
				[SifPmt5],
				[SifPmt6],
				[Manual],
				[AddEditMode],
				[Edited],
				[DocumentData],
				[CopyCustomer],
				[Deleted],
				[SaveImage],
				[ProcessingMethod],
				[ErrorDescription],
				[DateCreated],
				[DateUpdated],
				[SubjDebtorID],
				[SenderID],
				[RequesterID],
				[FutureID],
				[RecipientDebtorID],
				[RecipientDebtorSeq],
				[LtrSeriesQueueID],
				[SifPmt7],
				[SifPmt8],
				[SifPmt9],
				[SifPmt10],
				[SifPmt11],
				[SifPmt12],
				[SifPmt13],
				[SifPmt14],
				[SifPmt15],
				[SifPmt16],
				[SifPmt17],
				[SifPmt18],
				[SifPmt19],
				[SifPmt20],
				[SifPmt21],
				[SifPmt22],
				[SifPmt23],
				[SifPmt24]
			)
			OUTPUT
				[INSERTED].[AccountID],
				[INSERTED].[RecipientDebtorID],
				[INSERTED].[RecipientDebtorSeq],
				[INSERTED].[LetterRequestID]
			INTO @Requests (
				[AccountID],
				[DebtorID],
				[DebtorSeq],
				[LetterRequestID]
			)
			SELECT
				[master].[number] AS [AccountID],
				[master].[customer] AS [CustomerCode],
				[letter].[LetterID] AS [LetterID],
				[letter].[code]  AS [LetterCode],
				GETDATE() AS [DateRequested],
				'1753-01-01 12:00 PM' AS [DateProcessed],
				'Job_SetInt_' + CONVERT(VARCHAR(256), GETDATE(), 126) AS [JobName],
				[Accounts].[DueDate] AS [DueDate],
				[Accounts].[AmountDue] AS [AmountDue],
				'SYSTEM' AS [UserName],
				0 AS [Suspend],
				'' AS [SifPmt1],
				'' AS [SifPmt2],
				'' AS [SifPmt3],
				'' AS [SifPmt4],
				'' AS [SifPmt5],
				'' AS [SifPmt6],
				0 AS [Manual],
				0 AS [AddEditMode],
				0 AS [Edited],
				0x AS [DocumentData],
				0 AS [Deleted],
				0 AS [CopyCustomer],
				0 AS [SaveImage],
				0 AS [ProcessingMethod],
				'' AS [ErrorDescription],
				GETDATE() AS [DateCreated],
				GETDATE() AS [DateUpdated],
				[Debtors].[DebtorID] AS [SubjDebtorID],
				COALESCE([Users].[ID], 1) AS [SenderID],
				COALESCE([Users].[ID], 1) AS [RequesterID],
				0 AS [FutureID],
				[Debtors].[DebtorID] AS [RecipientDebtorID],
				[Debtors].[Seq] AS [RecipientDebtorSeq],
				NULL AS [LtrSeriesQueueID],
				'' AS [SifPmt7],
				'' AS [SifPmt8],
				'' AS [SifPmt9],
				'' AS [SifPmt10],
				'' AS [SifPmt11],
				'' AS [SifPmt12],
				'' AS [SifPmt13],
				'' AS [SifPmt14],
				'' AS [SifPmt15],
				'' AS [SifPmt16],
				'' AS [SifPmt17],
				'' AS [SifPmt18],
				'' AS [SifPmt19],
				'' AS [SifPmt20],
				'' AS [SifPmt21],
				'' AS [SifPmt22],
				'' AS [SifPmt23],
				'' AS [SifPmt24]
			FROM @Accounts AS [Accounts]
			INNER JOIN [dbo].[master]
			ON [Accounts].[AccountID] = [master].[number]
			INNER JOIN [dbo].[letter]
			ON [Accounts].[LetterCode] = [letter].[code]
			CROSS APPLY (
				SELECT TOP (1)
					[Debtors].[DebtorID],
					[Debtors].[Seq]
				FROM [dbo].[Debtors]
				WHERE [Debtors].[number] = [master].[number]
				ORDER BY [Debtors].[Seq], [Debtors].[DebtorID]
			) AS [Debtors]
			OUTER APPLY (
				SELECT TOP (1)
					[Users].[ID]
				FROM [dbo].[Users]
				WHERE [Users].[DeskCode] = [master].[desk]
				AND [Users].[Active] = 1
				ORDER BY [Users].[ID]
			) AS [Users]
			WHERE [Accounts].[LetterCode] IS NOT NULL;
		
			-- Insert the required letter request recipients for the inserted letter requests
			INSERT INTO [dbo].[LetterRequestRecipient] ([LetterRequestID], [AccountID], [Seq], [DebtorID], [DateCreated], [DateUpdated])
			SELECT [LetterRequestID], [AccountID], [DebtorSeq], [DebtorID], GETDATE(), GETDATE()
			FROM @Requests;
		
			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			SET @ErrorMessage = ERROR_MESSAGE();
			SET @ErrorSeverity = ERROR_SEVERITY();
			SET @ErrorState = ERROR_STATE();
			IF XACT_STATE() <> 0 BEGIN
				ROLLBACK TRANSACTION;
			END;
			RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
			RETURN;
		END CATCH
	END;

	IF EXISTS (SELECT * FROM @Accounts WHERE [Delete] = 1) BEGIN
		BEGIN TRY
			BEGIN TRANSACTION;

			-- Write note for how much deferred interest is being reinstated onto the account
			INSERT INTO [dbo].[notes] ([number], [user0], [created], [action], [result], [comment])
			SELECT [master].[number], 'SYSTEM', GETDATE(), 'INT', 'RNST', CHAR(36) + CONVERT(VARCHAR(100), [master].[DeferredInterest], 0) + ' deferred interest reinstated onto the account.'
			FROM @Accounts AS [Accounts]
			INNER JOIN [dbo].[master]
			ON [Accounts].[AccountID] = [master].[number]
			WHERE [master].[IsInterestDeferred] = 1
			AND [master].[DeferredInterest] IS NOT NULL
			AND [master].[DeferredInterest] > 0
			AND [Accounts].[Delete] = 1;

			-- Reinstate the deferred interest and disable interest deferral
			UPDATE [dbo].[master]
			SET [current0] = [master].[current0] + COALESCE([master].[DeferredInterest], 0),
				[current2] = [master].[current2] + COALESCE([master].[DeferredInterest], 0),
				[accrued2] = [master].[accrued2] + COALESCE([master].[DeferredInterest], 0),
				[DeferredInterest] = 0,
				[IsInterestDeferred] = 0
			FROM [dbo].[master]
			INNER JOIN @Accounts AS [Accounts]
			ON [master].[number] = [Accounts].[AccountID]
			WHERE [master].[IsInterestDeferred] = 1
			AND [Accounts].[Delete] = 1;

			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			SET @ErrorMessage = ERROR_MESSAGE();
			SET @ErrorSeverity = ERROR_SEVERITY();
			SET @ErrorState = ERROR_STATE();
			IF XACT_STATE() <> 0 BEGIN
				ROLLBACK TRANSACTION;
			END;
			RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
			RETURN;
		END CATCH

		BEGIN TRY
			BEGIN TRANSACTION;

			-- Write note for the settlement agreement that was broken
			INSERT INTO [dbo].[notes] ([number], [user0], [created], [action], [result], [comment])
			SELECT [master].[number], 'SYSTEM', GETDATE(), 'SETL', 'BREAK', 'Settlement agreement for ' + CHAR(36) + CONVERT(VARCHAR(100), [Settlement].[SettlementAmount], 0) + ' has been broken.'
			FROM @Accounts AS [Accounts]
			INNER JOIN [dbo].[master]
			ON [Accounts].[AccountID] = [master].[number]
			INNER JOIN [dbo].[Settlement]
			ON [master].[number] = [Settlement].[AccountID]
			AND [master].[SettlementID] = [Settlement].[ID]
			WHERE [Settlement].[SettlementAmount] IS NOT NULL
			AND [Settlement].[SettlementAmount] > 0
			AND [Accounts].[Delete] = 1;

			-- Update the last updated date of the active settlement record
			UPDATE [Settlement]
			SET [Updated] = GETDATE()
			FROM [dbo].[Settlement]
			INNER JOIN [dbo].[master]
			ON [master].[number] = [Settlement].[AccountID]
			AND [master].[SettlementID] = [Settlement].[ID]
			INNER JOIN @Accounts AS [Accounts]
			ON [Accounts].[AccountID] = [master].[number]
			AND [Accounts].[Delete] = 1;

			-- Remove the active settlement record from the master record
			UPDATE [master]
			SET [SettlementID] = NULL
			FROM [dbo].[master]
			INNER JOIN @Accounts AS [Accounts]
			ON [master].[number] = [Accounts].[AccountID]
			INNER JOIN [dbo].[Settlement]
			ON [master].[number] = [Settlement].[AccountID]
			AND [master].[SettlementID] = [Settlement].[ID]
			AND	[Accounts].[Delete] = 1;

			COMMIT TRANSACTION;
		END TRY
		BEGIN CATCH
			SET @ErrorMessage = ERROR_MESSAGE();
			SET @ErrorSeverity = ERROR_SEVERITY();
			SET @ErrorState = ERROR_STATE();
			IF XACT_STATE() <> 0 BEGIN
				ROLLBACK TRANSACTION;
			END;
			RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
			RETURN;
		END CATCH
	END;
END;

SELECT GETDATE() AS [SystemDate],
	@NextArrangementDate AS [NextArrangementDate],
	@NoArrangementDate AS [NoArrangementDate],
	@WarningDate AS [WarningDate],
	@GraceDate AS [GraceDate],
	*
FROM @Accounts;

RETURN;

GO
