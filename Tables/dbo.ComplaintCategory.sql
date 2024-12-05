CREATE TABLE [dbo].[ComplaintCategory]
(
[ComplaintCategoryId] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SLADays] [int] NOT NULL,
[Priority] [int] NOT NULL,
[CreatedWhen] [datetime] NOT NULL CONSTRAINT [DF_ComplaintCategory_CreatedWhen] DEFAULT (getutcdate()),
[CreatedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ModifiedWhen] [datetime] NULL CONSTRAINT [DF_ComplaintCategory_ModifiedWhen] DEFAULT (getutcdate()),
[ModifiedBy] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ComplaintCategory] ADD CONSTRAINT [PK_ComplaintCategory] PRIMARY KEY CLUSTERED ([ComplaintCategoryId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ComplaintCategory] ADD CONSTRAINT [UQ_ComplaintCategory_Code] UNIQUE NONCLUSTERED ([Code]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table used to manage the complaint categories used in the Complaints panel.', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Varchar code representing the complaint category. This field is referenced in the Complaint table.', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identifier for the complaint categories used in the complaints panel', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'ComplaintCategoryId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Ignore', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'ComplaintCategoryId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that identifies who created the initial record.', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that represents the date that the complaint category record was created.', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'CreatedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that holds a detailed description of the given complaint category.', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that identifies who last modified the record.', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'ModifiedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date field representing the last time a record was modified.', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'ModifiedWhen'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Field that represents number of SLA days associated with the complaint category', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'SLADays'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'ComplaintCategory', 'COLUMN', N'SLADays'
GO
