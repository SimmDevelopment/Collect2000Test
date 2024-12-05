SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetGenderEx] (@FullName VARCHAR(260))
RETURNS VARCHAR(15)
AS BEGIN
	IF @FullName IS NULL BEGIN
		RETURN NULL;
	END;

	IF RTRIM(@FullName) = '' BEGIN
		RETURN '';
	END;
	
	DECLARE @obj INTEGER;
	DECLARE @hr INTEGER;
	DECLARE @success BIT;
	DECLARE @DebtorID INTEGER;
	DECLARE @RawName VARCHAR(75);
	DECLARE @CompanyName VARCHAR(75);
	DECLARE @IsBusiness BIT;
	DECLARE @Gender VARCHAR(15);
	DECLARE @Prefix VARCHAR(50);
	DECLARE @FirstName VARCHAR(50);
	DECLARE @MiddleName VARCHAR(50);
	DECLARE @LastName VARCHAR(50);
	DECLARE @Suffix VARCHAR(50);
	DECLARE @BusinessName VARCHAR(50);

	EXEC @hr = sp_OACreate 'CAGender.ComActiveGender', @obj OUTPUT, 5;

	IF @hr = 0 BEGIN
		SET @IsBusiness = 0;
		SET @Gender = '';
		SET @Prefix = '';
		SET @FirstName = '';
		SET @MiddleName = '';
		SET @LastName = '';
		SET @Suffix = '';
		SET @BusinessName = '';
		EXEC @hr = sp_OAMethod @obj, 'SplitName2', @success OUTPUT, @FullName, @IsBusiness OUTPUT, @Prefix OUTPUT, @FirstName OUTPUT, @MiddleName OUTPUT, @LastName OUTPUT, @Suffix OUTPUT, @BusinessName OUTPUT, @Gender OUTPUT;
	END;

ExitFunction:
	IF @obj IS NOT NULL BEGIN
		EXEC sp_OADestroy @obj;
	END;
	RETURN @Gender;
END

GO
