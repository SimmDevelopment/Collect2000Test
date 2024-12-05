SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_CbrForcedSifsToPending*/
CREATE      PROCEDURE [dbo].[sp_CbrForcedSifsToPending]
	@ErrNum	INT OUTPUT
-- Name:	sp_CbrForcedSifsToPending
-- Function:	This procedure will insert CbrForced Sifs to CbrPendingFile table
--		This sp should only be called from sp_CbrLoadCbrPendingTable
-- Creation:	01/13/2003 jcc
-- Change History: 
--		01/24/2003 jcc no longer inserting master.current1 to cbrpending.current0
--		now inserting a zero for status 'SIF'.
--				07/14/2003 jcc added insert to new CbrPendingFile field Current1
--				07/14/2003 jcc added insert to new CbrPendingFile field ActualPaymentAmount
--				requires case logic using payhistory table
--             
AS
	set @ErrNum = 0
	declare @runDate datetime
	set @runDate = getdate()

	insert	CbrPendingFile( Number, Entered, Current0, Current1, Status, ActivityType,
		SpecialComment, ActualPaymentAmount) 		
	select	f.AccountId, @runDate, 0, 0, 'SIF', '62', 'AU',
	case
		when
			isnull((select sum(totalpaid) from payhistory where payhistory.number = m.number
			and batchtype in('PU','PA','PC')
			and entered >= (select max(CreatedDate) from CbrReport where ReportType = 0)
			and entered <= @runDate), 0) 
			-
			isnull((select sum(totalpaid) from payhistory where payhistory.number = m.number
			and batchtype in('PUR','PAR','PCR')
			and entered >= (select max(CreatedDate) from CbrReport where ReportType = 0)
			and entered <= @runDate), 0) < 0 then 0
		else
			isnull((select sum(totalpaid) from payhistory where payhistory.number = m.number
			and batchtype in('PU','PA','PC')
			and entered >= (select max(CreatedDate) from CbrReport where ReportType = 0)
			and entered <= @runDate), 0) 
			-
			isnull((select sum(totalpaid) from payhistory where payhistory.number = m.number
			and batchtype in('PUR','PAR','PCR')
			and entered >= (select max(CreatedDate) from CbrReport where ReportType = 0)
			and entered <= @runDate), 0) 
	end
	as ActualPaymentAmount	
	from CbrForced f with(nolock)
	inner join master m with(nolock) on m.number = f.accountid	
	where f.Type = 'SIF'

	IF (@@Error!=0)
	BEGIN
    	SET @ErrNum = @@Error
    	RAISERROR  ('20000',16,1,'Error encountered in sp_CbrForcedSifsToPending.')
    	RETURN(1)
	END	

	SET @ErrNum = 0
GO
