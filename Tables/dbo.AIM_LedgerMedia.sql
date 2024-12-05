CREATE TABLE [dbo].[AIM_LedgerMedia]
(
[LedgerMediaID] [int] NOT NULL IDENTITY(1, 1),
[LedgerID] [int] NOT NULL,
[WantsStatements] [bit] NULL CONSTRAINT [DF__AIM_Ledge__Wants__0BE22D8F] DEFAULT ((0)),
[StatementStartDate] [datetime] NULL,
[StatementEndDate] [datetime] NULL,
[StatementsCount] [int] NULL CONSTRAINT [DF__AIM_Ledge__State__0CD651C8] DEFAULT ((0)),
[StatementTotalCost] [money] NULL CONSTRAINT [DF__AIM_Ledge__State__0DCA7601] DEFAULT ((0)),
[StatementComment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WantsApplication] [bit] NULL CONSTRAINT [DF__AIM_Ledge__Wants__0EBE9A3A] DEFAULT ((0)),
[ApplicationTotalCost] [money] NULL CONSTRAINT [DF__AIM_Ledge__Appli__0FB2BE73] DEFAULT ((0)),
[ApplicationComment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WantsLenderAffidavit] [bit] NULL CONSTRAINT [DF__AIM_Ledge__Wants__10A6E2AC] DEFAULT ((0)),
[LenderAffidavitTotalCost] [money] NULL CONSTRAINT [DF__AIM_Ledge__Lende__119B06E5] DEFAULT ((0)),
[LenderAffidavitComment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WantsThirdPartyAffidavit] [bit] NULL CONSTRAINT [DF__AIM_Ledge__Wants__128F2B1E] DEFAULT ((0)),
[ThirdPartyAffidavitTotalCost] [money] NULL CONSTRAINT [DF__AIM_Ledge__Third__13834F57] DEFAULT ((0)),
[ThirdPartyAffidavitComment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WantsAffidavitLostLoanDoc] [bit] NULL CONSTRAINT [DF__AIM_Ledge__Wants__14777390] DEFAULT ((0)),
[AffidavitLostLoanDocTotalCost] [money] NULL CONSTRAINT [DF__AIM_Ledge__Affid__156B97C9] DEFAULT ((0)),
[AffidavitLostLoanDocComment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WantsLastPayment] [bit] NULL CONSTRAINT [DF__AIM_Ledge__Wants__165FBC02] DEFAULT ((0)),
[LastPaymentTotalCost] [money] NULL CONSTRAINT [DF__AIM_Ledge__LastP__1753E03B] DEFAULT ((0)),
[LastPaymentComment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WantsContract] [bit] NULL CONSTRAINT [DF__AIM_Ledge__Wants__18480474] DEFAULT ((0)),
[ContractTotalCost] [money] NULL CONSTRAINT [DF__AIM_Ledge__Contr__193C28AD] DEFAULT ((0)),
[ContractComment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WantsPaymentChecks] [bit] NULL CONSTRAINT [DF__AIM_Ledge__Wants__1A304CE6] DEFAULT ((0)),
[PaymentChecksStartDate] [datetime] NULL,
[PaymentChecksEndDate] [datetime] NULL,
[PaymentChecksCount] [int] NULL CONSTRAINT [DF__AIM_Ledge__Payme__1B24711F] DEFAULT ((0)),
[PaymentChecksTotalCost] [money] NULL CONSTRAINT [DF__AIM_Ledge__Payme__1C189558] DEFAULT ((0)),
[PaymentChecksComment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WantsOtherMedia] [bit] NULL CONSTRAINT [DF__AIM_Ledge__Wants__1D0CB991] DEFAULT ((0)),
[OtherMediaCost] [money] NULL CONSTRAINT [DF__AIM_Ledge__Other__1E00DDCA] DEFAULT ((0)),
[OtherMediaComment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StorageLocation] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'AffidavitLostLoanDocComment', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'AffidavitLostLoanDocComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AffidavitLostLoanDocTotalCost', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'AffidavitLostLoanDocTotalCost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ApplicationComment', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'ApplicationComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ApplicationTotalCost', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'ApplicationTotalCost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ContractComment', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'ContractComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ContractTotalCost', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'ContractTotalCost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'LastPaymentComment', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'LastPaymentComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'LastPaymentTotalCost', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'LastPaymentTotalCost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated ledger entry id', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'LedgerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'LedgerMediaID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'LenderAffidavitComment', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'LenderAffidavitComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'LenderAffidavitTotalCost', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'LenderAffidavitTotalCost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OtherMediaComment', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'OtherMediaComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OtherMediaCost', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'OtherMediaCost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PaymentChecksComment', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'PaymentChecksComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PaymentChecksCount', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'PaymentChecksCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PaymentChecksEndDate', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'PaymentChecksEndDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PaymentChecksStartDate', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'PaymentChecksStartDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'PaymentChecksTotalCost', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'PaymentChecksTotalCost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'StatementComment', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'StatementComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'StatementEndDate', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'StatementEndDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'StatementsCount', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'StatementsCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'StatementStartDate', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'StatementStartDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'StatementTotalCost', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'StatementTotalCost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'StorageLocation', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'StorageLocation'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ThirdPartyAffidavitComment', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'ThirdPartyAffidavitComment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ThirdPartyAffidavitTotalCost', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'ThirdPartyAffidavitTotalCost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'WantsAffidavitLostLoanDoc', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'WantsAffidavitLostLoanDoc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'WantsApplication', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'WantsApplication'
GO
EXEC sp_addextendedproperty N'MS_Description', N'WantsContract', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'WantsContract'
GO
EXEC sp_addextendedproperty N'MS_Description', N'WantsLastPayment', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'WantsLastPayment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'WantsLenderAffidavit', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'WantsLenderAffidavit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'WantsOtherMedia', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'WantsOtherMedia'
GO
EXEC sp_addextendedproperty N'MS_Description', N'WantsPaymentChecks', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'WantsPaymentChecks'
GO
EXEC sp_addextendedproperty N'MS_Description', N'WantsStatements', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'WantsStatements'
GO
EXEC sp_addextendedproperty N'MS_Description', N'WantsThirdPartyAffidavit', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMedia', 'COLUMN', N'WantsThirdPartyAffidavit'
GO
