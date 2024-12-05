SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/24/2022
-- Description: Export record 31 only
-- =============================================
CREATE PROCEDURE [dbo].[Custom_WRC_Record_31]
	-- Add the parameters for the stored procedure here
	@startdate datetime,
	@enddate DATETIME

	-- exec Custom_YGC_WRC_Record_31 '20220324', '20220324'

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
--Begin Record code 31 - Primary Debtor Info Update
select  '31' as record_code,
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,	
	d.name as d1_name,
	'' as d1_salut,
	'' as d1_alias,
	d.street1 as d1_street,
	rtrim(d.city) + ', ' + rtrim(d.state) as d1_cs,
	d.zipcode as d1_zip,
	ISNULL((SELECT TOP 1 phonenumber FROM Phones_Master pm WITH (NOLOCK) WHERE pm.PhoneTypeID = 1 AND (pm.PhoneStatusID IS NULL OR pm.PhoneStatusID = 2) AND d.DebtorID = pm.DebtorID ORDER BY pm.LastUpdated DESC), d.HomePhone) as d1_phone,
	ISNULL(d.fax, '') as d1_fax,
	d.ssn as d1_ssn,
	'' as rfile,
	'' as d1_dob,
	'' as d1_dl,
	d.state as d1_state,
	d.mr as d1_mail,
	'' as service_d,
	'' as answer_due_d,
	'' as answer_file_d,
	'' as default_d,
	'' as trial_d,
	'' as hearing_d,
	'' as lien_d,
	'' as garn_d,
	'' as service_type,
	d.street2 as d1_strt2,
	d.city as d1_city,
	ISNULL((SELECT TOP 1 phonenumber FROM Phones_Master pm WITH (NOLOCK) WHERE pm.PhoneTypeID = 3 AND (pm.PhoneStatusID IS NULL OR pm.PhoneStatusID = 2) AND d.DebtorID = pm.DebtorID ORDER BY pm.LastUpdated DESC), '') as d1_cell,
	'' as score_fico,
	'' as score_collect,
	'' as score_other,
	'USA' as d1_cntry,
	d.street1 + ' ' + d.street2 as d1_street_long,
	'' as d1_street2_long,
	d.firstName AS firstname,
	d.lastName AS lastname,
	'' AS scoreinternal,
	'' AS stage
from master m with (nolock) inner join debtors d with (nolock) on m.number = d.number and d.seq = 0
where m.customer = '0002770' and 
(CAST(dateupdated AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
OR (SELECT TOP 1 CAST(lastupdated AS DATE) FROM Phones_Master pm WITH (NOLOCK) WHERE pm.PhoneTypeID = 1 AND (pm.PhoneStatusID IS NULL OR pm.PhoneStatusID IN (0, 2)) AND d.DebtorID = pm.DebtorID ORDER BY pm.LastUpdated DESC) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
OR (SELECT TOP 1 CAST(lastupdated AS DATE) FROM Phones_Master pm WITH (NOLOCK) WHERE pm.PhoneTypeID = 3 AND (pm.PhoneStatusID IS NULL OR pm.PhoneStatusID IN (0, 2)) AND d.DebtorID = pm.DebtorID ORDER BY pm.LastUpdated DESC) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE))
--end Record code 31
END

--SELECT * 
--FROM Phones_Master pm WITH (NOLOCK) 
--WHERE pm.Number = 3190894

--SELECT TOP 1 CAST(lastupdated AS DATE) , pm.PhoneNumber
--FROM Phones_Master pm WITH (NOLOCK) 
--WHERE pm.PhoneTypeID = 3 AND (pm.PhoneStatusID IS NULL OR pm.PhoneStatusID IN (0, 2)) AND pm.Number = 3190894 
--ORDER BY pm.LastUpdated DESC


GO
