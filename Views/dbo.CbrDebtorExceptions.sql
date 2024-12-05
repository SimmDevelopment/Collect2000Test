SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--exceptions by debtors
create view [dbo].[CbrDebtorExceptions] as
select	customer,cbrenabled,Reportable,StatusCbrReport,StatusCbrDelete,cbrexclude,responsible,cbrexception,outofstatute,debtorexceptions,isbusiness,CbrOverride,rptdtexception,minbalexception,count(*) as Dbtrs
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

group by 
		customer,cbrenabled,Reportable,StatusCbrReport,StatusCbrDelete,cbrexclude,responsible,cbrexception,outofstatute,debtorexceptions,isbusiness,CbrOverride,rptdtexception,minbalexception


GO
