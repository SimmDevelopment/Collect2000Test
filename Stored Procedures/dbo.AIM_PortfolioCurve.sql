SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[AIM_PortfolioCurve]
@portfolioId int

AS


SELECT
isnull(SUM(CREDIT)-SUM(DEBIT),0) as [Net Income],
((12*year(max(DATEENTERED)))+month(max(DATEENTERED)) - (12*year(max(CONTRACTDATE)))+month(max(CONTRACTDATE))) as [Month]



FROM

AIM_Portfolio P WITH (NOLOCK) JOIN AIM_Ledger L WITH (NOLOCK) ON P.PortfolioID = L.PortfolioID

WHERE P.PortfolioId = @portfolioId

GROUP BY (12*year(DATEENTERED))+month(DATEENTERED)
ORDER BY (12*year(DATEENTERED))+month(DATEENTERED) ASC

GO
