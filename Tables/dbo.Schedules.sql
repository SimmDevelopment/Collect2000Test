CREATE TABLE [dbo].[Schedules]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Second] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Minute] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hour] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Day] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Month] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Weekday] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Year] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDateTime] [datetime] NULL,
[NeverBetweenStartDateTime] [datetime] NULL,
[NeverBetweenEndDateTime] [datetime] NULL,
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecurrenceString] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Schedules] ADD CONSTRAINT [PK_Schedules] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
