SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 4/8/2020
-- Description:	Export Debtor Contact Updates
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CitizensBank_DN_Contact_Update] 
	-- Add the parameters for the stored procedure here
	@startDate AS datetime,
	@endDate AS DATETIME
AS

--exec custom_citizensbank_dn_contact_update '20200503', '20200503'

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    --Address Update Primary
	SELECT m.id1 AS data_id, 
	m.account AS pri_acctno, 
	'1' AS contacttype_id,
	'Primary Consumer' AS contact_source,
'' AS contact_ssn,
d.firstName AS contact_first, 
'' AS contact_middle, 
d.lastName AS contact_last,
d.Name AS contact_name, 
'' AS contact_suffix, 
ah.NewStreet1 AS contact_add1, 
ah.NewStreet2 AS contact_add2,
ah.NewCity AS contact_city, 
ah.NewState	AS contact_state, 
ah.NewZipcode AS contact_zip, 
'' AS contact_country,
'' AS contact_hphone, 
'' AS contact_wphone, 
'' AS contact_cell, 
'' AS contact_fax, 
'' AS contact_dob,
'' AS contact_dod, 
'' AS contact_other, 
'' AS contact_alias,
'' AS contact_email
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq <> 0
INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0001110', '0001111', '0001112')
AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

UNION all

--Phone Update
SELECT m.id1 AS data_id,
m.account AS pri_acctno, 
CASE ph.Phonetype when 1 THEN '1' WHEN 2 THEN '2' end AS contacttype_id, 
CASE ph.Phonetype when 1 THEN 'Primary Consumer' WHEN 2 THEN 'Employer' end AS contact_source,
'' AS contact_ssn,
d.firstName AS contact_first, 
'' AS contact_middle, 
d.lastName AS contact_last,
d.Name AS contact_name, 
'' AS contact_suffix, 
'' AS contact_add1, 
'' AS contact_add2,
'' AS contact_city, 
''	AS contact_state, 
'' AS contact_zip, 
'' AS contact_country,
CASE ph.Phonetype when 1 THEN ph.NewNumber ELSE '' end AS contact_hphone, 
CASE ph.Phonetype when 2 THEN ph.NewNumber ELSE '' end AS contact_wphone, 
'' AS contact_cell, 
'' AS contact_fax, 
'' AS contact_dob,
'' AS contact_dod, 
'' AS contact_other, 
'' AS contact_alias,
'' AS contact_email
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN dbo.PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID
WHERE customer IN ('0001110', '0001111', '0001112') AND NewNumber <> ''
AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
--AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date('20200503') AND dbo.date('20200503')


UNION all

--Phone Update
SELECT m.id1 AS data_id,
m.account AS pri_acctno, 
CASE d.seq when 0 THEN '9' WHEN 1 THEN '56' end AS contacttype_id, 
CASE d.seq when 0 THEN 'Attorney' WHEN 1 THEN 'Liable Co-Debtor Attorney' end AS contact_source,
'' AS contact_ssn,
'' AS contact_first, 
'' AS contact_middle, 
'' AS contact_last,
da.Name AS contact_name, 
'' AS contact_suffix, 
da.Addr1 AS contact_add1, 
da.Addr2 AS contact_add2,
da.City AS contact_city, 
da.State	AS contact_state, 
da.Zipcode AS contact_zip, 
'' AS contact_country,
da.Phone AS contact_hphone, 
'' AS contact_wphone, 
'' AS contact_cell, 
da.Fax AS contact_fax, 
'' AS contact_dob,
'' AS contact_dod, 
'' AS contact_other, 
'' AS contact_alias,
'' AS contact_email
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
WHERE customer IN ('0001110', '0001111', '0001112')
AND closed IS NULL AND dbo.date(da.DateUpdated) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)


END
GO
