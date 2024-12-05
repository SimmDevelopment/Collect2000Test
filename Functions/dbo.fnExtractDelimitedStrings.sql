SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE     FUNCTION [dbo].[fnExtractDelimitedStrings] (@input TEXT, @delimiter VARCHAR(255))
RETURNS @values TABLE (
	[rowid] INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	[value] VARCHAR(8000) NOT NULL
)
AS BEGIN
	DECLARE @delimlen TINYINT;
	DECLARE @pos INTEGER;
	DECLARE @bookmark INTEGER;
	DECLARE @length INTEGER;
	DECLARE @totallength INTEGER;
	DECLARE @chunk VARCHAR(8000);

	IF @input IS NULL
		RETURN;

	SET @totallength = DATALENGTH(@input);
	SET @delimlen = LEN(@delimiter);
	SET @bookmark = 1;
	SET @pos = CHARINDEX(@delimiter, @input, @bookmark);

	WHILE @pos > 0 BEGIN
		SET @length = @pos - @bookmark;
		SET @chunk = SUBSTRING(@input, @bookmark, @length);
		INSERT INTO @values ([value]) VALUES (@chunk);
		SET @bookmark = @pos + @delimlen;
		SET @pos = CHARINDEX(@delimiter, @input, @bookmark);
	END;

	IF @bookmark < @totallength BEGIN
		SET @length = (@totallength - @bookmark) + 1;
		SET @chunk = SUBSTRING(@input, @bookmark, @length);
		INSERT INTO @values ([value]) VALUES (@chunk);
	END;

	RETURN;
END





GO