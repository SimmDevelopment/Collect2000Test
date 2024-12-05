SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Arrangements_GetBanks]
AS
SET NOCOUNT ON;

SELECT [bank].[ID],
	[bank].[code],
	[bank].[Name],
	COALESCE([bank].[PermitDepositToGeneral], CAST(0 AS BIT)) AS [PermitDepositToGeneral],
	CASE
		WHEN [generalTrust].[GeneralTrustBankID] IS NOT NULL
		THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
	END AS [IsGeneralTrust],
	CASE
		WHEN [operatingTrust].[OperatingTrustBankID] IS NOT NULL
		THEN CAST(1 AS BIT)
		ELSE CAST(0 AS BIT)
	END AS [IsOperatingTrust]
FROM [dbo].[bank]
LEFT OUTER JOIN [dbo].[controlFile] AS [generalTrust]
ON [bank].[ID] = [generalTrust].[GeneralTrustBankID]
LEFT OUTER JOIN [dbo].[controlFile] AS [operatingTrust]
ON [bank].[ID] = [operatingTrust].[OperatingTrustBankID];

RETURN 0;

GO
