CREATE TABLE [dbo].[Documentation_Attachments]
(
[AccountID] [int] NOT NULL,
[DocumentID] [uniqueidentifier] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Index] [int] NOT NULL,
[AttachedDate] [datetime] NOT NULL CONSTRAINT [DF__Documenta__Attac__71297349] DEFAULT (getdate()),
[AttachedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Category] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Documentation_Attachments] ADD CONSTRAINT [pk_Documentation_Attachments] PRIMARY KEY NONCLUSTERED ([AccountID], [DocumentID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Documentation_Attachments] ADD CONSTRAINT [uq_Documentation_Attachments_Name_Index] UNIQUE NONCLUSTERED ([AccountID], [Name], [Index]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Documentation_Attachments_Category] ON [dbo].[Documentation_Attachments] ([Category]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Documentation_Attachments] ADD CONSTRAINT [fk_Documentation_Attachments_Documentation] FOREIGN KEY ([DocumentID]) REFERENCES [dbo].[Documentation] ([UID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Documentation_Attachments] ADD CONSTRAINT [fk_Documentation_Attachments_master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number]) ON DELETE CASCADE
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table is used to index , search and list Account documents that have been attached', 'SCHEMA', N'dbo', 'TABLE', N'Documentation_Attachments', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account FileNumber ID', 'SCHEMA', N'dbo', 'TABLE', N'Documentation_Attachments', 'COLUMN', N'AccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'Documentation_Attachments', 'COLUMN', N'AttachedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp created', 'SCHEMA', N'dbo', 'TABLE', N'Documentation_Attachments', 'COLUMN', N'AttachedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity Key of child Documentation', 'SCHEMA', N'dbo', 'TABLE', N'Documentation_Attachments', 'COLUMN', N'DocumentID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User supplied name of attachment', 'SCHEMA', N'dbo', 'TABLE', N'Documentation_Attachments', 'COLUMN', N'Name'
GO
