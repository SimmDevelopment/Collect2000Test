SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE     FUNCTION [dbo].[fnExtractFixedNStrings] (@input NTEXT, @length SMALLINT)
RETURNS @values TABLE (
	[rowid] INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
	[value] NVARCHAR(4000) NOT NULL
)
AS BEGIN
	DECLARE @chunklength INTEGER;
	DECLARE @pos INTEGER;
	DECLARE @totallength INTEGER;
	DECLARE @chunk NVARCHAR(4000);

	IF @input IS NULL OR @length IS NULL OR @length < 0
		RETURN;

	IF @length > 4000
		SET @chunklength = 4000;
	ELSE
		SET @chunklength = @length;

	SET @totallength = DATALENGTH(@input) / 2;
	SET @pos = 1;

	WHILE @pos <= @totallength BEGIN
		SET @chunk = SUBSTRING(@input, @pos, @chunklength);
		INSERT INTO @values ([value]) VALUES (@chunk);
		SET @pos = @pos + @length;
	END;

	RETURN;
END





GO
