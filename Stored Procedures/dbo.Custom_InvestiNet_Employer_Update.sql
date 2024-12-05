SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_InvestiNet_Employer_Update] 
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
	'' AS employer_id, 
	'' AS employer_source_acctno,
	'' AS employer_status,
	'1' AS employertype_id,
	'Primary Employer' AS employer_source,
d.JobName AS employer_name,
d.JobAddr1 AS employer_add1, 
d.Jobaddr2 AS employer_add2, 
'' AS employer_add3, 
'' AS employer_add4,
'' AS employer_city,
'' AS employer_state, 
'' AS employer_zip,
'' AS employer_country, 
d.WorkPhone AS employer_phone, 
'' AS employer_fax,
'' AS employer_employee_ssn, 
'' AS employer_employee_first, 
'' AS employer_employee_middle, 
'' AS employer_employee_last,
'' AS employer_position, 
'' AS employer_title, 
'' AS employer_code,
'' AS employer_manager,
'' AS employer_employee_id,
'' AS employer_disclaimer, 
'' AS employer_payroll_disclaimer, 
'' AS employer_wage_basis,
'' AS employer_wage,
'' AS employer_division_code,
'' AS employer_effective_date, 
'' AS employer_most_recent, 
'' AS employer_length,
'' AS employer_termination,
'' AS employer_dispute,
'' AS employer_military,
'' AS employer_fraud,
'' AS employer_transaction,
'' AS employer_code_01,
'' AS employer_code_02,
'' AS employertype_id,
'' AS agent_name,
'' AS agent_add1,
'' AS agent_add2,
'' AS agent_city,
'' AS agent_state,
'' AS agent_zip,
'' AS agent_company,
'' AS agent_wphone,
'' AS agent_wphone_ext
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE customer IN ('0001095') AND d.JobAddr1 <> ''
AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)


UNION all

SELECT m.id1 AS data_id, 
	'' AS employer_id, 
	'' AS employer_source_acctno,
	'' AS employer_status,
CASE ph.Phonetype when 1 THEN '1' WHEN 2 THEN '2' end AS employertype_id, 
CASE ph.Phonetype when 1 THEN 'Primary Employer' WHEN 2 THEN 'Employer' end AS employer_source,
d.JobName AS employer_name,
d.JobAddr1 AS employer_add1, 
d.Jobaddr2 AS employer_add2, 
'' AS employer_add3, 
'' AS employer_add4,
'' AS employer_city,
'' AS employer_state, 
'' AS employer_zip,
'' AS employer_country,
d.WorkPhone AS employer_phone, 
'' AS employer_fax,
'' AS employer_employee_ssn, 
'' AS employer_employee_first, 
'' AS employer_employee_middle, 
'' AS employer_employee_last,
'' AS employer_position, 
'' AS employer_title, 
'' AS employer_code,
'' AS employer_manager,
'' AS employer_employee_id,
'' AS employer_disclaimer, 
'' AS employer_payroll_disclaimer, 
'' AS employer_wage_basis,
'' AS employer_wage,
'' AS employer_division_code,
'' AS employer_effective_date, 
'' AS employer_most_recent, 
'' AS employer_length,
'' AS employer_termination,
'' AS employer_dispute,
'' AS employer_military,
'' AS employer_fraud,
'' AS employer_transaction,
'' AS employer_code_01,
'' AS employer_code_02,
'' AS employertype_id,
'' AS agent_name,
'' AS agent_add1,
'' AS agent_add2,
'' AS agent_city,
'' AS agent_state,
'' AS agent_zip,
'' AS agent_company,
'' AS agent_wphone,
'' AS agent_wphone_ext
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN dbo.PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID
WHERE customer IN ('0001095') AND d.WorkPhone <> ''
AND closed IS NULL AND dbo.date(datechanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)


END
GO
