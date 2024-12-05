SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fnGetErrorInfo]()
RETURNS @ErrorTbl TABLE (ErrorNumber int,ErrorSeverity int,ErrorState int,ErrorProcedure nvarchar(126),ErrorLine int,ErrorMessage nvarchar(2048))
AS BEGIN

	INSERT INTO @ErrorTbl (ErrorNumber ,ErrorSeverity,ErrorState ,ErrorProcedure,ErrorLine ,ErrorMessage )
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage;

RETURN

END

GO
