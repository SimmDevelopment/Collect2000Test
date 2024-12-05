SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_User_Delete*/
CREATE Procedure [dbo].[sp_User_Delete]
@ID INT
AS

DELETE FROM Users
WHERE ID = @ID
GO
