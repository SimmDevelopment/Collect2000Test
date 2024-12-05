CREATE TABLE [dsh].[JsonMeta]
(
[JsonMetaID] [int] NOT NULL IDENTITY(1, 1),
[JsonID] [int] NOT NULL,
[JsonMetaName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[JsonMetaValue] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JsonMetaJsonID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dsh].[JsonMeta] ADD CONSTRAINT [PK_JsonMeta] PRIMARY KEY CLUSTERED ([JsonMetaID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The JsonID of the object that owns this JsonMeta.', 'SCHEMA', N'dsh', 'TABLE', N'JsonMeta', 'COLUMN', N'JsonID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Unique ID for this meta information about a Json object.', 'SCHEMA', N'dsh', 'TABLE', N'JsonMeta', 'COLUMN', N'JsonMetaID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The JsonID of this JsonMeta.', 'SCHEMA', N'dsh', 'TABLE', N'JsonMeta', 'COLUMN', N'JsonMetaJsonID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of this JsonMeta.', 'SCHEMA', N'dsh', 'TABLE', N'JsonMeta', 'COLUMN', N'JsonMetaName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The result of toString() called on this JsonMeta.', 'SCHEMA', N'dsh', 'TABLE', N'JsonMeta', 'COLUMN', N'JsonMetaValue'
GO
