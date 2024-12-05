SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--account level exceptions
create view [dbo].[CbrAccountExceptions] as 
select	customer,count(distinct number ) as accts
from	dbo.cbr_exceptions 
where	(statuscbrreport=1 or statuscbrdelete=1)
and	not	(
					CbrExclude=0
			and		Responsible=1
			and		CbrException=0
			and		OutOfStatute=0
			and		DebtorExceptions=0
			and		IsBusiness=0
			and		CbrOverride=0
			and		RptDtException=0
			and		MinBalException=0)
and		number not in (select accountid from dbo.cbr_accounts)
group by 
		customer

GO
