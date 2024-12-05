CREATE TABLE [dbo].[AIM_Attachment]
(
[AttachmentId] [int] NOT NULL IDENTITY(1, 1),
[DateAttached] [datetime] NULL,
[FileName] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttachmentTypeId] [int] NOT NULL,
[Details] [image] NULL,
[ReferenceId] [int] NOT NULL,
[Size] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Attachment] ADD CONSTRAINT [PK_AIM_Attachments] PRIMARY KEY CLUSTERED ([AttachmentId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Attachment', 'COLUMN', N'AttachmentId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of attachement (group or portfolio)', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Attachment', 'COLUMN', N'AttachmentTypeId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Attachment was attached', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Attachment', 'COLUMN', N'DateAttached'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The raw file in binary', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Attachment', 'COLUMN', N'Details'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the file attached', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Attachment', 'COLUMN', N'FileName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The size of the file', 'SCHEMA', N'dbo', 'TABLE', N'AIM_Attachment', 'COLUMN', N'Size'
GO
