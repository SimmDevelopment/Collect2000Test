CREATE TABLE [dbo].[SRG_ProductToken_Principal]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[SRG_ProductTokenID] [int] NOT NULL,
[AccountID] [int] NOT NULL,
[DebtorID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductToken_Principal] ADD CONSTRAINT [PK_SRG_ProductToken_Principal] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SRG_ProductToken_Principal_AccountID] ON [dbo].[SRG_ProductToken_Principal] ([AccountID], [DebtorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SRG_ProductToken_Principal_DebtorID] ON [dbo].[SRG_ProductToken_Principal] ([DebtorID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SRG_ProductToken_Principal_SRG_ProductTokenID] ON [dbo].[SRG_ProductToken_Principal] ([SRG_ProductTokenID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SRG_ProductToken_Principal] ADD CONSTRAINT [FK_SRG_ProductToken_Principal_Debtors] FOREIGN KEY ([DebtorID]) REFERENCES [dbo].[Debtors] ([DebtorID])
GO
ALTER TABLE [dbo].[SRG_ProductToken_Principal] ADD CONSTRAINT [FK_SRG_ProductToken_Principal_Master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Represents the principal association with a product token.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken_Principal', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Latitude filenumber that the product was requested for.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken_Principal', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The debtors.debtorid that the product was requested for if it applies to a debtor.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken_Principal', 'COLUMN', N'DebtorID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken_Principal', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to the SRG_ProductToken table that this record is associated with.', 'SCHEMA', N'dbo', 'TABLE', N'SRG_ProductToken_Principal', 'COLUMN', N'SRG_ProductTokenID'
GO
