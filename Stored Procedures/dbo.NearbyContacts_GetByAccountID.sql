SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[NearbyContacts_GetByAccountID]
	@AccountID INTEGER,
	@LinkID INTEGER = NULL
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT [NearbyContacts].[NearbyContactID],
	[NearbyContacts].[number],
	[NearbyContacts].[Type],
	[NearbyContacts].[LName],
	[NearbyContacts].[FName],
	[NearbyContacts].[MI],
	[NearbyContacts].[Addr1],
	[NearbyContacts].[Addr2],
	[NearbyContacts].[City],
	[NearbyContacts].[State],
	[NearbyContacts].[Zip],
	[NearbyContacts].[LoginName],
	[Services].[Description] AS [ServiceDescription],
	[NearbyContacts].[Created]
FROM [dbo].[NearbyContacts]
INNER JOIN [dbo].[fnGetLinkedAccounts](@AccountID, @LinkID) AS [Accounts]
ON [NearbyContacts].[number] = [Accounts].[AccountID]
LEFT OUTER JOIN [dbo].[ServiceHistory]
ON [ServiceHistory].[RequestID] = [NearbyContacts].[RequestID]
LEFT OUTER JOIN [dbo].[Services]
ON [Services].[ServiceID] = [ServiceHistory].[ServiceID];

RETURN 0;

GO
