CREATE TABLE [dbo].[MTDCUSTOMER]
(
[CUSTOMER] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[eom] [datetime] NULL,
[NAME] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MTDGross] [money] NULL,
[MTDFees] [money] NULL,
[MTDPDCgross] [money] NULL,
[MTDPDCFees] [money] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table used by Standard Latitude Reports', 'SCHEMA', N'dbo', 'TABLE', N'MTDCUSTOMER', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'MTDCUSTOMER', 'COLUMN', N'CUSTOMER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'End of Month ', 'SCHEMA', N'dbo', 'TABLE', N'MTDCUSTOMER', 'COLUMN', N'eom'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Fees earned', 'SCHEMA', N'dbo', 'TABLE', N'MTDCUSTOMER', 'COLUMN', N'MTDFees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Gross collections', 'SCHEMA', N'dbo', 'TABLE', N'MTDCUSTOMER', 'COLUMN', N'MTDGross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date PDC fees', 'SCHEMA', N'dbo', 'TABLE', N'MTDCUSTOMER', 'COLUMN', N'MTDPDCFees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Month to date Gross PDC', 'SCHEMA', N'dbo', 'TABLE', N'MTDCUSTOMER', 'COLUMN', N'MTDPDCgross'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Name', 'SCHEMA', N'dbo', 'TABLE', N'MTDCUSTOMER', 'COLUMN', N'NAME'
GO
