CREATE TABLE [dbo].[ArrangementCorrections]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[AccountId] [int] NOT NULL,
[Link] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ArrangementCorrections] ADD CONSTRAINT [PK__Arrangem__3214EC074BF72343] PRIMARY KEY CLUSTERED ([Id]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Relates to number in dbo.master table', 'SCHEMA', N'dbo', 'TABLE', N'ArrangementCorrections', 'COLUMN', N'AccountId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Key', 'SCHEMA', N'dbo', 'TABLE', N'ArrangementCorrections', 'COLUMN', N'Id'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Link value of dbo.master table record', 'SCHEMA', N'dbo', 'TABLE', N'ArrangementCorrections', 'COLUMN', N'Link'
GO
