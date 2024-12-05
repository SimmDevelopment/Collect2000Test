SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCleanInvalidPhones]	
AS
BEGIN TRY

UPDATE master
	SET homephone = ''
	WHERE homephone IN (SELECT phone FROM InvalidPhone)

UPDATE master
	SET workphone = ''
	WHERE workphone IN (SELECT phone FROM InvalidPhone)

UPDATE debtors
	SET homephone = ''
	WHERE homephone IN (SELECT phone FROM InvalidPhone)

UPDATE debtors
	SET workphone = ''
	WHERE workphone IN (SELECT phone FROM InvalidPhone)  

END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH

RETURN 0;

GO
