CREATE TABLE [dbo].[Reports_ExecutionHistory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[ReportID] [int] NOT NULL,
[RunDateTime] [datetime] NOT NULL CONSTRAINT [DF__Reports_E__RunDa__7CF4EFBA] DEFAULT (getdate()),
[Comment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Snapshot] [varbinary] (max) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reports_ExecutionHistory] ADD CONSTRAINT [PK_Reports_ExecutionHistory] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reports_ExecutionHistory] ADD CONSTRAINT [FK_Reports_ExecutionHistory_Reports_Master] FOREIGN KEY ([ReportID]) REFERENCES [dbo].[Reports_Master] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reports_ExecutionHistory] ADD CONSTRAINT [FK_Reports_ExecutionHistory_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'A user entered comment when saving a snapshot.', 'SCHEMA', N'dbo', 'TABLE', N'Reports_ExecutionHistory', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID from Reports_Master to identify the report that was run', 'SCHEMA', N'dbo', 'TABLE', N'Reports_ExecutionHistory', 'COLUMN', N'ReportID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the report was run', 'SCHEMA', N'dbo', 'TABLE', N'Reports_ExecutionHistory', 'COLUMN', N'RunDateTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The contents of the report in the event the user chose to save a snapshot of the report when run', 'SCHEMA', N'dbo', 'TABLE', N'Reports_ExecutionHistory', 'COLUMN', N'Snapshot'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID from Users to identify the user that ran the report', 'SCHEMA', N'dbo', 'TABLE', N'Reports_ExecutionHistory', 'COLUMN', N'UserID'
GO
