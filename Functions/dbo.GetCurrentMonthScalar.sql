SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetCurrentMonthScalar]()
RETURNS DATETIME
AS BEGIN
	DECLARE @Value DATETIME;
	SELECT TOP 1 @Value = [dbo].[DateSerial]([controlFile].[CurrentYear], [controlFile].[CurrentMonth], 1)
	FROM [dbo].[controlFile];
	RETURN @Value;
END

GO
