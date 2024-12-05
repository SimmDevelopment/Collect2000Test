SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnGetTimeZoneEx](@State VARCHAR(3), @ZipCode VARCHAR(15), @Phone VARCHAR(30), @UTC DATETIME)
RETURNS TINYINT
AS BEGIN
	DECLARE @LateTimeZone BIT;
	DECLARE @AddressTimeZone TINYINT;
	DECLARE @PhoneState VARCHAR(3);
	DECLARE @PhoneTimeZone TINYINT;
	DECLARE @AreaCode SMALLINT;
	DECLARE @Exchange SMALLINT;

	IF DATEPART(HOUR, @UTC) BETWEEN 6 AND 18 SET @LateTimeZone = 0;
	ELSE SET @LateTimeZone = 1;

	SET @State = COALESCE(@State, '');
	SET @ZipCode = COALESCE(@ZipCode, '');
	SET @ZipCode = LEFT([dbo].[StripNonDigits](@ZipCode), 5);
	IF LEN(@ZipCode) < 5 SET @ZipCode = '';

	SET @Phone = COALESCE(@Phone, '');
	SET @Phone = LEFT([dbo].[StripNonDigits](@Phone), 11);
	IF LEN(@Phone) >= 10 BEGIN
		IF SUBSTRING(@Phone, 1, 1) = '1' AND LEN(@Phone) = 11
			SET @Phone = SUBSTRING(@Phone, 2, 10);
		SET @AreaCode = CAST(SUBSTRING(@Phone, 1, 3) AS SMALLINT);
		SET @Exchange = CAST(SUBSTRING(@Phone, 4, 3) AS SMALLINT);
	END;

	IF @State = 'PR'  
	  IF [dbo].[IsDaylightSavings]() = 1 SET @AddressTimeZone = 5
	  ELSE SET @AddressTimeZone = 4;   
	ELSE IF @State IN ('ME','NH','VT','MA','RI','CT','NJ','NY','PA','DE','MD','OH','WV','VA','NC','SC','GA')  
	  SET @AddressTimeZone = 5;  
	ELSE IF @State IN ('MN','WI','IA','IL','MO','AR','OK','MS','AL','LA')  
	  SET @AddressTimeZone = 6;  
	ELSE IF @State IN ('MT','WY','CO','UT','NM')--,'AZ')  
	  SET @AddressTimeZone = 7;  
	ELSE IF @State IN ('WA','NV','CA')  
	  SET @AddressTimeZone = 8;  
	ELSE IF @State = 'AZ'
	  IF [dbo].[IsDaylightSavings]() = 1 SET @AddressTimeZone = 8
	  ELSE SET @AddressTimeZone = 7
	ELSE IF @State = 'HI'  
	  IF [dbo].[IsDaylightSavings]() = 1 SET @AddressTimeZone = 11
	  ELSE SET @AddressTimeZone = 10  
	ELSE
		SELECT TOP 1
			@AddressTimeZone = CAST([ZIPCODES].[T_Z] AS TINYINT)
		FROM [dbo].[ZIPCODES] WITH (NOLOCK)
		WHERE [ZIPCODES].[ZIP_CODE] <= @ZipCode
		AND [ZIPCODES].[T_Z] != ''
		AND ISNUMERIC([ZIPCODES].[T_Z]) = 1
		ORDER BY [ZIPCODES].[ZIP_CODE] DESC;

	IF @AddressTimeZone IS NULL
		IF @State IN ('MI','IN','KY','TN','FL')
			IF @LateTimeZone = 1 SET @AddressTimeZone = 5;
			ELSE SET @AddressTimeZone = 6;
		ELSE IF @State IN ('ND','SD','NE','KS','TX')
			IF @LateTimeZone = 1 SET @AddressTimeZone = 6;
			ELSE SET @AddressTimeZone = 7;
		ELSE IF @State IN ('ID','OR')
			IF @LateTimeZone = 1 SET @AddressTimeZone = 7;
			ELSE SET @AddressTimeZone = 8;
		ELSE IF @State = 'AK'
			IF @LateTimeZone = 1 SET @AddressTimeZone = 9;
			ELSE SET @AddressTimeZone = 10;

	IF NOT @AreaCode IS NULL BEGIN
		SELECT @PhoneState = [Phones_TimeZoneInfo].[State],
			@PhoneTimeZone = [Phones_TimeZoneInfo].[TimeZone]
		FROM [dbo].[Phones_TimeZoneInfo] WITH (NOLOCK)
		WHERE [Phones_TimeZoneInfo].[AreaCode] = @AreaCode
		AND [Phones_TimeZoneInfo].[Exchange] = @Exchange;
		
		IF @PhoneTimeZone IS NULL BEGIN
			SELECT TOP 1
				@PhoneState = [ZIPCODES].[STATE],
				@PhoneTimeZone = CASE @LateTimeZone
					WHEN 1 THEN MIN(CAST([ZIPCODES].[T_Z] AS TINYINT))
					ELSE MAX(CAST([ZIPCODES].[T_Z] AS TINYINT))
				END
			FROM [dbo].[ZIPCODES] WITH (NOLOCK)
			WHERE [ZIPCODES].[AREACODE] = CAST(@AreaCode as varchar(15))
			AND [ZIPCODES].[T_Z] != ''
			AND ISNUMERIC([ZIPCODES].[T_Z]) = 1
			GROUP BY [ZIPCODES].[STATE];
		END;

		IF @PhoneTimeZone IS NULL OR (@PhoneState = @State AND @AddressTimeZone IS NOT NULL)
			SET @PhoneTimeZone = @AddressTimeZone
	END;

	IF @PhoneTimeZone IS NOT NULL AND @AddressTimeZone IS NOT NULL AND @PhoneTimeZone != @AddressTimeZone AND ((@LateTimeZone = 0 AND @AddressTimeZone < @PhoneTimeZone) OR (@LateTimeZone = 1 AND @AddressTimeZone > @PhoneTimeZone))
		SET @AddressTimeZone = @PhoneTimeZone;
	IF @AddressTimeZone IS NULL AND @PhoneTimeZone IS NULL
		IF @LateTimeZone = 1 SET @AddressTimeZone = 5;
		ELSE SET @AddressTimeZone = 8;

	RETURN COALESCE(@AddressTimeZone, @PhoneTimeZone);
END
GO
