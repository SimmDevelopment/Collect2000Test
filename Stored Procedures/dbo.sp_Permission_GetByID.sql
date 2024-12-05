SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Permission_GetByID*/
CREATE Procedure [dbo].[sp_Permission_GetByID]
@ID INT
AS

SELECT *
FROM Permissions
WHERE ID = @ID
GO
