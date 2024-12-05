CREATE TABLE [dsh].[JsonInfo]
(
[JsonID] [int] NOT NULL,
[JsonName] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JsonDesc] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dsh].[JsonInfo] ADD CONSTRAINT [PK_JsonInfo] PRIMARY KEY CLUSTERED ([JsonID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Desc property of the JSON object. Should be its description.', 'SCHEMA', N'dsh', 'TABLE', N'JsonInfo', 'COLUMN', N'JsonDesc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The unique identifier of the JSON object that is info is associated with.', 'SCHEMA', N'dsh', 'TABLE', N'JsonInfo', 'COLUMN', N'JsonID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Name property of the JSON object.', 'SCHEMA', N'dsh', 'TABLE', N'JsonInfo', 'COLUMN', N'JsonName'
GO
