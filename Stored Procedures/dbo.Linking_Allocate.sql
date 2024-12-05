SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Linking_Allocate]
AS
SET NOCOUNT ON;
DECLARE @control INTEGER;
DECLARE @master INTEGER;
DECLARE @link INTEGER;


-- Change made 07/11/2011 to make sure @control is not reused.  TJL

BEGIN TRANSACTION;

SELECT TOP 1 @master = [link]
FROM [master] WITH (NOLOCK)
ORDER BY [link] DESC;

SELECT TOP 1 @control = [nextlink]
FROM [ControlFile] WITH (TABLOCKX);

IF @control IS NULL AND @master IS NULL BEGIN
	SET @link = 1;
END;
ELSE IF @control IS NULL OR (@control = 0 AND @master > 0) OR (@master IS NOT NULL AND @control <= @master) BEGIN
	SET @link = @master + 1;
END;
ELSE BEGIN
	SET @link = @control; 
END;

UPDATE [ControlFile]
SET [nextlink] = @link + 1;

COMMIT TRANSACTION;

RETURN @link;

GO
