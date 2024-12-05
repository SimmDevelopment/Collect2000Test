CREATE TABLE [dbo].[MTDCollectionsByCust]
(
[Customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SystemUser] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eom] [datetime] NULL,
[NAME] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MTDGross] [money] NULL,
[MTDFees] [money] NULL,
[MTDPDCgross] [money] NULL,
[MTDPDCFees] [money] NULL,
[UserID] [int] NULL,
[BranchCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table used by Standard Latitude Reports', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByCust', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branch where account is located', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByCust', 'COLUMN', N'BranchCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByCust', 'COLUMN', N'Customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'End of Month ', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByCust', 'COLUMN', N'eom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Fees earned', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByCust', 'COLUMN', N'MTDFees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Gross collections', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByCust', 'COLUMN', N'MTDGross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date PDC fees', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByCust', 'COLUMN', N'MTDPDCFees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Gross PDC', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByCust', 'COLUMN', N'MTDPDCgross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Name', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByCust', 'COLUMN', N'NAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByCust', 'COLUMN', N'SystemUser'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Identity running report', 'SCHEMA', N'dbo', 'TABLE', N'MTDCollectionsByCust', 'COLUMN', N'UserID'
GO
