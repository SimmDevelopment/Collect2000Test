SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*dbo.sp_CbrStatuteLimitationAccounts*/
CREATE     PROCEDURE [dbo].[sp_CbrStatuteLimitationAccounts]
	@ErrNum	INT OUTPUT
-- Name:	sp_CbrStatuteLimitationAccounts
-- Function:	This procedure will insert DA records into CbrPendingFile 
--		table which have accounts outside statute limitations which were
--		previously reported as activity type 93 
--		The procedure will determine whether the master.received, 
--		master.delinquencydate, or master.clidlc is greater than 7 years
--		from the current date. 
--		CbrStopRequest records will be created for these accounts
--		This sp should only be called from sp_CbrPrepareFullReport
-- Creation:	09/02/2004 jc    
-- Change History: 
AS
	set @ErrNum = 0
	declare @runDate datetime
	set @runDate = getdate()

	--create DA records for all accounts previously reported as 93 which are now 
	--greater than 7 years from either received, delinquencydate, or clidlc
	insert CbrPendingFile( Number, Entered, Current0, Current1, Status, ActivityType,
		SpecialComment, ActualPaymentAmount) 		
	select m.number, @runDate, 0, 0, m.Status, 'DA' As ActivityType, '' As SpecialComment, 0
	from master m with(nolock)
	inner join cbrreport r with(nolock) on r.createddate = (select max(createddate) from cbrreport with(nolock) where ReportType=0)
	inner join cbrreportdetail rd with(nolock) on rd.AccountId = m.number and rd.ReportId = r.Id and rd.ActivityType = '93'
	where m.received <= dateadd(yyyy, -7, @runDate)
	and m.number not in (select number from CBRStopRequest with(nolock)) 
	and m.number not in (select number from CBRPendingFile with(nolock)) 

	--create stop requests evaluating master.received 
	insert CbrStopRequest( Number, WhenCreated) 		
	select m.Number, @runDate
	from master m with(nolock)
	where m.received is not null
	and m.received <= dateadd(yyyy, -7, @runDate)
	and m.number not in (select number from CBRStopRequest with(nolock)) 

	--create stop requests evaluating master.delinquencydate 
	insert CbrStopRequest( Number, WhenCreated) 		
	select m.Number, @runDate
	from master m with(nolock)
	where m.delinquencydate is not null
	and m.delinquencydate <= dateadd(yyyy, -7, @runDate)
	and m.number not in (select number from CBRStopRequest with(nolock)) 

	--create stop requests evaluating master.clidlc 
	insert CbrStopRequest( Number, WhenCreated) 		
	select m.Number, @runDate
	from master m with(nolock)
	where m.clidlc is not null
	and m.clidlc <= dateadd(yyyy, -7, @runDate)
	and m.number not in (select number from CBRStopRequest with(nolock)) 

	IF (@@Error!=0)
	BEGIN
    	SET @ErrNum = @@Error
    	RAISERROR  ('20000',16,1,'Error encountered in sp_CbrStatuteLimitationAccounts.')
    	RETURN(1)
	END	
	SET @ErrNum = 0
GO
