SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spClearLicenses]	
AS
BEGIN TRY

	Truncate table License
	Truncate table CurrentUsers

END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH

RETURN 0;

GO
