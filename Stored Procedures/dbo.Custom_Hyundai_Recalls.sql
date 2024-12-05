SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Hyundai_Recalls]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    CREATE TABLE #HyundaiReturns(number int)

    insert into #HyundaiReturns(number)
select number
from master with (Nolock)
where customer in ('0001055') and ((status in ('sif', 'pif', 'cnd', 'cad', 'b07', 'bky', 'b11', 'b13', 'dec', 'aex') and 
closed between dbo.F_START_OF_MONTH(dateadd(mm, -1, getdate())) and dbo.F_END_OF_MONTH(dateadd(mm, -1, getdate()))
and qlevel = '998') )--OR (status = 'spr')) --removed SPR from showing up. 8/29/2014


	-- We need to update master to be returned and create a note
	UPDATE master
	SET Qlevel = '999',returned = dbo.date(getdate()),
	closed = CASE WHEN closed IS NULL THEN dbo.date(getdate()) ELSE closed END
	WHERE number IN (SELECT number from #HyundaiReturns)

	-- Insert a Note Showing the return of the account.
	INSERT INTO Notes(number,created,user0,action,result,comment)
	SELECT t.number, getdate(),'EXG','+++++','+++++','Account was in a Hyundai Maintenance Export file.'
	FROM #HyundaiReturns t 

Select m.account, 

	case when status = 'DEC' then 'Deceased'
		When status = 'AEX' then 'Uncollectable'
		when status in ('b07', 'b11', 'b13', 'bky') then 'Bankruptcy'
		when status in ('cnd', 'cad') then 'Cease and Desist'
		--WHEN status = 'spr' THEN 'Single Party Release' --removed spr from being sent 8/29/2014
		else status
	end as Reason, d.lastname,

	Case when status = 'DEC' then (select CONVERT(VARCHAR(10), DOD, 101) from deceased with (Nolock) where debtorid = d.debtorid)
		when status in ('b07', 'b11', 'b13', 'bky') then (select casenumber from bankruptcy with (nolock) where debtorid = d.debtorid)
		else ''
	end as OtherInfo
	
from master m with (Nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0
where m.number in (select number from #HyundaiReturns)
END
GO
