CREATE TABLE [ChampionChallenger].[ExperimentTypes]
(
[ExperimentTypeID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ChampionChallenger].[ExperimentTypes] ADD CONSTRAINT [PK_ChampionChallengerExperimentTypes] PRIMARY KEY CLUSTERED ([ExperimentTypeID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity, Primary Key', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'ExperimentTypes', 'COLUMN', N'ExperimentTypeID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ChampionChallenger Type', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'ExperimentTypes', 'COLUMN', N'Name'
GO
