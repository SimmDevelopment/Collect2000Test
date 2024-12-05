CREATE TABLE [dbo].[AIM_LedgerType]
(
[LedgerTypeId] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreditGroupTypeId] [int] NULL,
[DebitGroupTypeId] [int] NULL,
[IsSystem] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_LedgerType] ADD CONSTRAINT [PK_AIM_LedgerType] PRIMARY KEY CLUSTERED ([LedgerTypeId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'What group type will get credited for the ledger entry', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerType', 'COLUMN', N'CreditGroupTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'What group type will get debited for the ledger entry', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerType', 'COLUMN', N'DebitGroupTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag for PM system ledger entries', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerType', 'COLUMN', N'IsSystem'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerType', 'COLUMN', N'LedgerTypeId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerType', 'COLUMN', N'LedgerTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name or description for this type table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerType', 'COLUMN', N'Name'
GO
