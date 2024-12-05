SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Linking_SearchAccounts] @LinkID INTEGER = 0, @FirstName VARCHAR(50) = '', @LastName VARCHAR(50) = '', @SSN VARCHAR(50) = '', @Phone VARCHAR(50) = '', @DLNum VARCHAR(50) = '', @DOB DATETIME = NULL, @Street VARCHAR(50) = '', @City VARCHAR(50) = '', @ZipCode VARCHAR(50) = '', @Account VARCHAR(50) = '', @ID1 VARCHAR(50) = '', @ID2 VARCHAR(50) = ''
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE @LastName_Hash INTEGER;
DECLARE @FirstName_Hash INTEGER;
DECLARE @SSN_Hash INTEGER;
DECLARE @Phone_Hash INTEGER;
DECLARE @DLNum_Hash INTEGER;
DECLARE @DOB_Hash INTEGER;
DECLARE @Street_Hash INTEGER;
DECLARE @City_Hash INTEGER;
DECLARE @ZipCode_Hash INTEGER;
DECLARE @Account_Hash INTEGER;
DECLARE @ID1_Hash INTEGER;
DECLARE @ID2_Hash INTEGER;

SET @LastName_Hash = CHECKSUM(dbo.DoubleMetaPhone(ISNULL(@LastName, '')));
SET @FirstName_Hash = CHECKSUM(dbo.DoubleMetaPhone(ISNULL(@FirstName, '')));
SET @SSN_Hash = CAST(ISNULL([dbo].[ValidateSSN](@SSN), '') AS INTEGER);
SET @Phone_Hash = CHECKSUM(dbo.StripNonDigits(ISNULL(@Phone, '')));
SET @DLNum_Hash = CHECKSUM(ISNULL(@DLNum, ''));
SET @DOB_Hash = CHECKSUM(ISNULL(@DOB, '1900-01-01'));
SET @Street_Hash = CHECKSUM(UPPER(LEFT(dbo.CompactWhiteSpace(ISNULL(@Street, '')), 10)));
SET @City_Hash = CHECKSUM(UPPER(LEFT(ISNULL(@City, ''), 8)));
SET @ZipCode_Hash = CHECKSUM(LEFT(dbo.StripNonDigits(ISNULL(@ZipCode, '')), 5));
SET @Account_Hash = CHECKSUM(ISNULL(@Account, ''));
SET @ID1_Hash = CHECKSUM(ISNULL(@ID1, ''));
SET @ID2_Hash = CHECKSUM(ISNULL(@ID2, ''));

SELECT TOP 5000 [master].[number] AS [AccountID],
	ISNULL([master].[link], 0) AS [Link],
	[master].[account] AS [Account],
	[master].[customer] AS [CustomerCode],
	[customer].[name] AS [CustomerName],
	[master].[received] AS [ReceivedDate],
	[master].[original] AS [OriginalBalance],
	[master].[current0] AS [CurrentBalance],
	[Debtors].[name] AS [Name],
	[Debtors].[SSN] AS [SSN],
	[Debtors].[HomePhone] AS [Phone],
	[Debtors].[Street1] AS [Street1],
	[Debtors].[Street2] AS [Street2],
	[Debtors].[City] AS [City],
	[Debtors].[State] AS [State],
	[Debtors].[ZipCode] AS [ZipCode],
	[Debtors].[DOB] AS [DOB],
	[Debtors].[DLNum] AS [DLNum]
FROM [dbo].[Linking_HashData]
INNER JOIN [dbo].[Debtors]
ON [Linking_HashData].[DebtorID] = [Debtors].[DebtorID]
INNER JOIN [dbo].[master]
ON [master].[number] = [Debtors].[number]
INNER JOIN [dbo].[customer]
ON [master].[customer] = [customer].[customer]
WHERE ([Linking_HashData].[LastName_Hash] = @LastName_Hash
	OR @LastName_Hash = 0)
AND ([Linking_HashData].[SSN_Hash] = @SSN_Hash
	OR @SSN_Hash = 0)
AND ([Linking_HashData].[Phone_Hash] = @Phone_Hash
	OR @Phone_Hash = 0)
AND ([Linking_HashData].[DLNum_Hash] = @DLNum_Hash
	OR @DLNum_Hash = 0)
AND ([Linking_HashData].[DOB_Hash] = @DOB_Hash
	OR @DOB_Hash = 0)
AND ([Linking_HashData].[Street_Hash] = @Street_Hash
	OR @Street_Hash = 0)
AND ([Linking_HashData].[City_Hash] = @City_Hash
	OR @City_Hash = 0)
AND ([Linking_HashData].[ZipCode_Hash] = @ZipCode_Hash
	OR @ZipCode_Hash = 0)
AND ([Linking_HashData].[Account_Hash] = @Account_Hash
	OR @Account_Hash = 0)
AND ([Linking_HashData].[ID1_Hash] = @ID1_Hash
	OR @ID1_Hash = 0)
AND ([Linking_HashData].[ID2_Hash] = @ID2_Hash
	OR @ID2_Hash = 0)
AND ([master].[link] = @LinkID
	OR @LinkID = 0);

RETURN 0;

GO
