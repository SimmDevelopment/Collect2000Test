SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[spCleanInvalidSocials]	
AS

BEGIN TRY
	UPDATE master
		SET ssn = ''
		WHERE ssn IN (SELECT ssn FROM InvalidSSN);

	UPDATE debtors
		SET ssn = '' 
		WHERE ssn IN (SELECT ssn FROM InvalidSSN);
END TRY

BEGIN CATCH
    SELECT * FROM [dbo].[fnGetErrorInfo]()
	RETURN 1
END CATCH

RETURN 0;
GO
