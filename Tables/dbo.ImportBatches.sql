CREATE TABLE [dbo].[ImportBatches]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DateCreated] [datetime] NOT NULL,
[Filename] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateProcessed] [datetime] NULL,
[ProcessedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstAccountID] [int] NULL,
[LastAccountID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ImportBatches] ADD CONSTRAINT [PK_ImportBatches] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Temporary holding table used by Import Excel', 'SCHEMA', N'dbo', 'TABLE', N'ImportBatches', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name', 'SCHEMA', N'dbo', 'TABLE', N'ImportBatches', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Datetimestamp created', 'SCHEMA', N'dbo', 'TABLE', N'ImportBatches', 'COLUMN', N'DateCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp Batch was loaded to latitude', 'SCHEMA', N'dbo', 'TABLE', N'ImportBatches', 'COLUMN', N'DateProcessed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Source filename and path', 'SCHEMA', N'dbo', 'TABLE', N'ImportBatches', 'COLUMN', N'Filename'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First Account FileNumber ID in file', 'SCHEMA', N'dbo', 'TABLE', N'ImportBatches', 'COLUMN', N'FirstAccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity Key', 'SCHEMA', N'dbo', 'TABLE', N'ImportBatches', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last Account Filenumber ID in file', 'SCHEMA', N'dbo', 'TABLE', N'ImportBatches', 'COLUMN', N'LastAccountID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Logon Name who processed the batch', 'SCHEMA', N'dbo', 'TABLE', N'ImportBatches', 'COLUMN', N'ProcessedBy'
GO
