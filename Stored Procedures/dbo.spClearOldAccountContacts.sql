SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spClearOldAccountContacts] @MaximumDays int=50	
AS
BEGIN TRY


	DELETE FROM AccountContacts
	WHERE TheDate < DATEADD(day, -@MaximumDays, GETDATE())

END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH

RETURN 0;

GO
