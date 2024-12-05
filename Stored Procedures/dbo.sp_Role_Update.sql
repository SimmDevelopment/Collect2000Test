SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*sp_Role_Update*/
CREATE Procedure [dbo].[sp_Role_Update]
@ID int,
@RoleName varchar(50)
AS

UPDATE Roles
SET
RoleName = @RoleName
WHERE ID = @ID
GO
