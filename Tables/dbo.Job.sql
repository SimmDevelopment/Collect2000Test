CREATE TABLE [dbo].[Job]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CategoryID] [int] NULL,
[ForeignKeyID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ScheduleID] [int] NULL,
[JobStatusID] [int] NULL,
[LastRunDateTime] [datetime] NULL,
[NextRunDateTime] [datetime] NULL,
[LastRunOutcome] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enabled] [bit] NULL CONSTRAINT [DF__Job__Enabled__41736BE2] DEFAULT (0),
[Scheduled] [bit] NULL CONSTRAINT [DF__Job__Scheduled__4267901B] DEFAULT (0),
[EmailUponError] [bit] NULL,
[ErrorEmailAddress] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailUponSuccess] [bit] NULL,
[SuccessEmailAddress] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PickupAllPending] [bit] NULL,
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Config] [xml] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Job] ADD CONSTRAINT [PK_Job1] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Job] ADD CONSTRAINT [FK_Job_Job_Category] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Job_Category] ([ID])
GO
ALTER TABLE [dbo].[Job] ADD CONSTRAINT [FK_Job_Job_Status] FOREIGN KEY ([JobStatusID]) REFERENCES [dbo].[Job_Status] ([ID])
GO
ALTER TABLE [dbo].[Job] ADD CONSTRAINT [FK_Job_Schedules] FOREIGN KEY ([ScheduleID]) REFERENCES [dbo].[Schedules] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'This table supports an add on tool that allows Latitude users to schedule recurring processes for unattended operation, including file transfers for vendor services, Latitude Exchange processes and AIM imports.  The program may also trigger automatic export jobs at the times your company designates', 'SCHEMA', N'dbo', 'TABLE', N'Job', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Category ID relating to the Job_Catagory table', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'CategoryID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of Job ', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Email on job Error flag', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'EmailUponError'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Email on Job Success flag', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'EmailUponSuccess'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job enabled flag', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'Enabled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Email addressee list ', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'ErrorEmailAddress'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique Identity ID', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'JobStatus ID relating to the Job_Status table', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'JobStatusID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of last job execution', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'LastRunDateTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job completion status of last execution', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'LastRunOutcome'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job Name', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTimeStamp of next scheduled job execution', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'NextRunDateTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job scheduled flag', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'Scheduled'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Schedule ID relating to the Job Schedule table', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'ScheduleID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Email addressee list ', 'SCHEMA', N'dbo', 'TABLE', N'Job', 'COLUMN', N'SuccessEmailAddress'
GO
