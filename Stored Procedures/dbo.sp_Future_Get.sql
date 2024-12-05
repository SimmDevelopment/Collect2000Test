SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Future_Get*/
CREATE Procedure [dbo].[sp_Future_Get]
	@KeyID int
AS

SELECT *
FROM future
WHERE number = @KeyID

GO
