SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Stratitude_SetPortfolioAsFocus]
@portfolioid int

AS

UPDATE Portfolios SET Created = getdate()-1
UPDATE Portfolios SET Created = getdate() WHERE PortfolioID = @portfolioid
GO
