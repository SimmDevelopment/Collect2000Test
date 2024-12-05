SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Attunely_Staging_Portfolios]
	@FromDate DATETIME
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Updated BIT = 0

	INSERT INTO [dbo].[Attunely_Portfolios]
           ([PortfolioKey]
           ,[UniverseKey]
           ,[Name]
           ,[Client]
           ,[DefaultOriginatorClass_Id]
           ,[PortfolioClass_Id]
           ,[PriorPlacements]
           ,[Status_Id]
           ,[RecordTime])
	SELECT DISTINCT m.customer + '_' + CAST(CAST(received AS DATE) AS VARCHAR),
		'simm', 
		RTRIM(c.Name) + ' - ' + CAST(CAST(received AS DATE) AS VARCHAR), 
		m.customer,
		COALESCE(vv.ValidCreditorType, 'OriginatorType|unknown'),
		COALESCE(vv.ValidPortfolioType, 'PortfolioClass|servicing'),
		0,
		CASE c.status WHEN 'INACTIVE' THEN 'PortfolioStatus|disabled' ELSE 'PortfolioStatus|active' END,
		GETUTCDATE()
	FROM master m 
		INNER JOIN customer c
			ON m.customer = c.customer
		LEFT OUTER JOIN Attunely_Helper_CobToValidValue vv
			ON c.cob = vv.ClassOfBusiness
		LEFT OUTER JOIN Attunely_AccountStubs a 
			ON m.number = a.AccountKey 
		LEFT OUTER JOIN Attunely_Portfolios p 
			ON m.customer + '_' + CAST(CAST(received AS DATE) AS VARCHAR) = p.PortfolioKey 
	WHERE a.AccountKey IS NULL AND p.PortfolioKey IS NULL AND m.received > @FromDate
	
	IF @@ROWCOUNT > 0 SET @Updated = 1
	SELECT @Updated
END
GO
