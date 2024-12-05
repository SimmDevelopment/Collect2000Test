CREATE TABLE [dbo].[Job_History]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[JobID] [int] NOT NULL,
[JobCategoryID] [int] NOT NULL,
[StartedDateTime] [datetime] NULL,
[CompletedDateTime] [datetime] NULL,
[JobOutcomeID] [int] NULL,
[ForeignKeyID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OutcomeMessage] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Job_History] ADD CONSTRAINT [PK_Job_History] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Job_History] ADD CONSTRAINT [FK_Job_History_Job] FOREIGN KEY ([JobID]) REFERENCES [dbo].[Job] ([ID])
GO
ALTER TABLE [dbo].[Job_History] ADD CONSTRAINT [FK_Job_History_Job_Category] FOREIGN KEY ([JobCategoryID]) REFERENCES [dbo].[Job_Category] ([ID])
GO
ALTER TABLE [dbo].[Job_History] ADD CONSTRAINT [FK_Job_History_Job_Outcome] FOREIGN KEY ([JobOutcomeID]) REFERENCES [dbo].[Job_Outcome] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job History Transaction Table', 'SCHEMA', N'dbo', 'TABLE', N'Job_History', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp Job Completed', 'SCHEMA', N'dbo', 'TABLE', N'Job_History', 'COLUMN', N'CompletedDateTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity ID', 'SCHEMA', N'dbo', 'TABLE', N'Job_History', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job Category ID relating to Job Category Table', 'SCHEMA', N'dbo', 'TABLE', N'Job_History', 'COLUMN', N'JobCategoryID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job Identificatioon Number relating to Job Table', 'SCHEMA', N'dbo', 'TABLE', N'Job_History', 'COLUMN', N'JobID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job Outcoume ID relating to Job Outcome Table', 'SCHEMA', N'dbo', 'TABLE', N'Job_History', 'COLUMN', N'JobOutcomeID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job Outcome descriptive message', 'SCHEMA', N'dbo', 'TABLE', N'Job_History', 'COLUMN', N'OutcomeMessage'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp Job Started Executing', 'SCHEMA', N'dbo', 'TABLE', N'Job_History', 'COLUMN', N'StartedDateTime'
GO
