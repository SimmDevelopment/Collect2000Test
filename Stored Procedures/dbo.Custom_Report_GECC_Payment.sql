SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






/*

DECLARE @customer varchar(30)
DECLARE @startdate datetime
DECLARE @enddate datetime
set @customer = '0000669|'
set @startdate = '20070201'
set @enddate = '20070215'
EXEC [Custom_Report_GECC_Payment] @customer, @startdate, @enddate

*/

CREATE       procedure [dbo].[Custom_Report_GECC_Payment]
@customer varchar(8000),
@invoice varchar(8000)
as


	DECLARE @tmpGECC_payment TABLE(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[number] [int] NOT NULL,
	[datepaid] datetime NULL,
	[Paid_Agency] [money] NULL,
	[Paid_Client] [money] NULL,
	[Agency_Comm] [money] NULL,
	[Client_Principal] [money] NULL,
	[Due_Client] [money] NULL,
	[Balance_Due] [money] NULL,
	[Payment_type] varchar(3))

	INSERT INTO @tmpGECC_payment (number,datepaid,Paid_Agency,Paid_Client,Agency_Comm,Client_Principal,Due_Client,Balance_Due,Payment_type)
select 
	p.number
	,p.datepaid
	,case 
		when p.batchtype not in ('PC') then dbo.Custom_CalculatePaymentTotalPaid (p.uid)
		else 0.00
	end
	,case 
		when p.batchtype not in ('PC') then dbo.Custom_CalculatePaymentTotalPaid (p.uid)
		else 0.00
	end
	,(p.fee1 + p.fee2 + p.fee3 + p.fee4 + p.fee5 + p.fee6 + p.fee7 + p.fee8 + p.fee9 + p.fee10)
	,case 
		when p.batchtype not in ('PC') then ((dbo.Custom_CalculatePaymentTotalPaid (p.uid)) - (p.fee1 + p.fee2 + p.fee3 + p.fee4 + p.fee5 + p.fee6 + p.fee7 + p.fee8 + p.fee9 + p.fee10)) else 0.00
	end
	,case 
		when p.batchtype not in ('PC') then ((dbo.Custom_CalculatePaymentTotalPaid (p.uid)) - (p.fee1 + p.fee2 + p.fee3 + p.fee4 + p.fee5 + p.fee6 + p.fee7 + p.fee8 + p.fee9 + p.fee10))
		else 0.00
	end 
	,m.current0
	,p.batchtype
from payhistory p with(nolock)
join master m with(nolock) on m.number = p.number
where m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))
and p.invoice IN (SELECT string FROM dbo.CustomStringToSet(@invoice, '|'))
and p.batchtype in ('PC','PU','PA','PAR','PCR','PCR', 'PUR')

--payments
select 
	t.datepaid as [Date]
	,m.name as [Debtor Name]	
	,m.account as [Reference]
	,m.status as [Status]
	,t.paid_agency as [Paid Agency]
	,t.paid_client as [Paid Client]
	,m.current0 as [Balance Due]
	,t.agency_comm as [Agency Comm]
	,t.client_principal as [Client Principal]
	,'0.00' as [Adjustments]
	,t.due_client as [Due Client]
from @tmpGECC_payment t 
left outer join master m with(nolock) on m.number = t.number
where t.Payment_type in ('PC','PU','PA')


--reversal
select 
	t.datepaid as [Date]
	,m.name as [Debtor Name]
	,m.account as [Reference]
	,m.status as [Status]
	,t.paid_agency as [Paid Agency]
	,t.paid_client as [Paid Client]
	,m.current0 as [Balance Due]
	,t.agency_comm as [Agency Comm]
	,t.client_principal as [Client Principal]
	,'0.00' as [Adjustments]
	,-t.due_client as [Due Client]
from @tmpGECC_payment t 
left outer join master m with(nolock) on m.number = t.number
where t.payment_type in ('PCR','PUR','PAR')






GO
