SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_CbrDeleteCbrForced*/
CREATE     PROCEDURE [dbo].[sp_CbrDeleteCbrForced]
	@ErrNum	INT OUTPUT
-- Name:	sp_CbrDeleteCbrForced
-- Function:	This procedure will delete CbrForced records for each type.
--		This sp should only be called from sp_CbrLoadCbrPendingTable
-- Creation:	01/14/2003 (jcc)    
-- Change History: 
--		09/01/2004 jc commented out the deletion of CbrForced records
--		where type = 'DISPUTE'. Dispute records will remain until user
--		removes them from Info - cbr settings/history	
--             
AS
	SET @ErrNum = 0

	--Delete CbrForced 'DELETE' records
	DELETE FROM CbrForced WHERE Type = 'DELETE'

	--Delete CbrForced 'DISPUTE' records
	--DELETE FROM CbrForced WHERE Type = 'DISPUTE'

	--Delete CbrForced 'PIF' records
	DELETE FROM CbrForced WHERE Type = 'PIF'

	--Delete CbrForced 'SIF' records
	DELETE FROM CbrForced WHERE Type = 'SIF'

	IF (@@Error!=0)
	BEGIN
    	SET @ErrNum = @@Error
    	RAISERROR  ('20000',16,1,'Error encountered in sp_CbrDeleteCbrForced.')
    	RETURN(1)
	END	

	SET @ErrNum = 0
GO
