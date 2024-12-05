SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*dbo.sp_CbrInsertCbrReportHistory*/
CREATE    PROCEDURE [dbo].[sp_CbrInsertCbrReportHistory]
	@ReportType INT, @FileName varchar(256), @Header varchar(1024),
	@Trailer varchar(1024), @UserName varchar(50), @IncludeFeesAndInterest bit = null
-- Name:	sp_CbrInsertCbrReportHistory
-- Function:	This procedure will insert into historical tables CbrReport and
--		CbrReportDetail from CbrPendingFile table.
--		This sp should only be called from sp_CbrLoadCbrPendingTable
-- Creation:	01/16/2003 (jcc)    
-- Change History:
--		03/26/2003 (jcc) added field ExceptionType (int) to table CbrPendingFile
--		conditional where clause required to not retrieve exception records
--		WHERE (p.ExceptionType is null OR p.ExceptionType = 0)
--		07/14/2003 jcc added insert to new CbrReportDetail field Current0
--		07/14/2003 jcc added insert to new CbrReportDetail field ActualPaymentAmount
--             	11/16/2004 jc added support for new input parm @IncludeFeesAndInterest bit
--		this is set while running the cbr wizard and will correctly set balance reported 
--		based on this input parm. 
AS

	--set default IncludeFeesAndInterest if one not passed to always include fees and interest
	if @IncludeFeesAndInterest is null set @IncludeFeesAndInterest = 1

	DECLARE @ReportId INT

	--Insert CbrReport record
	INSERT	INTO CbrReport( ReportType, FileName, Header, Trailer, CreatedDate, CreatedBy )
	VALUES(	@ReportType, @FileName, @Header, @Trailer, getdate(), @UserName )		

	SELECT @ReportId = SCOPE_IDENTITY()

	--Insert CbrReportDetail records
	INSERT	CbrReportDetail( ReportId, AccountId, Balance, Status, ActivityType, SpecialComment,
				CustomerName, CbrClass, received, original1, current0, current1,
				ActualPaymentAmount, DelinquencyDate, clidlc, returned, lastpaid, 
				ssn, phone, mr)
	SELECT	@ReportId, p.Number, 
		case 
			when (@IncludeFeesAndInterest = 1) then p.Current0
			else p.Current1
		end as balance,
		p.Status, p.ActivityType, p.SpecialComment, 
		c.Name As CustomerName, c.CbrClass, m.received, m.original1, m.current0, m.current1,
		p.ActualPaymentAmount, m.DelinquencyDate, m.clidlc, m.returned, m.lastpaid, m.ssn,
		m.homephone, m.mr
	FROM	CbrPendingFile p with(nolock)
	INNER JOIN master m with(nolock) ON p.Number = m.number
	INNER JOIN Customer c with(nolock) ON c.customer = m.customer
	WHERE (p.ExceptionType is null OR p.ExceptionType = 0)


GO
