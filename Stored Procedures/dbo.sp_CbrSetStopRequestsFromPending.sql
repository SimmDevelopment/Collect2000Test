SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_CbrSetStopRequestsFromPending*/
CREATE      PROCEDURE [dbo].[sp_CbrSetStopRequestsFromPending]
	@ErrNum	INT OUTPUT
-- Name:	sp_CbrSetStopRequestsFromPending
-- Function:	This procedure will insert stop requests into table CbrStopRequest 
--		from valid records in CbrPendingFile table.
--		This sp should only be called from sp_CbrLoadCbrPendingTable
-- Creation:	01/14/2003 (jcc)    
-- Change History: 
--		03/26/2003 (jcc) added field ExceptionType (int) to table CbrPendingFile
--		conditional where clause required to not retrieve exception records
--		WHERE (p.ExceptionType is null OR p.ExceptionType = 0)
--             
AS
	SET @ErrNum = 0

	--Insert CbrStopRequest records
	INSERT	CbrStopRequest( Number, WhenCreated) 		
	SELECT	p.Number, getdate()
	FROM	CbrPendingFile p with(nolock)
	WHERE	((p.ActivityType IN ('DA', '62')) OR (p.SpecialComment = 'XB'))
	AND (p.ExceptionType is null OR p.ExceptionType = 0)

	IF (@@Error!=0)
	BEGIN
    	SET @ErrNum = @@Error
    	RAISERROR  ('20000',16,1,'Error encountered in sp_CbrSetStopRequestsFromPending.')
    	RETURN(1)
	END	

	SET @ErrNum = 0
GO
