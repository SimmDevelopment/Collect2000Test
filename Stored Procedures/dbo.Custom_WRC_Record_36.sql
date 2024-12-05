SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/24/2022
-- Description: Export record 36 only
-- =============================================
CREATE PROCEDURE [dbo].[Custom_WRC_Record_36]
	-- Add the parameters for the stored procedure here
	@startdate datetime,
	@enddate DATETIME

	-- exec Custom_YGC_WRC_Record_36 '20220315', '20220315'

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
--Begin Record code 36 - Primary Debtor Info Update
select  '36' as record_code,
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,	
	da.Name AS adva_name,
	SUBSTRING(da.Firm, 1, 30) AS adva_firm,
	CASE WHEN LEN(da.Firm) > 30 THEN SUBSTRING(da.Firm, 31, 30) ELSE '' END AS adva_firm2,
	da.Addr1 AS adva_street,
	da.city + ', ' + da.State + ' ' + da.Zipcode AS adva_csz,
	'' AS adva_salut,
	da.Phone AS adva_phone,
	da.Fax AS adva_fax,
	'' AS adva_fileno,
	'' AS misc_date1,
	'' AS misc_date2,
	'' AS misc_amt1,
	'' AS misc_amt2,
	'' AS misc_comm1,
	'' AS misc_comm2,
	'' AS misc_comm3,
	'' AS misc_comm4,
	'' AS adva_num,
	'USA' AS adva_cntry,
	'' AS adversemotionfileddate,
	'' AS adversemotionreceiveddate,
	'' AS adversemotiondescription
from master m with (nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0 INNER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
where m.customer = '0002770' and 
CAST(da.DateCreated AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)

--end Record code 36

END



GO
