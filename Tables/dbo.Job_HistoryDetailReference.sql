CREATE TABLE [dbo].[Job_HistoryDetailReference]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[JobHistoryID] [int] NULL,
[ForeignKeyID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Job_HistoryDetailReference] ADD CONSTRAINT [PK_Job_HistoryDetailReferene] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Job_HistoryDetailReference] ADD CONSTRAINT [FK_Job_HistoryDetailReference_Job_History] FOREIGN KEY ([JobHistoryID]) REFERENCES [dbo].[Job_History] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reference table for composing job history detail', 'SCHEMA', N'dbo', 'TABLE', N'Job_HistoryDetailReference', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity ID', 'SCHEMA', N'dbo', 'TABLE', N'Job_HistoryDetailReference', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job History ID relating to Job History table', 'SCHEMA', N'dbo', 'TABLE', N'Job_HistoryDetailReference', 'COLUMN', N'JobHistoryID'
GO
