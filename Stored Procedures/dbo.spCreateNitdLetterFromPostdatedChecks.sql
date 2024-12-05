SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCreateNitdLetterFromPostdatedChecks]
	@DaysUntilDepositLow INTEGER = 5,
	@DaysUntilDepositHigh INTEGER = 10,
	@SendNitdToDebtor BIT = 0
AS
-- function:	this procedure will create NITD letter requests for post dated checks
--				that are active, 10 days from deposit and entered at least 5 days
--				prior to deposit.
--
-- creation:	06/22/2006 jsb
--
-- change history:
--				08/24/2006 jsb	added daterange parameters. Changed logic to test for duedate within range.		
--							NITD on pdc will be updated only if letter requested
--				09/08/2005 jbs	added join to Users to obtain username and ID of the user that created the pdc
--							added join to Debtors by pdc.Seq to obtain recipient debtor responsible for check
--							corrected DateProcessed field to sentinel value expected by Letter Console
--							used variable set to getdate() to populate letterrequest.datecreated and refered to that value to populate letterrequestrecipient
--							changed pdc.deposit criteria to calculate range first in order to permit index scanning
--				01/04/2007 jsb  modified pdc update
--				12/04/2008 jbs  set alternate recipient of letter to check account holder
--		05/26/2022 BGM added code to the Coalesce for alt recipient to use the debtor bank info address information for the letter address.

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @LetterID INTEGER;
DECLARE @LoadDate DATETIME;
DECLARE @CreatedDate DATETIME;

SET @LoadDate = { fn CURDATE() };
IF DATEPART(HOUR, GETDATE()) <= 8
	SET @LoadDate = DATEADD(DAY, -1, @LoadDate);
SET @CreatedDate = GETDATE();

DECLARE @NitdLetters TABLE (
	[JobID] UNIQUEIDENTIFIER NOT NULL DEFAULT(NEWID()),
	[Number] INTEGER NOT NULL,
	[Customer] VARCHAR(7) NOT NULL,
	[LetterID] INTEGER NOT NULL,
	[LetterCode] VARCHAR(5) NOT NULL,
	[Deposit] DATETIME NOT NULL,
	[Amount] MONEY NOT NULL,
	[LoginName] VARCHAR(10) NOT NULL,
	[UserID] INTEGER NOT NULL,
	[CopyCustomer] BIT NOT NULL,
	[SaveImage] BIT NOT NULL,
	[DebtorID] INTEGER NOT NULL,
	[Seq] INTEGER NOT NULL,
	[UID] INTEGER NOT NULL,
	[BankID] INTEGER NULL,
	[RequestID] INTEGER NULL
);

BEGIN TRANSACTION;

-- Determine which post-dated checks have a pending NITD letter to be sent
-- Also determine which letter is to be sent, the requesting/sending user and the checking account information for the debtor
INSERT INTO @NitdLetters ([Number], [Customer], [LetterID], [LetterCode], [Deposit], [Amount], [LoginName], [UserID], [CopyCustomer], [SaveImage], [DebtorID], [Seq], [UID], [BankID])
SELECT [master].[number],
	[master].[customer],
	[letter].[LetterID],
	[letter].[code],
	[pdc].[deposit],
	[pdc].[amount] + COALESCE([pdc].[Surcharge], 0) AS [Amount],
	COALESCE([Users].[LoginName], 'global') AS [LoginName],
	COALESCE([Users].[ID], 0) AS [UserID],
	[CustLtrAllow].[CopyCustomer],
	[CustLtrAllow].[SaveImage],
	[Debtors].[DebtorID],
	[Debtors].[Seq],
	[pdc].[UID],
	[pdc].[DebtorBankID] as [BankId]
FROM [dbo].[pdc] WITH (ROWLOCK, UPDLOCK)
INNER JOIN [dbo].[master]
ON [master].[number] = [pdc].[number]
INNER JOIN [dbo].[Debtors]
ON [Debtors].[number] = [pdc].[number]
AND [Debtors].[Seq] = COALESCE([pdc].[seq], 0)
LEFT OUTER JOIN [dbo].[Users]
ON [Users].[LoginName] = [pdc].[CreatedBy]
INNER JOIN [dbo].[letter]
ON [letter].[code] = [pdc].[ltrcode]
INNER JOIN [dbo].[CustLtrAllow]
ON [CustLtrAllow].[CustCode] = [master].[customer]
AND [CustLtrAllow].[LtrCode] = [letter].[code]
WHERE [pdc].[deposit] BETWEEN DATEADD(DAY, @DaysUntilDepositLow, @LoadDate) AND DATEADD(DAY, @DaysUntilDepositHigh, @LoadDate)
AND [pdc].[nitd] IS NULL
AND [pdc].[Active] = 1
AND [pdc].[ApprovedBy] != ''
AND [pdc].[onhold] IS NULL;

IF @@ERROR <> 0 GOTO ErrorHandler;

-- Generate the letter request records for the pending NITD letters
-- Set the JobName to the randomly generated GUID to find this record and obtain the request ID
INSERT INTO [dbo].[LetterRequest] ([AccountID], [CustomerCode], [LetterID], [LetterCode], [DateRequested], [DateProcessed], [JobName], [DueDate], [AmountDue], [UserName], [SenderID], [RequesterID], [Suspend], [SifPmt1], [SifPmt2], [SifPmt3], [SifPmt4], [SifPmt5], [SifPmt6], [CopyCustomer], [SaveImage], [ProcessingMethod], [FutureID], [SubjDebtorID], [RecipientDebtorID], [RecipientDebtorSeq], [DateCreated], [DateUpdated], [PdcId])
SELECT [Nitd].[Number],
	[Nitd].[Customer],
	[Nitd].[LetterID],
	[Nitd].[LetterCode],
	@LoadDate AS [DateRequested],
	'1753-01-01 12:00 PM' AS [DateProcessed],
	CAST([Nitd].[JobID] AS VARCHAR(256)) AS [JobName],
	[Nitd].[Deposit],
	[Nitd].[Amount],
	[Nitd].[LoginName],
	[Nitd].[UserID],
	[Nitd].[UserID],
	0 AS [Suspend],
	'' AS [SifPmt1],
	'' AS [SifPmt2],
	'' AS [SifPmt3],
	'' AS [SifPmt4],
	'' AS [SifPmt5],
	'' AS [SifPmt6],
	[Nitd].[CopyCustomer],
	[Nitd].[SaveImage],
	0 AS [ProcessingMethod],
	0 AS [FutureID],
	[Nitd].[DebtorID],
	[Nitd].[DebtorID],
	[Nitd].[Seq],
	@CreatedDate AS [DateCreated],
	@CreatedDate AS [DateUpdated],
	[Nitd].[UID]
FROM @NitdLetters AS [Nitd];

IF @@ERROR <> 0 GOTO ErrorHandler;

-- Find the generated letter request ID
UPDATE [Nitd]
SET [RequestID] = [LetterRequest].[LetterRequestID]
FROM @NitdLetters AS [Nitd]
INNER JOIN [dbo].[LetterRequest]
ON [LetterRequest].[AccountID] = [Nitd].[Number]
AND [LetterRequest].[LetterID] = [Nitd].[LetterID]
AND [LetterRequest].[JobName] = CAST([Nitd].[JobID] AS VARCHAR(256))
AND [LetterRequest].[DueDate] = [Nitd].[Deposit]
AND [LetterRequest].[AmountDue] = [Nitd].[Amount]
WHERE [LetterRequest].[DateProcessed] = '1753-01-01 12:00 PM'
AND [LetterRequest].[DateRequested] = @LoadDate
AND [LetterRequest].[DateCreated] = @CreatedDate;

IF @@ERROR <> 0 GOTO ErrorHandler;

-- Insert the recipient records for each letter request using the address of the checking account
-- Added Bank Account address to coalesce when the wallet information is not available ie. payweb.
INSERT INTO [dbo].[LetterRequestRecipient] ([LetterRequestID], [AccountID], [Seq], [DebtorID], [DateCreated], [DateUpdated], [AltRecipient], [AltName], [AltStreet1], [AltStreet2], [AltCity], [AltState], [AltZipcode])
SELECT [Nitd].[RequestID],
	[Nitd].[Number],
	[Nitd].[Seq],
	[Nitd].[DebtorID],
	@CreatedDate AS [DateCreated],
	@CreatedDate AS [DateUpdated],
	CASE
		WHEN @SendNitdToDebtor IS NULL OR @SendNitdToDebtor = 0
		THEN 1
		ELSE 0
	END AS [AltRecipient],
	COALESCE([Wallet].[PayorName], dbi.AccountName, '') AS [AltName],
	COALESCE([WalletContact].[AccountAddress1], dbi.AccountAddress1, '') AS [AltStreet1],
	COALESCE([WalletContact].[AccountAddress2], dbi.AccountAddress2, '') AS [AltStreet2],
	COALESCE([WalletContact].[AccountCity], dbi.AccountCity, '') AS [AltCity],
	COALESCE([WalletContact].[AccountState], dbi.AccountState, '') AS [AltState],
	COALESCE([WalletContact].[AccountZipcode], dbi.AccountZipcode, '') AS [AltZipCode]
FROM @NitdLetters AS [Nitd]
INNER JOIN [dbo].[pdc]
ON [Nitd].[UID] = [pdc].[UID]
LEFT OUTER JOIN [dbo].[Wallet] [Wallet]
ON [Wallet].[PaymentVendorTokenId] = [pdc].[PaymentVendorTokenID]
LEFT OUTER JOIN [dbo].[WalletContact]
ON [WalletContact].[WalletId] = [Wallet].[Id]
LEFT OUTER JOIN DebtorBankInfo dbi WITH (NOLOCK) 
ON pdc.DebtorBankID = dbi.BankID
WHERE [Nitd].[RequestID] IS NOT NULL;

IF @@ERROR <> 0 GOTO ErrorHandler;

-- Remove the randomly generated GUID from the JobName of the generated letter requests
UPDATE [LetterRequest]
SET [JobName] = ''
FROM [dbo].[LetterRequest]
INNER JOIN @NitdLetters AS [Nitd]
ON [LetterRequest].[LetterRequestID] = [Nitd].[RequestID];

IF @@ERROR <> 0 GOTO ErrorHandler;

-- Update the PDC table that the NITD letter requests have been generated
UPDATE [pdc]
SET [nitd] = @LoadDate
FROM [dbo].[pdc]
INNER JOIN @NitdLetters AS [Nitd]
ON [pdc].[UID] = [Nitd].[UID]
WHERE [Nitd].[RequestID] IS NOT NULL;

IF @@ERROR <> 0 GOTO ErrorHandler;

COMMIT TRANSACTION;

RETURN 0;

ErrorHandler:
ROLLBACK TRANSACTION;
RETURN 1;
GO
