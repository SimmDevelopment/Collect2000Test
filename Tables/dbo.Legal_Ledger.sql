CREATE TABLE [dbo].[Legal_Ledger]
(
[Legal_LedgerID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ItemDate] [datetime] NOT NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DebitAmt] [money] NOT NULL CONSTRAINT [DF_Legal_Ledger_DebitAmt] DEFAULT (0),
[CreditAmt] [money] NOT NULL CONSTRAINT [DF_Legal_Ledger_CreditAmt] DEFAULT (0),
[PayhistoryID] [int] NULL,
[Invoiceable] [bit] NULL,
[Invoice] [int] NULL,
[LegalLedgerTypeID] [int] NULL,
[AIMID] [int] NULL,
[AIMUniqueID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AIMInvoiceID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__Legal_Ledger__Created] DEFAULT (getdate()),
[ApprovedAmount] [money] NULL,
[ApprovedOn] [datetime] NULL,
[ApprovedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountingLedgerID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ExportedForApprovalOn] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Legal_Ledger] ADD CONSTRAINT [PK_Legal_Ledger] PRIMARY KEY CLUSTERED ([Legal_LedgerID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Legal_Ledger_AccountID] ON [dbo].[Legal_Ledger] ([AccountID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Legal_Ledger_Customer] ON [dbo].[Legal_Ledger] ([Customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'An identifier for an outside general ledger system, this should correspond to a check number or invoice id from the GL', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'AccountingLedgerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The AIM Entity (if applicable) that made this entry, relates to AIM_Agency.AgencyID', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'AIMID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The invoice Identifier from the outside AIM entities system, will not be unique', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'AIMInvoiceID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Unique ID of the transaction in the outside AIM entities system, should be unique by AIMID', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'AIMUniqueID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount approved by Legal and Accounting, if NULL then the ledger entry has not yet been approved', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'ApprovedAmount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The entity approving the ledger entry', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'ApprovedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The DateTime stamp that the ledger entries were approved', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'ApprovedOn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The DateTime stamp for the creation of this Ledger entry', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of item.  May be defined by user.  Default items include: ', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used to track what ledger entries have been exported for approval so they do not get exported again.', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'ExportedForApprovalOn'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp Item Entered into system', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'ItemDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity ID', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'Legal_LedgerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Ledger Type ID from the LegalLedgerType table, for entries made in previous versions this will be NULL', 'SCHEMA', N'dbo', 'TABLE', N'Legal_Ledger', 'COLUMN', N'LegalLedgerTypeID'
GO
