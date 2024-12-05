SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_CbrUpdateCbrPendingFileSifPif*/
CREATE     PROCEDURE [dbo].[sp_CbrUpdateCbrPendingFileSifPif]
	@ErrNum	INT OUTPUT
-- Name:	sp_CbrUpdateCbrPendingFileSifPif
-- Function:	This procedure will update SIF/PIF records in the CbrPendingFile table
-- 		to the correct ActivityType, SpecialComment.
--		Bankruptcy status codes will also be updated to ActivityType 'DA'
--		Dispute status code records will be updated to ActivityType '93' SpecialComment 'XB'
--		Business Rule: Status CBR SIF/PIF reporting grace period
--		This sp should only be called from sp_CbrLoadCbrPendingTable
-- Creation:	01/14/2003 (jcc)    
-- Change History: 
--			07/14/2003 jcc revised update system SIF records. set CbrPendingFile.current1 = 0
AS
	SET @ErrNum = 0
	
	--update system PIF records
	UPDATE CbrPendingFile
		SET ActivityType = '62',
		SpecialComment = ''
	WHERE Status = 'PIF'

	--update system SIF records	
	UPDATE CbrPendingFile
		SET ActivityType = '62',
		SpecialComment = 'AU',
		Current0 = 0,
		Current1 = 0
	WHERE Status = 'SIF'

	--update system Bankruptcy records	
	UPDATE CbrPendingFile
		SET ActivityType = 'DA',
		SpecialComment = ''
	WHERE Status IN ('BAN','BKY','B07','B13')

	--update system Dispute records	
	UPDATE CbrPendingFile
		SET ActivityType = '93',
		SpecialComment = 'XB'
	WHERE Status = 'DIS'

	-- remove pending SIF/PIF records affected by business rule
	-- Business Rule: (Status CBR SIF/PIF reporting grace period)
        -- Accounts with a status of either SIF or PIF will not be reported
        -- until a grace period of 15 days has elapsed since the accounts
        -- closed date.
	DELETE p FROM CbrPendingFile p
	INNER JOIN master m ON p.Number = m.number
	where (m.closed is not null)
	AND (p.Status IN ('SIF','PIF'))
	AND (getdate() < DateAdd(d, 15, m.closed))


	IF (@@Error!=0)
	BEGIN
    	SET @ErrNum = @@Error
    	RAISERROR  ('20000',16,1,'Error encountered in sp_CbrUpdateCbrPendingFileSifPif.')
    	RETURN(1)
	END	

	SET @ErrNum = 0
GO
