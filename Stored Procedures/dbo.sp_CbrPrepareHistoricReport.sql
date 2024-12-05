SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_CbrPrepareHistoricReport*/
CREATE         PROCEDURE [dbo].[sp_CbrPrepareHistoricReport]
	@ReportId INT
-- Name:	sp_CbrPrepareHistoricReport
-- Function:    This procedure will call the following stored procedures
--              to load the Credit Bureau Report Pending table from History:
--		sp_CbrTruncateCbrPendingFile		- Clear CbrPendingFile table
--		sp_CbrHistoricAccountsToPending 	- Copy Historic Accounts to CbrPendingFile table
-- Creation: 	01/13/2003 (jcc)
-- Change History:
AS
	SET NOCOUNT ON
	DECLARE @ErrNum INT

	--initialize variables
	SELECT	@ErrNum = 0

	--prepare credit bureau historic report

	--clear CbrPendingFile table
	EXEC sp_CbrTruncateCbrPendingFile @ErrNum OUTPUT
	Print 'sp_CbrTruncateCbrPendingFile ' + Cast(@ErrNum As varchar(8))
	IF (@ErrNum != 0) GOTO ErrHandler

	--move historic accounts to CbrPendingFile table using input parameter @ReportId
--	EXEC sp_CbrHistoricAccountsToPending @ReportId, @ErrNum OUTPUT
--	Print 'sp_CbrHistoricAccountsToPending ' + Cast(@ErrNum As varchar(8))
--	IF (@ErrNum != 0) GOTO ErrHandler

	RETURN(0)	
	
ErrHandler:
	RAISERROR  ('20000',16,1,'Error encountered in sp_CbrPrepareHistoricReport.')
	Return(1)
	SET NOCOUNT OFF
GO
