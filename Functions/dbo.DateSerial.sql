SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  FUNCTION [dbo].[DateSerial] (@Year SMALLINT, @Month TINYINT, @Day TINYINT)
RETURNS DATETIME
WITH SCHEMABINDING
AS BEGIN
	RETURN DATEADD(DAY, @Day - 1, DATEADD(MONTH, @Month - 1, DATEADD(YEAR, @Year - 1753, '1753-01-01 12:00:00 AM')));
END


GO
