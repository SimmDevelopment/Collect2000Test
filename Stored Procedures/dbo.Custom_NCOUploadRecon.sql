SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_NCOUploadRecon]
	-- Add the parameters for the stored procedure here
	@customerList as varchar(7999)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
m.number,
	'38' as Record_Code,
	(Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'File_NO')  as FileNo,
        m.Account as Forw_File ,
	--Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Masco_File'),' ') as Masco_File,
--     Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Firm_ID'),' ') as Firm_ID,	
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Firm_ID'),'SMG3') as Firm_ID,		
	Isnull((Select TheData from MiscExtra with (nolock) where number = m.number and Title = 'Forw_ID'),' ') as Forw_ID,
	m.received as DPlaced,
	d.name as Debt_Name,
	m.originalcreditor as Cred_Name,
	m.current1 as D1_Bal,
	m.lastinterest as IDate,
	m.accrued2 as IAmt,
	m.current2 as IDue,
	m.paid as Paid,
	m.current0 as Cost_Bal,
	rtrim(d.city) + ltrim(d.state) as Debt_CS,
	d.zipcode as Debt_Zip,
	isnull(m.previouscreditor, '') as Cred_Name2,
	d.ssn as SSN
	
from master m with (nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0
where m.customer in (select string from dbo.CustomStringToSet(@customerList, '|'))


END
GO
