SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*sp_Permission_Update*/
CREATE Procedure [dbo].[sp_Permission_Update]
@ID int,
@ModuleName varchar(30),
@PermissionName varchar(50)
AS

UPDATE Permissions
SET
ModuleName = @ModuleName,
PermissionName = @PermissionName
WHERE ID = @ID
GO
