SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_NewBusinessOptions_Get*/
CREATE Procedure [dbo].[sp_NewBusinessOptions_Get]
	@KeyID int
AS

SELECT *
FROM NewBusinessOptions
WHERE CustomerID = @KeyID

GO
