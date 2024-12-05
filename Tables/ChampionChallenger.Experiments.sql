CREATE TABLE [ChampionChallenger].[Experiments]
(
[ExperimentID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ExperimentTypeID] [int] NOT NULL,
[PopulationTypeID] [tinyint] NOT NULL CONSTRAINT [DF_ChampionChallengerExperiments_PopulationTypeID] DEFAULT ((0)),
[Percentage] [float] NULL,
[FromSQL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WhereSQL] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ConditionData] [image] NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NOT NULL,
[UserID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ChampionChallenger].[Experiments] ADD CONSTRAINT [PK_ChampionChallengerExperiments] PRIMARY KEY CLUSTERED ([ExperimentID]) ON [PRIMARY]
GO
ALTER TABLE [ChampionChallenger].[Experiments] ADD CONSTRAINT [FK_ChampionChallengerExperiments_ChampionChallengerExperimentTypes] FOREIGN KEY ([ExperimentTypeID]) REFERENCES [ChampionChallenger].[ExperimentTypes] ([ExperimentTypeID])
GO
ALTER TABLE [ChampionChallenger].[Experiments] ADD CONSTRAINT [FK_ChampionChallengerExperiments_ChampionChallengerPopulationTypes] FOREIGN KEY ([PopulationTypeID]) REFERENCES [ChampionChallenger].[PopulationTypes] ([PopulationTypeID])
GO
ALTER TABLE [ChampionChallenger].[Experiments] ADD CONSTRAINT [FK_ChampionChallengerExperiments_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[Users] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Code for the Model', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'Experiments', 'COLUMN', N'Code'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Model will End', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'Experiments', 'COLUMN', N'EndDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity, Primary Key', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'Experiments', 'COLUMN', N'ExperimentID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the CC Model', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'Experiments', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Model Created', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'Experiments', 'COLUMN', N'StartDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Model Creator User ID', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'Experiments', 'COLUMN', N'UserID'
GO
