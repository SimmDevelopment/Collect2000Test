SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCreateNitdLetterFromPostDatedCreditCards]
	@DaysUntilDepositLow INTEGER = 5,
	@DaysUntilDepositHigh INTEGER = 10,
	@SendNitdToDebtor BIT = 0
AS
-- Name:		spCreateNitdLetterFromPostDatedCreditCards
-- Function:		This procedure will create NITD leter requests for post dated credit cards
-- Creation:		05/05/2006 jc
--					09/11/2006 jsb updated to conform to pdc letter request
-- Change History:	
--					01/04/2007 modified pdc update
--					01/18/2007 jbs updated to set SenderID/RequesterID from the user that set the DebtorCreditCard
--				12/04/2008 jbs  set alternate recipient of letter to credit card holder
--	 05/26/2022 BGM Updated to use the debtor credit card address and notes name from payweb entry if available when wallet's is null


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
	[RequestID] INTEGER NULL
);

BEGIN TRANSACTION;

-- Determine which post-dated credit cards have a pending NITD letter to be sent
-- Also determine which letter is to be sent and the requesting/sending user
INSERT INTO @NitdLetters ([Number], [Customer], [LetterID], [LetterCode], [Deposit], [Amount], [LoginName], [UserID], [CopyCustomer], [SaveImage], [DebtorID], [Seq], [UID])
SELECT [master].[number],
	[master].[customer],
	[letter].[LetterID],
	[letter].[code],
	[DebtorCreditCards].[DepositDate],
	[DebtorCreditCards].[Amount] + COALESCE([DebtorCreditCards].[Surcharge], 0) AS [Amount],
	COALESCE([Users].[LoginName], 'global') AS [LoginName],
	COALESCE([Users].[ID], 0) AS [UserID],
	[CustLtrAllow].[CopyCustomer],
	[CustLtrAllow].[SaveImage],
	[Debtors].[DebtorID],
	[Debtors].[Seq],
	[DebtorCreditCards].[ID]
FROM [dbo].[DebtorCreditCards] WITH (ROWLOCK, UPDLOCK)
INNER JOIN [dbo].[master]
ON [master].[number] = [DebtorCreditCards].[Number]
INNER JOIN [dbo].[Debtors]
ON [Debtors].[DebtorID] = [DebtorCreditCards].[DebtorID]
LEFT OUTER JOIN [dbo].[Users]
ON [Users].[LoginName] = [DebtorCreditCards].[CreatedBy]
INNER JOIN [dbo].[letter]
ON [letter].[code] = [DebtorCreditCards].[LetterCode]
INNER JOIN [dbo].[CustLtrAllow]
ON [CustLtrAllow].[CustCode] = [master].[customer]
AND [CustLtrAllow].[LtrCode] = [letter].[code]
WHERE [DebtorCreditCards].[DepositDate] BETWEEN DATEADD(DAY, @DaysUntilDepositLow, @LoadDate) AND DATEADD(DAY, @DaysUntilDepositHigh, @LoadDate)
AND [DebtorCreditCards].[NITDSendDate] IS NULL
AND [DebtorCreditCards].[IsActive] = 1
AND [DebtorCreditCards].[ApprovedBy] != ''
AND [DebtorCreditCards].[OnHoldDate] IS NULL;

IF @@ERROR <> 0 GOTO ErrorHandler;

-- Generate the letter request records for the pending NITD letters
-- Set the JobName to the randomly generated GUID to find this record and obtain the request ID
INSERT INTO [dbo].[LetterRequest] ([AccountID], [CustomerCode], [LetterID], [LetterCode], [DateRequested], [DateProcessed], [JobName], [DueDate], [AmountDue], [UserName], [SenderID], [RequesterID], [Suspend], [SifPmt1], [SifPmt2], [SifPmt3], [SifPmt4], [SifPmt5], [SifPmt6], [CopyCustomer], [SaveImage], [ProcessingMethod], [FutureID], [SubjDebtorID], [RecipientDebtorID], [RecipientDebtorSeq], [DateCreated], [DateUpdated])
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
	@CreatedDate AS [DateUpdated]
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

-- Insert the recipient records for each letter request using the address of the credit card account
-- 05/26/2022 BGM Updated to use the debtor credit card address and notes name from payweb entry if available when wallet's is null
INSERT INTO [dbo].[LetterRequestRecipient] ([LetterRequestID], [AccountID], [Seq], [DebtorID], [DateCreated], [DateUpdated], [AltRecipient], [AltName], [AltStreet1], [AltStreet2], [AltCity], [AltState], [AltZipcode], [SecureRecipientID])
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
	COALESCE([Wallet].[PayorName], (SELECT TOP 1 SUBSTRING(CONVERT(VARCHAR(255), comment), charindex( ':', CONVERT(VARCHAR(255), comment)) + 2, charindex( ',', CONVERT(VARCHAR(255), comment)) - (charindex( ':', CONVERT(VARCHAR(255), comment)) + 2))
FROM notes n WITH (NOLOCK) 
WHERE number = DebtorCreditCards.Number	AND user0 = 'payweb' AND CONVERT(VARCHAR(255), comment) LIKE '%I Agree%'), debtors.firstName + ' ' + debtors.lastName, '') AS [AltName],
	COALESCE([WalletContact].[AccountAddress1], DebtorCreditCards.Street1, '') AS [AltStreet1],
	COALESCE([WalletContact].[AccountAddress2], DebtorCreditCards.Street2,  '') AS [AltStreet2],
	COALESCE([WalletContact].[AccountCity], DebtorCreditCards.City, '') AS [AltCity],
	COALESCE([WalletContact].[AccountState], DebtorCreditCards.State,  '') AS [AltState],
	COALESCE([WalletContact].[AccountZipcode], DebtorCreditCards.Zipcode,  '') AS [AltZipCode],
	[DebtorCreditCards].[CCImageID] AS [SecureRecipientID]
FROM @NitdLetters AS [Nitd]
INNER JOIN [dbo].[DebtorCreditCards]
ON [Nitd].[UID] = [DebtorCreditCards].[ID]
INNER JOIN [dbo].[Debtors]
ON [Debtors].[DebtorID] = [Nitd].[DebtorID]
LEFT OUTER JOIN [dbo].[Wallet] [Wallet]
ON [Wallet].[PaymentVendorTokenId] = [DebtorCreditCards].[PaymentVendorTokenID]
LEFT OUTER JOIN [dbo].[WalletContact]
ON [WalletContact].[WalletId] = [Wallet].[Id]
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
UPDATE [DebtorCreditCards]
SET [NITDSendDate] = @LoadDate
FROM [dbo].[DebtorCreditCards]
INNER JOIN @NitdLetters AS [Nitd]
ON [DebtorCreditCards].[ID] = [Nitd].[UID]
WHERE [Nitd].[RequestID] IS NOT NULL;

IF @@ERROR <> 0 GOTO ErrorHandler;

COMMIT TRANSACTION;

RETURN 0;

ErrorHandler:
ROLLBACK TRANSACTION;
RETURN 1;
GO
