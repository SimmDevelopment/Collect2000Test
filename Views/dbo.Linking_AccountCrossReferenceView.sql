SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*
SELECT [master].[number],
	[target].[number],
	'Last Name' AS [test],
	[source_debtors].[LastName],
	[target_debtors].[LastName],
	[source_config].[LastNameScore]
FROM [dbo].[master]
INNER JOIN [dbo].[master] AS [target]
ON [master].[number] <> [target].[number]
INNER JOIN [dbo].[Linking_HashData] AS [source_hash]
ON [master].[number] = [source_hash].[Number]
AND [source_hash].[Seq] = 0
INNER JOIN [dbo].[Linking_HashData] AS [target_hash]
ON [target].[number] = [target_hash].[Number]
AND [target_hash].[Seq] = 0
INNER JOIN [dbo].[Linking_EffectiveConfiguration] AS [source_config]
ON [master].[customer] = [source_config].[customer]
INNER JOIN [dbo].[Linking_EffectiveConfiguration] AS [target_config]
ON [target].[customer] = [target_config].[customer]
INNER JOIN [dbo].[Debtors] AS [source_debtors]
ON [source_hash].[DebtorID] = [source_debtors].[DebtorID]
INNER JOIN [dbo].[Debtors] AS [target_debtors]
ON [target_hash].[DebtorID] = [target_debtors].[DebtorID]
WHERE [source_config].[LastNameScore] > 0
AND [source_hash].[LastName_Hash] IS NOT NULL
AND [source_hash].[LastName_Hash] <> 0
AND [source_hash].[LastName_Hash] = [target_hash].[LastName_Hash]
*/

CREATE VIEW [dbo].[Linking_AccountCrossReferenceView]
AS
SELECT [source].[number] AS [source_number],
	[source].[link] AS [source_link],
	[target].[number] AS [target_number],
	COALESCE([target].[link], 0) AS [target_link],
	[source].[customer] AS [source_customer],
	[target].[customer] AS [target_customer],
	[source_debtors].[DebtorID] AS [source_debtorID],
	[source_debtors].[lastName] AS [source_lastname],
	[source_debtors].[firstName] AS [source_firstname],
	[source_debtors].[SSN] AS [source_ssn],
	[source_debtors].[HomePhone] AS [source_homephone],
	[source_debtors].[DLNum] AS [source_dlnum],
	[source_debtors].[DOB] AS [source_dob],
	[source_debtors].[Street1] AS [source_street],
	[source_debtors].[City] AS [source_city],
	[source_debtors].[ZipCode] AS [source_zipcode],
	[source].[account] AS [source_account],
	[source].[ID1] AS [source_id1],
	[source].[ID2] AS [source_id2],
	[target_debtors].[DebtorID] AS [target_debtorID],
	[target_debtors].[lastName] AS [target_lastname],
	[target_debtors].[firstName] AS [target_firstname],
	[target_debtors].[SSN] AS [target_ssn],
	[target_debtors].[HomePhone] AS [target_homephone],
	[target_debtors].[DLNum] AS [target_dlnum],
	[target_debtors].[DOB] AS [target_dob],
	[target_debtors].[Street1] AS [target_street],
	[target_debtors].[City] AS [target_city],
	[target_debtors].[ZipCode] AS [target_zipcode],
	[target].[account] AS [target_account],
	[target].[ID1] AS [target_id1],
	[target].[ID2] AS [target_id2],
	[source_hash].[LastName_Hash] AS [source_hash_lastname],
	[source_hash].[FirstName_Hash] AS [source_hash_firstname],
	[source_hash].[SSN_Hash] AS [source_hash_ssn],
	[source_hash].[Phone_Hash] AS [source_hash_phone],
	[source_hash].[DLNum_Hash] AS [source_hash_dlnum],
	[source_hash].[DOB_Hash] AS [source_hash_dob],
	[source_hash].[Street_Hash] AS [source_hash_street],
	[source_hash].[City_Hash] AS [source_hash_city],
	[source_hash].[ZipCode_Hash] AS [source_hash_zipcode],
	[source_hash].[Account_Hash] AS [source_hash_account],
	[source_hash].[ID1_Hash] AS [source_hash_id1],
	[source_hash].[ID2_Hash] AS [source_hash_id2],
	[target_hash].[LastName_Hash] AS [target_hash_lastname],
	[target_hash].[FirstName_Hash] AS [target_hash_firstname],
	[target_hash].[SSN_Hash] AS [target_hash_ssn],
	[target_hash].[Phone_Hash] AS [target_hash_phone],
	[target_hash].[DLNum_Hash] AS [target_hash_dlnum],
	[target_hash].[DOB_Hash] AS [target_hash_dob],
	[target_hash].[Street_Hash] AS [target_hash_street],
	[target_hash].[City_Hash] AS [target_hash_city],
	[target_hash].[ZipCode_Hash] AS [target_hash_zipcode],
	[target_hash].[Account_Hash] AS [target_hash_account],
	[target_hash].[ID1_Hash] AS [target_hash_id1],
	[target_hash].[ID2_Hash] AS [target_hash_id2],
	[source_config].[LinkMode] AS [source_config_linkmode],
	[source_config].[CustomGroupID] AS [source_config_customgroup],
	[source_config].[CrossBranch] AS [source_config_crossbranch],
	[source_config].[DeskLinkingMode] AS [source_config_desklinkmode],
	[source_config].[LastNameScore] AS [source_config_lastname],
	[source_config].[FullNameScore] AS [source_config_fullname],
	[source_config].[SSNScore] AS [source_config_ssn],
	[source_config].[PhoneScore] AS [source_config_phone],
	[source_config].[DLNumScore] AS [source_config_dlnum],
	[source_config].[DOBScore] AS [source_config_dob],
	[source_config].[StreetScore] AS [source_config_street],
	[source_config].[CityScore] AS [source_config_city],
	[source_config].[ZipCodeScore] AS [source_config_zipcode],
	[source_config].[AccountScore] AS [source_config_account],
	[source_config].[ID1Score] AS [source_config_id1],
	[source_config].[ID2Score] AS [source_config_id2],
	[target_config].[LinkMode] AS [target_config_linkmode],
	[target_config].[CustomGroupID] AS [target_config_customgroup],
	[target_config].[CrossBranch] AS [target_config_crossbranch],
	[target_config].[DeskLinkingMode] AS [target_config_desklinkmode]
FROM [dbo].[master] AS [source]
INNER JOIN [dbo].[master] AS [target]
ON [source].[number] <> [target].[number]
INNER JOIN [dbo].[Linking_HashData] AS [source_hash]
ON [source].[number] = [source_hash].[Number]
AND [source_hash].[Seq] = 0
INNER JOIN [dbo].[Linking_HashData] AS [target_hash]
ON [target].[number] = [target_hash].[Number]
AND [target_hash].[Seq] = 0
INNER JOIN [dbo].[Linking_EffectiveConfiguration] AS [source_config]
ON [source].[customer] = [source_config].[customer]
INNER JOIN [dbo].[Linking_EffectiveConfiguration] AS [target_config]
ON [source].[customer] = [target_config].[customer]
INNER JOIN [dbo].[Debtors] AS [source_debtors]
ON [source_hash].[DebtorID] = [source_debtors].[DebtorID]
INNER JOIN [dbo].[Debtors] AS [target_debtors]
ON [target_hash].[DebtorID] = [target_debtors].[DebtorID]


GO
