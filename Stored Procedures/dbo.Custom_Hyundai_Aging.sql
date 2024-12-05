SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Hyundai_Aging]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	CREATE TABLE #HyundaiReturns(number int)


insert into #HyundaiReturns(number)
select number
from master m with (nolock)
where customer in ('0001122', '0001123', '0001162') and datediff(dd, received, getdate()) > 180 and closed is null and 
m.status not in ('pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'bkn', 'stl', 'hot', 'npc') AND number NOT IN (SELECT number FROM master WITH (NOLOCK)
WHERE customer IN ('0001122', '0001123', '0001162') AND DATEDIFF(dd, lastpaid, getdate()) <=180)


	-- We need to update master to be returned and create a note
	UPDATE master
	SET Qlevel = '999',returned = dbo.date(getdate()), status = 'RCL', 
	closed = CASE WHEN closed IS NULL THEN dbo.date(getdate()) ELSE closed END
	WHERE number IN (SELECT number from #HyundaiReturns)

	-- Insert a Note Showing the return of the account.
	INSERT INTO Notes(number,created,user0,action,result,comment)
	SELECT t.number, getdate(),'EXG','+++++','+++++','Account was in a Hyundai Aging Export file.'
	FROM #HyundaiReturns t 

Select d.lastname, m.account, m.received,

	case when status = 'DEC' then 'Deceased'
		When status = 'AEX' then 'Uncollectable'
		when status in ('b07', 'b11', 'b13', 'bky') then 'Bankruptcy'
		when status in ('cnd', 'cad') then 'Cease and Desist'
		else '180 Day Aging'
	end as Reason,
	'' as OtherInfo
from master m with (Nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0
where m.number in (select number from #HyundaiReturns)

END
GO
