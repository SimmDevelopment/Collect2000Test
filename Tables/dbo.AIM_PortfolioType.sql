CREATE TABLE [dbo].[AIM_PortfolioType]
(
[PortfolioTypeId] [int] NOT NULL,
[Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_PortfolioType] ADD CONSTRAINT [PK_AIM_PortfolioType] PRIMARY KEY CLUSTERED ([PortfolioTypeId]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'Synchronize', N'true', 'SCHEMA', N'dbo', 'TABLE', N'AIM_PortfolioType', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name or description for this type table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_PortfolioType', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Overwrite', 'SCHEMA', N'dbo', 'TABLE', N'AIM_PortfolioType', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique ID for Table', 'SCHEMA', N'dbo', 'TABLE', N'AIM_PortfolioType', 'COLUMN', N'PortfolioTypeId'
GO
EXEC sp_addextendedproperty N'Synchronize', N'Key', 'SCHEMA', N'dbo', 'TABLE', N'AIM_PortfolioType', 'COLUMN', N'PortfolioTypeId'
GO