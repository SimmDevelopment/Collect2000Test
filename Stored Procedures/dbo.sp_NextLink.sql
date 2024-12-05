SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*sp_NextLink*/
CREATE Procedure [dbo].[sp_NextLink]
AS
-- Name:		sp_NextLink
-- Creation:	06/2003 
--		Used by manual new business entry.
-- Change History:	7/9/2004 jc changed sp to use nextLink value from control then update controlfile with nextlink +1. 

	Declare @N int

	BEGIN TRAN
	Select @N = NextLink from controlFile
	Update controlfile set NextLink =  @N + 1
	IF @N + 1 = (Select NextLink from controlFile)
		BEGIN
			COMMIT TRAN
			Return @N
		END
	ELSE
		BEGIN
			ROLLBACK TRAN
			Return 0
		END
GO
