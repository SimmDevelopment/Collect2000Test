SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Debtors_ParseNames] @TargetDebtorID INTEGER = NULL, @NoOutput BIT = 0
WITH RECOMPILE
AS
SET NOCOUNT ON;
DECLARE @obj INTEGER;
DECLARE @hr INTEGER;
DECLARE @ErrorSource VARCHAR(8000);
DECLARE @ErrorDesc VARCHAR(8000);
DECLARE @success BIT;
DECLARE @DebtorID INTEGER;
DECLARE @RawName VARCHAR(75);
DECLARE @CompanyName VARCHAR(75);
DECLARE @IsBusiness BIT;
DECLARE @Prefix VARCHAR(50);
DECLARE @FirstName VARCHAR(50);
DECLARE @MiddleName VARCHAR(50);
DECLARE @LastName VARCHAR(50);
DECLARE @Suffix VARCHAR(50);
DECLARE @Gender VARCHAR(50);
DECLARE @BusinessName VARCHAR(50);
DECLARE @Errors INTEGER;
DECLARE @Names TABLE (
	[ID] INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	[DebtorID] INTEGER NOT NULL
);
DECLARE @Index INTEGER;

EXEC @hr = sp_OACreate 'CAGender.ComActiveGender', @obj OUTPUT, 5;

IF @hr = 0 BEGIN
	IF @TargetDebtorID IS NULL
		INSERT INTO @Names ([DebtorID])
		SELECT [Debtors].[DebtorID]
		FROM [dbo].[Debtors] AS [Debtors]
		WHERE [Debtors].[Name] IS NOT NULL
		AND NOT RTRIM([Debtors].[Name]) = ''
		AND ([Debtors].[isParsed] IS NULL
			OR [Debtors].[isParsed] = 0);
	ELSE
		INSERT INTO @Names ([DebtorID])
		SELECT [Debtors].[DebtorID]
		FROM [dbo].[Debtors] AS [Debtors]
		WHERE [Debtors].[Name] IS NOT NULL
		AND NOT RTRIM([Debtors].[Name]) = ''
		AND [Debtors].[DebtorID] = @TargetDebtorID;

	SET @Index = 1;
	SET @Errors = 0;

	WHILE EXISTS (SELECT * FROM @Names WHERE [ID] = @Index) BEGIN
		SELECT @DebtorID = [Names].[DebtorID],
			@RawName = [Debtors].[Name]
		FROM @Names AS [Names]
		INNER JOIN [dbo].[Debtors]
		ON [Debtors].[DebtorID] = [Names].[DebtorID]
		WHERE [Names].[ID] = @Index;

		SET @success = 0;
		EXEC @hr = sp_OAMethod @obj, 'Parse', @success OUTPUT, @RawName;
		IF @hr = 0 BEGIN
			IF @success = 1 BEGIN		
				SET @IsBusiness = 0;
				SET @Prefix = '';
				SET @FirstName = '';
				SET @MiddleName = '';
				SET @LastName = '';
				SET @Suffix = '';
				SET @BusinessName = '';
				SET @Gender = '';

				EXEC sp_OAGetProperty @obj, 'CompanyName', @BusinessName OUTPUT;
				IF LEN(@BusinessName) > 0 BEGIN
					SET @IsBusiness = 1;
					EXEC sp_OAGetProperty @obj, 'Prefix2', @Prefix OUTPUT;
					EXEC sp_OAGetProperty @obj, 'FirstName2', @FirstName OUTPUT;
					EXEC sp_OAGetProperty @obj, 'MiddleName2', @MiddleName OUTPUT;
					EXEC sp_OAGetProperty @obj, 'LastName2', @LastName OUTPUT;
					EXEC sp_OAGetProperty @obj, 'Suffix2', @Suffix OUTPUT;
					EXEC sp_OAGetProperty @obj, 'Gender2', @Gender OUTPUT;
				END;
				ELSE BEGIN
					EXEC sp_OAGetProperty @obj, 'Prefix', @Prefix OUTPUT;
					EXEC sp_OAGetProperty @obj, 'FirstName', @FirstName OUTPUT;
					EXEC sp_OAGetProperty @obj, 'MiddleName', @MiddleName OUTPUT;
					EXEC sp_OAGetProperty @obj, 'LastName', @LastName OUTPUT;
					EXEC sp_OAGetProperty @obj, 'Suffix', @Suffix OUTPUT;
					EXEC sp_OAGetProperty @obj, 'Gender', @Gender OUTPUT;
					EXEC sp_OAGetProperty @obj, 'CompanyName2', @BusinessName OUTPUT;
					IF LEN(@BusinessName) > 0
						SET @IsBusiness = 1;
					ELSE
						SET @IsBusiness = 0;
				END;

				UPDATE [dbo].[Debtors] WITH (ROWLOCK)
				SET [prefix] = @Prefix,
					[firstName] = @FirstName,
					[lastName] = @LastName,
					[middleName] = @MiddleName,
					[suffix] = @Suffix,
					[isBusiness] = @IsBusiness,
					[businessName] = @BusinessName,
					[gender] = LEFT(@Gender, 1),
					[isParsed] = 1
				WHERE [DebtorID] = @DebtorID;

				IF @TargetDebtorID IS NOT NULL AND @NoOutput = 0
					SELECT @RawName AS [RawName],
						@IsBusiness AS [IsBusiness],
						@Prefix AS [Prefix],
						@FirstName AS [FirstName],
						@MiddleName AS [MiddleName],
						@LastName AS [LastName],
						@Suffix AS [Suffix],
						@BusinessName AS [BusinessName],
						LEFT(@Gender, 1) AS [Gender];

				SET @Errors = 0;
			END;
			ELSE BEGIN
				SET @ErrorDesc = '';
				EXEC @hr = sp_OAGetProperty @obj, 'ReturnCode', @ErrorDesc OUTPUT;
				SET @RawName = ISNULL(@RawName, '(null)');
				IF @hr = 0
					RAISERROR('Call to SplitName2 unsuccessful.  DebtorID=%d, Name="%s", ReturnCode="%s"', 16, 1, @DebtorID, @RawName, @ErrorDesc);
				ELSE BEGIN
					EXEC @hr = sp_OAGetErrorInfo @hr, @ErrorSource OUTPUT, @ErrorDesc OUTPUT;
					IF @hr = 0
						RAISERROR('Call to SplitName2 unsuccessful.  DebtorID=%d, Name="%s", ErrorSource="%s", ErrorDescription="%s"', 16, 1, @DebtorID, @RawName, @ErrorSource, @ErrorDesc);
				END;
				SET @Errors = @Errors + 1;
				IF @Errors > 25 BEGIN
					EXEC @hr = sp_OADestroy @obj;
					RAISERROR('Maximum number of consecutive errors exceeded.', 16, 1);
					RETURN 1;
				END;
			END;
		END;
		ELSE BEGIN
			EXEC @hr = sp_OAGetErrorInfo @hr, @ErrorSource OUTPUT, @ErrorDesc OUTPUT;
			SET @RawName = ISNULL(@RawName, '(null)');
			IF @hr = 0
				RAISERROR('Call to SplitName2 failed.  DebtorID=%d, Name="%s", ErrorSource="%s", ErrorDescription="%s"', 16, 1, @DebtorID, @RawName, @ErrorSource, @ErrorDesc);
			SET @Errors = @Errors + 1;
			IF @Errors > 25 BEGIN
				EXEC @hr = sp_OADestroy @obj;
				RAISERROR('Maximum number of consecutive errors exceeded.', 16, 1);
				RETURN 1;
			END;
		END;

		SET @Index = @Index + 1;
	END;

	EXEC @hr = sp_OADestroy @obj;
END;
ELSE BEGIN
	EXEC @hr = sp_OAGetErrorInfo @hr, @ErrorSource OUTPUT, @ErrorDesc OUTPUT;
	IF @hr = 0
		RAISERROR('Failed to initialize ActiveGender library. (%s) %s', 16, 1, @ErrorSource, @ErrorDesc);
	ELSE
		RAISERROR('Failed to initialize ActiveGender library.', 16, 1);
	RETURN 1;
END;

RETURN 0;








GO
