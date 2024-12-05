SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_InvestiNet_Contact_Update] 
	-- Add the parameters for the stored procedure here
	@startDate AS datetime,
	@endDate AS DATETIME
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.id1 AS data_id, 
	'' AS contact_id, 
	'' AS contact_source_acctno,
	'' AS contact_status,
	'1' AS contacttype_id,
	'Primary Consumer' AS contact_source,
'' AS contact_ssn,
'' AS contact_taxid, 
d.firstName AS contact_first, 
'' AS contact_middle, 
d.lastName AS contact_last,
d.Name AS contact_name, 
'' AS contact_company,
'' AS contact_suffix, 
ah.NewStreet1 AS contact_add1, 
ah.NewStreet2 AS contact_add2,
ah.NewCity AS contact_city, 
ah.NewState	AS contact_state, 
ah.NewZipcode AS contact_zip, 
'' AS contact_country,
'' AS contact_hphone, 
'' AS contact_wphone, 
'' AS contact_wphone_ext,
'' AS contact_ophone,
'' AS contact_ophone_ext,
'' AS contact_email, 
'' AS contact_fax, 
'' AS contact_cphone,
'' AS contact_date,
'' AS contact_dob,
'' AS contact_dod, 
'' AS contact_other, 
'' AS contact_alias,
'' AS contact_bank_account,
'' AS contact_bank_aba
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0001095')
AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)


UNION all

SELECT m.id1 AS data_id, 
	'' AS contact_id, 
	'' AS contact_source_acctno,
	'' AS contact_status,
CASE ph.Phonetype when 1 THEN '1' WHEN 2 THEN '2' end AS contacttype_id, 
CASE ph.Phonetype when 1 THEN 'Primary Consumer' WHEN 2 THEN 'Employer' end AS contact_source,
'' AS contact_ssn,
'' AS contact_taxid, 
d.firstName AS contact_first, 
'' AS contact_middle, 
d.lastName AS contact_last,
d.Name AS contact_name, 
'' AS contact_company,
'' AS contact_suffix, 
'' AS contact_add1, 
'' AS contact_add2,
'' AS contact_city, 
''	AS contact_state, 
'' AS contact_zip, 
'' AS contact_country,
CASE ph.Phonetype when 1 THEN ph.NewNumber ELSE '' end AS contact_hphone, 
CASE ph.Phonetype when 2 THEN ph.NewNumber ELSE '' end AS contact_wphone, 
'' AS contact_wphone_ext,
'' AS contact_ophone,
'' AS contact_ophone_ext,
'' AS contact_email, 
'' AS contact_fax, 
'' AS contact_cphone,
'' AS contact_date,
'' AS contact_dob,
'' AS contact_dod, 
'' AS contact_other, 
'' AS contact_alias,
'' AS contact_bank_account,
'' AS contact_bank_aba
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN dbo.PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID
WHERE customer IN ('0001095') AND NewNumber <> ''
AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)


END
GO
