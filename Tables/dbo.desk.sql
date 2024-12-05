CREATE TABLE [dbo].[desk]
(
[code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[priv] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[desktype] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[password] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fees] [money] NULL,
[collections] [money] NULL,
[mtdpdcfees] [money] NULL,
[mtdpdccollections] [money] NULL,
[mtdfees] [money] NULL,
[mtdcollections] [money] NULL,
[ytdfees] [money] NULL,
[ytdcollections] [money] NULL,
[Branch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QueueRptDays] [int] NULL,
[QueueRpt] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WaitDays] [int] NULL,
[MOnthlyGoal] [money] NULL,
[MonthlyCbrRequests] [int] NOT NULL,
[CbrRequests] [int] NOT NULL,
[CaseLimit] [int] NULL,
[EnforceLimit] [bit] NULL,
[dailylimit] [int] NULL,
[newbizdays] [int] NULL,
[maxfollowup] [int] NULL,
[CAlias] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Extension] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MonthlyGoal2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Special1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Special2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Special3] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Vpassword] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TeamID] [int] NULL,
[PreventLinking] [bit] NOT NULL CONSTRAINT [def_desk_PreventLinking] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[desk] ADD CONSTRAINT [Desk1] UNIQUE CLUSTERED ([code]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[desk] ADD CONSTRAINT [FK__Desk__TeamID__17E4190E] FOREIGN KEY ([TeamID]) REFERENCES [dbo].[Teams] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desks or desk codes are used to hold accounts for collection or other activity within Latitude. Users are assigned to the desk holding the accounts they need to work', 'SCHEMA', N'dbo', 'TABLE', N'desk', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'This column will be removed in a future version of Latitude. Reference the Branchcode table.  ', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'Branch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collector name inserted for letters where the Alias merge field is inserted', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'CAlias'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The maximum number of accounts that may be assigned to a desk', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'CaseLimit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Remaining CBR requests allowed', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'CbrRequests'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Defined Desk Code', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Collections  ', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'collections'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The number of accounts the desk will be allowed to set for follow-up work for any 24 hour period', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'dailylimit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Catogorized as:  Administrator, Supervisor, Collector, Clerical, Inventory , AIM', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'desktype'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Email address for the collector inserted for letters where the Email merge field is inserted.', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'Email'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Flag when set enforces Case Limit on Desk', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'EnforceLimit'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Phone extension used for collector inserted for letters where the Extension merge field is inserted', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'Extension'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Fees collected', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'fees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The most number of days ahead a follow-up date may be set for an account when assigned to this desk', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'maxfollowup'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The maximum number of credit bureau reports the desk code may request per month.  This number may not be set higher than 32,000', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'MonthlyCbrRequests'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of credit bureau reports the desk code should strive to attain for each month.  ', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'MOnthlyGoal'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of credit bureau reports the desk code should strive to attain for each alternative month.', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'MonthlyGoal2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total month to date Collections', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'mtdcollections'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total month to date Fees', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'mtdfees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total month to date PDC Collections', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'mtdpdccollections'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total month to date PDC Fees', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'mtdpdcfees'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Name', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of days new business must be worked while assigned to the desk.', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'newbizdays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Phone number used for collector inserted for letters where the Extension merge field is inserted', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'Phone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If set will prevent accounts belonging to desk from being linked by the linking application', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'PreventLinking'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Y/N flag that determines if account information for the desk should be included on the Collector Queue and Monthly Collections reports.', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'QueueRpt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The most number of days ahead a reminder may be set for an account when assigned to this desk', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'QueueRptDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of special request goals for the desk', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'Special1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of special request goals for the desk', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'Special2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of special request goals for the desk', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'Special3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Team Identity Key for assigned Team', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'TeamID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of days an account may be idle before it is prompted to be worked again while assigned to the desk', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'WaitDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total year to date Collections', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'ytdcollections'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total year to date Fees', 'SCHEMA', N'dbo', 'TABLE', N'desk', 'COLUMN', N'ytdfees'
GO
