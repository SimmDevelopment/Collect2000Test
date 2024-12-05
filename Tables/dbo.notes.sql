CREATE TABLE [dbo].[notes]
(
[UID] [bigint] NOT NULL IDENTITY(1, 1),
[number] [int] NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created] [datetime] NULL,
[user0] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[action] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[result] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Seq] [int] NULL,
[IsPrivate] [bit] NULL,
[UtcCreated] [datetime] NULL CONSTRAINT [DF__notes__UtcCreate__391002AF] DEFAULT (getutcdate())
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = ROW
)
GO
ALTER TABLE [dbo].[notes] ADD CONSTRAINT [PK_notes] PRIMARY KEY NONCLUSTERED ([UID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Notes_Created] ON [dbo].[notes] ([created]) INCLUDE ([number], [result]) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_Notes_Number] ON [dbo].[notes] ([number]) WITH (DATA_COMPRESSION = ROW) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Action Code', 'SCHEMA', N'dbo', 'TABLE', N'notes', 'COLUMN', N'action'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Text freeform comment', 'SCHEMA', N'dbo', 'TABLE', N'notes', 'COLUMN', N'comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Note was created', 'SCHEMA', N'dbo', 'TABLE', N'notes', 'COLUMN', N'created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'notes', 'COLUMN', N'ctl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Private Flag (1 - Indicateds this not is a private note)', 'SCHEMA', N'dbo', 'TABLE', N'notes', 'COLUMN', N'IsPrivate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique file number related to Master.number', 'SCHEMA', N'dbo', 'TABLE', N'notes', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Result Code', 'SCHEMA', N'dbo', 'TABLE', N'notes', 'COLUMN', N'result'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'notes', 'COLUMN', N'Seq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identifier assigned to each note row', 'SCHEMA', N'dbo', 'TABLE', N'notes', 'COLUMN', N'UID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that Created the Note', 'SCHEMA', N'dbo', 'TABLE', N'notes', 'COLUMN', N'user0'
GO
