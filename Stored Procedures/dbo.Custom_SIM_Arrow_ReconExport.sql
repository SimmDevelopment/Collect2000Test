SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
/*
[Custom_NCC_Arrow_ReconExport]
*/
CREATE procedure [dbo].[Custom_SIM_Arrow_ReconExport]

-- @customer varchar(7)
as
begin
-- DECLARE @lastFileDateTime datetime
-- SELECT @lastFileDateTime = dbo.Custom_GetLastFileDate(5,@customer)


SELECT
	m.account as account,
	m.ssn as debtor_ssn,
	substring(m.name,0,charindex(',',m.name,0))  as debtor_last_name,
	substring(m.name,charindex(',',m.name,0)+2,len(m.name)-charindex(',',m.name,0)) as debtor_first_name,
	m.received as agency_list_date,
	m.closed as agency_close_date,
	m.original as agency_list_balance,
	m.current0 as agency_current_balance,
	m.status as status,
	.15 as agency_fee_rate
	
FROM
	master m  
	join fact f on f.customerid = m.customer
	join customcustgroups c on c.id = f.customgroupid
	
WHERE  m.customer in (select customerid from fact (nolock) where customgroupid = 97)

end
GO
