SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_CbrOpenAccountsToPending*/
CREATE     PROCEDURE [dbo].[sp_CbrOpenAccountsToPending]
	@ErrNum	INT OUTPUT
-- Name:	sp_CbrOpenAccountsToPending
-- Function:	This procedure will insert Open account records into CbrPendingFile 
--		table which pass specific business rules.
--		This sp should only be called from sp_CbrPrepareFullReport
-- Creation:	01/29/2003 (jcc)    
-- Business Rules
--		Business Rule #1: (Customer CBR class)
--			The customer associated with this account must have
--			a valid CBR class assigned.
--		Business Rule #2: (Customer CBR report type)
--			The customer associated with this account must have
--			a valid CBR RPT type assigned.
--		Business Rule #3: (Customer CBR wait days)
--			The received date of the account must be validated
--			against the minimum number of wait days set for this
--			accounts associated customer.
--		Business Rule #4: (Customer CBR minimum balance)
--			The original1 amount of the account must be greater
--			than the CBR minimum balance set for this accounts
--			associated customer.
--		Business Rule #5: (Status CBR report flag)
--			The status of the account must have CBRReport = 1 as
--			configured in the Status table. Unknown status codes
--			will not be reported.
-- Change History: 
--			7/14/2003 jcc Originally master.current1 was being inserted 
--			into CbrPendingFile.current0. CbrPendingFile table is altered with a new 
--			field (current1) so master.current0 and master.current1 will be inserted
--			into CbrPendingFile.current0 and CbrPendingFile.current1 respectively.
--			07/14/2003 jcc added insert to new CbrPendingFile field ActualPaymentAmount
--			requires case logic using payhistory table
--             
AS
	set @ErrNum = 0
	declare @runDate datetime
	set @runDate = getdate()

	insert CbrPendingFile( Number, Entered, Current0, Current1, Status, ActivityType, 
		SpecialComment, ActualPaymentAmount) 		
	select m.number, @runDate, m.Current0, m.Current1, m.Status, '93' As ActivityType, '' As SpecialComment,
	case
		when
			isnull((select sum(totalpaid) from payhistory with(nolock) where payhistory.number = m.number
			and batchtype in('PU','PA','PC')
			and entered >= (select max(CreatedDate) from CbrReport with(nolock) where ReportType = 0)
			and entered <= @runDate), 0) 
			-
			isnull((select sum(totalpaid) from payhistory with(nolock) where payhistory.number = m.number
			and batchtype in('PUR','PAR','PCR')
			and entered >= (select max(CreatedDate) from CbrReport with(nolock) where ReportType = 0)
			and entered <= @runDate), 0) < 0 then 0
		else
			isnull((select sum(totalpaid) from payhistory with(nolock) where payhistory.number = m.number
			and batchtype in('PU','PA','PC')
			and entered >= (select max(CreatedDate) from CbrReport with(nolock) where ReportType = 0)
			and entered <= @runDate), 0) 
			-
			isnull((select sum(totalpaid) from payhistory with(nolock) where payhistory.number = m.number
			and batchtype in('PUR','PAR','PCR')
			and entered >= (select max(CreatedDate) from CbrReport with(nolock) where ReportType = 0)
			and entered <= @runDate), 0) 
	end
	as ActualPaymentAmount	
	from master m with(nolock) 
	inner join customer c with(nolock) on c.customer = m.customer 
	left outer join status s with(nolock) on s.code = m.status 
	where m.number not in (select number from CBRStopRequest with(nolock)) 
	and m.number not in (select number from CBRPendingFile with(nolock)) 
	and ((c.CbrClass is not null) and (left(c.CbrClass, 2) <> '00'))
	and ((c.cbrRPTtype is not null) and (c.cbrRPTtype <> ''))
	and ((c.cbrwaitdays is not null) and (getdate() >= dateadd(d, c.cbrwaitdays, m.received)))
	and ((c.cbrminbal is not null) and (m.original1 > c.cbrminbal))
	and (s.CBRReport = 1)
	and ((m.status <> 'SIF') and (m.status <> 'PIF'))

	IF (@@Error!=0)
	BEGIN
    	SET @ErrNum = @@Error
    	RAISERROR  ('20000',16,1,'Error encountered in sp_CbrOpenAccountsToPending.')
    	RETURN(1)
	END	
	SET @ErrNum = 0
GO
