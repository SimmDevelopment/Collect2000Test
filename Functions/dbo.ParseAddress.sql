SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*========================================================================================================= 
Script:		dbo.ParseAddress.sql 

Synopsis:	Function to parse an address string containing city, state and zip code information. This 
			should work for any United States or Canada address string. Tested using multiple variations 
			including 5-digit zip codes, 5-digit zip code + 4-digit extension separated with 1+ space(s),
			hyphen, or no separation and Canadian 6-character postal codes with the same variations. This
			function will also discard non-alpha characters and multiple spaces used to separate city, 
			state and zip code information.

Usage:		SELECT	 [Address] 
					,[City]  = [dbo].[ParseAddress]([Address], N'City') 
					,[State] = [dbo].[ParseAddress]([Address], N'State') 
					,[Zip]   = [dbo].[ParseAddress]([Address], N'Zip') 

Notes:		The following assumptions are made about the data for parsing: 

					- Zip code information is the last part of the string
					- Zip code will always contain 5+ characters. 
					- State will always be two letters. 
					- City will always end with a letter. 

=========================================================================================================== 
Revision History: 

Date			Author				Description 
----------------------------------------------------------------------------------------------------------- 


===========================================================================================================*/ 
CREATE FUNCTION [dbo].[ParseAddress] 
( 
	@String NVARCHAR(64), 
	@Get NVARCHAR(64) 
) 
RETURNS NVARCHAR(64) 
AS 
BEGIN 
	DECLARE @Address AS NVARCHAR(64); 
	DECLARE @City    AS NVARCHAR(25); 
	DECLARE @State   AS NVARCHAR( 2); 
	DECLARE @Zip     AS NVARCHAR(10); 
	DECLARE @Index   AS TINYINT     ; 
	DECLARE @Char    AS NCHAR(    1); 
	DECLARE @Value   AS NVARCHAR(64); 

	-- Remove any leading or trailing white space
 	SET @Address = LTRIM(RTRIM(@String)); 
	-- Initialize string index
	SET @Index = 1; 
	
	WHILE (@Index <= LEN(@Address)) 
	BEGIN 
		SET @Char = SUBSTRING(REVERSE(@Address), @Index, 1); 

		IF (@Zip IS NULL OR LEN(@Zip) < 5) 
		BEGIN 
			-- Continue reading valid characters for @Zip
			WHILE (PATINDEX(N'[a-zA-Z0-9]', @Char) = 1) 
			BEGIN 
				SET @Zip = ISNULL(STUFF(@Zip, 1, 0, UPPER(@Char)), UPPER(@Char)); 
				SET @Index = @Index + 1; 
				SET @Char = SUBSTRING(REVERSE(@Address), @Index, 1); 
			END; 
		END; 

		IF (@State IS NULL OR LEN(@State) <> 2) 
		BEGIN 
			-- Continue reading valid characters for @State
			WHILE (PATINDEX(N'[a-zA-Z]', @Char) = 1) 
			BEGIN 
				SET @State = ISNULL(STUFF(@State, 1, 0, UPPER(@Char)), UPPER(@Char)); 
				SET @Index = @Index + 1; 
				SET @Char = SUBSTRING(REVERSE(@Address), @Index, 1); 
			END; 
		END; 

		-- The last character of city should be an alpha character
		IF (PATINDEX(N'[a-zA-Z]', @Char) = 1) 
		BEGIN 
			-- Just assign the rest of the string to the @City variable
			SET @City = SUBSTRING(@Address, 1, LEN(@Address) - @Index + 1); 
			BREAK; 
		END; 

		SET @Index = @Index + 1; 
	END; 

	-- Removes double-spaces from the city name 
	WHILE (CHARINDEX(SPACE(2), @City) > 0) 
	BEGIN 
		SET @City = REPLACE(@City, SPACE(2), SPACE(1)); 
	END; 

	-- Format US Postal Codes that have 4 digit extension by stuffing the hyphen in correct position 
	IF (PATINDEX(N'[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]', @Zip) = 1) 
	BEGIN 
		SET @Zip = STUFF(@Zip, 6, 0, N'-'); 
	END; 

	-- Format Canadian Postal Codes by stuffing a space in correct position 
	IF (PATINDEX(N'[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]', @Zip) = 1) 
	BEGIN 
		SET @Zip = STUFF(@Zip, 4, 0, N' '); 
	END; 

	IF (@Get = N'City')  SET @Value = @City; 
	IF (@Get = N'State') SET @Value = @State; 
	IF (@Get = N'Zip')   SET @Value = @Zip; 

	RETURN @Value; 
END; 
GO
