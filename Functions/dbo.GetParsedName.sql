SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS OFF
GO
CREATE        FUNCTION [dbo].[GetParsedName] (@FullName VARCHAR(260))
RETURNS @ParsedName TABLE (
	[FullName] VARCHAR(260) NULL,
	[BusinessName] VARCHAR(75) NULL,
	[IsBusiness] BIT NULL,
	[Prefix] VARCHAR(50) NULL,
	[FirstName] VARCHAR(50) NULL,
	[MiddleName] VARCHAR(50) NULL,
	[LastName] VARCHAR(50) NULL,
	[Suffix] VARCHAR(50) NULL,
	[Gender] VARCHAR(15) NULL
)
AS BEGIN
	DECLARE @obj INTEGER;
	DECLARE @hr INTEGER;
	DECLARE @success BIT;
	DECLARE @DebtorID INTEGER;
	DECLARE @RawName VARCHAR(75);
	DECLARE @IsBusiness BIT;
	DECLARE @Prefix VARCHAR(50);
	DECLARE @FirstName VARCHAR(50);
	DECLARE @MiddleName VARCHAR(50);
	DECLARE @LastName VARCHAR(50);
	DECLARE @Suffix VARCHAR(50);
	DECLARE @BusinessName VARCHAR(50);
	DECLARE @Gender VARCHAR(15);

	SET @IsBusiness = 0;
	SET @Prefix = '';
	SET @FirstName = '';
	SET @MiddleName = '';
	SET @LastName = '';
	SET @Suffix = '';
	SET @BusinessName = '';
	SET @Gender = '';

	IF NOT @FullName IS NULL AND RTRIM(@FullName) != '' BEGIN
		EXEC @hr = sp_OACreate 'CAGender.ComActiveGender', @obj OUTPUT, 5;
		IF @hr = 0 BEGIN
			EXEC @hr = sp_OAMethod @obj, 'SplitName2', @success OUTPUT, @FullName, @IsBusiness OUTPUT, @Prefix OUTPUT, @FirstName OUTPUT, @MiddleName OUTPUT, @LastName OUTPUT, @Suffix OUTPUT, @BusinessName OUTPUT, @Gender OUTPUT;
			EXEC sp_OADestroy @obj;
		END;
	END;
	INSERT INTO @ParsedName ([FullName], [BusinessName], [IsBusiness], [Prefix], [FirstName], [MiddleName], [LastName], [Suffix], [Gender])
	VALUES (@FullName, @BusinessName, @IsBusiness, @Prefix, @FirstName, @MiddleName, @LastName, @Suffix, @Gender);

	RETURN;
END










GO
