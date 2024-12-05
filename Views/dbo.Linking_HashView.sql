SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Linking_HashView]
WITH SCHEMABINDING
AS
SELECT [master].[number],
	[Debtors].[DebtorID],
	[Debtors].[Seq],
	CASE [Debtors].[isBusiness]
		WHEN 0 THEN CHECKSUM(ISNULL(dbo.DoubleMetaPhone([Debtors].[lastName]), ''))
		ELSE CHECKSUM(ISNULL(dbo.DoubleMetaPhone([Debtors].[businessName]), ''))
	END AS [LastName_Hash],
	CASE [Debtors].[isBusiness]
		WHEN 0 THEN CHECKSUM(ISNULL(dbo.DoubleMetaPhone([Debtors].[firstName]), ''))
		ELSE 0
	END AS [FirstName_Hash],
	CAST(ISNULL([dbo].[ValidateSSN]([Debtors].[ssn]), '') AS INTEGER) AS [SSN_Hash],
	CHECKSUM(dbo.StripNonDigits(ISNULL([Debtors].[homephone], ''))) AS [Phone_Hash],
	CHECKSUM(ISNULL([Debtors].[DLNum], '')) AS [DLNum_Hash],
	CASE
		WHEN [Debtors].[DOB] IS NULL THEN 0
		WHEN YEAR([Debtors].[DOB]) < 1900 THEN 0
		ELSE CHECKSUM([Debtors].[DOB])
	END AS [DOB_Hash],
	CHECKSUM(UPPER(LEFT(dbo.CompactWhiteSpace(ISNULL([Debtors].[Street1], '')), 10))) AS [Street_Hash], 
	CHECKSUM(UPPER(LEFT(ISNULL([Debtors].[city], ''), 8))) AS [City_Hash],
	CHECKSUM(LEFT(dbo.StripNonDigits(ISNULL([Debtors].[zipcode], '')), 5)) AS [ZipCode_Hash],
	CHECKSUM(ISNULL([master].[account], '')) AS [Account_Hash],
	CHECKSUM(ISNULL([master].[id1], '')) AS [ID1_Hash],
	CHECKSUM(ISNULL([master].[id2], '')) AS [ID2_Hash]
FROM [dbo].[master]
INNER JOIN [dbo].[Debtors]
ON [master].[number] = [Debtors].[number]
GO
