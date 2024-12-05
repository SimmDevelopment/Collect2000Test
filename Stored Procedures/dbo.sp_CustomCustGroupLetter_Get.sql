SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_CustomCustGroupLetter_Get*/
CREATE Procedure [dbo].[sp_CustomCustGroupLetter_Get]
	@KeyID int
AS

SELECT *
FROM CustomCustGroupLetter
WHERE CustomCustGroupID = @KeyID

GO
