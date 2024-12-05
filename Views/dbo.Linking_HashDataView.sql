SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Linking_HashDataView]
AS
SELECT
	[Debtors].[Number],
	[Parsed].[DebtorID],
	[Debtors].[Seq],
	[Parsed].[DebtorIndex],
	CASE [Parsed].[IsBusiness]
		WHEN 1 THEN CHECKSUM(COALESCE([Parsed].[BusinessName], ''))
		ELSE CHECKSUM(COALESCE([dbo].[DoubleMetaPhone]([Parsed].[LastName]), ''))
	END AS [LastName_Hash],
	CASE [Parsed].[IsBusiness]
		WHEN 1 THEN -1
		ELSE CHECKSUM(COALESCE([dbo].[DoubleMetaPhone]([Parsed].[FirstName]), ''))
	END AS [FirstName_Hash],
	COALESCE(CAST([dbo].[ValidateSSN]([Debtors].[SSN]) AS INTEGER), 0) AS [SSN_Hash],
	CHECKSUM(COALESCE([dbo].[StripNonDigits]([Debtors].[HomePhone]), '')) AS [Phone_Hash],
	CHECKSUM(COALESCE(RTRIM([Debtors].[DLNum]), '')) AS [DLNum_Hash],
	CASE
		WHEN [Debtors].[DOB] IS NULL OR [Debtors].[DOB] <= '1900-01-01' THEN 0
		ELSE CHECKSUM([Debtors].[DOB])
	END AS [DOB_Hash],
	CHECKSUM(COALESCE(LEFT([dbo].[CompactWhiteSpace]([Debtors].[Street1]), 10), '')) AS [Street_Hash],
	CHECKSUM(COALESCE(LEFT([dbo].[CompactWhiteSpace]([Debtors].[City]), 8), '')) AS [City_Hash],
	CHECKSUM(COALESCE(LEFT([dbo].[StripNonDigits]([Debtors].[ZipCode]), 5), '')) AS [ZipCode_Hash],
	CHECKSUM(COALESCE([master].[account], '')) AS [Account_Hash],
	CHECKSUM(COALESCE([master].[id1], '')) AS [ID1_Hash],
	CHECKSUM(COALESCE([master].[id2], '')) AS [ID2_Hash]
FROM [dbo].[master]
INNER JOIN [dbo].[Debtors]
ON [Debtors].[number] = [master].[number]
INNER JOIN [dbo].[Debtors_ParsedNamesView] AS [Parsed]
ON [Debtors].[DebtorID] = [Parsed].[DebtorID]

GO
