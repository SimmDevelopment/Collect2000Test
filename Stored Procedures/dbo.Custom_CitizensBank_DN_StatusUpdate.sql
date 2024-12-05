SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 05/03/2020
-- Description:	Export Status Updates, new codes
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CitizensBank_DN_StatusUpdate]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- Removed all but first 3 columns, Data_id, Status_Code and Status_date
--exec custom_citizensbank_dn_statusupdate
	

    -- Insert statements for procedure here
	SELECT id1 AS data_id, 
	CASE 
	WHEN CONVERT(VARCHAR(10), m.received, 101) = CONVERT(VARCHAR(10), GETDATE(), 101) THEN '101000' 
	--WHEN CONVERT(VARCHAR(10), m.received, 101) = CONVERT(VARCHAR(10), GETDATE(), 101) AND m.customer IN ('0001294', '0001295') THEN '191000'
	WHEN status IN ('ACT', 'NON') THEN '112000' 
	WHEN status IN ('PPA', 'PDC', 'PCC') THEN '113020' 
	WHEN status = 'MIL' THEN '910208'
	WHEN status IN ('HOT', 'nsf', 'dcc', 'dbd', 'bkn') THEN '112045' 
	WHEN status LIKE 'VRB' THEN '112046' 
	WHEN status = 'VRD' THEN '112046' 
	WHEN status = 'DSP' THEN '920220'
	WHEN status = 'B07' THEN '901007' WHEN status = 'B11' THEN '901011' WHEN status = 'B12' THEN '901012' WHEN status = 'B13' THEN '901013'	WHEN status = 'BKY' THEN '901007' 
	WHEN status = 'DEC' THEN '902000' 
	WHEN status = 'RSK' THEN '112070' 
	WHEN status IN ('CND', 'CAD') THEN '910120' 
	WHEN status in ('AEX') THEN '910180'
	WHEN status = 'OOS' THEN '910280' 
	WHEN status IN ('CCR') THEN '910150' 
	WHEN status = 'RCL' AND returned = dbo.date(GETDATE()) THEN (SELECT TOP 1 CASE WHEN SUBSTRING(thedata, 1, 1) = 9 THEN thedata ELSE thedata + 100000 end FROM dbo.MiscExtra WITH (NOLOCK) WHERE title = 'status_code' AND number = m.number)
	ELSE '112010' END AS status_code, 
	dbo.date(GETDATE()) AS status_date, 
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 CONVERT(NVARCHAR(10), dbo.date(DateFiled), 101) FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_filing,
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 CONVERT(NVARCHAR(2), chapter) FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_chapter,
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 casenumber FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_case,
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 status FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_disposition,
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
WHERE customer IN ('0001110', '0001111', '0001112')  
AND (CASE 
	WHEN CONVERT(VARCHAR(10), m.received, 101) = CONVERT(VARCHAR(10), GETDATE(), 101) THEN '101000' 
	--WHEN CONVERT(VARCHAR(10), m.received, 101) = CONVERT(VARCHAR(10), GETDATE(), 101) AND m.customer IN ('0001294', '0001295') THEN '191000'
	WHEN status IN ('ACT', 'NON') THEN '112000' 
	WHEN status IN ('PPA', 'PDC', 'PCC') THEN '113020' 
	WHEN status = 'MIL' THEN '910208'
	WHEN status IN ('HOT', 'nsf', 'dcc', 'dbd', 'bkn') THEN '112045' WHEN status LIKE 'VRB' THEN '112046' WHEN status = 'VRD' THEN '112046' WHEN status = 'DSP' THEN '920220'
	WHEN status = 'B07' THEN '901007' WHEN status = 'B11' THEN '901011' WHEN status = 'B12' THEN '901012' WHEN status = 'B13' THEN '901013'
	WHEN status = 'BKY' THEN '901007' WHEN status = 'DEC' THEN '902000' WHEN status = 'RSK' THEN '112070' WHEN status IN ('CND', 'CAD') THEN '910120' WHEN status in ('AEX') THEN '910180' 
	WHEN status = 'OOS' THEN '910280'
	WHEN status IN ('CCR') THEN '910150' 
	WHEN status = 'RCL' AND returned = dbo.date(GETDATE()) THEN (SELECT TOP 1 CASE WHEN SUBSTRING(thedata, 1, 1) = 9 THEN thedata ELSE thedata + 100000 end FROM dbo.MiscExtra WITH (NOLOCK) WHERE title = 'status_code' AND number = m.number)
	ELSE '112010' END <> (SELECT TOP 1 statuscode FROM dbo.Custom_CitizensBank_Status_Codes WITH (NOLOCK) WHERE m.id1 = DataID ORDER BY statusdate DESC)
	OR (SELECT TOP 1 statuscode FROM dbo.Custom_CitizensBank_Status_Codes WITH (NOLOCK) WHERE m.id1 = DataID ORDER BY statusdate DESC) IS NULL)

INSERT INTO dbo.Custom_CitizensBank_Status_Codes
        ( DataID, StatusCode, statusdate )

SELECT id1 AS data_id, CASE WHEN CONVERT(VARCHAR(10), m.received, 101) = CONVERT(VARCHAR(10), GETDATE(), 101) THEN '101000' 
	--WHEN CONVERT(VARCHAR(10), m.received, 101) = CONVERT(VARCHAR(10), GETDATE(), 101) AND m.customer IN ('0001294', '0001295') THEN '191000'
	WHEN status IN ('ACT', 'NON') THEN '112000' WHEN status IN ('PPA', 'PDC', 'PCC') THEN '113020' WHEN status = 'MIL' THEN '910208'
	WHEN status IN ('HOT', 'nsf', 'dcc', 'dbd', 'bkn') THEN '112045' WHEN status LIKE 'VRB' THEN '112046' WHEN status = 'VRD' THEN '112046' WHEN status = 'DSP' THEN '920220'
	WHEN status = 'B07' THEN '901007' WHEN status = 'B11' THEN '901011' WHEN status = 'B12' THEN '901012' WHEN status = 'B13' THEN '901013'
	WHEN status = 'BKY' THEN '901007' WHEN status = 'DEC' THEN '902000' WHEN status = 'RSK' THEN '112070' WHEN status IN ('CND', 'CAD') THEN '910120' WHEN status in ('AEX') THEN '910180' WHEN status = 'OOS' THEN '910280'
	WHEN status IN ('CCR') THEN '910150' 
	WHEN status = 'RCL' AND returned = dbo.date(GETDATE()) THEN (SELECT TOP 1 CASE WHEN SUBSTRING(thedata, 1, 1) = 9 THEN thedata ELSE thedata + 100000 end FROM dbo.MiscExtra WITH (NOLOCK) WHERE title = 'status_code' AND number = m.number)
	ELSE '112010' END AS status_code, dbo.date(GETDATE()) AS status_date
	
FROM master m WITH (NOLOCK)
WHERE customer IN ('0001110', '0001111', '0001112')
AND (CASE WHEN CONVERT(VARCHAR(10), m.received, 101) = CONVERT(VARCHAR(10), GETDATE(), 101) THEN '101000' 
	--WHEN CONVERT(VARCHAR(10), m.received, 101) = CONVERT(VARCHAR(10), GETDATE(), 101) AND m.customer IN ('0001294', '0001295') THEN '191000'
	WHEN status IN ('ACT', 'NON') THEN '112000' WHEN status IN ('PPA', 'PDC', 'PCC') THEN '113020' WHEN status = 'MIL' THEN '910208'
	WHEN status IN ('HOT', 'nsf', 'dcc', 'dbd', 'bkn') THEN '112045' WHEN status LIKE 'VRB' THEN '112046' WHEN status = 'VRD' THEN '112046' WHEN status = 'DSP' THEN '920220'
	WHEN status = 'B07' THEN '901007' WHEN status = 'B11' THEN '901011' WHEN status = 'B12' THEN '901012' WHEN status = 'B13' THEN '901013'
	WHEN status = 'BKY' THEN '901007' WHEN status = 'DEC' THEN '902000' WHEN status = 'RSK' THEN '112070' WHEN status IN ('CND', 'CAD') THEN '910120' WHEN status in ('AEX') THEN '910180' WHEN status = 'OOS' THEN '910280'
	WHEN status IN ('CCR') THEN '910150' 
	WHEN status = 'RCL' AND returned = dbo.date(GETDATE()) THEN (SELECT TOP 1 CASE WHEN SUBSTRING(thedata, 1, 1) = 9 THEN thedata ELSE thedata + 100000 end FROM dbo.MiscExtra WITH (NOLOCK) WHERE title = 'status_code' AND number = m.number)
	ELSE '112010' END <> (SELECT TOP 1 statuscode FROM dbo.Custom_CitizensBank_Status_Codes WITH (NOLOCK) WHERE m.id1 = DataID ORDER BY statusdate DESC)
	OR (SELECT TOP 1 statuscode FROM dbo.Custom_CitizensBank_Status_Codes WITH (NOLOCK) WHERE m.id1 = DataID ORDER BY statusdate DESC) IS NULL)

END
GO
