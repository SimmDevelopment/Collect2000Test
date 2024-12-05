CREATE TABLE [dbo].[AIM_ScheduleType]
(
[scheduletypeid] [int] NOT NULL,
[description] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_ScheduleType] ADD CONSTRAINT [pk_scheduletype] PRIMARY KEY CLUSTERED ([scheduletypeid]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'AIM_ScheduleType', NULL, NULL
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'AIM_ScheduleType', 'COLUMN', N'description'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_ScheduleType', 'COLUMN', N'scheduletypeid'
GO
