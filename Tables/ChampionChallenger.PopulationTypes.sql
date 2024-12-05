CREATE TABLE [ChampionChallenger].[PopulationTypes]
(
[PopulationTypeID] [tinyint] NOT NULL,
[PopulaitonTypeDescription] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ChampionChallenger].[PopulationTypes] ADD CONSTRAINT [PK_ChampionChallengerPopulationTypes] PRIMARY KEY CLUSTERED ([PopulationTypeID]) ON [PRIMARY]
GO
