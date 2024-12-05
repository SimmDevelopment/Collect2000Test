CREATE TABLE [dbo].[AIM_LedgerMiscExtra]
(
[LedgerMiscExtraID] [int] NOT NULL IDENTITY(1, 1),
[LedgerID] [int] NULL,
[Title] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TheData] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID association to the AIM_Ledger table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMiscExtra', 'COLUMN', N'LedgerID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMiscExtra', 'COLUMN', N'LedgerMiscExtraID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The actual miscellaneous data associated with the ledger entry', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMiscExtra', 'COLUMN', N'TheData'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the data', 'SCHEMA', N'dbo', 'TABLE', N'AIM_LedgerMiscExtra', 'COLUMN', N'Title'
GO
