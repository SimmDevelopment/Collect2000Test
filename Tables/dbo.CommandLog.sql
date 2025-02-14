CREATE TABLE [dbo].[CommandLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[DatabaseName] [sys].[sysname] NULL,
[SchemaName] [sys].[sysname] NULL,
[ObjectName] [sys].[sysname] NULL,
[ObjectType] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IndexName] [sys].[sysname] NULL,
[IndexType] [tinyint] NULL,
[StatisticsName] [sys].[sysname] NULL,
[PartitionNumber] [int] NULL,
[ExtendedInfo] [xml] NULL,
[Command] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CommandType] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StartTime] [datetime] NOT NULL,
[EndTime] [datetime] NULL,
[ErrorNumber] [int] NULL,
[ErrorMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CommandLog] ADD CONSTRAINT [PK_CommandLog] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
