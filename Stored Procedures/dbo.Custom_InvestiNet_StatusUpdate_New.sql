SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_InvestiNet_StatusUpdate_New]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- Removed all but first 3 columns, Data_id, Status_Code and Status_date
	

    -- Insert statements for procedure here
	SELECT id1 AS data_id, 
	Case when (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '800100' THEN '900100' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801007' THEN '901007'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801011' THEN '901011'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801012' THEN '901012'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801013' THEN '901013' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801000' THEN '901000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '802000' THEN '902000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '800999' THEN '900999'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810298' THEN '910298'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810208' THEN '910208' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810180' THEN '910180'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '899100' THEN '999100'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820260' THEN '920260' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810210' THEN '910210'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '806000' THEN '906000' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810270' THEN '910270'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '807000' THEN '907000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820300' THEN '920300'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820270' THEN '920270'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810220' THEN '910220'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810295' THEN '910295'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810290' THEN '910290'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810320' THEN '910320'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820250' THEN '920250'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810280' THEN '910280'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810120' THEN '910120'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810190' THEN '910190'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '800300' THEN '900300'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '808000' THEN '908000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '880300' THEN '980300'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '880301' THEN '980301'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810125' THEN '910125'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820220' THEN '920220'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801099' THEN '901099'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810310' THEN '910310'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810297' THEN '910297'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820200' THEN '920200'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820000' THEN '920000'
	END AS placedetail_status, 
	dbo.date(GETDATE()) AS status_date, 
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 CONVERT(NVARCHAR(10), dbo.date(DateFiled), 101) FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_filing,
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 CONVERT(NVARCHAR(2), chapter) FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_chapter,
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 casenumber FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_case,
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 REPLACE(status, 'discharge', 'discharged') FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_disposition,
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 CourtDistrict + ' ' + CourtStreet1 + ' ' + courtstreet2 + ' ' + CourtCity + ', ' + CourtState + ' ' + CourtZipcode  FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_location,
	CASE WHEN status = 'DEC' THEN (SELECT TOP 1 CONVERT(NVARCHAR(10), dod, 101) FROM dbo.Deceased WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS dec_date,
	'' AS rec_date, 
	CASE WHEN status = 'PDC' THEN (SELECT TOP 1 CONVERT(NVARCHAR(10), deposit, 101) FROM pdc WITH (NOLOCK) WHERE number = m.number AND active = 1 ORDER BY deposit) 
							WHEN status = 'PCC' THEN (SELECT TOP 1 CONVERT(NVARCHAR(10), depositdate, 101) FROM debtorcreditcards WITH (NOLOCK) WHERE Number = m.number AND IsActive = 1 ORDER BY DepositDate)
							WHEN status = 'PPA' THEN (SELECT TOP 1 CONVERT(NVARCHAR(10), duedate, 101) FROM promises WITH (NOLOCK) WHERE AcctID = m.number AND Active = 1 ORDER BY DueDate) ELSE '' END AS promise_due,
	CASE WHEN status = 'PDC' THEN (SELECT TOP 1 CONVERT(nvarchar(11), amount) FROM pdc WITH (NOLOCK) WHERE number = m.number AND active = 1 ORDER BY deposit) 
							WHEN status = 'PCC' THEN (SELECT TOP 1 CONVERT(NVARCHAR(11), amount) FROM debtorcreditcards WITH (NOLOCK) WHERE Number = m.number AND IsActive = 1 ORDER BY DepositDate)
							WHEN status = 'PPA' THEN (SELECT TOP 1 CONVERT(NVARCHAR(11), Amount) FROM promises WITH (NOLOCK) WHERE AcctID = m.number AND Active = 1 ORDER BY DueDate) ELSE '' END AS promise_amount,
	CASE WHEN status IN ('hot', 'pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'bkn') THEN 'Y' ELSE '' end AS keeper
	
FROM master m WITH (NOLOCK)
WHERE customer IN ('0001095') AND returned IS NULL 
AND (Case when (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '800100' THEN '900100' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801007' THEN '901007'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801011' THEN '901011'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801012' THEN '901012'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801013' THEN '901013' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801000' THEN '901000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '802000' THEN '902000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '800999' THEN '900999'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810298' THEN '910298'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810208' THEN '910208' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810180' THEN '910180'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '899100' THEN '999100'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820260' THEN '920260' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810210' THEN '910210'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '806000' THEN '906000' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810270' THEN '910270'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '807000' THEN '907000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820300' THEN '920300'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820270' THEN '920270'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810220' THEN '910220'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810295' THEN '910295'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810290' THEN '910290'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810320' THEN '910320'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820250' THEN '920250'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810280' THEN '910280'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810120' THEN '910120'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810190' THEN '910190'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '800300' THEN '900300'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '808000' THEN '908000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '880300' THEN '980300'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '880301' THEN '980301'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810125' THEN '910125'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820220' THEN '920220'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801099' THEN '901099'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810310' THEN '910310'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810297' THEN '910297'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820200' THEN '920200'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820000' THEN '920000'
	 END <> (SELECT TOP 1 statuscode FROM dbo.Custom_InvestiNet_Status_Codes WITH (NOLOCK) WHERE m.id1 = DataID ORDER BY statusdate DESC)
	OR (SELECT TOP 1 statuscode FROM dbo.Custom_InvestiNet_Status_Codes WITH (NOLOCK) WHERE m.id1 = DataID ORDER BY statusdate DESC) IS NULL)

INSERT INTO dbo.Custom_InvestiNet_Status_Codes
        ( DataID, StatusCode, statusdate )

SELECT id1 AS data_id, CASE WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '800100' THEN '900100' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801007' THEN '901007'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801011' THEN '901011'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801012' THEN '901012'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801013' THEN '901013' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801000' THEN '901000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '802000' THEN '902000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '800999' THEN '900999'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810298' THEN '910298'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810208' THEN '910208' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810180' THEN '910180'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '899100' THEN '999100'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820260' THEN '920260' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810210' THEN '910210'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '806000' THEN '906000' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810270' THEN '910270'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '807000' THEN '907000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820300' THEN '920300'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820270' THEN '920270'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810220' THEN '910220'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810295' THEN '910295'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810290' THEN '910290'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810320' THEN '910320'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820250' THEN '920250'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810280' THEN '910280'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810120' THEN '910120'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810190' THEN '910190'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '800300' THEN '900300'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '808000' THEN '908000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '880300' THEN '980300'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '880301' THEN '980301'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810125' THEN '910125'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820220' THEN '920220'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801099' THEN '901099'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810310' THEN '910310'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810297' THEN '910297'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820200' THEN '920200'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820000' THEN '920000'
	 END AS status_code, dbo.date(GETDATE()) AS status_date
	
FROM master m WITH (NOLOCK)
WHERE customer IN ('0001095') AND returned IS NULL 
AND (CASE WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '800100' THEN '900100' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801007' THEN '901007'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801011' THEN '901011'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801012' THEN '901012'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801013' THEN '901013' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801000' THEN '901000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '802000' THEN '902000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '800999' THEN '900999'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810298' THEN '910298'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810208' THEN '910208' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810180' THEN '910180'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '899100' THEN '999100'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820260' THEN '920260' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810210' THEN '910210'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '806000' THEN '906000' 
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810270' THEN '910270'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '807000' THEN '907000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820300' THEN '920300'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820270' THEN '920270'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810220' THEN '910220'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810295' THEN '910295'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810290' THEN '910290'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810320' THEN '910320'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820250' THEN '920250'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810280' THEN '910280'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810120' THEN '910120'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810190' THEN '910190'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '800300' THEN '900300'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '808000' THEN '908000'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '880300' THEN '980300'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '880301' THEN '980301'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810125' THEN '910125'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820220' THEN '920220'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '801099' THEN '901099'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810310' THEN '910310'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '810297' THEN '910297'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820200' THEN '920200'
	WHEN (select (thedata) from miscextra with (nolock) where number = m.number and title = 'status_code') = '820000' THEN '920000'
	 END <> (SELECT TOP 1 statuscode FROM dbo.Custom_InvestiNet_Status_Codes WITH (NOLOCK) WHERE m.id1 = DataID ORDER BY statusdate DESC)
	OR (SELECT TOP 1 statuscode FROM dbo.Custom_InvestiNet_Status_Codes WITH (NOLOCK) WHERE m.id1 = DataID ORDER BY statusdate DESC) IS NULL)


END
GO
