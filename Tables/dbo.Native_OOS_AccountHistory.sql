CREATE TABLE [dbo].[Native_OOS_AccountHistory]
(
[number] [int] NOT NULL,
[StartDate] [datetime] NOT NULL,
[DateSource] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OOSDate] [datetime] NOT NULL,
[IsOOS] [bit] NOT NULL,
[COB] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OOSTypeId] [tinyint] NOT NULL,
[State] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DateCalculated] [datetime] NOT NULL,
[WorkflowTrigger] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_OOS_AccountHistory] ON [dbo].[Native_OOS_AccountHistory] ([number]) INCLUDE ([DateSource], [OOSDate], [IsOOS], [DateCalculated], [WorkflowTrigger]) ON [PRIMARY]
GO
