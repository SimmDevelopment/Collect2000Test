CREATE TABLE [dbo].[CbrDataCycleUpdates]
(
[CbrDataCycleUpdatesID] [int] NOT NULL IDENTITY(1, 1),
[CbrChangeType] [varchar] (155) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Number] [varchar] (155) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Debtorid] [varchar] (155) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DataPoint] [varchar] (155) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Item] [varchar] (155) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Exception] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CbrDataCycleUpdates] ADD CONSTRAINT [pk_CbrDataCycleUpdates] PRIMARY KEY NONCLUSTERED ([CbrDataCycleUpdatesID]) ON [PRIMARY]
GO
