SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Restrictions_GetByID*/
CREATE Procedure [dbo].[sp_Restrictions_GetByID]
@RestrictionID INT
AS

SELECT *
FROM restrictions
WHERE RestrictionID = @RestrictionID
GO
