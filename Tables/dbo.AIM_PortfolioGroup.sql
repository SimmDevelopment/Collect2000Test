CREATE TABLE [dbo].[AIM_PortfolioGroup]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TreePath] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_PortfolioGroup] ADD CONSTRAINT [PK_AIM_PortfolioGroup] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
