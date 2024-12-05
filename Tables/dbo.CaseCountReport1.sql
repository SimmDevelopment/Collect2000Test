CREATE TABLE [dbo].[CaseCountReport1]
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
EXEC sp_addextendedproperty N'MS_Description', N'Not used ', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport1', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used ', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport1', 'COLUMN', N'Company'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used ', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport1', 'COLUMN', N'ConsolIdated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used ', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport1', 'COLUMN', N'Current0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used ', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport1', 'COLUMN', N'CUSTOMER'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used ', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport1', 'COLUMN', N'CUSTOMERNAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used ', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport1', 'COLUMN', N'DESK'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used ', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport1', 'COLUMN', N'DESKNAME'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used ', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport1', 'COLUMN', N'RecordCount'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not used ', 'SCHEMA', N'dbo', 'TABLE', N'CaseCountReport1', 'COLUMN', N'TheAverage'
GO
