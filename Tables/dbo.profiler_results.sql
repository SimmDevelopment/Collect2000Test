CREATE TABLE [dbo].[profiler_results]
(
[RowNumber] [int] NOT NULL IDENTITY(1, 1),
[EventClass] [int] NULL,
[TextData] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NTUserName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClientProcessID] [int] NULL,
[ApplicationName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LoginName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SPID] [int] NULL,
[Duration] [bigint] NULL,
[StartTime] [datetime] NULL,
[Reads] [bigint] NULL,
[Writes] [bigint] NULL,
[CPU] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[profiler_results] ADD CONSTRAINT [PK__profiler_results__42197EA5] PRIMARY KEY CLUSTERED ([RowNumber]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
