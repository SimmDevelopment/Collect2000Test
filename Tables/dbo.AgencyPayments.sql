CREATE TABLE [dbo].[AgencyPayments]
(
[Number] [int] NULL,
[AmtPaid] [money] NULL,
[DatePaid] [datetime] NULL,
[PmtType] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgcyCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processed] [bit] NULL,
[PmtFileName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPayments', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPayments', 'COLUMN', N'AgcyCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPayments', 'COLUMN', N'AmtPaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPayments', 'COLUMN', N'DatePaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPayments', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPayments', 'COLUMN', N'PmtFileName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPayments', 'COLUMN', N'PmtType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'AgencyPayments', 'COLUMN', N'Processed'
GO
