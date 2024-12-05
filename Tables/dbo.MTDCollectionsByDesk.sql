CREATE TABLE [dbo].[MTDCollectionsByDesk]
(
[DESK] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[branchname] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[branch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[systemUser] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eom] [datetime] NULL,
[NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MTDGross] [money] NULL,
[MTDFees] [money] NULL,
[MTDPDCgross] [money] NULL,
[MTDPDCFees] [money] NULL,
[UserID] [int] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table used by Standard Latitude Reports', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByDesk', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'BranchCode', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByDesk', 'COLUMN', N'branch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branch where accounts are located', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByDesk', 'COLUMN', N'branchname'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Code where accounts are located', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByDesk', 'COLUMN', N'DESK'
GO
EXEC sp_addextendedproperty N'MS_Description', N'End of Month ', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByDesk', 'COLUMN', N'eom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Fees earned', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByDesk', 'COLUMN', N'MTDFees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Gross collections', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByDesk', 'COLUMN', N'MTDGross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date PDC fees', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByDesk', 'COLUMN', N'MTDPDCFees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Gross PDC', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByDesk', 'COLUMN', N'MTDPDCgross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Name', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByDesk', 'COLUMN', N'NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByDesk', 'COLUMN', N'systemUser'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Identity running report', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByDesk', 'COLUMN', N'UserID'
GO
