SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Hyundai_Recalls_New2]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @startDate = dbo.F_START_OF_DAY(@startDate)
	SET @endDate = DATEADD(ss, -3, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))


	CREATE TABLE #HyundaiReturns(number int)


insert into #HyundaiReturns(number)
select number
from master with (Nolock)
where customer in ('0001122', '0001123') and ((status in ('sif', 'pif', 'cnd', 'cad', 'b07', 'bky', 'b11', 'b13', 'dec', 'rsk', 'oos') and 
closed between @startDate and @endDate
and qlevel = '998') )


	-- We need to update master to be returned and create a note
	UPDATE master
	SET Qlevel = '999',returned = dbo.date(getdate()),
	closed = CASE WHEN closed IS NULL THEN dbo.date(getdate()) ELSE closed END
	WHERE number IN (SELECT number from #HyundaiReturns)

	-- Insert a Note Showing the return of the account.
	INSERT INTO Notes(number,created,user0,action,result,comment)
	SELECT t.number, getdate(),'EXG','+++++','+++++','Account was in a Hyundai Maintenance Export file.'
	FROM #HyundaiReturns t 

Select 'SIMM' AS Vendor, m.account AS [HCA Account #], 

	case when status = 'DEC' then 'DECEASED'
		--When status = 'AEX' then 'UNCOLLECTABLE'
		when status in ('b07', 'b11', 'b13', 'bky') then 'BK'
		when status in ('cnd', 'cad') then 'CAD'
		WHEN status = 'RSK' THEN 'LITIGOUS DEBTOR'
		WHEN status = 'OOS' THEN 'OUT OF STATUTE'
		else status
	end as [Reason for Closure],
	Case when status = 'DEC' then d.firstname + ' ' + d.lastname + ' ' + (select CONVERT(VARCHAR(10), DOD, 101) from deceased with (Nolock) where debtorid = d.debtorid) ELSE '' END AS [Name of Deceased and DOD],
	CASE WHEN status IN ('CND', 'CAD') THEN 'WRITTEN' ELSE '' END AS [C&D Type],
	CASE WHEN status IN ('CND', 'CAD') AND d.debtorid IN (SELECT debtorid FROM DebtorAttorneys WITH (NOLOCK)) THEN 'Yes' 
		WHEN status IN ('CND', 'CAD') AND d.debtorid NOT IN (SELECT debtorid FROM DebtorAttorneys WITH (NOLOCK)) THEN 'No' ELSE '' END AS [C&D - Attorney?],
	ISNULL(CASE when status in ('b07', 'b11', 'b13', 'bky') THEN (select CONVERT(VARCHAR(3), Chapter) from bankruptcy with (nolock) where debtorid = d.debtorid) ELSE '' END, '') AS [BK Type],
	ISNULL(CASE when status in ('b07', 'b11', 'b13', 'bky') then (select casenumber from bankruptcy with (nolock) where debtorid = d.debtorid)	else ''	END, '') as [BK Case #],
	ISNULL(CASE when status in ('b07', 'b11', 'b13', 'bky') THEN (select CONVERT(VARCHAR(10), DateFiled, 101) from bankruptcy with (nolock) where debtorid = d.debtorid) ELSE '' END, '') AS [BK Filed Date],
	CASE WHEN STATUS IN ('b07', 'b11', 'b13', 'bky') THEN (SELECT 'Bankruptcy Status: ' + b.Status  + ' Dissmisal Date: ' + ISNULL(CONVERT(VARCHAR(10), DismissalDate, 101), 'N/A') + ' Discharged Date: ' + ISNULL(CONVERT(VARCHAR(10), DischargeDate, 101), 'N/A') + ' Court: ' + CourtDistrict + ' Division: ' + CourtStreet1 + ' ' + CourtStreet2 + ' ' + CourtCity + ' ' + b.CourtState + ' ' + CourtZipcode + ' CourtPhone: ' + CourtPhone + 
'   Trustee: ' + Trustee + ' Trustee Address: ' + TrusteeStreet1 + ' ' + TrusteeStreet2 + ' ' + TrusteeCity + ' ' + TrusteeState + ' ' + TrusteeZipcode + ' Trustee Phone: ' + TrusteePhone FROM Bankruptcy b WITH (NOLOCK) WHERE d.DebtorID = DebtorID)
		WHEN status = 'OOS' THEN 'account is outside of the statute of limitations' ELSE '' END AS [Additional Information]
from master m with (Nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0
where m.number in (select number from #HyundaiReturns)

END
GO
