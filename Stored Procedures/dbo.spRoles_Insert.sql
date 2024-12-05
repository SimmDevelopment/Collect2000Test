SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





/*spRoles_Insert*/
CREATE  PROCEDURE [dbo].[spRoles_Insert]
	@RoleName varchar(50) 
AS
	SELECT RoleName from Roles Where RoleName = @RoleName

	IF @@RowCount > 0
		Return -1
	ELSE BEGIN
		INSERT INTO Roles (RoleName) VALUES (@RoleName)

		IF @@Error = 0
			Return SCOPE_IDENTITY()
		ELSE
			Return 0
	END


GO
