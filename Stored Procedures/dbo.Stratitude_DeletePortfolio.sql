SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Stratitude_DeletePortfolio]
@portfolioID int

AS

DELETE FROM PortfolioAccount WHERE PortfolioID = portfolioID
DELETE FROM Portfolios WHERE PortfolioID = portfolioID


GO
