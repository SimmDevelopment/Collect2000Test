CREATE TABLE [dbo].[DebtorAssetType]
(
[ID] [tinyint] NOT NULL IDENTITY(0, 1),
[Code] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAssetType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'A code to use for the debtor asset type, this is unique', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAssetType', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAssetType', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The description of the debtor asset, we will ship the previous 7 debtor asset types that were available in the drop down, this value will contain what was in the drop down', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAssetType', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Data', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAssetType', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The unique id of the debtor asset type, this will be stamped in Legal_Ledger', 'SCHEMA', N'dbo', 'TABLE', N'DebtorAssetType', 'COLUMN', N'ID'
GO
