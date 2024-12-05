SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_CbrPrepareFullReport*/
CREATE         PROCEDURE [dbo].[sp_CbrPrepareFullReport]
	@IsTrialRun bit 
-- Name:	sp_CbrPrepareFullReport
-- Function:    This procedure will call the following stored procedures
--              to load the Credit Bureau Report Pending table:
--		sp_CbrTruncateCbrPendingFile		- Clear CbrPendingFile table
--		sp_CbrForcedDeletesToPending 		- Forced Deletes
--		sp_CbrForcedDisputesToPending 		- Forced Disputes
--		sp_CbrForcedSifsToPending 		- Forced SIFs
--		sp_CbrForcedPifsToPending 		- Forced PIFs
--		sp_CbrDeletedStatusAccountsToPending	- Delete Accounts with Status set to not report
--		sp_CbrReturnedAccountsToPending		- Returned Accounts Business Rules
--		sp_CbrOpenAccountsToPending 		- Open Accounts Business Rules
--		sp_CbrClosedAccountsToPending		- Closed Accounts Business Rules
--		sp_CbrUpdateCbrPendingFileSifPif	- Update CbrPendingFile by status
--		sp_CbrSetStopRequestsFromPending	- Set Stop Requests
--		sp_CbrDeleteCbrForced			- Delete CbrForced
-- Creation: 	01/13/2003 (jcc)
-- Change History:
--		01/29/2003 (jcc) Separated sp_CbrBusRulesToPending into two new sp's 
--				sp_CbrOpenAccountsToPending and sp_CbrClosedAccountsToPending
--				to enable reporting differneces in business rules for open 
--				and closed accounts.
--		03/26/2003 (jcc) added sp_CbrSetCbrPendingFileExceptions to update records in the 
--				CbrPendingFile table if not FCRA compliat. An exception type will be set.
--		02/23/2004 (jcc) added new sp_CbrReturnedAccountsToPending to delete returned accounts 
--				from the credit bureau.
--		03/30/2004 (jcc) added new sp_CbrDeletedStatusAccountsToPending to delete accounts with
--				a status code set to not report to credit bureau. The accounts must have 
--				been previously reported.
AS
	SET NOCOUNT ON
	DECLARE @ErrNum INT

	--initialize variables
	SELECT	@ErrNum = 0

	--prepare credit bureau FULL report

	--clear CbrPendingFile table
	EXEC sp_CbrTruncateCbrPendingFile @ErrNum OUTPUT
	Print 'sp_CbrTruncateCbrPendingFile ' + Cast(@ErrNum As varchar(8))
	IF (@ErrNum != 0) GOTO ErrHandler

	--move CbrForced deletes to CbrPendingFile table
	EXEC sp_CbrForcedDeletesToPending @ErrNum OUTPUT
	Print 'sp_CbrForcedDeletesToPending ' + Cast(@ErrNum As varchar(8))
	IF (@ErrNum != 0) GOTO ErrHandler

	--move CbrForced disputes to CbrPendingFile table
	EXEC sp_CbrForcedDisputesToPending @ErrNum OUTPUT
	Print 'sp_CbrForcedDisputesToPending ' + Cast(@ErrNum As varchar(8))
	IF (@ErrNum != 0) GOTO ErrHandler

	--move CbrForced SIFs to CbrPendingFile table
	EXEC sp_CbrForcedSifsToPending @ErrNum OUTPUT
	Print 'sp_CbrForcedSifsToPending ' + Cast(@ErrNum As varchar(8))
	IF (@ErrNum != 0) GOTO ErrHandler

	--move CbrForced PIFs to CbrPendingFile table
	EXEC sp_CbrForcedPifsToPending @ErrNum OUTPUT
	Print 'sp_CbrForcedPifsToPending ' + Cast(@ErrNum As varchar(8))
	IF (@ErrNum != 0) GOTO ErrHandler

	--move accounts to delete which meet business rules to CbrPendingFile table
	EXEC sp_CbrDeletedStatusAccountsToPending @ErrNum OUTPUT
	Print 'sp_CbrDeletedStatusAccountsToPending ' + Cast(@ErrNum As varchar(8))
	IF (@ErrNum != 0) GOTO ErrHandler

	--move returned accounts which meet business rules to CbrPendingFile table
	EXEC sp_CbrReturnedAccountsToPending @ErrNum OUTPUT
	Print 'sp_CbrReturnedAccountsToPending ' + Cast(@ErrNum As varchar(8))
	IF (@ErrNum != 0) GOTO ErrHandler

	--move open accounts which meet business rules to CbrPendingFile table
	EXEC sp_CbrOpenAccountsToPending @ErrNum OUTPUT
	Print 'sp_CbrOpenAccountsToPending ' + Cast(@ErrNum As varchar(8))
	IF (@ErrNum != 0) GOTO ErrHandler

	--move closed accounts which meet business rules to CbrPendingFile table
	EXEC sp_CbrClosedAccountsToPending @ErrNum OUTPUT
	Print 'sp_CbrClosedAccountsToPending ' + Cast(@ErrNum As varchar(8))
	IF (@ErrNum != 0) GOTO ErrHandler

	--update CbrPendingFile SIF/PIF records which were inserted by business rules
	EXEC sp_CbrUpdateCbrPendingFileSifPif @ErrNum OUTPUT
	Print 'sp_CbrUpdateCbrPendingFileSifPif ' + Cast(@ErrNum As varchar(8))
	IF (@ErrNum != 0) GOTO ErrHandler

	--update CbrPendingFile records meeting exception requirements
	EXEC sp_CbrSetCbrPendingFileExceptions @ErrNum OUTPUT
	Print 'sp_CbrSetCbrPendingFileExceptions ' + Cast(@ErrNum As varchar(8))
	IF (@ErrNum != 0) GOTO ErrHandler

	if @IsTrialRun = 0
		BEGIN
			--create stop request records for qualifying accounts in CbrStopRequest table
			EXEC sp_CbrSetStopRequestsFromPending @ErrNum OUTPUT
			Print 'sp_CbrSetStopRequestsFromPending ' + Cast(@ErrNum As varchar(8))
			IF (@ErrNum != 0) GOTO ErrHandler
		
			--delete CbrForced records for each type (delete, dispute, sif, pif)
			EXEC sp_CbrDeleteCbrForced @ErrNum OUTPUT
			Print 'sp_CbrDeleteCbrForced ' + Cast(@ErrNum As varchar(8))
			IF (@ErrNum != 0) GOTO ErrHandler
		END

	RETURN(0)	
	
ErrHandler:
	RAISERROR  ('20000',16,1,'Error encountered in sp_CbrPrepareFullReport.')
	Return(1)

SET NOCOUNT OFF
GO
