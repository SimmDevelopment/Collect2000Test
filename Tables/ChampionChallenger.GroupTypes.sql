CREATE TABLE [ChampionChallenger].[GroupTypes]
(
[GroupTypeID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ChampionChallenger].[GroupTypes] ADD CONSTRAINT [PK_ChampionChallengerGroupTypes] PRIMARY KEY CLUSTERED ([GroupTypeID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity, Primary Key', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'GroupTypes', 'COLUMN', N'GroupTypeID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group Type (Control, Test)', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'GroupTypes', 'COLUMN', N'Name'
GO
