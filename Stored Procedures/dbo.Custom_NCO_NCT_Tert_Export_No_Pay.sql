SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- 3/22/20216 BGM Updated record 36 to not send special characters in attorney information fields

--EXEC Custom_NCO_NCT_Tert_Export_No_Pay '0001283', '20130531', '20130601'

CREATE PROCEDURE [dbo].[Custom_NCO_NCT_Tert_Export_No_Pay]
	-- Add the parameters for the stored procedure here
	@customer VARCHAR(25),
	@startDate DATETIME,
	@endDate DATETIME,
	@keepers INT
	
AS
BEGIN
	
	
IF (@keepers = 1)
	BEGIN
		--Get record 31 Address changes
		SELECT '31' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
		d.lastname AS DEBT_LNAME, d.firstName AS DEBT_FNAME, d.Street1 AS DEBT_STREET1, d.Street2 AS DEBT_STREET2, d.city AS DEBT_CITY, d.State AS DEBT_STATE, d.Zipcode AS DEBT_ZIP,
		d.HomePhone AS DEBT_PHONE, d.SSN AS DEBT_SSN,  CONVERT(VARCHAR(10), d.dob, 112) AS DEBT_DOB, d.DLNum AS DEBT_DL, '' AS rfile
		FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
		INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON m.number = ah.AccountID AND dbo.date(ah.DateChanged) BETWEEN @startDate AND @endDate
		where m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		--Get record 33 2nd & 3rd Debtor Information Update.
		SELECT '33' AS recordcode, m.id1 AS fileno, m.account AS forw_file, '' AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer = '0001283' THEN 'ASLMSA' WHEN m.customer = '0001404' THEN 'ASLMSA' END AS forw_id,
		d.lastname AS DEBT2_LNAME, d.firstName AS DEBT2_FNAME, d.Street1 AS DEBT2_STREET1, d.Street2 AS DEBT2_STREET2, d.city AS DEBT2_CITY, d.State AS DEBT2_STATE, d.Zipcode AS DEBT2_ZIP,
		d.HomePhone AS DEBT2_PHONE, d.SSN AS DEBT2_SSN,  CONVERT(VARCHAR(10), d.dob, 112) AS DEBT2_DOB, d.DLNum AS DEBT2_DL,d.lastname AS DEBT3_LNAME, d.firstName AS DEBT3_FNAME, d.Street1 AS DEBT3_STREET1, d.Street2 AS DEBT3_STREET2, d.city AS DEBT3_CITY, d.State AS DEBT3_STATE, d.Zipcode AS DEBT3_ZIP,
		d.HomePhone AS DEBT3_PHONE, d.SSN AS DEBT3_SSN,  CONVERT(VARCHAR(10), d.dob, 112) AS DEBT3_DOB, d.DLNum AS DEBT2_DL
		from master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq IN ('1','2') 
		INNER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.debtorid = da.debtorid AND dbo.date(da.DateCreated) BETWEEN @startDate AND @endDate 
		where m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		--Get record 36 attorney information added on account.
		SELECT '36' AS recordcode, m.id1 AS fileno, m.account AS forw_file, '' AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer = '0001283' THEN 'ASLMSA' WHEN m.customer = '0001404' THEN 'ASLMSA' END AS forw_id,
		dbo.fnAlphaWithSpacesOnly(da.Name) AS adva_name, dbo.fnAlphaWithSpacesOnly(da.Firm) AS adva_firm, '' AS adva_firm2, dbo.fnAlphaWithSpacesOnly(da.Addr1) AS adva_street, dbo.fnAlphaWithSpacesOnly(da.city + ' ' + da.State) + ' ' + dbo.StripNonDigits(da.Zipcode) AS adva_csz,
		'' AS adva_salut, dbo.StripNonDigits(da.Phone) AS adva_phone, dbo.StripNonDigits(da.Fax) AS adva_fax, '' AS advafileno, '' AS misc_date1, '' AS misc_date2, '' AS misc_amt1, '' AS misc_amt2,
		'' AS misc_comm1, '' AS misc_comm2, '' AS misc_comm3, '' AS misc_comm4, '1' AS adva_no, '' AS RELATIONSHIPCODEID
		from master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 
		INNER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.debtorid = da.debtorid AND dbo.date(da.DateCreated) BETWEEN @startDate AND @endDate 
		where m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		--Get record 39 acknowledgements
		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
		CONVERT(VARCHAR(10), m.received, 112) AS pdate, '*CC:S101' AS pcode, 'Acknowledgment' AS pcmt
		FROM master m WITH (NOLOCK)
		WHERE received BETWEEN @startDate AND @endDate AND customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		UNION ALL 

		--Get record 39 Notes
		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
		CONVERT(VARCHAR(10), n.created, 112) AS pdate, 
		CASE WHEN action = 'MR' AND result = 'PH' THEN '*CC:Z107' 
			 WHEN action = 'MR' AND result = 'LD' THEN '*CC:Z112' 
			 WHEN action = 'MR' AND result = 'DBCK' THEN '*CC:Z134'
			 WHEN action = 'MR' AND result = 'SCH' THEN '*CC:Z135'
			 WHEN action = 'MR' AND result = 'LFA' THEN '*CC:Z136'
			 WHEN action = 'MR' AND result = 'DFA' THEN '*CC:Z137'
			 WHEN action = 'MR' AND result = 'RS' THEN '*CC:Z138'
			 WHEN action = 'MR' AND result = 'APPL' THEN '*CC:S128'
			 WHEN action = 'MR' AND result = 'STMT' THEN '*CC:S129'
			 WHEN action = 'MR' AND result = 'TERM' THEN '*CC:Z106'
			 WHEN action = 'MR' AND result = 'COTL' THEN '*CC:Z114'
			 WHEN action = 'MR' AND result = 'JDGE' THEN '*CC:Z132'
			 WHEN action = 'MR' AND result = 'HMED' THEN '*CC:Z139'
			 WHEN action = 'MR' AND result = 'SMEM' THEN '*CC:Z140'
			 WHEN action = 'MR' AND result = 'POOL' THEN '*CC:Z141'
			 WHEN action = 'MR' AND result = 'DESA' THEN '*CC:Z142'
			 
			 else '*CC:W122' END AS pcode,
		REPLACE(CONVERT(VARCHAR(1024), n.comment), char(13) + char(10), '') AS pcmt
		FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
		WHERE dbo.date(n.created) BETWEEN @startDate AND @endDate AND customer in (select string from dbo.CustomStringToSet(@customer, '|')) AND n.user0 NOT IN ('exg', 'linking', 'fusion')
		AND n.comment NOT like ('')

		UNION ALL

		--Get record 39 letters sent
		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
		CONVERT(VARCHAR(10), l.DateProcessed, 112) AS pdate, CASE l.LetterCode 
																	WHEN '67' THEN '*CC:W100'
																	ELSE '*CC:W110' END AS pcode, 
															CASE l.LetterCode
																	WHEN '67' THEN '1st Demand Letter'
																	ELSE 'Letter Sent' END AS pcmt
											
		FROM master m WITH (NOLOCK) INNER JOIN dbo.LetterRequest l WITH (NOLOCK) ON m.number = l.AccountID
		WHERE dbo.date(l.DateProcessed) BETWEEN @startDate AND @endDate AND customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		UNION ALL 

		--Get record 39 phone attempts and contacts
		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), n.created, 112) AS pdate,
			CASE WHEN result IN (SELECT code FROM dbo.result WITH (NOLOCK) WHERE contacted = 1) THEN '*CC:W117'
				ELSE CASE action when 'tr' THEN '*CC:W120'
						WHEN 'te' THEN '*CC:W119'
						WHEN 'to' THEN '*CC:W118'
						END END AS pcode,
			CASE WHEN result IN (SELECT code FROM dbo.result WITH (NOLOCK) WHERE contacted = 1) THEN 'Phone Contact'
				ELSE CASE action when 'tr' THEN 'Telephone Demand Residence'
						WHEN 'te' THEN 'Telephone Demand Business'
						WHEN 'to' THEN 'Telephone Demand'
						END END AS pcmt
		FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number 
		WHERE customer in (select string from dbo.CustomStringToSet(@customer, '|')) AND dbo.date(n.created) BETWEEN @startDate AND @endDate AND action IN ('tr', 'to', 'te')

		UNION ALL 

		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), GETDATE(), 112) AS pdate,
			'*CC:A102' AS pcode,
			'Payment Plan' AS pcmt
		FROM master m WITH (NOLOCK)
		WHERE m.desk NOT IN ('054', '062') AND closed IS NULL AND status NOT IN ('DSP', 'DPV', 'LCP') 
		AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		UNION ALL

		--Get record 39 promises entered

		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
		CONVERT(VARCHAR(10), p.entered, 112) AS pdate,
		'*CC:A106' AS pcode,
		'Promise to Pay' AS pcmt
		FROM master m WITH (NOLOCK) inner JOIN promises p WITH (NOLOCK) ON m.number = p.AcctID
		WHERE p.Active = 1 AND (p.entered BETWEEN @startDate AND @endDate OR m.account IN (SELECT forw_file FROM Custom_NCO_Post_Default_Recalls WITH (NOLOCK) WHERE PCode = '*CC:C111')) 

		AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))
			
			

		UNION ALL 

		--Get record 39 PDCs entered
		SELECT DISTINCT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), p.entered, 112) AS pdate,
			'*CC:A103' AS pcode,
			'Payment Plan' AS pcmt
		FROM master m WITH (NOLOCK) inner JOIN pdc p WITH (NOLOCK) ON m.number = p.number
		WHERE p.Active = 1  AND (p.entered BETWEEN @startDate AND @endDate OR m.account IN (SELECT forw_file FROM Custom_NCO_Post_Default_Recalls WITH (NOLOCK) WHERE PCode = '*CC:C111'))
		AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		UNION ALL 

		--get record 39 PCC's entered
		SELECT DISTINCT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), p.dateentered, 112) AS pdate,
			'*CC:A103' AS pcode,
			'Payment Plan' AS pcmt
		FROM master m WITH (NOLOCK) inner JOIN debtorcreditcards p WITH (NOLOCK) ON m.number = p.number
		WHERE p.isActive = 1 AND (p.dateentered BETWEEN @startDate AND @endDate OR m.account IN (SELECT forw_file FROM Custom_NCO_Post_Default_Recalls WITH (NOLOCK) WHERE PCode = '*CC:C111')) 
		AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))
		UNION ALL 

		--Get record 39 payments with PDC/PCC still on file
		SELECT DISTINCT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), p.datepaid, 112) AS pdate,
			'*CC:A020' AS pcode,
			'Collection' AS pcmt
		FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
		WHERE p.datepaid BETWEEN @startDate AND @endDate AND m.status IN ('pdc', 'pcc') AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		UNION ALL 

		--Get record 39 Payments that are settlements PDC
		SELECT DISTINCT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), p.DateCreated, 112) AS pdate,
			'*CC:A108' AS pcode,
			'Settlement Offer' AS pcmt
		FROM master m WITH (NOLOCK) INNER JOIN pdc p WITH (NOLOCK) ON m.number = p.number
		WHERE p.active = 1 AND p.DateCreated BETWEEN @startDate AND @endDate AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) AND p.PromiseMode IN (6,7)

		UNION ALL 

		--Get record 39 Payments that are settlements PCC
		SELECT DISTINCT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), p.DateCreated, 112) AS pdate,
			'*CC:A108' AS pcode,
			'Settlement Offer' AS pcmt
		FROM master m WITH (NOLOCK) INNER JOIN dbo.DebtorCreditCards p WITH (NOLOCK) ON m.number = p.number
		WHERE p.isactive = 1 AND p.DateCreated BETWEEN @startDate AND @endDate AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) AND p.PromiseMode IN (6,7)

		UNION ALL 

		--Get record 39 skip accounts
		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), sh.datechanged, 112) AS pdate,
			CASE WHEN customer = '0001404' AND status NOT IN ('SIF', 'PIF') THEN '*CC:C104'
				ELSE CASE status 
				WHEN 'SKP' THEN '*CC:S123' 
				WHEN 'AEX' THEN '*CC:C105' 
				WHEN 'BKN' THEN '*CC:A111' 
				WHEN 'DBD' THEN '*CC:A111'
				WHEN 'DCC' THEN '*CC:A111' 
				WHEN 'RFP' THEN '*CC:S125' 
				WHEN 'BKY' THEN '*CC:C101'
				WHEN 'B07' THEN '*CC:C101'
				WHEN 'B11' THEN '*CC:C101'
				WHEN 'B13' THEN '*CC:C101' 
				WHEN 'CCR' THEN '*CC:C102' 
				WHEN 'DEC' THEN '*CC:C104' 
				WHEN 'ATY' THEN '*CC:C107' 
				WHEN 'PIF' THEN '*CC:A100' 
				WHEN 'RCL' THEN '*CC:C111' 
				WHEN 'FRD' THEN '*CC:S116' 
				WHEN 'DSP' THEN '*CC:S106' 
				WHEN 'CAD' THEN '*CC:S111' 
				WHEN 'CND' THEN '*CC:S111' 
				WHEN 'CCS' THEN '*CC:S112'
				WHEN 'SIF' THEN '*CC:A101'
				WHEN 'DPV' THEN '*CC:S115'
				WHEN 'LCP' THEN '*CC:S111' 
				END END AS pcode,
			CASE WHEN customer = '0001404' AND status NOT IN ('SIF', 'PIF') THEN 'Close - Deceased No Estate'
				ELSE CASE status 
				WHEN 'SKP' THEN 'Skip Search - Bad Address' 
				WHEN 'AEX' THEN 'Close - Efforts exhausted' 
				WHEN 'BKN' THEN 'Payment Plan in Default' 
				WHEN 'DBD' THEN 'Payment Plan in Default' 
				WHEN 'DCC' THEN 'Payment Plan in Default' 
				WHEN 'RFP' THEN 'Debtor Refuses to pay' 
				WHEN 'BKY' THEN 'Close - Bankrupt' 
				WHEN 'B07' THEN 'Close - Bankrupt' 
				WHEN 'B11' THEN 'Close - Bankrupt' 
				WHEN 'B13' THEN 'Close - Bankrupt' 
				WHEN 'CCR' THEN 'Close - Client Request' 
				WHEN 'DEC' THEN 'Close - Deceased No Estate' 
				WHEN 'ATY' THEN 'Close - Legal Problem' 
				WHEN 'PIF' THEN 'Close - Paid in Full' 
				WHEN 'RCL' THEN 'Close - Recall Account' 
				WHEN 'FRD' THEN 'DTR Claims Fraud on Account' 
				WHEN 'DSP' THEN 'Disputed' 
				WHEN 'CAD' THEN 'Debtor Sent Cease and Desist Letter' 
				WHEN 'CND' THEN 'Debtor Sent Cease and Desist Letter' 
				WHEN 'CCS' THEN 'Debtor Submitted CCCS Terms' 
				WHEN 'SIF' THEN 'Close - Settled in Full'
				WHEN 'DPV' THEN 'Dispute'
				WHEN 'LCP' THEN 'Debtor Sent Cease and Desist Letter' 
				END END AS pcmt
		FROM master m WITH (NOLOCK) INNER JOIN dbo.StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
		WHERE m.status IN ('SKP', 'AEX', 'BKN', 'DBD', 'DCC', 'DPV', 'LCP', 'RFP', 'BKY', 'B07', 'B11', 'B13', 'CCR', 'DEC', 'SIF', 'ATY', 'PIF', 'RCL', 'FRD', 'DSP', 'CAD', 'CND', 'CCS') AND dbo.date(sh.DateChanged) BETWEEN @startDate AND @endDate AND returned IS null
		AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))
	END
ELSE
	BEGIN
		--Do not look in recall table
		--Get record 31 Address changes
		SELECT '31' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
		d.lastname AS DEBT_LNAME, d.firstName AS DEBT_FNAME, d.Street1 AS DEBT_STREET1, d.Street2 AS DEBT_STREET2, d.city AS DEBT_CITY, d.State AS DEBT_STATE, d.Zipcode AS DEBT_ZIP,
		d.HomePhone AS DEBT_PHONE, d.SSN AS DEBT_SSN,  CONVERT(VARCHAR(10), d.dob, 112) AS DEBT_DOB, d.DLNum AS DEBT_DL, '' AS rfile
		FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
		INNER JOIN dbo.AddressHistory ah WITH (NOLOCK) ON m.number = ah.AccountID AND dbo.date(ah.DateChanged) BETWEEN @startDate AND @endDate
		where m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		--Get record 33 2nd & 3rd Debtor Information Update.
		SELECT '33' AS recordcode, m.id1 AS fileno, m.account AS forw_file, '' AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer = '0001283' THEN 'ASLMSA' WHEN m.customer = '0001404' THEN 'ASLMSA' END AS forw_id,
		d.lastname AS DEBT2_LNAME, d.firstName AS DEBT2_FNAME, d.Street1 AS DEBT2_STREET1, d.Street2 AS DEBT2_STREET2, d.city AS DEBT2_CITY, d.State AS DEBT2_STATE, d.Zipcode AS DEBT2_ZIP,
		d.HomePhone AS DEBT2_PHONE, d.SSN AS DEBT2_SSN,  CONVERT(VARCHAR(10), d.dob, 112) AS DEBT2_DOB, d.DLNum AS DEBT2_DL,d.lastname AS DEBT3_LNAME, d.firstName AS DEBT3_FNAME, d.Street1 AS DEBT3_STREET1, d.Street2 AS DEBT3_STREET2, d.city AS DEBT3_CITY, d.State AS DEBT3_STATE, d.Zipcode AS DEBT3_ZIP,
		d.HomePhone AS DEBT3_PHONE, d.SSN AS DEBT3_SSN,  CONVERT(VARCHAR(10), d.dob, 112) AS DEBT3_DOB, d.DLNum AS DEBT2_DL
		from master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq IN ('1','2') 
		INNER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.debtorid = da.debtorid AND dbo.date(da.DateCreated) BETWEEN @startDate AND @endDate 
		where m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		--Get record 36 attorney information added on account.
		SELECT '36' AS recordcode, m.id1 AS fileno, m.account AS forw_file, '' AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer = '0001283' THEN 'ASLMSA' WHEN m.customer = '0001404' THEN 'ASLMSA' END AS forw_id,
		dbo.fnAlphaWithSpacesOnly(da.Name) AS adva_name, dbo.fnAlphaWithSpacesOnly(da.Firm) AS adva_firm, '' AS adva_firm2, dbo.fnAlphaWithSpacesOnly(da.Addr1) AS adva_street, dbo.fnAlphaWithSpacesOnly(da.city + ' ' + da.State) + ' ' + dbo.StripNonDigits(da.Zipcode) AS adva_csz,
		'' AS adva_salut, dbo.StripNonDigits(da.Phone) AS adva_phone, dbo.StripNonDigits(da.Fax) AS adva_fax, '' AS advafileno, '' AS misc_date1, '' AS misc_date2, '' AS misc_amt1, '' AS misc_amt2,
		'' AS misc_comm1, '' AS misc_comm2, '' AS misc_comm3, '' AS misc_comm4, '1' AS adva_no, '' AS RELATIONSHIPCODEID
		from master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 
		INNER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.debtorid = da.debtorid AND dbo.date(da.DateCreated) BETWEEN @startDate AND @endDate 
		where m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		--Get record 39 acknowledgements
		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
		CONVERT(VARCHAR(10), m.received, 112) AS pdate, '*CC:S101' AS pcode, 'Acknowledgment' AS pcmt
		FROM master m WITH (NOLOCK)
		WHERE received BETWEEN @startDate AND @endDate AND customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		UNION ALL 

		--Get record 39 Notes
		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
		CONVERT(VARCHAR(10), n.created, 112) AS pdate, 
		CASE WHEN action = 'MR' AND result = 'PH' THEN '*CC:Z107' 
			 WHEN action = 'MR' AND result = 'LD' THEN '*CC:Z112' 
			 WHEN action = 'MR' AND result = 'DBCK' THEN '*CC:Z134'
			 WHEN action = 'MR' AND result = 'SCH' THEN '*CC:Z135'
			 WHEN action = 'MR' AND result = 'LFA' THEN '*CC:Z136'
			 WHEN action = 'MR' AND result = 'DFA' THEN '*CC:Z137'
			 WHEN action = 'MR' AND result = 'RS' THEN '*CC:Z138'
			 WHEN action = 'MR' AND result = 'APPL' THEN '*CC:S128'
			 WHEN action = 'MR' AND result = 'STMT' THEN '*CC:S129'
			 WHEN action = 'MR' AND result = 'TERM' THEN '*CC:Z106'
			 WHEN action = 'MR' AND result = 'COTL' THEN '*CC:Z114'
			 WHEN action = 'MR' AND result = 'JDGE' THEN '*CC:Z132'
			 WHEN action = 'MR' AND result = 'HMED' THEN '*CC:Z139'
			 WHEN action = 'MR' AND result = 'SMEM' THEN '*CC:Z140'
			 WHEN action = 'MR' AND result = 'POOL' THEN '*CC:Z141'
			 WHEN action = 'MR' AND result = 'DESA' THEN '*CC:Z142'
			 
			 else '*CC:W122' END AS pcode,
		REPLACE(CONVERT(VARCHAR(1024), n.comment), char(13) + char(10), '') AS pcmt
		FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
		WHERE dbo.date(n.created) BETWEEN @startDate AND @endDate AND customer in (select string from dbo.CustomStringToSet(@customer, '|')) AND n.user0 NOT IN ('exg', 'linking', 'fusion')
		AND n.comment NOT like ('')

		UNION ALL

		--Get record 39 letters sent
		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
		CONVERT(VARCHAR(10), l.DateProcessed, 112) AS pdate, CASE l.LetterCode 
																	WHEN '67' THEN '*CC:W100'
																	ELSE '*CC:W110' END AS pcode, 
															CASE l.LetterCode
																	WHEN '67' THEN '1st Demand Letter'
																	ELSE 'Letter Sent' END AS pcmt
											
		FROM master m WITH (NOLOCK) INNER JOIN dbo.LetterRequest l WITH (NOLOCK) ON m.number = l.AccountID
		WHERE dbo.date(l.DateProcessed) BETWEEN @startDate AND @endDate AND customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		UNION ALL 

		--Get record 39 phone attempts and contacts
		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), n.created, 112) AS pdate,
			CASE WHEN result IN (SELECT code FROM dbo.result WITH (NOLOCK) WHERE contacted = 1) THEN '*CC:W117'
				ELSE CASE action when 'tr' THEN '*CC:W120'
						WHEN 'te' THEN '*CC:W119'
						WHEN 'to' THEN '*CC:W118'
						END END AS pcode,
			CASE WHEN result IN (SELECT code FROM dbo.result WITH (NOLOCK) WHERE contacted = 1) THEN 'Phone Contact'
				ELSE CASE action when 'tr' THEN 'Telephone Demand Residence'
						WHEN 'te' THEN 'Telephone Demand Business'
						WHEN 'to' THEN 'Telephone Demand'
						END END AS pcmt
		FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number 
		WHERE customer in (select string from dbo.CustomStringToSet(@customer, '|')) AND dbo.date(n.created) BETWEEN @startDate AND @endDate AND action IN ('tr', 'to', 'te')

		--UNION ALL 

		--SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
		--CONVERT(VARCHAR(10), GETDATE(), 112) AS pdate,
		--'*CC:A102' AS pcode,
		--'Payment Plan' AS pcmt
		--FROM master m WITH (NOLOCK)
		--WHERE m.desk NOT IN ('054', '062') AND closed IS NULL AND status NOT IN ('DSP', 'DPV') 
		--AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		UNION ALL

		--Get record 39 promises entered

		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
		CONVERT(VARCHAR(10), p.entered, 112) AS pdate,
		'*CC:A106' AS pcode,
		'Promise to Pay' AS pcmt
		FROM master m WITH (NOLOCK) inner JOIN promises p WITH (NOLOCK) ON m.number = p.AcctID
		WHERE p.Active = 1 AND p.entered BETWEEN @startDate AND @endDate 
		AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))
			
			

		UNION ALL 

		--Get record 39 PDCs entered
		SELECT DISTINCT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), p.entered, 112) AS pdate,
			'*CC:A103' AS pcode,
			'Payment Plan' AS pcmt
		FROM master m WITH (NOLOCK) inner JOIN pdc p WITH (NOLOCK) ON m.number = p.number
		WHERE p.Active = 1  AND p.entered BETWEEN @startDate AND @endDate
		AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		UNION ALL 

		--get record 39 PCC's entered
		SELECT DISTINCT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), p.dateentered, 112) AS pdate,
			'*CC:A103' AS pcode,
			'Payment Plan' AS pcmt
		FROM master m WITH (NOLOCK) inner JOIN debtorcreditcards p WITH (NOLOCK) ON m.number = p.number
		WHERE p.isActive = 1 AND p.dateentered BETWEEN @startDate AND @endDate
		AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))
		UNION ALL 

		--Get record 39 payments with PDC/PCC still on file
		SELECT DISTINCT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), p.datepaid, 112) AS pdate,
			'*CC:A020' AS pcode,
			'Collection' AS pcmt
		FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
		WHERE p.datepaid BETWEEN @startDate AND @endDate AND m.status IN ('pdc', 'pcc') AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))

		UNION ALL 

		--Get record 39 Payments that are settlements PDC
		SELECT DISTINCT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), p.DateCreated, 112) AS pdate,
			'*CC:A108' AS pcode,
			'Settlement Offer' AS pcmt
		FROM master m WITH (NOLOCK) INNER JOIN pdc p WITH (NOLOCK) ON m.number = p.number
		WHERE p.active = 1 AND p.DateCreated BETWEEN @startDate AND @endDate AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) AND p.PromiseMode IN (6,7)

		UNION ALL 

		--Get record 39 Payments that are settlements PCC
		SELECT DISTINCT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), p.DateCreated, 112) AS pdate,
			'*CC:A108' AS pcode,
			'Settlement Offer' AS pcmt
		FROM master m WITH (NOLOCK) INNER JOIN dbo.DebtorCreditCards p WITH (NOLOCK) ON m.number = p.number
		WHERE p.isactive = 1 AND p.DateCreated BETWEEN @startDate AND @endDate AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|')) AND p.PromiseMode IN (6,7)

		UNION ALL 

		--Get record 39 skip accounts
		SELECT '39' AS recordcode, m.id1 AS fileno, m.account AS forw_file, m.id2 AS masco_file, CASE WHEN m.customer = '0001283' THEN 'SIM3' WHEN m.customer = '0001404' THEN 'SIM9' END AS firm_id, CASE WHEN m.customer IN ('0001283', '0001404') THEN 'ASLMSA' END AS forw_id,
			CONVERT(VARCHAR(10), sh.datechanged, 112) AS pdate,
			CASE status WHEN 'SKP' THEN '*CC:S123' 
				WHEN 'AEX' THEN '*CC:C105' 
				WHEN 'BKN' THEN '*CC:A111' 
				WHEN 'DBD' THEN '*CC:A111'
				WHEN 'DCC' THEN '*CC:A111' 
				WHEN 'RFP' THEN '*CC:S125' 
				WHEN 'BKY' THEN '*CC:C101'
				WHEN 'B07' THEN '*CC:C101'
				WHEN 'B11' THEN '*CC:C101'
				WHEN 'B13' THEN '*CC:C101' 
				WHEN 'CCR' THEN '*CC:C102' 
				WHEN 'DEC' THEN '*CC:C104' 
				WHEN 'ATY' THEN '*CC:C107' 
				WHEN 'PIF' THEN '*CC:A100' 
				WHEN 'RCL' THEN '*CC:C111' 
				WHEN 'FRD' THEN '*CC:S116' 
				WHEN 'DSP' THEN '*CC:S106' 
				WHEN 'CAD' THEN '*CC:S111' 
				WHEN 'CND' THEN '*CC:S111' 
				WHEN 'CCS' THEN '*CC:S112'
				WHEN 'SIF' THEN '*CC:A101'
				WHEN 'DPV' THEN '*CC:S115'
				WHEN 'LCP' THEN '*CC:S111'
				END AS pcode,
			CASE status WHEN 'SKP' THEN 'Skip Search - Bad Address' 
				WHEN 'AEX' THEN 'Close - Efforts exhausted' 
				WHEN 'BKN' THEN 'Payment Plan in Default' 
				WHEN 'DBD' THEN 'Payment Plan in Default' 
				WHEN 'DCC' THEN 'Payment Plan in Default' 
				WHEN 'RFP' THEN 'Debtor Refuses to pay' 
				WHEN 'BKY' THEN 'Close - Bankrupt' 
				WHEN 'B07' THEN 'Close - Bankrupt' 
				WHEN 'B11' THEN 'Close - Bankrupt' 
				WHEN 'B13' THEN 'Close - Bankrupt' 
				WHEN 'CCR' THEN 'Close - Client Request' 
				WHEN 'DEC' THEN 'Close - Deceased No Estate' 
				WHEN 'ATY' THEN 'Close - Legal Problem' 
				WHEN 'PIF' THEN 'Close - Paid in Full' 
				WHEN 'RCL' THEN 'Close - Recall Account' 
				WHEN 'FRD' THEN 'DTR Claims Fraud on Account' 
				WHEN 'DSP' THEN 'Disputed' 
				WHEN 'CAD' THEN 'Debtor Sent Cease and Desist Letter' 
				WHEN 'CND' THEN 'Debtor Sent Cease and Desist Letter' 
				WHEN 'CCS' THEN 'Debtor Submitted CCCS Terms' 
				WHEN 'SIF' THEN 'Close - Settled in Full' 
				WHEN 'DPV' THEN 'Dispute'
				WHEN 'LCP' THEN 'Debtor Sent Cease and Desist Letter'
				END AS pcmt
		FROM master m WITH (NOLOCK) INNER JOIN dbo.StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
		WHERE m.status IN ('SKP', 'AEX', 'BKN', 'DBD', 'DCC', 'DPV', 'LCP', 'RFP', 'BKY', 'B07', 'B11', 'B13', 'CCR', 'DEC', 'SIF', 'ATY', 'PIF', 'RCL', 'FRD', 'DSP', 'CAD', 'CND', 'CCS') AND dbo.date(sh.DateChanged) BETWEEN @startDate AND @endDate AND returned IS null
		AND m.customer in (select string from dbo.CustomStringToSet(@customer, '|'))
	END
END
GO
