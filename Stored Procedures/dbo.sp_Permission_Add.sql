SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*sp_Permission_Add*/
CREATE Procedure [dbo].[sp_Permission_Add]
@ID int,
@ModuleName varchar(30),
@PermissionName varchar(50)
AS

INSERT INTO Permissions
(
ID,
ModuleName,
PermissionName
)
VALUES
(
@ID,
@ModuleName,
@PermissionName
)

--SET @PermissionID = @@IDENTITY
GO
