CREATE TABLE [dbo].[ImportDebtors]
(
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[homephone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[workphone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Spouse] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpouseWP] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table used by Import Excel', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parent Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', 'COLUMN', N'account'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors City', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Home Phone', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', 'COLUMN', N'homephone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors name', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse name', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', 'COLUMN', N'Spouse'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Spouse work Phone', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', 'COLUMN', N'SpouseWP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Social Security Number (SSN)', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors State', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors street address line 1', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors street address line 2', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Work Phone', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', 'COLUMN', N'workphone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Debtors Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'ImportDebtors', 'COLUMN', N'Zipcode'
GO
