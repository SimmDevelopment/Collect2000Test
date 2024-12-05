SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*dbo.sp_NextAcctID*/
CREATE PROCEDURE [dbo].[sp_NextAcctID] 
AS
-- Name:		sp_NextAcctID
-- Function:		This procedure will load letter requests from letter series 
--			for an account using input parameters.
-- Creation:		6/18/2003
--			Used by New Business Manual Entry
-- Change History:	2/17/2003 jc sp was returning nextdebtor plus one but not using
--			the next debtor value. sp modified to now return the next debtor 
--			number and update control file to next debtor plus one.

	Declare @N int
	BEGIN TRAN
	Select @N = NextDebtor from controlFile
	Update controlfile set NextDebtor =  @N + 1
	IF @N + 1 = (Select NextDebtor from controlFile)
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
