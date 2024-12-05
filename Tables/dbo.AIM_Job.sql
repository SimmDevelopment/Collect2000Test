CREATE TABLE [dbo].[AIM_Job]
(
[jobid] [int] NOT NULL IDENTITY(1, 1),
[jobexecutiontypeid] [int] NULL,
[jobstatusid] [int] NULL,
[scheduleid] [int] NULL,
[scheduleddatetime] [datetime] NULL,
[author] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[description] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jobpriorityid] [int] NULL,
[executionwindow] [int] NULL,
[endpoint] [varchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[context] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_Job] ADD CONSTRAINT [pk_job] PRIMARY KEY CLUSTERED ([jobid]) ON [PRIMARY]
GO
