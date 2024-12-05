SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_AddCustomCustGroup]
	@GrpName varchar (30),
	@Description varchar (100)
 AS
	Declare @Rtn int

	SELECT * FROM CustomCustGroups WHERE Name = @GrpName

	IF @@rowcount > 0 BEGIN
		Return -1
	END

	INSERT INTO CustomCustGroups(Name, Description)
                 VALUES(@GrpName, @Description)

	IF @@Error = 0 BEGIN
		Select @Rtn = SCOPE_IDENTITY()
		Return @Rtn
	END
	ELSE
		Return 0

GO
