CREATE TABLE [dbo].[AIM_JobRun]
(
[jobrunid] [int] NOT NULL IDENTITY(1, 1),
[jobid] [int] NOT NULL,
[jobstatusid] [int] NOT NULL,
[scheduleddatetime] [datetime] NULL,
[starteddatetime] [datetime] NULL,
[completeddatetime] [datetime] NULL,
[results] [varchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_JobRun] ADD CONSTRAINT [pk_jobrun] PRIMARY KEY CLUSTERED ([jobrunid]) ON [PRIMARY]
GO
