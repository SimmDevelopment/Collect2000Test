SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_ARC_Contact_Update] 
	-- Add the parameters for the stored procedure here
	@startDate AS datetime,
	@endDate AS DATETIME
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT (select top 1 (thedata) from miscextra me with (nolock) where number = m.number and title = 'Con.0.contact_id') AS contact_id,
	m.id2 AS data_id,
	(select top 1 (thedata) from miscextra me with (nolock) where number = m.number and title = 'Con.0.contact_status') AS contact_status,
	CASE WHEN d.seq = 0 THEN '10' WHEN d.seq = 1 THEN '17' ELSE '9' END AS contacttype_id,
	'Primary Consumer' AS contact_source,
	'' AS contact_taxid, 
	d.firstName AS contact_first, 
    d.lastName AS contact_last,
	d.firstName + d.lastName AS contact_name,
	'' AS contact_company,
	ah.NewStreet1 AS contact_add1, 
	ah.NewStreet2 AS contact_add2,
	ah.NewCity AS contact_city, 
	ah.NewState	AS contact_state, 
	ah.NewZipcode AS contact_zip, 
	'' AS contact_country,
	'' AS contact_hphone, 
	'' AS contact_wphone, 
	'' AS contact_ophone,
	'' AS contact_email, 
	'' AS contact_fax, 
	'' AS contact_cphone,
	'' AS contact_date
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0003098')
AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

UNION all

SELECT '' AS contact_id,
	m.id2 AS data_id, 
	'' AS contact_status,
	CASE ph.Phonetype when 1 THEN '1' WHEN 2 THEN 2 end AS contacttype_id,
	CASE ph.Phonetype when 1 THEN 'Primary Consumer' WHEN 2 THEN 'Employer' end AS contact_source,
	'' AS contact_taxid, 
	d.firstName AS contact_first, 
	d.lastName AS contact_last,
	'' AS contact_name, 
	'' AS contact_company,
	'' AS contact_add1, 
	'' AS contact_add2,
	'' AS contact_city, 
	''	AS contact_state, 
	'' AS contact_zip, 
	'' AS contact_country,
	CASE ph.Phonetype when 1 THEN ph.NewNumber ELSE '' end AS contact_hphone, 
	CASE ph.Phonetype when 2 THEN ph.NewNumber ELSE '' end AS contact_wphone, 
	'' AS contact_ophone,
	'' AS contact_email, 
	'' AS contact_fax, 
	'' AS contact_cphone,
	'' AS contact_date
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN dbo.PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID
WHERE customer IN ('0003098') AND NewNumber <> ''
AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
--and id2 not in ('AllGate','ARS-JMET')

END
GO
