CREATE TABLE [dbo].[AIM_AttachmentType]
(
[AttachmentTypeId] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AttachmentType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AttachmentType', 'COLUMN', N'AttachmentTypeId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AttachmentType', 'COLUMN', N'AttachmentTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name or description for this type table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AttachmentType', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'AIM_AttachmentType', 'COLUMN', N'Name'
GO
