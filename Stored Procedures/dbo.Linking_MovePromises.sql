SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Mike Devlin
-- Create date: 2008-8-14
-- Description:	Move promises, pdc's and 
--	debtorcreditcard records to new link driver 
--	account.
--	At this point we assume that the driver has
--	been validated and all we need to do is 
--	validate that the promises can be moved.
-- RULES: 
--	Cannot move to a closed account.
--	Cannot move if new driver already has promises.	
--	Only move active promises.
-- =============================================
CREATE PROCEDURE [dbo].[Linking_MovePromises] 
	@OldLinkDriver INTEGER = NULL,
	@NewLinkDriver INTEGER,
	@LoginName VARCHAR(10) = 'SYSTEM',
	@FailMessage VARCHAR(255) OUTPUT
AS
SET NOCOUNT ON;
DECLARE @RC INTEGER;
DECLARE @MovePromises BIT;
DECLARE @PromisesCount INTEGER;
DECLARE @PDCsCount INTEGER;
DECLARE @DebtorCreditCardsCount INTEGER;
DECLARE @UID BIGINT;
DECLARE @Comment VARCHAR(511);

-- if we don't have a previous link driver, then we won't move anything...
-- if we decide to move promises from any linked account to the new
-- driver then we will remove this check...
IF @OldLinkDriver IS NULL BEGIN
	RETURN 0;
END;

-- Does the old link driver have any Primises?
SELECT @PromisesCount = COUNT(*) FROM [Promises] WHERE [AcctId] = @OldLinkDriver AND [Active] = 1;
-- Does the old link driver have any PDCs?
SELECT @PDCsCount = COUNT(*) FROM [pdc] WHERE [number] = @OldLinkDriver AND [Active] = 1;
-- Does the old link driver have any DebtorCreditCards?
SELECT @DebtorCreditCardsCount = COUNT(*) FROM [DebtorCreditCards] WHERE [number] = @OldLinkDriver AND [IsActive] = 1;

IF (@PromisesCount + @PDCsCount + @DebtorCreditCardsCount) = 0 BEGIN
	RETURN 0;
END;


-- Does the new link driver have any promises?
-- SELECT @PromisesCount = COUNT(*) FROM [Promises] WHERE [AcctId] = @NewLinkDriver AND [Active] = 1;
-- IF @PromisesCount > 0 BEGIN
-- 	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Cannot move promises because new link driver #' + CAST(@NewLinkDriver AS VARCHAR(15)) + ' already contains active promises.';
-- 	SET @FailMessage = 'Cannot move promises because new link driver #' + CAST(@NewLinkDriver AS VARCHAR(15)) + ' already contains active promises.';
-- 	RETURN -1;
-- END;
-- -- Does the new link driver have any PDCs?
-- SELECT @PDCsCount = Count(*) FROM PDC WHERE number = @NewLinkDriver AND Active = 1
-- IF @PDCsCount > 0 BEGIN
-- 	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Cannot move PDCs because new link driver #' + CAST(@NewLinkDriver AS VARCHAR(15)) + ' already contains active PDCs.';
-- 	SELECT @FailMessage = 'Cannot move PDCs because new link driver #' + CAST(@NewLinkDriver AS VARCHAR(15)) + ' already contains active PDCs.';
-- 	RETURN -2;
-- END;

-- -- Does the new link driver have any DebtorCreditCards?
-- SELECT @DebtorCreditCardsCount = COUNT(*) FROM [DebtorCreditCards] WHERE [number] = @NewLinkDriver AND [IsActive] = 1;
-- IF @DebtorCreditCardsCount > 0 BEGIN
-- 	PRINT CONVERT(VARCHAR, GETDATE(), 120) + ': Cannot move PCCs because new link driver #' + CAST(@NewLinkDriver AS VARCHAR(15)) + ' already contains active PCCs.';
-- 	SELECT @FailMessage = 'Cannot move PCCs because new link driver #' + CAST(@NewLinkDriver AS VARCHAR(15)) + ' already contains active PCCs.';
-- 	RETURN -3;
-- END;

-- Update promises to new link driver.
UPDATE [Promises]
SET [AcctId] = @NewLinkDriver
WHERE [AcctId] = @OldLinkDriver
AND [Active] = 1;

SELECT @PromisesCount = @@ROWCOUNT, @RC = @@ERROR;
IF @PromisesCount > 0 BEGIN
	-- Add note...
	SELECT @Comment = 'Moved ' + CAST(@PromisesCount AS VARCHAR) + ' Promises to new Driver ' + CAST(@NewLinkDriver AS VARCHAR) + '. '
	EXEC @RC = [Lib_Insert_Notes] @UID, @OldLinkDriver, NULL, NULL, @LoginName, 'PROM', 'MOVED', @Comment, 0, NULL;

	SELECT @Comment = CAST(@PromisesCount AS VARCHAR) + ' Promises from ' +  CAST(@OldLinkDriver AS VARCHAR) + ' moved to this new Driver account. '
	EXEC @RC = [Lib_Insert_Notes] @UID, @NewLinkDriver, NULL, NULL, @LoginName, 'PROM', 'MOVED', @Comment, 0, NULL;
END

-- Update pdcs to new link driver.
UPDATE [pdc]
SET [number] = @NewLinkDriver
WHERE [number] = @OldLinkDriver
AND [Active] = 1;

SELECT @PDCsCount = @@ROWCOUNT, @RC = @@ERROR;
IF @PDCsCount > 0 BEGIN
	SELECT @Comment = 'Moved ' + CAST(@PDCsCount AS VARCHAR) + ' PDCs to new Driver ' + CAST(@NewLinkDriver AS VARCHAR) + '. ';
	EXEC @RC = [Lib_Insert_Notes] @UID, @OldLinkDriver, NULL, NULL, @LoginName, 'PROM', 'MOVED', @Comment, 0, NULL;

	SELECT @Comment = CAST(@PDCsCount AS VARCHAR) + ' PDCs from ' +  CAST(@OldLinkDriver AS VARCHAR) + ' moved to this new Driver account. ';
	EXEC @RC = [Lib_Insert_notes] @UID, @NewLinkDriver, NULL, NULL, @LoginName, 'PROM', 'MOVED', @Comment, 0, NULL;

	-- if there is an debtorbankinfo for the new driver, then 
	-- we need to create a note and delete the dbi record.
	SELECT @Comment = 'Bank Info Deleted: ABAnumber=' + ISNULL(ABAnumber, 'NULL') + ', ' +
			'AccountNumber=' + ISNULL(AccountNumber, 'NULL') + ', ' + 
			'AccountName=' + ISNULL(AccountName, 'NULL') + ', ' + 
			'AccountAddress1=' + ISNULL(AccountAddress1, 'NULL') + ', ' + 
			'AccountAddress2=' + ISNULL(AccountAddress2, 'NULL') +  ', ' +
			'AccountCity=' + ISNULL(AccountCity, 'NULL') +  ', ' +
			'AccountState=' + ISNULL(AccountState, 'NULL') +  ', ' +
			'AccountZipcode=' + ISNULL(AccountZipcode, 'NULL') +  ', ' +
			'AccountVerified=' + ISNULL(CAST(AccountVerified as VARCHAR), 'NULL') +  ', ' +
			'LastCheckNumber=' + ISNULL(CAST(LastCheckNumber as VARCHAR), 'NULL') +  ', ' +
			'BankName=' + ISNULL(BankName, 'NULL') +  ', ' +
			'BankAddress=' + ISNULL(BankAddress, 'NULL') +  ', ' +
			'BankCity=' + ISNULL(BankCity, 'NULL') +  ', ' +
			'BankState=' + ISNULL(BankState, 'NULL') +  ', ' +
			'BankZipCode=' + ISNULL(BankZipCode, 'NULL') +  ', ' +
			'BankPhone=' + ISNULL(BankPhone, 'NULL')
	FROM [DebtorBankInfo]
	WHERE [AcctId] = @NewLinkDriver;

	IF @@ROWCOUNT = 1 BEGIN
		EXEC @RC = [Lib_Insert_Notes] @UID, @NewLinkDriver, NULL, NULL, @LoginName, 'BANK', 'INFO', 'Bank Info Deleted. ', 0, NULL;
		EXEC @RC = [Lib_Insert_Notes_Private] @UID, @NewLinkDriver, NULL, NULL, @LoginName, 'BANK', 'INFO', @Comment, 0, NULL;
		-- SELECT @Comment = comment FROM DebtorBankInfo WHERE AcctId = @NewLinkDriver
		DELETE FROM [DebtorBankInfo]
		WHERE [AcctId] = @NewLinkDriver;
	END
	UPDATE [DebtorBankInfo]
	SET [AcctID] = @NewLinkDriver
	WHERE [AcctID] = @OldLinkDriver;
END

-- Update debtorcreditcards to new link driver.
UPDATE [DebtorCreditCards]
SET [number] = @NewLinkDriver
WHERE [number] = @OldLinkDriver
AND [IsActive] = 1;

SELECT @DebtorCreditCardsCount = @@ROWCOUNT, @RC = @@ERROR;
IF @DebtorCreditCardsCount > 0 BEGIN
	SELECT @Comment = 'Moved ' + CAST(@DebtorCreditCardsCount AS VARCHAR) + ' PCCs to new Driver ' + CAST(@NewLinkDriver AS VARCHAR) + '. ';
	EXEC @RC = [Lib_Insert_Notes] @UID, @NewLinkDriver, NULL, NULL, @LoginName, 'PROM', 'MOVED', @Comment, 0, NULL;

	SELECT @Comment = CAST(@DebtorCreditCardsCount AS VARCHAR) + ' PCCs from ' +  CAST(@OldLinkDriver AS VARCHAR) + ' moved to this new Driver account. ';
	EXEC @RC = [Lib_Insert_Notes] @UID, @NewLinkDriver, NULL, NULL, @LoginName, 'PROM', 'MOVED', @Comment, 0, NULL;
END;

RETURN 0;
GO
