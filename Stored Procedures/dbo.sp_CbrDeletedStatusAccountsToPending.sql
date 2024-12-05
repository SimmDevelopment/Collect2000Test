SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_CbrDeletedStatusAccountsToPending*/
CREATE    PROCEDURE [dbo].[sp_CbrDeletedStatusAccountsToPending]
	@ErrNum	INT OUTPUT
-- Name:	sp_CbrDeletedStatusAccountsToPending
-- Function:	This procedure will insert account DA records into CbrPendingFile 
--		table which pass specific business rules.
--		All accounts previously reported which are now assigned to a status set 
--		to not report, should be deleted from the credit bureau's.
--		The accounts must have been previously reported. 
--		This sp should only be called from sp_CbrPrepareFullReport
-- Creation:	03/30/2004 (jcc)    
-- Business Rules
--		Business Rule #1: (Customer CBR class)
--			The customer associated with this account must have
--			a valid CBR class assigned.
--		Business Rule #2: (Customer CBR report type)
--			The customer associated with this account must have
--			a valid CBR RPT type assigned.
--		Business Rule #5: (Status CBR report flag)
--			The status of the account must have CBRReport = 0 as
--			configured in the Status table. Unknown status codes
--			will not be reported.
-- Change History: 
--		08/03/2004 jc inner join from cbrreportdetail was causing dupe accounts
--		to be inserted into cbrpendingfile causing dupes in output file. Revised
--		sp for distinct account with join to last cbrreport and cbrreportdetail 
--		02/23/2005 jc revised join to cbrreport to ensure proper DA reporting if an account last reported as 93
AS
	set @ErrNum = 0
	insert CbrPendingFile( Number, Entered, Current0, Current1, Status, ActivityType,
		SpecialComment, ActualPaymentAmount) 		
	select distinct m.number, getdate(), 0, 0, m.Status, 'DA' As ActivityType, '' As SpecialComment, 0	 
	from master m with(nolock)
	inner join customer c with(nolock) on c.customer = m.customer
	inner join cbrreport r with(nolock) on r.Id = (select max(rd1.ReportId) from cbrreportdetail rd1 with(nolock) where rd1.AccountID = m.number and rd1.ActivityType = '93')
	left outer join status s with(nolock) on s.code = m.status 
	where m.number not in (select number from CBRStopRequest with(nolock)) 
	and m.number not in (select number from CBRPendingFile with(nolock)) 
	and ((c.CbrClass is not null) and (left(c.CbrClass, 2) <> '00'))
	and ((c.cbrRPTtype is not null) and (c.cbrRPTtype <> ''))
	and (s.CBRReport = 0)

	IF (@@Error!=0)
	BEGIN
    	SET @ErrNum = @@Error
    	RAISERROR  ('20000',16,1,'Error encountered in sp_CbrDeletedStatusAccountsToPending.')
    	RETURN(1)
	END	
	SET @ErrNum = 0
GO
