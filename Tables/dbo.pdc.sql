CREATE TABLE [dbo].[pdc]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[number] [int] NULL,
[ctl] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PDC_Type] [tinyint] NULL,
[entered] [datetime] NULL,
[onhold] [datetime] NULL,
[processed1] [datetime] NULL,
[processedflag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[deposit] [datetime] NULL,
[amount] [money] NULL,
[checknbr] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQ] [int] NULL,
[LtrCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[nitd] [datetime] NULL,
[Desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fill1] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fill2] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fill3] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fill4] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fill5] [char] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SurCharge] [money] NULL,
[Printed] [bit] NULL,
[ApprovedBy] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PromiseMode] [tinyint] NULL,
[ProjectedFee] [money] NULL,
[UseProjectedFee] [bit] NOT NULL CONSTRAINT [DF__PDC__UseProjecte__6BEFBCE0] DEFAULT (0),
[Active] [bit] NOT NULL CONSTRAINT [DF__PDC__Active__5E2BAD6E] DEFAULT (1),
[CollectorFee] [money] NULL,
[DateCreated] [datetime] NULL CONSTRAINT [def_pdc_DateCreated] DEFAULT (getdate()),
[DateUpdated] [datetime] NULL CONSTRAINT [def_pdc_DateUpdated] DEFAULT (getdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrintedDate] [datetime] NULL,
[NSFCount] [int] NULL CONSTRAINT [DF__PDC__NSFCount__20795F0F] DEFAULT (0),
[ProcessStatus] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__PDC__ProcessStat__216D8348] DEFAULT ('Active'),
[SurchargeCheckNbr] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepositToGeneralTrust] [bit] NOT NULL CONSTRAINT [def_pdc_DepositToGeneralTrust] DEFAULT ((0)),
[DebtorBankID] [int] NULL,
[ArrangementID] [int] NULL,
[PaymentLinkUID] [int] NULL,
[IsBatched] [bit] NULL,
[PaymentVendorTokenId] [int] NULL,
[IsExternallyManaged] [bit] NULL CONSTRAINT [DF__pdc__IsExternallyManaged] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_pdc_DateStamps]
ON [dbo].[pdc]
FOR UPDATE
AS

UPDATE dbo.pdc
	SET DateUpdated = GETDATE()
FROM dbo.pdc
INNER JOIN INSERTED
ON pdc.UID = INSERTED.UID;

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_PDC_WalletValidations]
ON [dbo].[pdc]
FOR INSERT, UPDATE
AS

SET ROWCOUNT 0;
SET NOCOUNT ON;

IF EXISTS (SELECT * FROM INSERTED WHERE 
(UPDATE(Active) AND Active <> 0) OR 
(UPDATE(Printed) AND Printed = 1) OR 
(UPDATE(deposit) AND deposit IS NOT NULL) OR 
(UPDATE(IsBatched) AND IsBatched IS NOT NULL)) OR UPDATE(PaymentVendorTokenId)
BEGIN

	DECLARE @INS_TokenID INT, @TokenRecCount INT, @NumberRecCount INT;
	DECLARE @Number VARCHAR(20), @Link INT;
	
	SET @TokenRecCount = (SELECT COUNT(DISTINCT PaymentVendorTokenId) FROM INSERTED)
	SET @NumberRecCount = (SELECT COUNT(DISTINCT number) FROM INSERTED)
	
	IF @TokenRecCount <= 1 OR @NumberRecCount <= 1
	BEGIN
	
		SET @INS_TokenID = (SELECT DISTINCT PaymentVendorTokenId FROM INSERTED)
		SET @Number = (SELECT DISTINCT Number FROM INSERTED)
		
		IF @INS_TokenID IS NOT NULL
		BEGIN
			
			SELECT @Link = Link FROM master WHERE number = @Number;

			IF @Link <> 0 AND @Link IS NOT NULL
			BEGIN
				IF NOT EXISTS(SELECT * FROM Wallet WHERE PaymentVendorTokenId = @INS_TokenID AND (DebtorID IN (SELECT DebtorID FROM Debtors WHERE Number IN (SELECT Number FROM master WHERE Link = @Link) OR Number = @Number)))
				BEGIN
					DECLARE @Err1 VARCHAR(100) = 'Attempting to apply invalid payment instrument PaymentVendorTokenID: ' + CAST(@INS_TokenID AS VARCHAR(10)) + ' on File Number: ' + @Number
					RAISERROR (@Err1, 16, 1);
			
					ROLLBACK TRANSACTION;
					RETURN;
				END
			END
			ELSE
			BEGIN
				IF NOT EXISTS(SELECT * FROM Wallet WHERE PaymentVendorTokenId = @INS_TokenID AND DebtorID IN (SELECT DebtorID FROM Debtors WHERE Number = @Number))
				BEGIN
					DECLARE @Err2 VARCHAR(100) = 'Attempting to apply invalid payment instrument PaymentVendorTokenID: ' + CAST(@INS_TokenID AS VARCHAR(10)) + ' on File Number: ' + @Number
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
CREATE TRIGGER [dbo].[trg_pdc_WorkFlow_SystemEvents]
ON [dbo].[pdc]
FOR INSERT
AS

CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

INSERT INTO #EventAccounts ([AccountID], [EventVariable])
SELECT [INSERTED].[number], CAST(NULL AS SQL_VARIANT)
FROM [INSERTED]
WHERE NOT EXISTS (
	SELECT *
	FROM [dbo].[pdc]
	WHERE [pdc].[number] = [INSERTED].[number]
	AND NOT [pdc].[UID] = [INSERTED].[UID]
	AND [pdc].[Active] = 1
);

IF EXISTS (SELECT * FROM #EventAccounts) BEGIN
	EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Post-Dated Check Entered', @CreateNew = 0;
END;

DROP TABLE #EventAccounts;

RETURN;

GO
ALTER TABLE [dbo].[pdc] ADD CONSTRAINT [PK_pdc] PRIMARY KEY NONCLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Pdc_ArrangementID] ON [dbo].[pdc] ([ArrangementID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Pdc_DepositDate] ON [dbo].[pdc] ([deposit] DESC) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [PDC1] ON [dbo].[pdc] ([number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_pdc_PaymentLinkUID] ON [dbo].[pdc] ([PaymentLinkUID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[pdc] ADD CONSTRAINT [FK_pdc_PaymentVendorToken] FOREIGN KEY ([PaymentVendorTokenId]) REFERENCES [dbo].[PaymentVendorToken] ([Id])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Post Dated Check Transaction Table', 'SCHEMA', N'dbo', 'TABLE', N'pdc', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'When 1 Indicates execution of PDC transaction outstanding', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'Active'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dollar amount for the transaction ', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'amount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User or manager approving PDC', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'ApprovedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of Parent Arrangement', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'ArrangementID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors check number to print ', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'checknbr'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates the collector commission assigned to the payment if a collector commis', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'CollectorFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User ID of user creating PDC', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'ctl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer code account belongs to', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date PDC entered into system ', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date pdc last updated', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'DateUpdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date to process the post dated transaction ', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'deposit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Deposit amount to General Trust account when set', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'DepositToGeneralTrust'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk intitiating PDC', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'Desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Post Date entered into system', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'entered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag to represent whether or not the scheduled payment has been added to a Latitude payment batch.', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'IsBatched'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag to represent whether this is a vendor managed payment.  0 or Null for normal Latitude managed payment.', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'IsExternallyManaged'
GO
EXEC sp_addextendedproperty N'MS_Description', N'letter code of the notice of intent to deposit (NITD) letter that will be sent p', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'LtrCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates date NITD letter was sent', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'nitd'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FileNumber - Master.Number of account ', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator placing execution of transaction on hold ', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'onhold'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Virtual Key to link all the related payment items together.', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'PaymentLinkUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK into PaymentVendorToken table. Once the payment information has been authorized via the Latitude Payment Vendor Gateway, then a PaymentVendorToken record is created to be used for all future transactions for this bank information.', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'PaymentVendorTokenId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Paper draft, ACH etc.', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'PDC_Type'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date check printed or PDC processed via payment batch', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'Printed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'processed1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Override fee or surcharge amount to use', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'ProjectedFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 - Single Payment,2 - Monthly Payments,3 - Bi-Weekly Payments,4 - Twice a Month, 5 - Weekly, 6 - Settlement, 7 - MultipartSettlement, 8 - PayOff, 9 - Every28Days, 10 - EndOfMonth,  11 - BiMonthly, 12 - LastFriday, 99 - Multiple ', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'PromiseMode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary or paying Debtors sequence number', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'SEQ'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount your agency adds to the transaction, automatically calculated based on se', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'SurCharge'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Auto Generated Unique Identity for PDC ', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'UID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator which allows projected fee to be used', 'SCHEMA', N'dbo', 'TABLE', N'pdc', 'COLUMN', N'UseProjectedFee'
GO
