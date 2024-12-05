CREATE TABLE [dsh].[JsonClass]
(
[JsonClassID] [int] NOT NULL IDENTITY(1, 1),
[JsonClassName] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dsh].[JsonClass] ADD CONSTRAINT [PK_JsonClass] PRIMARY KEY CLUSTERED ([JsonClassID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The unique identifier of the JSON class.  For each object that is serialized into the dsh.Json table, its class will be in this table.', 'SCHEMA', N'dsh', 'TABLE', N'JsonClass', 'COLUMN', N'JsonClassID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The Assembly-qualified name of the JSON class.', 'SCHEMA', N'dsh', 'TABLE', N'JsonClass', 'COLUMN', N'JsonClassName'
GO
