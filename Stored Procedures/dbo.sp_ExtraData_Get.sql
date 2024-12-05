SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_ExtraData_Get*/
CREATE Procedure [dbo].[sp_ExtraData_Get]
	@KeyID int
AS

SELECT *
FROM extradata
WHERE Number = @KeyID

GO
