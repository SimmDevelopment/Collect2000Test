SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Role_Delete*/
CREATE Procedure [dbo].[sp_Role_Delete]
@ID INT
AS

DELETE FROM Roles
WHERE ID = @ID
GO
