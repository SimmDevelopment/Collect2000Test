SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Kia Evans
-- Create date: 09/25/2023
-- Description:	Export Status Updates, new codes
-- Changes:		
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Denali_Capital_StatusUpdate]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- Removed all but first 3 columns, Data_id, Status_Code and Status_date
--exec custom_citizensbank_dn_statusupdate
	

    -- Insert statements for procedure here
	SELECT id2 AS data_id, 
	CASE 
	WHEN CONVERT(VARCHAR(10), m.received, 101) = CONVERT(VARCHAR(10), GETDATE(), 101) THEN '101000' 
	WHEN status IN ('ACT', 'NON') THEN '112000' 
	WHEN status IN ('PPA', 'PDC', 'PCC') THEN '113020' 
	WHEN status = 'MIL' THEN '910208'
	--WHEN status IN ('HOT', 'nsf', 'dcc', 'dbd', 'bkn') THEN '112045' 
	--WHEN status LIKE 'VRB' THEN '112046' 
	--WHEN status = 'VRD' THEN '112046' 
	--WHEN status = 'DSP' THEN '112035'
	WHEN status = 'B07' THEN '801007' WHEN status = 'B11' THEN '801011' WHEN status = 'B12' THEN '801012' WHEN status = 'B13' THEN '801013'	WHEN status = 'BKY' THEN '801000' 
	WHEN status = 'DEC' THEN '802000'
	WHEN status = 'RSK' THEN '910298' 
	--WHEN status = 'RSK' THEN '910180' changed to 905001 on 10/4/22 per Heather
	WHEN status IN ('CND', 'CAD') THEN '910120' 
	WHEN status in ('AEX') THEN '910180'
	--WHEN status = 'OOS' THEN '910280' 
	--WHEN status IN ('CCR') THEN '910150' 
	WHEN status IN ('sif', 'pif', 'rcl') AND dbo.date(returned) = dbo.date(GETDATE()) THEN (SELECT TOP 1 CASE WHEN SUBSTRING(thedata, 1, 1) = 9 THEN thedata ELSE thedata + 100000 end FROM dbo.MiscExtra WITH (NOLOCK) WHERE title = 'status_code' AND number = m.number)
	ELSE '112000' END AS status_code, 
	dbo.date(GETDATE()) AS status_date, 
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 CONVERT(NVARCHAR(10), dbo.date(DateFiled), 101) FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_filing,
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 CONVERT(NVARCHAR(2), chapter) FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_chapter,
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 casenumber FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_case,
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 status FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_disposition,
	CASE WHEN status IN ('bky', 'b07', 'b13', 'b11') THEN (SELECT TOP 1 CourtDistrict + ' ' + CourtStreet1 + ' ' + courtstreet2 + ' ' + CourtCity + ', ' + CourtState + ' ' + CourtZipcode  FROM bankruptcy WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS bk_location, 
	'' bk_state, 
	CASE WHEN status = 'DEC' THEN (SELECT TOP 1 CONVERT(NVARCHAR(10), dod, 101) FROM dbo.Deceased WITH (NOLOCK) WHERE AccountID = m.number ORDER BY DebtorID) ELSE '' END AS dec_date,
	'' AS rec_date, 
	CASE WHEN status = 'PDC' THEN (SELECT TOP 1 CONVERT(NVARCHAR(10), DATEADD(dd, 5, deposit), 101) FROM pdc WITH (NOLOCK) WHERE number = m.number AND active = 1 ORDER BY deposit) 
							WHEN status = 'PCC' THEN (SELECT TOP 1 CONVERT(NVARCHAR(10), DATEADD(dd, 5, depositdate), 101) FROM debtorcreditcards WITH (NOLOCK) WHERE Number = m.number AND IsActive = 1 ORDER BY DepositDate)
							WHEN status = 'PPA' THEN (SELECT TOP 1 CONVERT(NVARCHAR(10), DATEADD(dd, 5, duedate), 101) FROM promises WITH (NOLOCK) WHERE AcctID = m.number AND Active = 1 ORDER BY DueDate) ELSE '' END AS promise_due,
	CASE WHEN status = 'PDC' THEN (SELECT TOP 1 CONVERT(nvarchar(11), amount) FROM pdc WITH (NOLOCK) WHERE number = m.number AND active = 1 ORDER BY deposit) 
							WHEN status = 'PCC' THEN (SELECT TOP 1 CONVERT(NVARCHAR(11), amount) FROM debtorcreditcards WITH (NOLOCK) WHERE Number = m.number AND IsActive = 1 ORDER BY DepositDate)
							WHEN status = 'PPA' THEN (SELECT TOP 1 CONVERT(NVARCHAR(11), Amount) FROM promises WITH (NOLOCK) WHERE AcctID = m.number AND Active = 1 ORDER BY DueDate) ELSE '' END AS promise_amount,
	CASE WHEN status IN ('hot', 'pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'bkn') THEN 'Y' ELSE '' end AS keeper
	
FROM master m WITH (NOLOCK)
WHERE customer IN ('0003108')  
AND ((status <> 'RCL' AND CASE 
	WHEN CONVERT(VARCHAR(10), m.received, 101) = CONVERT(VARCHAR(10), GETDATE(), 101) THEN '101000' 
	WHEN status IN ('ACT', 'NON') THEN '112000' 
	WHEN status IN ('PPA', 'PDC', 'PCC') THEN '113020' 
	WHEN status = 'MIL' THEN '910208'
	--WHEN status IN ('HOT', 'nsf', 'dcc', 'dbd', 'bkn') THEN '112045' WHEN status LIKE 'VRB' THEN '112046' WHEN status = 'VRD' THEN '112046' WHEN status = 'DSP' THEN '112035'
	WHEN status = 'B07' THEN '801007' WHEN status = 'B11' THEN '801011' WHEN status = 'B12' THEN '801012' WHEN status = 'B13' THEN '801013'
	WHEN status = 'BKY' THEN '801000' WHEN status = 'DEC' THEN '802000' WHEN status = 'RSK' THEN '910298' WHEN status IN ('CND', 'CAD') THEN '910120' WHEN status in ('AEX') THEN '910180' 
	--WHEN status = 'OOS' THEN '910280'
	--WHEN status IN ('CCR') THEN '910150' 
	WHEN status IN ('sif', 'pif', 'rcl') AND dbo.date(returned) = dbo.date(GETDATE()) THEN (SELECT TOP 1 CASE WHEN SUBSTRING(thedata, 1, 1) = 9 THEN thedata ELSE thedata + 100000 end FROM dbo.MiscExtra WITH (NOLOCK) WHERE title = 'status_code' AND number = m.number)
	ELSE '112000' END <> (SELECT TOP 1 statuscode FROM dbo.Custom_ARC_Status_Codes WITH (NOLOCK) WHERE m.id2 = DataID ORDER BY statusdate DESC)
	OR (SELECT TOP 1 statuscode FROM dbo.Custom_ARC_Status_Codes WITH (NOLOCK) WHERE m.id2 = DataID ORDER BY statusdate DESC) IS NULL)
	OR (status IN ('sif', 'pif', 'rcl') AND (SELECT TOP 1 CASE WHEN SUBSTRING(thedata, 1, 1) = 9 THEN thedata ELSE thedata + 100000 end FROM dbo.MiscExtra WITH (NOLOCK) WHERE title = 'status_code' AND number = m.number) <> (SELECT TOP 1 statuscode FROM dbo.Custom_ARC_Status_Codes WITH (NOLOCK) WHERE m.id2 = DataID ORDER BY statusdate DESC)  AND dbo.date(returned) = dbo.date(GETDATE())))
	--AND id2 NOT IN ('a001', 'a002', 'a003', 'a004')
	
INSERT INTO dbo.Custom_ARC_Status_Codes
        ( DataID, StatusCode, statusdate )

	
	
SELECT id2 AS data_id, 
	CASE 
	WHEN CONVERT(VARCHAR(10), m.received, 101) = CONVERT(VARCHAR(10), GETDATE(), 101) THEN '101000' 
	WHEN status IN ('ACT', 'NON') THEN '112000' 
	WHEN status IN ('PPA', 'PDC', 'PCC') THEN '113020' 
	WHEN status = 'MIL' THEN '910208'
	--WHEN status IN ('HOT', 'nsf', 'dcc', 'dbd', 'bkn') THEN '112045' 
	--WHEN status LIKE 'VRB' THEN '112046' 
	--WHEN status = 'VRD' THEN '112046' 
	--WHEN status = 'DSP' THEN '112035'
	WHEN status = 'B07' THEN '801007' WHEN status = 'B11' THEN '801011' WHEN status = 'B12' THEN '801012' WHEN status = 'B13' THEN '801013'	WHEN status = 'BKY' THEN '801000' 
	WHEN status = 'DEC' THEN '802000'
	WHEN status = 'RSK' THEN '910298' 
	--WHEN status = 'RSK' THEN '910180' changed to 905001 on 10/4/22 per Heather
	WHEN status IN ('CND', 'CAD') THEN '910120' 
	WHEN status in ('AEX') THEN '910180'
	--WHEN status = 'OOS' THEN '910280' 
	--WHEN status IN ('CCR') THEN '910150' 
	WHEN status IN ('sif', 'pif', 'rcl') AND dbo.date(returned) = dbo.date(GETDATE()) THEN (SELECT TOP 1 CASE WHEN SUBSTRING(thedata, 1, 1) = 9 THEN thedata ELSE thedata + 100000 end FROM dbo.MiscExtra WITH (NOLOCK) WHERE title = 'status_code' AND number = m.number)
	ELSE '112000' END AS status_code, 
	dbo.date(GETDATE()) AS status_date
	
FROM master m WITH (NOLOCK)
WHERE customer IN ('0003108')
AND ((status <> 'RCL' AND CASE 
	WHEN CONVERT(VARCHAR(10), m.received, 101) = CONVERT(VARCHAR(10), GETDATE(), 101) THEN '101000' 
	WHEN status IN ('ACT', 'NON') THEN '112000' 
	WHEN status IN ('PPA', 'PDC', 'PCC') THEN '113020' 
	WHEN status = 'MIL' THEN '910208'
	--WHEN status IN ('HOT', 'nsf', 'dcc', 'dbd', 'bkn') THEN '112045' WHEN status LIKE 'VRB' THEN '112046' WHEN status = 'VRD' THEN '112046' WHEN status = 'DSP' THEN '112035'
	WHEN status = 'B07' THEN '801007' WHEN status = 'B11' THEN '801011' WHEN status = 'B12' THEN '801012' WHEN status = 'B13' THEN '801013'
	WHEN status = 'BKY' THEN '801000' WHEN status = 'DEC' THEN '802000' WHEN status = 'RSK' THEN '910298' WHEN status IN ('CND', 'CAD') THEN '910120' WHEN status in ('AEX') THEN '910180' 
	--WHEN status = 'OOS' THEN '910280'
	--WHEN status IN ('CCR') THEN '910150' 
	WHEN status IN ('sif', 'pif', 'rcl') AND dbo.date(returned) = dbo.date(GETDATE()) THEN (SELECT TOP 1 CASE WHEN SUBSTRING(thedata, 1, 1) = 9 THEN thedata ELSE thedata + 100000 end FROM dbo.MiscExtra WITH (NOLOCK) WHERE title = 'status_code' AND number = m.number)
	ELSE '112000' END <> (SELECT TOP 1 statuscode FROM dbo.Custom_ARC_Status_Codes WITH (NOLOCK) WHERE m.id2 = DataID ORDER BY statusdate DESC)
	OR (SELECT TOP 1 statuscode FROM dbo.Custom_ARC_Status_Codes WITH (NOLOCK) WHERE m.id2 = DataID ORDER BY statusdate DESC) IS NULL)
	OR (status IN ('sif', 'pif', 'rcl') AND (SELECT TOP 1 CASE WHEN SUBSTRING(thedata, 1, 1) = 9 THEN thedata ELSE thedata + 100000 end FROM dbo.MiscExtra WITH (NOLOCK) WHERE title = 'status_code' AND number = m.number) <> (SELECT TOP 1 statuscode FROM dbo.Custom_ARC_Status_Codes WITH (NOLOCK) WHERE m.id2 = DataID ORDER BY statusdate DESC)  AND dbo.date(returned) = dbo.date(GETDATE())))
	--AND id2 NOT IN ('a001', 'a002', 'a003', 'a004')

END
GO
