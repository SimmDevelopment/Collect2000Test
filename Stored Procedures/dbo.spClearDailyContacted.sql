SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spClearDailyContacted]	
AS
BEGIN TRY

	Truncate table Daily_Account_Contacted

END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH

RETURN 0;

GO
