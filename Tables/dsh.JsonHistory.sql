CREATE TABLE [dsh].[JsonHistory]
(
[JsonHistoryID] [int] NOT NULL IDENTITY(1, 1),
[JsonID] [int] NOT NULL,
[JsonClassID] [int] NOT NULL,
[Json] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[JsonHistoryTime] [datetime] NOT NULL CONSTRAINT [DF_JsonHistory_JsonHistoryTime] DEFAULT (getutcdate())
) ON [PRIMARY]
GO
ALTER TABLE [dsh].[JsonHistory] ADD CONSTRAINT [PK_JsonHistory] PRIMARY KEY CLUSTERED ([JsonHistoryID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'The serialization for the JSON object.', 'SCHEMA', N'dsh', 'TABLE', N'JsonHistory', 'COLUMN', N'Json'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The unique class ID for the JSON object.', 'SCHEMA', N'dsh', 'TABLE', N'JsonHistory', 'COLUMN', N'JsonClassID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The unique ID for the revision of the JSON object.', 'SCHEMA', N'dsh', 'TABLE', N'JsonHistory', 'COLUMN', N'JsonHistoryID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The UTC time this revision occurred.', 'SCHEMA', N'dsh', 'TABLE', N'JsonHistory', 'COLUMN', N'JsonHistoryTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The unique ID for the JSON object.', 'SCHEMA', N'dsh', 'TABLE', N'JsonHistory', 'COLUMN', N'JsonID'
GO
