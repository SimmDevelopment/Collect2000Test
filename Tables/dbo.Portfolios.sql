CREATE TABLE [dbo].[Portfolios]
(
[PortfolioID] [int] NOT NULL IDENTITY(1, 1),
[PortfolioName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Created] [datetime] NOT NULL,
[UserID] [int] NOT NULL,
[TreePath] [varchar] (900) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Portfolios] ADD CONSTRAINT [PK_Portfolios] PRIMARY KEY CLUSTERED ([TreePath]) ON [PRIMARY]
GO
