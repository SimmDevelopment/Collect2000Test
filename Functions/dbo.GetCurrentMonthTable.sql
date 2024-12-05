SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetCurrentMonthTable]()
RETURNS @Results TABLE (
	[CurrentMonth] DATETIME
)
AS BEGIN
	INSERT INTO @Results ([CurrentMonth])
	SELECT TOP 1 [dbo].[DateSerial]([controlFile].[CurrentYear], [controlFile].[CurrentMonth], 1)
	FROM [dbo].[controlFile];
	RETURN;
END

GO
