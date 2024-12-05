SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE        PROCEDURE [dbo].[Custom_NCOUploadNSF]
	@customerList as varchar(7999),  
	@startDate as DateTime, 
 	@endDate as DateTime
AS
SET NOCOUNT ON;
SET @customerList=@customerList + '|'
---Record 30 
-- Payments PU,PUR records
-- TODO: all Record 30 should also produce a Record Type = 42 need to write record 42
Select
	m.number,
	'01' as Ret_Code,
	'30' as Record_Code,	
	isnull(m.id2,m.account) as FileNo,
    m.Account as Forw_File ,
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Masco_File') as Masco_File,
        --case m.customer when '0000658' then 'SMG' when '0000666' then 'SOO' end as Firm_ID,
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Firm_ID') as Firm_ID,		
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Forw_ID') as Forw_ID,
	(SELECT CONVERT(varchar, entered, 112) FROM payhistory WHERE UID = p.ReverseofUID) as Pay_Date,
	(case len(ltrim(rtrim(p.batchtype))) when 2 then dbo.Custom_CalculatePaymentTotalPaid(p.uid) else dbo.Custom_CalculatePaymentTotalPaid(p.uid)* -1 end) as Gross_Pay,
	(case len(ltrim(rtrim(p.batchtype))) when 2 then dbo.Custom_CalculatePaymentTotalFee(p.uid) else dbo.Custom_CalculatePaymentTotalFee(p.uid)* -1 end) as Fees,
	'' as Net_Client, '' as Check_Amt, 0 as Cost_Ret, 0 as Cost_Rec, 0 as agent_Fees, 0 as forw_Cut,
	'' as BPJ, p.uid as TA_No, 0 as Rmit_No, /*<--need to tie in batch number here*/ 
	0 as Line1_3,0 as Line1_5,
	(case len(ltrim(rtrim(p.batchtype))) when 2 then dbo.Custom_CalculatePaymentTotalPaid(p.uid) else dbo.Custom_CalculatePaymentTotalPaid(p.uid)* -1 end) as Line1_6, 
	(case Len(rtrim(ltrim(P.batchtype)))WHEN 2 THEN ((P.paid1)* convert(tinyint,substring(P.invoiceflags,1,1)))end ) as Line2_1, 
   (case Len(rtrim(ltrim(P.batchtype)))WHEN 2 THEN ((P.paid2)* convert(tinyint,substring(P.invoiceflags,2,1)))end ) as Line2_2, 
	 0 as Line2_5, 0 as Line2_6, 0 as Line2_7, 
	(case len(ltrim(rtrim(p.batchtype))) when 2 then dbo.Custom_CalculatePaymentTotalFee(p.uid) else dbo.Custom_CalculatePaymentTotalFee(p.uid)* -1 end) as Line2_8,
	 p.payType as Descr,
	ltrim(rtrim(convert(char,p.entered,112))) as Post_Date,
    ltrim(rtrim(convert(char,Getdate(),112))) as Remit_Date,
	'*CC:A020' as TA_Code
	from master m with(nolock), payhistory p with (nolock)
	where p.number = m.number
	and p.matched = 'N' and p.invoiced between  @startDate and @endDate
	and p.customer in (select string from dbo.CustomStringToSet(@customerList, '|'))
	and p.batchtype in ('PUR')

/*
union all
--Record 30 - Increasing Cost, DAR records
select
	m.number,
	'30' as Record_Code,
	'51' as Ret_Code,	
	isnull(m.id2,m.account) as FileNo,
        m.Account as Forw_File ,
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Masco_File') as Masco_File,
--        case m.customer when '0000658' then 'SMG' when '0000666' then 'SOO' end as Firm_ID,	
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Firm_ID') as Firm_ID,		
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Forw_ID') as Forw_ID,
	ltrim(rtrim(convert(char,p.entered,112))) as Pay_Date,
	(case len(ltrim(rtrim(p.batchtype))) when 2 then dbo.Custom_CalculatePaymentTotalPaid(p.uid) else dbo.Custom_CalculatePaymentTotalPaid(p.uid)* -1 end) as Gross_Pay,
	(case len(ltrim(rtrim(p.batchtype))) when 2 then dbo.Custom_CalculatePaymentTotalFee(p.uid) else dbo.Custom_CalculatePaymentTotalFee(p.uid)* -1 end) as Fees,
	'' as Net_Client, '' as Check_Amt, 0 as Cost_Ret, 0 as Cost_Rec, 0 as agent_Fees, 0 as forw_Cut,
	'' as BPJ, p.uid as TA_No, 0 as Rmit_No, 
	0 as Line1_3,0 as Line1_5,0 as Line1_6, 0 as Line2_1, 
	0 as Line2_2, 
	p.paid6+p.paid7 as Line2_5,
    0 as Line2_6, 0 as Line2_7, 0 as Line2_8, p.payType as Descr,
	ltrim(rtrim(convert(char,p.entered,112))) as Post_Date,
    ltrim(rtrim(convert(char,Getdate(),112))) as Remit_Date,
	'*CC:D101' as TA_Code -- this may need to be changed based on comment and money bucket
	from master m with(nolock), payhistory p with (nolock)
	where p.number = m.number 
	and p.matched = 'N' and p.invoiced between  @startDate and @endDate
	and p.customer in (select string from dbo.CustomStringToSet(@customerList, '|'))
	and p.batchtype in ('DAR')
*/



GO
