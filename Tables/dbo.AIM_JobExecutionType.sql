CREATE TABLE [dbo].[AIM_JobExecutionType]
(
[jobexecutiontypeid] [int] NOT NULL,
[description] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_JobExecutionType] ADD CONSTRAINT [pk_jobexecutiontype] PRIMARY KEY CLUSTERED ([jobexecutiontypeid]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'AIM_JobExecutionType', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'AIM_JobExecutionType', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_JobExecutionType', 'COLUMN', N'jobexecutiontypeid'
GO
