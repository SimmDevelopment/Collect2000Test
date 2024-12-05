CREATE TABLE [dbo].[AIM_PortfolioGroupASSN]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[PortfolioGroupID] [int] NOT NULL,
[PortfolioID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_PortfolioGroupASSN] ADD CONSTRAINT [PK_AIM_PortfolioGroupASSN] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AIM_PortfolioGroupASSN] ADD CONSTRAINT [FK_AIM_PortfolioGroupASSN_AIM_Portfolio] FOREIGN KEY ([PortfolioID]) REFERENCES [dbo].[AIM_Portfolio] ([PortfolioId])
GO
ALTER TABLE [dbo].[AIM_PortfolioGroupASSN] ADD CONSTRAINT [FK_AIM_PortfolioGroupASSN_AIM_PortfolioGroup] FOREIGN KEY ([PortfolioGroupID]) REFERENCES [dbo].[AIM_PortfolioGroup] ([ID])
GO
