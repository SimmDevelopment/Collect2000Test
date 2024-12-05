CREATE TABLE [dbo].[ProgramExecutionTimer]
(
[Code] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RunTime] [datetimeoffset] NOT NULL,
[LastRun] [bit] NULL,
[Interval] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProgramExecutionTimer] ADD CONSTRAINT [PK_ProgramExecutionTimer] PRIMARY KEY CLUSTERED ([RunTime]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ProgramExecutionTimer_Code] ON [dbo].[ProgramExecutionTimer] ([Code]) ON [PRIMARY]
GO
