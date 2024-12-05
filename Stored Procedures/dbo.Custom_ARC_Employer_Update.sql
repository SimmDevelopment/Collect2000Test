SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 4/8/2020
-- Description:	Export Employer Information Changes
-- =============================================
CREATE PROCEDURE [dbo].[Custom_ARC_Employer_Update] 
	-- Add the parameters for the stored procedure here
	@startDate AS datetime,
	@endDate AS DATETIME
AS

--exec Custom_CitizensBank_DN_Employer_Update '20200503', '20200503'

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT m.id2 AS data_id,
	'' AS employer_id,
	'' AS employertype_id,
	m.account AS employer_source_acctno,
	'Confirmed' AS employer_status,
	'' AS employer_source,
	d.JobName AS employer_name,
d.JobAddr1 AS employer_add1, 
d.Jobaddr2 AS employer_add2, 
'' AS employer_city,
'' AS employer_state, 
'' AS employer_zip,
'' AS employer_country, 
'' AS employer_phone, 
'' AS employer_fax,
'' AS employer_position, 
'' AS employer_employee_id,
'' AS employer_effective_date, 
'' AS employer_verification_name, 
'' AS employer_verification_phone
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0003098') AND d.JobName <> ''
AND closed IS NULL AND dbo.date(DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)


UNION all

SELECT m.id2 AS data_id, 
	'' AS employer_id, 
	CASE ph.Phonetype when 1 THEN '1' WHEN 2 THEN '2' end AS employertype_id,
	'' AS employer_source_acctno,
	'' AS employer_status,
 CASE ph.Phonetype when 1 THEN 'Primary Employer' WHEN 2 THEN 'Employer' end AS employer_source,
'' AS employer_name,
'' AS employer_add1, 
'' AS employer_add2, 
'' AS employer_city,
'' AS employer_state, 
'' AS employer_zip,
'' AS employer_country,
d.WorkPhone AS employer_phone, 
'' AS employer_fax,
'' AS employer_position, 
'' AS employer_employee_id,
'' AS employer_effective_date, 
'' AS employer_verification_name, 
'' AS employer_verification_phone
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN dbo.PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID
WHERE customer IN ('0003098') AND d.WorkPhone <> ''
AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)


END
GO
