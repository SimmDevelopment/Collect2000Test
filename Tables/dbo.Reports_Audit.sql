CREATE TABLE [dbo].[Reports_Audit]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserID] [int] NOT NULL,
[ReportID] [int] NOT NULL,
[Created] [datetime] NOT NULL CONSTRAINT [DF__Reports_A__Creat__04961182] DEFAULT (getdate()),
[Comment] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Action] [tinyint] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reports_Audit] ADD CONSTRAINT [PK_Reports_Audit] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Reports_Audit] ADD CONSTRAINT [FK_Reports_Audit_Reports_Master] FOREIGN KEY ([ReportID]) REFERENCES [dbo].[Reports_Master] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reports_Audit] ADD CONSTRAINT [FK_Reports_Audit_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'A magic number indicating the action that triggered the creation of this record.', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Audit', 'COLUMN', N'Action'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A textual description of the action taken, suitable for reporting.', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Audit', 'COLUMN', N'Comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time this record created.', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Audit', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID from Reports_Master to identify the report that was run', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Audit', 'COLUMN', N'ReportID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID from Users to identify the user that ran the report', 'SCHEMA', N'dbo', 'TABLE', N'Reports_Audit', 'COLUMN', N'UserID'
GO
