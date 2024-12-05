SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_GS2_Reliamax_Payment_File] 
@invoice varchar(8000)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Payment Header
select top 1 'RPPS' as formattype,	
replace(CONVERT(varchar(10), GETDATE(), 101), '/', '') as processing,
    'SIMS' as entityid
     --count(*) as entrycount,
     --replace(sum(case when batchtype like '%r' then -(p.paid1 + p.paid2 + OverPaidAmt) else (p.paid1 + p.paid2 + OverPaidAmt) end), '.', '') as dollarscents
	FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
WHERE p.Invoice in (select string from dbo.CustomStringToSet(@invoice,'|') )
--where p.customer in ('0001802','0001803') --and invoiced = dbo.date(getdate()) 
--and batchtype = 'pu'

--payment detail records
select 
	UID as trackingnumber,
	(select top 1 thedata from miscextra with (nolock) where number = p.number and title = 'Pri.0.ServicerSubAccountNumber') as accountnumber,
	Name as name,
	replace((p.paid1 + p.paid2), '.', '') as dollarscents	
from payhistory p with (nolock) inner join master m with (nolock) on p.number = m.number
WHERE p.Invoice in (select string from dbo.CustomStringToSet(@invoice,'|') )
--where p.customer in ('0001802','0001803') --and invoiced = dbo.date(getdate()) 
--and batchtype = 'pu'
END
GO
