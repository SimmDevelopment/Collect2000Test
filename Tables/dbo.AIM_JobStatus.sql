CREATE TABLE [dbo].[AIM_JobStatus]
(
[jobstatusid] [int] NOT NULL,
[status] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[description] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_JobStatus] ADD CONSTRAINT [pk_jobstatus] PRIMARY KEY CLUSTERED ([jobstatusid]) ON [PRIMARY]
GO
