SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Attunely_Staging_AccountStubs]
	@FromDate DATETIME
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Updated BIT = 0

	DELETE FROM Attunely_AccountStubs WHERE AccountKey IN (SELECT number FROM master WHERE returned <= @FromDate)

	INSERT INTO Attunely_AccountStubs (AccountKey, UniverseKey, PortfolioKey, RecordTime)
	SELECT number, 'simm', customer + '_' + CAST(CAST(received AS DATE) AS VARCHAR), GETUTCDATE() 
	FROM master m LEFT OUTER JOIN Attunely_AccountStubs a ON m.number = a.AccountKey 
	WHERE a.AccountKey IS NULL AND m.received > @FromDate
	
	IF @@ROWCOUNT > 0 SET @Updated = 1

	SELECT @Updated
END
GO
