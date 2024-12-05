CREATE TABLE [ChampionChallenger].[Groups]
(
[GroupID] [int] NOT NULL IDENTITY(1, 1),
[ExperimentID] [int] NOT NULL,
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GroupTypeID] [int] NOT NULL,
[FromSQL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WhereSQL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConditionData] [image] NULL,
[Percentage] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ChampionChallenger].[Groups] ADD CONSTRAINT [PK_ChampionChallengerGroups] PRIMARY KEY CLUSTERED ([GroupID]) ON [PRIMARY]
GO
ALTER TABLE [ChampionChallenger].[Groups] ADD CONSTRAINT [FK_ChampionChallengerGroups_ChampionChallengerExperiments] FOREIGN KEY ([ExperimentID]) REFERENCES [ChampionChallenger].[Experiments] ([ExperimentID])
GO
ALTER TABLE [ChampionChallenger].[Groups] ADD CONSTRAINT [FK_ChampionChallengerGroups_ChampionChallengerGroupTypes] FOREIGN KEY ([GroupTypeID]) REFERENCES [ChampionChallenger].[GroupTypes] ([GroupTypeID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code for the Group', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'Groups', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to ChampionChallenger', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'Groups', 'COLUMN', N'ExperimentID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity, Primary Key', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'Groups', 'COLUMN', N'GroupID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'FK to Group Type', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'Groups', 'COLUMN', N'GroupTypeID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the Group', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'Groups', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Percentage of DB Accts for each Group', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'Groups', 'COLUMN', N'Percentage'
GO
