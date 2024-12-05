CREATE TABLE [dbo].[ImportCoDebtors]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[ImportAccountID] [int] NOT NULL,
[Seq] [tinyint] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HomePhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[WorkPhone] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSN] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImportCoDebtors] ADD CONSTRAINT [PK_ImportCoDebtors] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table used by Import Excel', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'CoDebtors City', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CoDebtors date of Birth', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'DOB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CoDebtors Home Phone', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'HomePhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parent Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'ImportAccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CoDebtors Full Name (Last, M, First)', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence number of debtor , must be > 0, primary debtor = 0', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'Seq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CoDebtors Social Security Number (SSN)', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CoDebtors State', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CoDebtors street address line 1', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CoDebtors street address line 2', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'UID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CoDebtors Work Phone', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'WorkPhone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'CoDebtors Zipcode', 'SCHEMA', N'dbo', 'TABLE', N'ImportCoDebtors', 'COLUMN', N'Zipcode'
GO
