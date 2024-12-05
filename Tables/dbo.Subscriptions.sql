CREATE TABLE [dbo].[Subscriptions]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[SourceDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DestinationDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CustomerGroup] [int] NULL,
[MinimumBalance] [money] NULL,
[MaximumBalance] [money] NULL,
[DailyRecords] [int] NOT NULL,
[MaximumDays] [int] NOT NULL,
[Active] [bit] NOT NULL CONSTRAINT [def_Active] DEFAULT (0)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Subscriptions] ADD CONSTRAINT [chk_DailyRecords] CHECK (([DailyRecords]>=(0)))
GO
ALTER TABLE [dbo].[Subscriptions] ADD CONSTRAINT [chk_MaximumDays] CHECK (([MaximumDays]>=(0)))
GO
ALTER TABLE [dbo].[Subscriptions] ADD CONSTRAINT [pk_Subscriptions] PRIMARY KEY CLUSTERED ([UID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Subscriptions] ADD CONSTRAINT [uq_Desks] UNIQUE NONCLUSTERED ([SourceDesk], [DestinationDesk]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Subscriptions] ADD CONSTRAINT [fk_CustomerGroup] FOREIGN KEY ([CustomerGroup]) REFERENCES [dbo].[CustomCustGroups] ([ID])
GO
ALTER TABLE [dbo].[Subscriptions] ADD CONSTRAINT [fk_DestinationDesk] FOREIGN KEY ([DestinationDesk]) REFERENCES [dbo].[desk] ([code])
GO
ALTER TABLE [dbo].[Subscriptions] ADD CONSTRAINT [fk_SourceDesk] FOREIGN KEY ([SourceDesk]) REFERENCES [dbo].[desk] ([code]) ON DELETE CASCADE
GO
