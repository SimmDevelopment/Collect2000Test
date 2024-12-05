CREATE TABLE [dbo].[DeskChangeHistory]
(
[Uid] [int] NOT NULL IDENTITY(1, 1),
[Number] [int] NOT NULL,
[JobNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldDesk] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewDesk] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldQLevel] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewQLevel] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldQDate] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewQDate] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OldBranch] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewBranch] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[User] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DMDateStamp] [datetime] NOT NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DeskChangeHistory_Number] ON [dbo].[DeskChangeHistory] ([Number]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk Change Transaction History', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Timestamp of update', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'DMDateStamp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'JobNumber associated with respective DeskMover Job', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'JobNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'BranchCode after update', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'NewBranch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk code after update', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'NewDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Qdate after update', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'NewQDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Qlevel after update', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'NewQLevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'Number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'BranchCode before update', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'OldBranch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk code before update', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'OldDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Qdate before update', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'OldQDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Qlevel before update', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'OldQLevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'Uid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'DeskChangeHistory', 'COLUMN', N'User'
GO
