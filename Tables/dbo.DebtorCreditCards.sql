CREATE TABLE [dbo].[DebtorCreditCards]
(
[Number] [int] NOT NULL,
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CardNumber] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPMonth] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EXPYear] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditCard] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NULL,
[Printed] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApprovedBy] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Approved] [datetime] NULL,
[Code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1),
[CollectorFee] [money] NULL,
[DebtorID] [int] NULL,
[DateEntered] [smalldatetime] NOT NULL CONSTRAINT [DF__DebtorCre__DateE__08E10149] DEFAULT (convert(smalldatetime,convert(varchar,getdate(),107))),
[DepositDate] [smalldatetime] NOT NULL CONSTRAINT [DF__DebtorCre__Depos__09D52582] DEFAULT (convert(smalldatetime,convert(varchar,getdate(),107))),
[NITDSentDate] [datetime] NULL,
[OnHoldDate] [smalldatetime] NULL,
[LetterCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NITDSendDate] [smalldatetime] NULL,
[ProjectedFee] [money] NULL,
[UseProjectedFee] [bit] NOT NULL CONSTRAINT [DF__DebtorCre__UsePr__0AC949BB] DEFAULT (0),
[Surcharge] [money] NOT NULL CONSTRAINT [DF__DebtorCre__Surch__0BBD6DF4] DEFAULT (0),
[IsActive] [bit] NOT NULL CONSTRAINT [DF__DebtorCre__IsAct__0CB1922D] DEFAULT (1),
[PromiseMode] [tinyint] NULL CONSTRAINT [DF__DebtorCre__Promi__0DA5B666] DEFAULT (1),
[AuthDate] [smalldatetime] NULL,
[AuthCode] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthErrCode] [int] NULL,
[AuthErrDesc] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthAVS] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthCVV2] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AuthSource] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BatchNumber] [int] NULL,
[DateCreated] [datetime] NULL CONSTRAINT [def_DebtorCreditCards_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NULL CONSTRAINT [def_DebtorCreditCards_DateUpdated] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrintedDate] [datetime] NULL,
[NSFCount] [int] NULL CONSTRAINT [DF__DebtorCre__NSFCo__1F853AD6] DEFAULT (0),
[ProcessStatus] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__DebtorCre__Proce__2261A781] DEFAULT ('Active'),
[CCImageId] [uniqueidentifier] NULL,
[AuthReferenceNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepositToGeneralTrust] [bit] NOT NULL CONSTRAINT [def_DebtorCreditCard_DepositToGeneralTrust] DEFAULT ((0)),
[DepositSurchargeToOperatingTrust] [bit] NOT NULL CONSTRAINT [def_DebtorCreditCard_DepositSurchargeToOperatingTrust] DEFAULT ((0)),
[ArrangementID] [int] NULL,
[PaymentVendorTokenId] [int] NULL,
[PaymentLinkUID] [int] NULL,
[IsBatched] [bit] NULL,
[IsExternallyManaged] [bit] NULL CONSTRAINT [DF__DebtorCreditCards__IsExternallyManaged] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_DebtorCreditCards_DateStamps]
ON [dbo].[DebtorCreditCards]
FOR UPDATE
AS

UPDATE dbo.DebtorCreditCards
	SET DateUpdated = GETDATE()
FROM dbo.DebtorCreditCards
INNER JOIN INSERTED
ON DebtorCreditCards.ID = INSERTED.ID;

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_DebtorCreditCards_WalletValidation]
ON [dbo].[DebtorCreditCards]
FOR INSERT, UPDATE
AS

SET ROWCOUNT 0;
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM INSERTED WHERE 
(UPDATE(IsActive) AND IsActive <> 0) OR 
(UPDATE(Printed) AND (Printed = 'Y' OR Printed = '1')) OR 
(UPDATE(DepositDate) AND DepositDate IS NOT NULL) OR 
(UPDATE(IsBatched) AND IsBatched IS NOT NULL)) OR UPDATE(PaymentVendorTokenId)
BEGIN

	DECLARE @INS_TokenID INT, @TokenRecCount INT, @DebtorRecCount INT;
	DECLARE @DebtorID INT, @Link INT;
	
	SET @TokenRecCount = (SELECT COUNT(DISTINCT PaymentVendorTokenId) FROM INSERTED)
	SET @DebtorRecCount = (SELECT COUNT(DISTINCT DebtorID) FROM INSERTED)
	
	IF @TokenRecCount <= 1 OR @DebtorRecCount <= 1
	BEGIN
	
		SET @INS_TokenID = (SELECT DISTINCT PaymentVendorTokenId FROM INSERTED)

		IF @INS_TokenID IS NOT NULL
		BEGIN
			
			SET @DebtorID = (SELECT DISTINCT DebtorID FROM INSERTED)
			
			IF @DebtorID IS NULL OR @DebtorID <= 0
			BEGIN
				SET @DebtorID = (SELECT DISTINCT DebtorId FROM dbo.DebtorCreditCards
				WHERE ID IN (SELECT ID FROM INSERTED))
			END
			
			SELECT @Link = Link FROM master WHERE number IN (SELECT Number FROM Debtors WHERE DebtorID = @DebtorID);
			
			IF @Link <> 0 AND @Link IS NOT NULL
			BEGIN
				
				IF NOT EXISTS(SELECT * FROM Wallet WHERE PaymentVendorTokenId = @INS_TokenID AND ((DebtorID IN (SELECT DebtorID FROM Debtors WHERE Number IN (SELECT Number FROM master WHERE Link = @Link))) OR DebtorID = @DebtorID))
				BEGIN
					DECLARE @Err1 VARCHAR(100) = 'Attempting to apply invalid payment instrument PaymentVendorTokenID: ' + CAST(@INS_TokenID AS VARCHAR(10)) + ' on Debtor ID: ' + CAST(@DebtorID AS VARCHAR(10))
					RAISERROR (@Err1, 16, 1);
			
					ROLLBACK TRANSACTION;
					RETURN;
				END
			END
			ELSE
			BEGIN
				IF NOT EXISTS(SELECT * FROM Wallet WHERE PaymentVendorTokenId = @INS_TokenID AND DebtorID = @DebtorID)
				BEGIN
					DECLARE @Err2 VARCHAR(100) = 'Attempting to apply invalid payment instrument PaymentVendorTokenID: ' + CAST(@INS_TokenID AS VARCHAR(10)) + ' on Debtor ID: ' + CAST(@DebtorID AS VARCHAR(10))
					RAISERROR (@Err2, 16, 1);
			
					ROLLBACK TRANSACTION;
					RETURN;

				END;
			END;
			
		END;
	END;
END;
RETURN;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_DebtorCreditCards_WorkFlow_SystemEvents]
ON [dbo].[DebtorCreditCards]
FOR INSERT
AS

CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

INSERT INTO #EventAccounts ([AccountID], [EventVariable])
SELECT [INSERTED].[Number], CAST(NULL AS SQL_VARIANT)
FROM [INSERTED]
WHERE NOT EXISTS (
	SELECT *
	FROM [dbo].[DebtorCreditCards]
	WHERE [DebtorCreditCards].[Number] = [INSERTED].[Number]
	AND [DebtorCreditCards].[ID] <> [INSERTED].[ID]
	AND [DebtorCreditCards].[IsActive] = 1
);

IF EXISTS (SELECT * FROM #EventAccounts) BEGIN
	EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Post-Dated Credit Card Entered', @CreateNew = 0;
END;

DROP TABLE #EventAccounts;

RETURN;

GO
ALTER TABLE [dbo].[DebtorCreditCards] ADD CONSTRAINT [PK_DebtorCreditCards] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DebtorCreditCards_ArrangementID] ON [dbo].[DebtorCreditCards] ([ArrangementID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DebtorCreditCards_DepositDate] ON [dbo].[DebtorCreditCards] ([DepositDate] DESC) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DebtorCreditCards_number] ON [dbo].[DebtorCreditCards] ([Number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DebtorCreditCards_PaymentLinkUID] ON [dbo].[DebtorCreditCards] ([PaymentLinkUID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DebtorCreditCards] ADD CONSTRAINT [FK_DebtorCreditCards_PaymentVendorToken] FOREIGN KEY ([PaymentVendorTokenId]) REFERENCES [dbo].[PaymentVendorToken] ([Id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Post Dated Credit Card Transaction Table', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of payment', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'Amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp post date approved', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'Approved'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name approving post date', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'ApprovedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of Parent Arrangement', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'ArrangementID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Authorization Code', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'AuthCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location code of security code', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'AuthCVV2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Authorization DateTimeStamp', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'AuthDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Authorization Error Code', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'AuthErrCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Authorization Error Description', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'AuthErrDesc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Authorization Reference number', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'AuthReferenceNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude PaymentBatch Batch number', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'BatchNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Credit card number', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'CardNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of encrypted credit card information', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'CCImageId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'City of credit card holder', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Card Security code', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount based on Collector fee schedule of customer or projected fee schedule ', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'CollectorFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name ', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Internal code for credit card (CreditCardTypes code)', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'CreditCard'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp created', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp transaction entered', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'DateEntered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimStamp of last update', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Debtor Identity ID of debtor on account', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Due date of transaction', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'DepositDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deposit surcharge to operationg trust when set', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'DepositSurchargeToOperatingTrust'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deposit amount to General Trust account when set', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'DepositToGeneralTrust'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Expiration month of card', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'EXPMonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Experation year of card', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'EXPYear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key of transaction ', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Active NonActive indicator', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'IsActive'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag to represent whether or not the scheduled payment has been added to a Latitude payment batch.', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'IsBatched'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag to represent whether this is a vendor managed payment.  0 or Null for normal Latitude managed payment.', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'IsExternallyManaged'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Letter code of NITD letter', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'LetterCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of credit card holder', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used.  Reserved for Future Use.', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'NITDSendDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp that Notice of intent to deposit letter was processed and sent to Debtor', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'NITDSentDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp transaction was put into a hold state', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'OnHoldDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Virtual Key to link all the related payment items together.', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'PaymentLinkUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK into PaymentVendorToken table. Once the payment information has been authorized via the Latitude Payment Vendor Gateway, then a PaymentVendorToken record is created to be used for all future transactions for this scheduled payment.', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'PaymentVendorTokenId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Y/N flag indicating transaction processed', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'Printed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp Deposit Printed', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'PrintedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Projected Fee amount based on Customer Fee schedule', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'ProjectedFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 - Single Payment,2 - Monthly Payments,3 - Bi-Weekly Payments,4 - Twice a Month, 5 - Weekly, 6 - Settlement, 7 - MultipartSettlement, 8 - PayOff, 9 - Every28Days, 10 - EndOfMonth,  11 - BiMonthly, 12 - LastFriday, 99 - Multiple', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'PromiseMode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State of credit card holder', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 1 of credit card holder', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address line 2 of credit card holder', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surcharge amount in addition to Amount of payment or portion of payment amount based on user selection', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'Surcharge'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when not set accepts manual entry Fee from collector', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'UseProjectedFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Zipcode of credit card holder', 'SCHEMA', N'dbo', 'TABLE', N'DebtorCreditCards', 'COLUMN', N'Zipcode'
GO
