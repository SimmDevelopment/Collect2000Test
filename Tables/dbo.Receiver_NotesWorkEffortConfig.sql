CREATE TABLE [dbo].[Receiver_NotesWorkEffortConfig]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ClientId] [int] NOT NULL,
[ActionCategory] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActionCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[action] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[result] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionText] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Receiver_NotesWorkEffortConfig] ADD CONSTRAINT [PK_Receiver_NotesWorkEffortConfig] PRIMARY KEY NONCLUSTERED ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table contains work effort configuration related to notes for an agency', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_NotesWorkEffortConfig', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key from the action column of the dbo.Notes table', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_NotesWorkEffortConfig', 'COLUMN', N'action'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The category of the work effort', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_NotesWorkEffortConfig', 'COLUMN', N'ActionCategory'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The action code of the work effort', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_NotesWorkEffortConfig', 'COLUMN', N'ActionCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The text of the work effort', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_NotesWorkEffortConfig', 'COLUMN', N'ActionText'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity key', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_NotesWorkEffortConfig', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key from the result column of the dbo.Notes table', 'SCHEMA', N'dbo', 'TABLE', N'Receiver_NotesWorkEffortConfig', 'COLUMN', N'result'
GO
