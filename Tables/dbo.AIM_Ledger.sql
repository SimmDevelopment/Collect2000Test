CREATE TABLE [dbo].[AIM_Ledger]
(
[LedgerId] [int] NOT NULL IDENTITY(1, 1),
[LedgerTypeId] [int] NULL,
[Comments] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Credit] [money] NULL CONSTRAINT [DF__AIM_Ledge__Credi__3148BC68] DEFAULT ((0)),
[Debit] [money] NULL CONSTRAINT [DF__AIM_Ledge__Debit__323CE0A1] DEFAULT ((0)),
[DateEntered] [datetime] NULL,
[PortfolioId] [int] NULL,
[Number] [int] NULL,
[DateCleared] [datetime] NULL,
[ToGroupId] [int] NULL,
[FromGroupId] [int] NULL,
[ToInvoiceId] [int] NULL,
[FromInvoiceId] [int] NULL,
[Status] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[soldportfolioid] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Ledger] ADD CONSTRAINT [PK_AIM_Ledger] PRIMARY KEY CLUSTERED ([LedgerId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AIM_Ledger_Number] ON [dbo].[AIM_Ledger] ([Number]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AIM_Ledger_Portfolio] ON [dbo].[AIM_Ledger] ([PortfolioId], [LedgerTypeId]) INCLUDE ([Number], [soldportfolioid]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_AIM_Ledger_LedgerTypeSoldPortfolio] ON [dbo].[AIM_Ledger] ([soldportfolioid], [LedgerTypeId]) INCLUDE ([DateEntered], [Number]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Ledger] WITH NOCHECK ADD CONSTRAINT [FK_AIM_Ledger_AIM_LedgerType] FOREIGN KEY ([LedgerTypeId]) REFERENCES [dbo].[AIM_LedgerType] ([LedgerTypeId])
GO
ALTER TABLE [dbo].[AIM_Ledger] WITH NOCHECK ADD CONSTRAINT [FK_AIM_Ledger_AIM_Portfolio] FOREIGN KEY ([PortfolioId]) REFERENCES [dbo].[AIM_Portfolio] ([PortfolioId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AIM_Ledger] WITH NOCHECK ADD CONSTRAINT [FK_AIM_Ledger_master] FOREIGN KEY ([Number]) REFERENCES [dbo].[master] ([number]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AIM_Ledger] NOCHECK CONSTRAINT [FK_AIM_Ledger_AIM_LedgerType]
GO
ALTER TABLE [dbo].[AIM_Ledger] NOCHECK CONSTRAINT [FK_AIM_Ledger_AIM_Portfolio]
GO
ALTER TABLE [dbo].[AIM_Ledger] NOCHECK CONSTRAINT [FK_AIM_Ledger_master]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Free form comments', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'Comments'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount to credit the purchased portfolio', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'Credit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date the entry was cleared', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'DateCleared'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the ledger entry was entered', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'DateEntered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The amount to debit the purchased portfolio', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'Debit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The group id associated where the money is coming from', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'FromGroupId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The invoice id for the money coming from', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'FromInvoiceId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'LedgerId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The type of ledger entry', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'LedgerTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The latitude file number = [Master].[number]', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'the associated portfolio', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'PortfolioId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'status of the entry (PENDING,APPROVED,DECLINED)', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The group id associated where the money is going', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'ToGroupId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The invoice id for the money going to', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Ledger', 'COLUMN', N'ToInvoiceId'
GO
