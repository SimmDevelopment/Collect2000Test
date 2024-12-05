CREATE TABLE [dbo].[Notes_Referenced]
(
[NoteId] [bigint] NOT NULL,
[RefSource] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RefKey] [varchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RefId] [bigint] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Notes_Referenced] ADD CONSTRAINT [PK_Notes_Referenced] PRIMARY KEY CLUSTERED ([NoteId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Notes_Referenced] ADD CONSTRAINT [FK_Notes_Referenced_Notes] FOREIGN KEY ([NoteId]) REFERENCES [dbo].[notes] ([UID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Associates a Latitude notes record with an unknown entity that can be defined by Source and Key values.  For example, the source may be a particular dialer (so the dialerinstancecode may be used) and the key may be a unique id value to a particular call record that the note describes.', 'SCHEMA', N'dbo', 'TABLE', N'Notes_Referenced', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'PK and FK to notes table.', 'SCHEMA', N'dbo', 'TABLE', N'Notes_Referenced', 'COLUMN', N'NoteId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A 64bit integer value, see RefSource for context. If this is populated it is likely a key to a DialerContactAttempt table record.', 'SCHEMA', N'dbo', 'TABLE', N'Notes_Referenced', 'COLUMN', N'RefId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A string value for the key, see RefSource for context.', 'SCHEMA', N'dbo', 'TABLE', N'Notes_Referenced', 'COLUMN', N'RefKey'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code value paired with RefKey/refId to reference a particular entity that the note refers to.', 'SCHEMA', N'dbo', 'TABLE', N'Notes_Referenced', 'COLUMN', N'RefSource'
GO
