SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[User_GetWindowsSID] (@WindowsUserName NVARCHAR(256))
RETURNS VARBINARY(85)
AS BEGIN
	IF @WindowsUserName IS NULL
		RETURN NULL;
	IF NOT @WindowsUserName LIKE '%\%'
		RETURN NULL;
	DECLARE @WindowsSID VARBINARY(85);
	SET @WindowsSID = SUSER_SID(@WindowsUserName);
	IF LEN(@WindowsSID) < 8
		RETURN NULL;
	RETURN @WindowsSID;
END

GO