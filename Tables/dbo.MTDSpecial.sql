CREATE TABLE [dbo].[MTDSpecial]
(
[CUSTOMER] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESK] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eom] [datetime] NULL,
[DeskNAME] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerNAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MTDGross] [money] NULL,
[MTDFees] [money] NULL,
[MTDPDCgross] [money] NULL,
[MTDPDCFees] [money] NULL,
[MTDNumber] [money] NULL,
[MTDDollars] [money] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table used by Standard Latitude Reports', 'SCHEMA', N'dbo', 'TABLE', N'MTDSpecial', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'MTDSpecial', 'COLUMN', N'CUSTOMER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Name', 'SCHEMA', N'dbo', 'TABLE', N'MTDSpecial', 'COLUMN', N'CustomerNAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Code', 'SCHEMA', N'dbo', 'TABLE', N'MTDSpecial', 'COLUMN', N'DESK'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Name', 'SCHEMA', N'dbo', 'TABLE', N'MTDSpecial', 'COLUMN', N'DeskNAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'End of Month ', 'SCHEMA', N'dbo', 'TABLE', N'MTDSpecial', 'COLUMN', N'eom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Fees earned', 'SCHEMA', N'dbo', 'TABLE', N'MTDSpecial', 'COLUMN', N'MTDFees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Gross collections', 'SCHEMA', N'dbo', 'TABLE', N'MTDSpecial', 'COLUMN', N'MTDGross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date transactions', 'SCHEMA', N'dbo', 'TABLE', N'MTDSpecial', 'COLUMN', N'MTDNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date PDC fees', 'SCHEMA', N'dbo', 'TABLE', N'MTDSpecial', 'COLUMN', N'MTDPDCFees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Gross PDC', 'SCHEMA', N'dbo', 'TABLE', N'MTDSpecial', 'COLUMN', N'MTDPDCgross'
GO
