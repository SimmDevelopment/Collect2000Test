CREATE TABLE [dbo].[DistributionPopulation]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GroupID] [int] NOT NULL,
[ParentID] [int] NULL,
[DistributionTemplateID] [int] NOT NULL,
[Conditions] [image] NULL,
[MaxCount] [int] NOT NULL CONSTRAINT [DEF_MaxCount] DEFAULT ((0)),
[ReturnUnallocated] [bit] NOT NULL CONSTRAINT [DEF_ReturnUnallocated] DEFAULT ((0)),
[LinkAccountsOption] [tinyint] NULL CONSTRAINT [DF__DistributionPopulation__LinkAccountsOption] DEFAULT ((0)),
[LinkAccountsQuery] [image] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DistributionPopulation] ADD CONSTRAINT [PK_DistributionPopulation] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DistributionPopulation] ADD CONSTRAINT [UNQ_DistributionPopulationName] UNIQUE NONCLUSTERED ([Name], [GroupID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DistributionPopulation] ADD CONSTRAINT [FK_DistributionPopulation_DistributionTemplateID] FOREIGN KEY ([DistributionTemplateID]) REFERENCES [dbo].[DistributionTemplate] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DistributionPopulation] ADD CONSTRAINT [FK_DistributionPopulation_GroupId] FOREIGN KEY ([GroupID]) REFERENCES [dbo].[DistributionGroup] ([ID]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[DistributionPopulation] ADD CONSTRAINT [FK_DistributionPopulation_ParentID] FOREIGN KEY ([ParentID]) REFERENCES [dbo].[DistributionPopulation] ([ID])
GO
