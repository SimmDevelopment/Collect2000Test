SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Permission_Delete*/
CREATE Procedure [dbo].[sp_Permission_Delete]
@ID INT
AS

DELETE FROM Permissions
WHERE ID = @ID
GO
