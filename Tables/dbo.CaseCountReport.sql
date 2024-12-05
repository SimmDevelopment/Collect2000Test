CREATE TABLE [dbo].[CaseCountReport]
(
[DESK] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESKNAME] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMER] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConsolIdated] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CUSTOMERNAME] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordCount] [int] NULL,
[TheAverage] [money] NULL,
[Current0] [money] NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Aggregate table used to build case count totals for the Case Count report.  This report lists the number of active accounts assigned to each desk for each customer', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Company Name', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport', 'COLUMN', N'Company'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Current Balance', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport', 'COLUMN', N'Current0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Code', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport', 'COLUMN', N'CUSTOMER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer Name', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport', 'COLUMN', N'CUSTOMERNAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Code', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport', 'COLUMN', N'DESK'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Name', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport', 'COLUMN', N'DESKNAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Accounts', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport', 'COLUMN', N'RecordCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Average account total current balance', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport', 'COLUMN', N'TheAverage'
GO
