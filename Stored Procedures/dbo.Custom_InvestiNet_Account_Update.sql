SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[Custom_InvestiNet_Account_Update] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME, 
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Address change
SELECT m.id1 AS data_id, m.account AS pri_acctno, '' AS sec_acctno, '' AS TYPE, '' AS originator, '' AS intrate, '' as	term, '' as	cycleid, '' as	acctopen,
 '' as	lastactivity, '' as	lastactivityamt, '' as	delinquency, '' as	chargeoff, '' as	chargeoffamt, '' as	lineofcredit, '' as	pri_ssn, 
 '' as	pri_taxid, '' as	pri_dob, '' as	pri_last, '' as	pri_middle, '' as	pri_first, '' as	pri_company, CASE WHEN d.seq = 0 THEN ah.NewStreet1 ELSE '' end as	pri_add1, 
 CASE WHEN d.seq = 0 THEN ah.NewStreet2 ELSE '' end as	pri_add2, CASE WHEN d.seq = 0 THEN ah.NewCity ELSE '' end as	pri_city, CASE WHEN d.seq = 0 THEN ah.NewState ELSE '' end as	pri_state, 
 CASE WHEN d.seq = 0 THEN ah.NewZipcode ELSE '' end as	pri_zip, '' as	pri_country, '' as	pri_hphone, '' as	pri_wphone, '' as	pri_driverlicense,  '' as	sec_ssn, 
 '' as	sec_taxid, '' as	sec_dob, '' AS sec_last, '' as	sec_middle, '' as	sec_first, '' as	sec_company, CASE WHEN d.seq = 1 THEN ah.NewStreet1 ELSE '' end as	sec_add1, 
 CASE WHEN d.seq = 1 THEN ah.NewStreet2 ELSE '' end as	sec_add2, CASE WHEN d.seq = 1 THEN ah.NewCity ELSE '' end as	sec_city, CASE WHEN d.seq = 1 THEN ah.NewState ELSE '' end as	sec_state, 
 CASE WHEN d.seq = 1 THEN ah.NewZipcode ELSE '' end as	sec_zip, '' as	sec_country, '' as	sec_wphone, '' as	sec_hphone, '' as	sec_driverlicense, 
 '' as	bk_filing, '' as	bk_chapter, '' as	bk_case, '' as	bk_disposition, '' as	bk_location, '' as	dec_date, '' as	fraud_date, '' as	occurrence_date, 
 '' as	judgment_filed, '' as	judgment_case, '' as	judgment_served, '' as	judgment_date, '' as	judgment_state, '' as	judgment_amount, 
 '' as	judgment_suit_amount, '' as	judgment_intrate, '' as	judgment_court, '' as	judgment_county, '' as	judgment_plaintiff, '' as	judgment_firm, 
 '' as	judgment_attorney, '' as	data_indicator, '' as	data_indicator_01, '' as	data_indicator_02, '' as	club_id, '' as	club_name
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON d.DebtorID = ah.DebtorID
WHERE m.customer IN ('0001095') AND dbo.date(ah.DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

UNION ALL

--Phone Change
SELECT m.id1 AS data_id, m.account AS pri_acctno, '' AS sec_acctno, '' AS TYPE, '' AS originator, '' AS intrate, '' as	term, '' as	cycleid, '' as	acctopen,
 '' as	lastactivity, '' as	lastactivityamt, '' as	delinquency, '' as	chargeoff, '' as	chargeoffamt, '' as	lineofcredit, '' as	pri_ssn, 
 '' as	pri_taxid, '' as	pri_dob, '' as	pri_last, '' as	pri_middle, '' as	pri_first, '' as	pri_company, '' as	pri_add1, 
 '' as	pri_add2, '' as	pri_city, '' as	pri_state, 
 '' as	pri_zip, '' as	pri_country, CASE WHEN d.seq = 0 AND phonetype = 1 THEN NewNumber ELSE '' end as	pri_hphone, CASE WHEN d.seq = 0 AND phonetype = 2 THEN NewNumber ELSE '' end as	pri_wphone, 
 '' as	pri_driverlicense,  '' as	sec_ssn, '' as	sec_taxid, '' as	sec_dob, '' AS sec_last, '' as	sec_middle, '' as	sec_first, 
 '' as	sec_company, '' as	sec_add1,  '' as	sec_add2, '' as	sec_city, '' as	sec_state, '' as	sec_zip, '' as	sec_country, 
 CASE WHEN d.seq = 1 AND phonetype = 2 THEN NewNumber ELSE '' end AS sec_wphone, CASE WHEN d.seq = 1 AND phonetype = 1 THEN NewNumber ELSE '' end as	sec_hphone, 
 '' as	sec_driverlicense, '' as	bk_filing, '' as	bk_chapter, '' as	bk_case, '' as	bk_disposition, '' as	bk_location, '' as	dec_date, '' as	fraud_date, '' as	occurrence_date, 
 '' as	judgment_filed, '' as	judgment_case, '' as	judgment_served, '' as	judgment_date, '' as	judgment_state, '' as	judgment_amount, 
 '' as	judgment_suit_amount, '' as	judgment_intrate, '' as	judgment_court, '' as	judgment_county, '' as	judgment_plaintiff, '' as	judgment_firm, 
 '' as	judgment_attorney, '' as	data_indicator, '' as	data_indicator_01, '' as	data_indicator_02, '' as	club_id, '' as	club_name

FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number INNER JOIN dbo.PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID AND NewNumber <> ''
WHERE m.customer IN ('0001095') AND dbo.date(ph.DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

UNION ALL

--Bankruptcy
SELECT m.id1 AS data_id, m.account AS pri_acctno, '' AS sec_acctno, '' AS TYPE, '' AS originator, '' AS intrate, '' as	term, '' as	cycleid, 
 '' as	acctopen, '' as	lastactivity, '' as	lastactivityamt, '' as	delinquency, '' as	chargeoff, '' as	chargeoffamt, '' as	lineofcredit, 
 '' as	pri_ssn, '' as	pri_taxid, '' as	pri_dob, '' as	pri_last, '' as	pri_middle, '' as	pri_first, '' as	pri_company, '' as	pri_add1, 
 '' as	pri_add2, '' as	pri_city, '' as	pri_state,  '' as	pri_zip, '' as	pri_country, '' as	pri_hphone, '' as	pri_wphone, 
 '' as	pri_driverlicense,  '' as	sec_ssn, '' as	sec_taxid, '' as	sec_dob, '' AS sec_last, '' as	sec_middle, '' as	sec_first, 
 '' as	sec_company, '' as	sec_add1,  '' as	sec_add2, '' as	sec_city, '' as	sec_state, '' as	sec_zip, '' as	sec_country, 
 '' AS sec_wphone, '' as	sec_hphone, '' as	sec_driverlicense, convert(VARCHAR(10), b.DateFiled, 101) as	bk_filing, CONVERT(VARCHAR(2), b.Chapter) as	bk_chapter, b.CaseNumber as	bk_case, 
 b.Status as	bk_disposition,  b.CourtDistrict + ' ' + b.CourtStreet1 + ' ' + b.courtstreet2 + ' ' + b.CourtCity + ' ' + b.CourtState + ' ' + b.CourtZipcode as	bk_location, 
 '' as	dec_date, '' as	fraud_date, '' as	occurrence_date, 
 '' as	judgment_filed, '' as	judgment_case, '' as	judgment_served, '' as	judgment_date, '' as	judgment_state, '' as	judgment_amount, 
 '' as	judgment_suit_amount, '' as	judgment_intrate, '' as	judgment_court, '' as	judgment_county, '' as	judgment_plaintiff, '' as	judgment_firm, 
 '' as	judgment_attorney, '' as	data_indicator, '' as	data_indicator_01, '' as	data_indicator_02, '' as	club_id, '' as	club_name

FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number INNER JOIN dbo.Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID 
WHERE m.customer IN ('0001095') AND dbo.date(b.TransmittedDate) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

END
GO
