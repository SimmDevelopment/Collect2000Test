SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




/*

DECLARE @customerList varchar(7999)
DECLARE @startDate datetime
DECLARE @endDate datetime
set @customerList = '0000658|0000666|0000609|'
set @startDate = '20070201'
set @endDate = '20070215'
EXEC [Custom_NCOUploadRemit] @customerList, @startDate, @endDate

*/

--Scott Gormant Altered to add reversal and take out adjusments 20070125

CREATE         PROCEDURE [dbo].[Custom_NCOUploadRemit]
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
	case when m.status = 'SIF' then '3' else '1' end as Ret_Code,
	'30' as Record_Code,	
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'File_NO') as FileNo,   
    	m.Account as Forw_File ,
	(Select isnull(TheData,' ') from MiscExtra with (nolock) where number = m.number and Title = 'Masco_File') as Masco_File,
        --case m.customer when '0000658' then 'SMG' when '0000666' then 'SOO' else 'SMG' end as Firm_ID,
	isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Firm_ID'),' ') as Firm_ID,		
	isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Forw_ID'),' ') as Forw_ID,
	ltrim(rtrim(convert(char,p.entered,112))) as Pay_Date,
	(case len(ltrim(rtrim(p.batchtype))) when 2 then dbo.Custom_CalculatePaymentTotalPaid(p.uid) else dbo.Custom_CalculatePaymentTotalPaid(p.uid)* -1 end) as Gross_Pay,
	'' as Fees,--(case len(ltrim(rtrim(p.batchtype))) when 2 then dbo.Custom_CalculatePaymentTotalFee(p.uid) else dbo.Custom_CalculatePaymentTotalFee(p.uid)* -1 end) as Fees,
	'' as Net_Client,
	'' as Check_Amt,
	'' as Cost_Ret, 
	'' as Cost_Rec,
	'' as agent_Fees, 
	'' as forw_Cut,
	'' as BPJ, 
	'' as TA_No,--p.uid as TA_No, 
	'' as Rmit_No, /*<--need to tie in batch number here*/ 
	'' as Line1_3,
	'' as Line1_5,
	'' as Line1_6, --(case len(ltrim(rtrim(p.batchtype))) when 2 then dbo.Custom_CalculatePaymentTotalPaid(p.uid) else dbo.Custom_CalculatePaymentTotalPaid(p.uid)* -1 end) as Line1_6, 
	'' as Line2_1, --(case Len(rtrim(ltrim(P.batchtype)))WHEN 2 THEN ((P.paid1)* convert(tinyint,substring(P.invoiceflags,1,1)))end ) as Line2_1, 
   	'' as Line2_2, --(case Len(rtrim(ltrim(P.batchtype)))WHEN 2 THEN ((P.paid2)* convert(tinyint,substring(P.invoiceflags,2,1)))end ) as Line2_2, 
	'' as Line2_5,
	'' as Line2_6, 
	'' as Line2_7, 
	'' as Line2_8,--(case len(ltrim(rtrim(p.batchtype))) when 2 then dbo.Custom_CalculatePaymentTotalFee(p.uid) else dbo.Custom_CalculatePaymentTotalFee(p.uid)* -1 end) as Line2_8,
	'' as Descr,--p.payType as Descr,
	'' as Post_Date,--ltrim(rtrim(convert(char,p.entered,112))) as Post_Date,
    	'' as Remit_Date,--ltrim(rtrim(convert(char,Getdate(),112))) as Remit_Date,
	'' as TA_Code--*CC:A020' as TA_Code
	from master m with(nolock), payhistory p with (nolock)
	where p.number = m.number
	and p.matched = 'N' and p.entered between  @startDate and @endDate
	and p.customer in (select string from dbo.CustomStringToSet(@customerList, '|'))
	and p.batchtype in ('PU','PUR')
--union all
--Record 30 - Increasing Cost, DAR records
--select
--	m.number,
--	'30' as Record_Code,
--	'51' as Ret_Code,	
--	m.id2 as FileNo,
--        m.Account as Forw_File ,
--	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Masco_File') as Masco_File,
--         case m.customer when '0000658' then 'SMG' when '0000666' then 'SOO' end as Firm_ID,		
--	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Forw_ID') as Forw_ID,
--	ltrim(rtrim(convert(char,p.entered,112))) as Pay_Date,
--	(case len(ltrim(rtrim(p.batchtype))) when 2 then dbo.Custom_CalculatePaymentTotalPaid(p.uid) else dbo.Custom_CalculatePaymentTotalPaid(p.uid)* -1 end) as Gross_Pay,
--	'' as Fees,--(case len(ltrim(rtrim(p.batchtype))) when 2 then dbo.Custom_CalculatePaymentTotalFee(p.uid) else dbo.Custom_CalculatePaymentTotalFee(p.uid)* -1 end) as Fees,
--	'' as Net_Client,
-- 	'' as Check_Amt, 
--	'' as Cost_Ret, 
--	'' as Cost_Rec, 
--	'' as agent_Fees, 
--	'' as forw_Cut,
--	'' as BPJ, 
--	''  as TA_No,--p.uid as TA_No, 
--	'' as Rmit_No, /*<--need to tie in batch number here*/ 
--	'' as Line1_3,
--	'' as Line1_5,
--	'' as Line1_6, 
--	'' as Line2_1, 
--	'' as Line2_2, 
--	'' as Line2_5,--p.paid6+p.paid7 as Line2_5,
--	'' as Line2_6, 
--	'' as Line2_7, 
--	'' as Line2_8, 
--	'' as Descr,--p.payType as Descr,
--	'' as Post_Date,--ltrim(rtrim(convert(char,p.entered,112))) as Post_Date,
--    	'' as Remit_Date,--ltrim(rtrim(convert(char,Getdate(),112))) as Remit_Date,
--	'' as TA_Code--'*CC:D101' as TA_Code /* this may need to be changed based on comment and money bucket*/
--	from master m with(nolock), payhistory p with (nolock)
--	where p.number = m.number 
--	and p.matched = 'N' and p.entered between  @startDate and @endDate
--	and p.customer in (select string from dbo.CustomStringToSet(@customerList, '|'))
--	and p.batchtype in ('DAR')









GO
