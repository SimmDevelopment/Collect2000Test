CREATE TABLE [dbo].[SystemNoteTemplate]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[NoteText] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpecialCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionCode] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RFU] [varchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SystemNoteTemplate] ADD CONSTRAINT [PK_SystemNoteTemplate] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'SystemNoteTemplate', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'SystemNoteTemplate', 'COLUMN', N'SpecialCode'
GO
