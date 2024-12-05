SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G. Meehan
-- Create date: 03/31/2022
-- Description:	Export Maintenance File for Sallie Mae CO Placements by Date
-- Changes:
--			05/19/2022 BGM Added 500/510 Deceased Record/Bankruptcy Record/Litigious Risk/SCRA
--			05/20/2022 BGM Added 500/510 for Verbal Deceased and Bankruptcy
--			05/20/2022 BGM Added 520 Record for Phones
--			05/23/2022 BGM Added 530 Record for POE Information 510 record for address changes.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Sallie_Mae_Post_Export_Maintenance]
	-- Add the parameters for the stored procedure here
	@startDate DATE,
	@endDate DATE	

--	exec Custom_Sallie_Mae_Post_Export_Maintenance '20220301', '20220531'

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

--500 Record Placement Acknowledgments
	SELECT '500' AS RECID, id1 AS ARACID, 'SIMMS' AS ARACVENDID, 'N' AS ISRETURN, '' AS RETURNREASON, '' AS ZZFSACPHOBJREASON, 'ACT' AS ARACVENSTATID, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE m.number = number AND Title = 'acc.0.afacintrate') AS AFACINTRATE,
(SELECT TOP 1 FORMAT(CAST(TheData AS DATE), 'MMddyyyy') from MiscExtra WITH (NOLOCK) WHERE Title = 'acc.0.afacinthrudt' AND Number = m.number) AS AFACINTHRUDR, '' AS ARACLPYAMT, '' AS ARACLPYDTE, 'N' AS ARACDISPUTE, '' AS ARACDISPRSNID,
'' AS ARACDISPDTE, '' AS ZZACDSPPDDTE, '' AS ZZACDSPPDAMT, '' AS ZZACDSPOTHREAS
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.Seq = 0
WHERE customer = '0002877' AND CAST(m.received AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

UNION ALL

--500 Record Recall Acknowledgement
	SELECT '500' AS RECID, id1 AS ARACID, 'SIMMS' AS ARACVENDID, 'Y' AS ISRETURN, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE Title = 'REASON' AND Number = m.number) AS RETURNREASON, 
	'' AS ZZFSACPHOBJREASON, 'RTN' AS ARACVENSTATID, m.interestrate AS AFACINTRATE, FORMAT(m.lastinterest, 'MMddyyyy') AS AFACINTHRUDR, ISNULL(m.lastpaidamt, 0) AS ARACLPYAMT, 
ISNULL(FORMAT(m.lastpaid, 'MMddyyyy'), '') AS ARACLPYDTE,  'N' AS ARACDISPUTE, '' AS ARACDISPRSNID, '' AS ARACDISPDTE, '' AS ZZACDSPPDDTE, '' AS ZZACDSPPDAMT, '' AS ZZACDSPOTHREAS
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.Seq = 0
WHERE customer = '0002877' AND CAST(m.returned AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

UNION ALL

--500 Record for Deceased - Service
	SELECT '500' AS RECID, id1 AS ARACID, 'SIMMS' AS ARACVENDID, 'N' AS ISRETURN, '' AS RETURNREASON, 
	'' AS ZZFSACPHOBJREASON, 'DTH' AS ARACVENSTATID, m.interestrate AS AFACINTRATE, FORMAT(m.lastinterest, 'MMddyyyy') AS AFACINTHRUDR, ISNULL(m.lastpaidamt, 0) AS ARACLPYAMT, 
ISNULL(FORMAT(m.lastpaid, 'MMddyyyy'), '') AS ARACLPYDTE,  'N' AS ARACDISPUTE, '' AS ARACDISPRSNID, '' AS ARACDISPDTE, '' AS ZZACDSPPDDTE, '' AS ZZACDSPPDAMT, '' AS ZZACDSPOTHREAS
FROM master m WITH (NOLOCK) INNER JOIN deceased dc WITH (NOLOCK) ON m.number = dc.AccountID INNER JOIN Debtors d WITH (NOLOCK) ON dc.DebtorID = d.DebtorID
WHERE customer = '0002877' 
AND m.number IN (SELECT number FROM notes WITH (NOLOCK) WHERE number = m.number AND action = 'DECD' AND result = 'IF' AND CAST(created AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))

UNION ALL

--500 Record for Deceased - Verbal
	SELECT '500' AS RECID, id1 AS ARACID, 'SIMMS' AS ARACVENDID, 'N' AS ISRETURN, '' AS RETURNREASON, 
	'' AS ZZFSACPHOBJREASON, 'DTH' AS ARACVENSTATID, m.interestrate AS AFACINTRATE, FORMAT(m.lastinterest, 'MMddyyyy') AS AFACINTHRUDR, ISNULL(m.lastpaidamt, 0) AS ARACLPYAMT, 
ISNULL(FORMAT(m.lastpaid, 'MMddyyyy'), '') AS ARACLPYDTE,  'N' AS ARACDISPUTE, '' AS ARACDISPRSNID, '' AS ARACDISPDTE, '' AS ZZACDSPPDDTE, '' AS ZZACDSPPDAMT, '' AS ZZACDSPOTHREAS
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number LEFT OUTER JOIN deceased dc WITH (NOLOCK) ON d.debtorid = dc.AccountID 
WHERE customer = '0002877' AND m.status = 'VRD'
AND m.number IN (SELECT sh.AccountID FROM StatusHistory sh WITH (NOLOCK) WHERE AccountID = m.number AND sh.NewStatus = 'VRD' AND DateChanged BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))

UNION ALL

--500 Record for Bankruptcy - Service
	SELECT '500' AS RECID, id1 AS ARACID, 'SIMMS' AS ARACVENDID, 'N' AS ISRETURN, '' AS RETURNREASON, 
	'' AS ZZFSACPHOBJREASON, 'BNK' AS ARACVENSTATID, m.interestrate AS AFACINTRATE, FORMAT(m.lastinterest, 'MMddyyyy') AS AFACINTHRUDR, ISNULL(m.lastpaidamt, 0) AS ARACLPYAMT, 
ISNULL(FORMAT(m.lastpaid, 'MMddyyyy'), '') AS ARACLPYDTE,  'N' AS ARACDISPUTE, '' AS ARACDISPRSNID, '' AS ARACDISPDTE, '' AS ZZACDSPPDDTE, '' AS ZZACDSPPDAMT, '' AS ZZACDSPOTHREAS
FROM master m WITH (NOLOCK) INNER JOIN Bankruptcy b WITH (NOLOCK) ON m.number = b.AccountID INNER JOIN Debtors d WITH (NOLOCK) ON b.DebtorID = d.DebtorID
WHERE customer = '0002877' 
AND m.number IN (SELECT number FROM notes WITH (NOLOCK) WHERE number = m.number AND action = 'BNKO' AND result = 'IF' AND CAST(created AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
AND b.status <> 'Dismissed'

UNION ALL

--500 Record for Bankruptcy - Verbal
	SELECT '500' AS RECID, id1 AS ARACID, 'SIMMS' AS ARACVENDID, 'N' AS ISRETURN, '' AS RETURNREASON, 
	'' AS ZZFSACPHOBJREASON, 'BNK' AS ARACVENSTATID, m.interestrate AS AFACINTRATE, FORMAT(m.lastinterest, 'MMddyyyy') AS AFACINTHRUDR, ISNULL(m.lastpaidamt, 0) AS ARACLPYAMT, 
ISNULL(FORMAT(m.lastpaid, 'MMddyyyy'), '') AS ARACLPYDTE,  'N' AS ARACDISPUTE, '' AS ARACDISPRSNID, '' AS ARACDISPDTE, '' AS ZZACDSPPDDTE, '' AS ZZACDSPPDAMT, '' AS ZZACDSPOTHREAS
FROM master m WITH (NOLOCK) INNER JOIN Bankruptcy b WITH (NOLOCK) ON m.number = b.AccountID INNER JOIN Debtors d WITH (NOLOCK) ON b.DebtorID = d.DebtorID
WHERE customer = '0002877' AND m.status = 'VRB'
AND m.number IN (SELECT sh.AccountID FROM StatusHistory sh WITH (NOLOCK) WHERE AccountID = m.number AND sh.NewStatus = 'VRB' AND DateChanged BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
AND b.status <> 'Dismissed'


UNION ALL

--500 Record for Litigious/Risk
	SELECT '500' AS RECID, id1 AS ARACID, 'SIMMS' AS ARACVENDID, 'Y' AS ISRETURN, 'ZZRISK' AS RETURNREASON, 
	'' AS ZZFSACPHOBJREASON, '' AS ARACVENSTATID, m.interestrate AS AFACINTRATE, FORMAT(m.lastinterest, 'MMddyyyy') AS AFACINTHRUDR, ISNULL(m.lastpaidamt, 0) AS ARACLPYAMT, 
ISNULL(FORMAT(m.lastpaid, 'MMddyyyy'), '') AS ARACLPYDTE,  'N' AS ARACDISPUTE, '' AS ARACDISPRSNID, '' AS ARACDISPDTE, '' AS ZZACDSPPDDTE, '' AS ZZACDSPPDAMT, '' AS ZZACDSPOTHREAS
FROM master m WITH (NOLOCK) 
WHERE customer = '0002877' AND m.status = 'RSK' AND CAST(closed  AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

UNION ALL

--500 Record for SCRA
	SELECT '500' AS RECID, id1 AS ARACID, 'SIMMS' AS ARACVENDID, 'Y' AS ISRETURN, 'SCRA' AS RETURNREASON, 
	'' AS ZZFSACPHOBJREASON, '' AS ARACVENSTATID, m.interestrate AS AFACINTRATE, FORMAT(m.lastinterest, 'MMddyyyy') AS AFACINTHRUDR, ISNULL(m.lastpaidamt, 0) AS ARACLPYAMT, 
ISNULL(FORMAT(m.lastpaid, 'MMddyyyy'), '') AS ARACLPYDTE,  'N' AS ARACDISPUTE, '' AS ARACDISPRSNID, '' AS ARACDISPDTE, '' AS ZZACDSPPDDTE, '' AS ZZACDSPPDAMT, '' AS ZZACDSPOTHREAS
FROM master m WITH (NOLOCK) 
WHERE customer = '0002877' AND m.status = 'MIL' AND CAST(closed  AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

---------------------------------------------------------------------------------
-------------------------BEGIN 510 RECORDS---------------------------------------
---------------------------------------------------------------------------------

--510 Record For Deceased
	SELECT '510' AS RECID, 
	id1 AS ARACID,
	D.DebtorMemo AS ZZENCIN,
	CASE D.Seq WHEN 0 THEN 'PRIM' ELSE 'COMAK' END AS ARRELTYPID,
	D.lastName AS ARENLNM, 
	D.firstName AS ARENFNM,
	D.middleName AS ARENMNM,
	CONVERT(VARCHAR(8), FORMAT(D.DOB, 'MMddyyyy')) AS ARENBTHDTE,
	D.Street1 AS ARENADR,
	D.Street2 AS ARENUNT,
	D.City AS ARENCTY,
	D.State AS ARENST,
	D.Zipcode AS ARENZIP,
	ISNULL(D.Country, '') AS ARENCNTRY,
	'' AS ZZENADR3,
	'' AS ZZENADR4,
	CASE d.MR WHEN '1' THEN 'N' ELSE 'Y' END AS ZZENADRFLAG,
	D.Email AS ARENEMAIL,
	'' AS ZZENEMFL,
	'' AS ZZENCITIZENCD,
	'' AS ARENBNKRPT,
	'' AS ARENBNKCHP,
	'' AS ARENBNKDTE,
	'' AS ARRELCONLVL,
	ISNULL(CONVERT(VARCHAR(8), FORMAT(M.contacted, 'MMddyyyy')), '') AS ARRELLASTCTCDTE,
	'Y' AS ARENDECEASED,
	ISNULL(CONVERT(VARCHAR(8), FORMAT(ISNULL(dc.DOD, GETDATE()), 'MMddyyyy')), '') AS ARENDECDTE,
	'' AS ZZENDISABLED,
	'' AS ARENSCRAID_ARSCRAACTIVE,
	'' AS ARENSCRAID_ARSCRAENDDTE,
	'' AS ARENSCRAID_ARSCRASTARTDTE,
	'' AS ZZENCOMPRCVDDTE,
	'' AS ZZENCOMPREASON,
	'' AS ZZENCOMPRESPDTE,
	'' AS ZZENCOMPRESONSE,
	ISNULL(da.Firm, '') AS ARATFIRM,
	ISNULL(dbo.GetFirstName(da.Name), '') AS ARATFNM,
	ISNULL(dbo.GetLastName(da.Name), '') AS ARATLNM,
	'' AS ARATSPEC,
	ISNULL(da.Addr1, '') AS ARATADR,
	ISNULL(da.Addr2, '') AS ARATADR2,
	ISNULL(da.City, '') AS ARATCTY,
	ISNULL(da.State, '') AS ARATST,
	ISNULL(da.Zipcode, '') AS ARATZIP,
	ISNULL(da.Phone, '') AS ARATPH,
	ISNULL(da.Email, '') AS ARATEMAIL,
	'' AS ARATCONFNM,
	'' AS ARATCONLNM,
	'' AS ZZRELFRAUD	
FROM master m WITH (NOLOCK) INNER JOIN deceased dc WITH (NOLOCK) ON m.number = dc.AccountID INNER JOIN Debtors d WITH (NOLOCK) ON dc.DebtorID = d.DebtorID
	LEFT OUTER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
WHERE customer = '0002877' 
AND m.number IN (SELECT number FROM notes WITH (NOLOCK) WHERE number = m.number AND action = 'DECD' AND result = 'IF' AND CAST(created AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))

UNION ALL

--510 Record For Deceased - Verbal
	SELECT '510' AS RECID, 
	id1 AS ARACID,
	D.DebtorMemo AS ZZENCIN,
	CASE D.Seq WHEN 0 THEN 'PRIM' ELSE 'COMAK' END AS ARRELTYPID,
	D.lastName AS ARENLNM, 
	D.firstName AS ARENFNM,
	D.middleName AS ARENMNM,
	CONVERT(VARCHAR(8), FORMAT(D.DOB, 'MMddyyyy')) AS ARENBTHDTE,
	D.Street1 AS ARENADR,
	D.Street2 AS ARENUNT,
	D.City AS ARENCTY,
	D.State AS ARENST,
	D.Zipcode AS ARENZIP,
	ISNULL(D.Country, '') AS ARENCNTRY,
	'' AS ZZENADR3,
	'' AS ZZENADR4,
	CASE d.MR WHEN '1' THEN 'N' ELSE 'Y' END AS ZZENADRFLAG,
	D.Email AS ARENEMAIL,
	'' AS ZZENEMFL,
	'' AS ZZENCITIZENCD,
	'' AS ARENBNKRPT,
	'' AS ARENBNKCHP,
	'' AS ARENBNKDTE,
	'' AS ARRELCONLVL,
	ISNULL(CONVERT(VARCHAR(8), FORMAT(M.contacted, 'MMddyyyy')), '') AS ARRELLASTCTCDTE,
	'Y' AS ARENDECEASED,
	ISNULL(CONVERT(VARCHAR(8), FORMAT(ISNULL(dc.DOD, GETDATE()), 'MMddyyyy')), '') AS ARENDECDTE,
	'' AS ZZENDISABLED,
	'' AS ARENSCRAID_ARSCRAACTIVE,
	'' AS ARENSCRAID_ARSCRAENDDTE,
	'' AS ARENSCRAID_ARSCRASTARTDTE,
	'' AS ZZENCOMPRCVDDTE,
	'' AS ZZENCOMPREASON,
	'' AS ZZENCOMPRESPDTE,
	'' AS ZZENCOMPRESONSE,
	ISNULL(da.Firm, '') AS ARATFIRM,
	ISNULL(dbo.GetFirstName(da.Name), '') AS ARATFNM,
	ISNULL(dbo.GetLastName(da.Name), '') AS ARATLNM,
	'' AS ARATSPEC,
	ISNULL(da.Addr1, '') AS ARATADR,
	ISNULL(da.Addr2, '') AS ARATADR2,
	ISNULL(da.City, '') AS ARATCTY,
	ISNULL(da.State, '') AS ARATST,
	ISNULL(da.Zipcode, '') AS ARATZIP,
	ISNULL(da.Phone, '') AS ARATPH,
	ISNULL(da.Email, '') AS ARATEMAIL,
	'' AS ARATCONFNM,
	'' AS ARATCONLNM,
	'' AS ZZRELFRAUD	
FROM master m WITH (NOLOCK) INNER JOIN deceased dc WITH (NOLOCK) ON m.number = dc.AccountID INNER JOIN Debtors d WITH (NOLOCK) ON dc.DebtorID = d.DebtorID
	LEFT OUTER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
WHERE customer = '0002877' AND m.status = 'VRD'
AND m.number IN (SELECT sh.AccountID FROM StatusHistory sh WITH (NOLOCK) WHERE AccountID = m.number AND sh.NewStatus = 'VRD' AND CAST(DateChanged AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))

UNION ALL

--510 Record For Bankruptcy
	SELECT '510' AS RECID, 
	id1 AS ARACID,
	D.DebtorMemo AS ZZENCIN,
	CASE D.Seq WHEN 0 THEN 'PRIM' ELSE 'COMAK' END AS ARRELTYPID,
	D.lastName AS ARENLNM, 
	D.firstName AS ARENFNM,
	D.middleName AS ARENMNM,
	CONVERT(VARCHAR(8), FORMAT(D.DOB, 'MMddyyyy')) AS ARENBTHDTE,
	D.Street1 AS ARENADR,
	D.Street2 AS ARENUNT,
	D.City AS ARENCTY,
	D.State AS ARENST,
	D.Zipcode AS ARENZIP,
	ISNULL(D.Country, '') AS ARENCNTRY,
	'' AS ZZENADR3,
	'' AS ZZENADR4,
	CASE d.MR WHEN '1' THEN 'N' ELSE 'Y' END AS ZZENADRFLAG,
	D.Email AS ARENEMAIL,
	'' AS ZZENEMFL,
	'' AS ZZENCITIZENCD,
	CASE WHEN b.Status = 'Dismissed' THEN 'N' ELSE 'Y' END AS ARENBNKRPT,
	b.Chapter AS ARENBNKCHP,
	ISNULL(CONVERT(VARCHAR(8), FORMAT(b.DateFiled, 'MMddyyyy')), '') AS ARENBNKDTE,
	'' AS ARRELCONLVL,
	ISNULL(CONVERT(VARCHAR(8), FORMAT(M.contacted, 'MMddyyyy')), '') AS ARRELLASTCTCDTE,
	'' AS ARENDECEASED,
	'' AS ARENDECDTE,
	'' AS ZZENDISABLED,
	'' AS ARENSCRAID_ARSCRAACTIVE,
	'' AS ARENSCRAID_ARSCRAENDDTE,
	'' AS ARENSCRAID_ARSCRASTARTDTE,
	'' AS ZZENCOMPRCVDDTE,
	'' AS ZZENCOMPREASON,
	'' AS ZZENCOMPRESPDTE,
	'' AS ZZENCOMPRESONSE,
	ISNULL(da.Firm, '') AS ARATFIRM,
	ISNULL(dbo.GetFirstName(da.Name), '') AS ARATFNM,
	ISNULL(dbo.GetLastName(da.Name), '') AS ARATLNM,
	CASE WHEN da.id IS NOT NULL THEN 'BNK' ELSE '' END AS ARATSPEC,
	ISNULL(da.Addr1, '') AS ARATADR,
	ISNULL(da.Addr2, '') AS ARATADR2,
	ISNULL(da.City, '') AS ARATCTY,
	ISNULL(da.State, '') AS ARATST,
	ISNULL(da.Zipcode, '') AS ARATZIP,
	ISNULL(da.Phone, '') AS ARATPH,
	ISNULL(da.Email, '') AS ARATEMAIL,
	'' AS ARATCONFNM,
	'' AS ARATCONLNM,
	'' AS ZZRELFRAUD	
FROM master m WITH (NOLOCK) INNER JOIN Bankruptcy b WITH (NOLOCK) ON m.number = b.AccountID INNER JOIN Debtors d WITH (NOLOCK) ON b.DebtorID = d.DebtorID
	LEFT OUTER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
WHERE customer = '0002877' 
AND m.number IN (SELECT number FROM notes WITH (NOLOCK) WHERE number = m.number AND action = 'BNKO' AND result = 'IF' AND CAST(created AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
AND b.status <> 'Dismissed'

UNION ALL

--510 Record For Bankruptcy - Verbal
	SELECT '510' AS RECID, 
	id1 AS ARACID,
	D.DebtorMemo AS ZZENCIN,
	CASE D.Seq WHEN 0 THEN 'PRIM' ELSE 'COMAK' END AS ARRELTYPID,
	D.lastName AS ARENLNM, 
	D.firstName AS ARENFNM,
	D.middleName AS ARENMNM,
	CONVERT(VARCHAR(8), FORMAT(D.DOB, 'MMddyyyy')) AS ARENBTHDTE,
	D.Street1 AS ARENADR,
	D.Street2 AS ARENUNT,
	D.City AS ARENCTY,
	D.State AS ARENST,
	D.Zipcode AS ARENZIP,
	ISNULL(D.Country, '') AS ARENCNTRY,
	'' AS ZZENADR3,
	'' AS ZZENADR4,
	CASE d.MR WHEN '1' THEN 'N' ELSE 'Y' END AS ZZENADRFLAG,
	D.Email AS ARENEMAIL,
	'' AS ZZENEMFL,
	'' AS ZZENCITIZENCD,
	CASE WHEN b.Status = 'Dismissed' THEN 'N' ELSE 'Y' END AS ARENBNKRPT,
	b.Chapter AS ARENBNKCHP,
	ISNULL(CONVERT(VARCHAR(8), FORMAT(b.DateFiled, 'MMddyyyy')), '') AS ARENBNKDTE,
	'' AS ARRELCONLVL,
	ISNULL(CONVERT(VARCHAR(8), FORMAT(M.contacted, 'MMddyyyy')), '') AS ARRELLASTCTCDTE,
	'' AS ARENDECEASED,
	'' AS ARENDECDTE,
	'' AS ZZENDISABLED,
	'' AS ARENSCRAID_ARSCRAACTIVE,
	'' AS ARENSCRAID_ARSCRAENDDTE,
	'' AS ARENSCRAID_ARSCRASTARTDTE,
	'' AS ZZENCOMPRCVDDTE,
	'' AS ZZENCOMPREASON,
	'' AS ZZENCOMPRESPDTE,
	'' AS ZZENCOMPRESONSE,
	ISNULL(da.Firm, '') AS ARATFIRM,
	ISNULL(dbo.GetFirstName(da.Name), '') AS ARATFNM,
	ISNULL(dbo.GetLastName(da.Name), '') AS ARATLNM,
	CASE WHEN da.id IS NOT NULL THEN 'BNK' ELSE '' END AS ARATSPEC,
	ISNULL(da.Addr1, '') AS ARATADR,
	ISNULL(da.Addr2, '') AS ARATADR2,
	ISNULL(da.City, '') AS ARATCTY,
	ISNULL(da.State, '') AS ARATST,
	ISNULL(da.Zipcode, '') AS ARATZIP,
	ISNULL(da.Phone, '') AS ARATPH,
	ISNULL(da.Email, '') AS ARATEMAIL,
	'' AS ARATCONFNM,
	'' AS ARATCONLNM,
	'' AS ZZRELFRAUD	
FROM master m WITH (NOLOCK) INNER JOIN Bankruptcy b WITH (NOLOCK) ON m.number = b.AccountID INNER JOIN Debtors d WITH (NOLOCK) ON b.DebtorID = d.DebtorID
	LEFT OUTER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
WHERE customer = '0002877' AND m.status = 'VRB'
AND m.number IN (SELECT sh.AccountID FROM StatusHistory sh WITH (NOLOCK) WHERE AccountID = m.number AND sh.NewStatus = 'VRB' AND DateChanged BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
AND b.status <> 'Dismissed'

UNION ALL

--510 Record For SCRA
	SELECT '510' AS RECID, 
	id1 AS ARACID,
	D.DebtorMemo AS ZZENCIN,
	CASE D.Seq WHEN 0 THEN 'PRIM' ELSE 'COMAK' END AS ARRELTYPID,
	D.lastName AS ARENLNM, 
	D.firstName AS ARENFNM,
	D.middleName AS ARENMNM,
	CONVERT(VARCHAR(8), FORMAT(D.DOB, 'MMddyyyy')) AS ARENBTHDTE,
	D.Street1 AS ARENADR,
	D.Street2 AS ARENUNT,
	D.City AS ARENCTY,
	D.State AS ARENST,
	D.Zipcode AS ARENZIP,
	ISNULL(D.Country, '') AS ARENCNTRY,
	'' AS ZZENADR3,
	'' AS ZZENADR4,
	CASE d.MR WHEN '1' THEN 'N' ELSE 'Y' END AS ZZENADRFLAG,
	D.Email AS ARENEMAIL,
	'' AS ZZENEMFL,
	'' AS ZZENCITIZENCD,
	'' AS ARENBNKRPT,
	'' AS ARENBNKCHP,
	'' AS ARENBNKDTE,
	'' AS ARRELCONLVL,
	ISNULL(CONVERT(VARCHAR(8), FORMAT(M.contacted, 'MMddyyyy')), '') AS ARRELLASTCTCDTE,
	'' AS ARENDECEASED,
	'' AS ARENDECDTE,
	'' AS ZZENDISABLED,
	CASE WHEN csh.IsActiveDuty = 'X' THEN 'Y' ELSE 'N' END AS ARENSCRAID_ARSCRAACTIVE,
	ISNULL(CONVERT(varchar(8), FORMAT(csh.ActiveDutyEndDate, 'MMddyyyy')), '') AS ARENSCRAID_ARSCRAENDDTE,
	ISNULL(CONVERT(varchar(8), FORMAT(csh.ActiveDutyBeginDate, 'MMddyyyy')), '') AS ARENSCRAID_ARSCRASTARTDTE,
	'' AS ZZENCOMPRCVDDTE,
	'' AS ZZENCOMPREASON,
	'' AS ZZENCOMPRESPDTE,
	'' AS ZZENCOMPRESONSE,
	'' AS ARATFIRM,
	'' AS ARATFNM,
	'' AS ARATLNM,
	'' AS ARATSPEC,
	'' AS ARATADR,
	'' AS ARATADR2,
	'' AS ARATCTY,
	'' AS ARATST,
	'' AS ARATZIP,
	'' AS ARATPH,
	'' AS ARATEMAIL,
	'' AS ARATCONFNM,
	'' AS ARATCONLNM,
	'' AS ZZRELFRAUD	
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number
	INNER JOIN Custom_SCRA_History csh WITH (NOLOCK) ON d.DebtorID = csh.DebtorID 
WHERE customer = '0002877' AND m.status = 'MIL' AND CAST(closed  AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

UNION ALL

--510 Record For Address and Name Changes
	SELECT '510' AS RECID, 
	id1 AS ARACID,
	D.DebtorMemo AS ZZENCIN,
	CASE D.Seq WHEN 0 THEN 'PRIM' ELSE 'COMAK' END AS ARRELTYPID,
	D.lastName AS ARENLNM, 
	D.firstName AS ARENFNM,
	D.middleName AS ARENMNM,
	CONVERT(VARCHAR(8), FORMAT(D.DOB, 'MMddyyyy')) AS ARENBTHDTE,
	D.Street1 AS ARENADR,
	D.Street2 AS ARENUNT,
	D.City AS ARENCTY,
	D.State AS ARENST,
	D.Zipcode AS ARENZIP,
	ISNULL(D.Country, '') AS ARENCNTRY,
	'' AS ZZENADR3,
	'' AS ZZENADR4,
	CASE d.MR WHEN '1' THEN 'N' ELSE 'Y' END AS ZZENADRFLAG,
	D.Email AS ARENEMAIL,
	'' AS ZZENEMFL,
	'' AS ZZENCITIZENCD,
	'' AS ARENBNKRPT,
	'' AS ARENBNKCHP,
	'' AS ARENBNKDTE,
	'' AS ARRELCONLVL,
	ISNULL(CONVERT(VARCHAR(8), FORMAT(M.contacted, 'MMddyyyy')), '') AS ARRELLASTCTCDTE,
	'' AS ARENDECEASED,
	'' AS ARENDECDTE,
	'' AS ZZENDISABLED,
	'' AS ARENSCRAID_ARSCRAACTIVE,
	'' AS ARENSCRAID_ARSCRAENDDTE,
	'' AS ARENSCRAID_ARSCRASTARTDTE,
	'' AS ZZENCOMPRCVDDTE,
	'' AS ZZENCOMPREASON,
	'' AS ZZENCOMPRESPDTE,
	'' AS ZZENCOMPRESONSE,
	'' AS ARATFIRM,
	'' AS ARATFNM,
	'' AS ARATLNM,
	'' AS ARATSPEC,
	'' AS ARATADR,
	'' AS ARATADR2,
	'' AS ARATCTY,
	'' AS ARATST,
	'' AS ARATZIP,
	'' AS ARATPH,
	'' AS ARATEMAIL,
	'' AS ARATCONFNM,
	'' AS ARATCONLNM,
	'' AS ZZRELFRAUD	
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number
	WHERE customer = '0002877' 
AND d.DebtorID IN (SELECT ah.DebtorID FROM AddressHistory ah WITH (NOLOCK) WHERE ah.DebtorID = d.DebtorID AND DateChanged BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))

---------------------------------------------------------------------------------
-------------------------BEGIN 520 RECORDS---------------------------------------
---------------------------------------------------------------------------------

--Record 520 Update phones
	SELECT DISTINCT '520' AS RECID, CONVERT(VARCHAR(50), D.DebtorMemo) AS ZZENCIN, CASE D.Seq WHEN 0 THEN 'PRIM' ELSE 'COMAK' END AS ARRELTYPID, pm.PhoneNumber AS ARPHPHONE, CASE pt.PhoneTypeMapping WHEN '0' THEN 'HOME' WHEN '1' THEN 'WORK' WHEN '2' THEN 'MOBILE' ELSE 'OTHER' END AS ARPHTYPE,
	CASE pt.PhoneTypeMapping WHEN '0' THEN 'PRIMARY' WHEN '1' THEN 'POE' WHEN '2' THEN 'SECONDARY' ELSE 'TERTIARY' END AS ARPHMAPKEY, CASE pm.PhoneStatusID WHEN '1' THEN 'Y' ELSE 'N' END AS ARPHWRONG,
	CASE pm.PhoneStatusID WHEN '1' THEN 'Y' ELSE 'N' END AS ARPHBAD, 'N' AS ARPHCEASE
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number
LEFT OUTER JOIN PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID
LEFT OUTER JOIN Phones_Master pm WITH (NOLOCK) ON d.DebtorID = pm.DebtorID
INNER JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
OUTER APPLY (
    SELECT  TOP 1 *
    FROM    PhoneHistory ph2
    WHERE   ph2.AccountID = ph.AccountID
    AND ph2.debtorid = ph.DebtorID AND ph2.OldNumber = pm.PhoneNumber
    AND (ph2.DateChanged = ph.DateChanged)
    AND ph2.UserChanged NOT IN ('EXG')
    ORDER BY ph2.DateChanged DESC
    ) AS phh
WHERE (CAST(ph.DateChanged AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) OR CAST(pm.DateAdded AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
AND customer = '0002877'
AND (ph.ID = phh.ID OR ph.id IS NULL)
AND pm.loginname <> 'SYNC' AND CAST(pm.DateAdded AS DATE) <> CAST(m.received AS DATE)
AND pt.PhoneTypeMapping <> 1

---------------------------------------------------------------------------------
-------------------------BEGIN 530 RECORDS---------------------------------------
---------------------------------------------------------------------------------

--Record 530 Update POE Phones
SELECT DISTINCT '530' AS RECID, CONVERT(VARCHAR(30), D.DebtorMemo) AS ZZENCIN, CASE D.Seq WHEN 0 THEN 'PRIM' ELSE 'COMAK' END AS ARRELTYPID, d.JobName AS ARPOENAME, D.JobAddr1 AS ARPOEADR1, D.Jobaddr2 AS ARPOEADR2,
ISNULL(dbo.ParseAddress(D.jobcsz, N'City'), '') AS ARPOECITY, ISNULL(dbo.ParseAddress(D.jobcsz, N'State'), '') AS ARPOEST, ISNULL(dbo.ParseAddress(D.jobcsz, N'Zip'), '') AS ARPOEZIP, CASE WHEN d.JobName = '' THEN 'N' ELSE 'Y' END AS ARPOEACTIVE,
'' AS APOEBEST, pm.PhoneNumber AS ARPHPHONE, '' AS ARPHPHONE1, '' AS ARPOETYPE, '' AS ARPOETITLE, '' AS ARPOEHIREDATE, '' AS ARPOETERMDATE
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number
LEFT OUTER JOIN PhoneHistory ph WITH (NOLOCK) ON d.DebtorID = ph.DebtorID
LEFT OUTER JOIN Phones_Master pm WITH (NOLOCK) ON d.DebtorID = pm.DebtorID
INNER JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
OUTER APPLY (
    SELECT  TOP 1 *
    FROM    PhoneHistory ph2
    WHERE   ph2.AccountID = ph.AccountID
    AND ph2.debtorid = ph.DebtorID AND ph2.OldNumber = pm.PhoneNumber
    AND (ph2.DateChanged = ph.DateChanged)
    AND ph2.UserChanged NOT IN ('EXG')
    ORDER BY ph2.DateChanged DESC
    ) AS phh
WHERE (CAST(ph.DateChanged AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) OR CAST(pm.DateAdded AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE))
AND customer = '0002877'
AND (ph.ID = phh.ID OR ph.id IS NULL)
AND pm.loginname <> 'SYNC' AND CAST(pm.DateAdded AS DATE) <> CAST(m.received AS DATE)
AND pt.PhoneTypeMapping = 1

END
GO
