CREATE TABLE [dbo].[DeskChgDetails]
(
[JobID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JobDate] [datetime] NOT NULL,
[FileNumber] [int] NOT NULL,
[OldDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NewDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserID] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table used to retain desk change details and allow undo or reversal of changes made by Desk Distribution', 'SCHEMA', N'dbo', 'TABLE', N'DeskChgDetails', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account  FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'DeskChgDetails', 'COLUMN', N'FileNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of Job', 'SCHEMA', N'dbo', 'TABLE', N'DeskChgDetails', 'COLUMN', N'JobDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job ID associated with Desk Distribution', 'SCHEMA', N'dbo', 'TABLE', N'DeskChgDetails', 'COLUMN', N'JobID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Desk Code', 'SCHEMA', N'dbo', 'TABLE', N'DeskChgDetails', 'COLUMN', N'NewDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Previous Desk Code', 'SCHEMA', N'dbo', 'TABLE', N'DeskChgDetails', 'COLUMN', N'OldDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'DeskChgDetails', 'COLUMN', N'UserID'
GO
