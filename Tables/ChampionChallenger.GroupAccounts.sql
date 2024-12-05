CREATE TABLE [ChampionChallenger].[GroupAccounts]
(
[GroupAccountID] [int] NOT NULL IDENTITY(1, 1),
[GroupID] [int] NOT NULL,
[AccountID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ChampionChallenger].[GroupAccounts] ADD CONSTRAINT [PK_ChampionChallengerGroupAccounts] PRIMARY KEY CLUSTERED ([GroupAccountID]) ON [PRIMARY]
GO
ALTER TABLE [ChampionChallenger].[GroupAccounts] ADD CONSTRAINT [FK_ChampionChallengerGroupAccounts_ChampionChallengerGroups] FOREIGN KEY ([GroupID]) REFERENCES [ChampionChallenger].[Groups] ([GroupID])
GO
ALTER TABLE [ChampionChallenger].[GroupAccounts] ADD CONSTRAINT [FK_ChampionChallengerGroupAccounts_master] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[master] ([number])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity, Primary Key', 'SCHEMA', N'ChampionChallenger', 'TABLE', N'GroupAccounts', 'COLUMN', N'GroupAccountID'
GO
