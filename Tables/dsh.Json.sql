CREATE TABLE [dsh].[Json]
(
[JsonID] [int] NOT NULL IDENTITY(1, 1),
[JsonClassID] [int] NOT NULL,
[Json] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dsh].[Json] ADD CONSTRAINT [PK_Json] PRIMARY KEY CLUSTERED ([JsonID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The serialized Json information.', 'SCHEMA', N'dsh', 'TABLE', N'Json', 'COLUMN', N'Json'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID of the class that the serialized object.  This is a foreign key to the JsonClass table.', 'SCHEMA', N'dsh', 'TABLE', N'Json', 'COLUMN', N'JsonClassID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The unique identifier of the JSON object.  Each object that needs to persist will have a unique identifier -- this field.  It will correspond to its C# ID Property.', 'SCHEMA', N'dsh', 'TABLE', N'Json', 'COLUMN', N'JsonID'
GO
