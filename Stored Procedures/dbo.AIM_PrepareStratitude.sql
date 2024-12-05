SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_PrepareStratitude]

@portfolioid int,
@portfoliotypeid int

AS
DELETE FROM PortfolioAccount WHERE PortfolioID = @portfolioid

IF(@portfoliotypeid = 1)
BEGIN
INSERT INTO PortfolioAccount (PortfolioID,AccountID)
SELECT @portfolioid,number FROM Master WITH (NOLOCK) WHERE SoldPortfolio = @portfolioid
END
ELSE IF(@portfoliotypeid = 0)
BEGIN
INSERT INTO PortfolioAccount (PortfolioID,AccountID)
SELECT @portfolioid,number FROM Master WITH (NOLOCK) WHERE PurchasedPortfolio = @portfolioid
END

GO
