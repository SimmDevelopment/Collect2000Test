SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/10/2022
-- Description: Export record 39 only
-- =============================================
CREATE PROCEDURE [dbo].[Custom_WRC_Record_39]
	-- Add the parameters for the stored procedure here
	@startdate datetime,
	@enddate DATETIME

	-- exec Custom_YGC_WRC_Record_39 '20220315', '20220315'

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
--close codes
SELECT '39' AS record_code, 
	m.id1 AS fileno, 
	m.account AS forw_file, 
	m.number AS masco_file, 
	'SIMM' AS firm_id, 
	'WCF3' AS forw_id,
	CAST(m.received AS DATE) AS pdate,
	'*CC:S101' AS pcode,
	'Acknowledgment' AS pcmt,
	'000001' AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	'1' AS debtor_type
FROM master m WITH (NOLOCK) 
WHERE m.customer = '0002770' and CAST(m.received AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)

UNION ALL 

--Active Collections
SELECT '39' AS record_code, 
	m.id1 AS fileno, 
	m.account AS forw_file, 
	m.number AS masco_file, 
	'SIMM' AS firm_id, 
	'WCF3' AS forw_id,
	CAST(m.received AS DATE) AS pdate,
	'*CC:A020' AS pcode,
	'Collection' AS pcmt,
	'000001' AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	'1' AS debtor_type
FROM master m WITH (NOLOCK) 
WHERE m.customer = '0002770' AND (SELECT TOP 1 sh.OldStatus FROM StatusHistory sh WITH (NOLOCK) WHERE sh.AccountID = m.number AND CAST(sh.DateChanged AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) AND sh.OldStatus = 'NEW' ORDER BY sh.DateChanged DESC) = 'NEW'

UNION ALL 

--Closed Accounts
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	CAST(datechanged AS DATE) as pdate,
	case when newstatus in ('CCR', 'RCL') then '*CC:C102'
		when newstatus = 'PIF' then '*CC:C109'
		when newstatus = 'SIF' then '*CC:C118' 
		when newstatus in ('CAD', 'CND') then '*CC:C135'
		when newstatus in ('B07', 'B11', 'B13', 'BKY') then '*CC:C101'
		when newstatus = 'DEC' then '*CC:C163'
		when newstatus = 'RSK' then '*CC:C196'
		when newstatus = 'MIL' then '*CC:C140'
		when newstatus = 'AEX' then '*CC:C105'		
	end as pcode,
	case when newstatus in ('CCR', 'RCL') then 'Close - Client Request'
		when newstatus = 'PIF' then 'Close - Paid in Full'
		when newstatus = 'SIF' then 'Close - Settle in Full' 
		when newstatus in ('CAD', 'CND') then 'Close - Cease and Desist'
		when newstatus in ('B07', 'B11', 'B13', 'BKY') then 'Close - Bankrupt'
		when newstatus = 'DEC' then 'Close - Deceased - Confirmed'
		when newstatus = 'RSK' then 'Litigation Risk by Consumer'
		when newstatus = 'MIL' then 'Close - Soldiers & Sailors'
		when newstatus = 'AEX' then 'Close - Efforts exhausted'		
	end AS pcmt,
	'000001' AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	'1' AS debtor_type
from master m with (nolock) inner join statushistory sh with (nolock) on m.number = sh.accountid
where m.customer = '0002770' and 
	newstatus in ('SIF', 'PIF', 'CCR', 'RCL', 'B07', 'B11', 'B13', 'BKY', 'DEC', 'RSK', 'MIL', 'AEX', 'CAD', 'CND') 	and datechanged between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
	
UNION ALL

--Letters Sent Primary
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	CAST(dateprocessed AS DATE) as pdate,
	case when lettercode = '1BNK' then '*CC:W100'
		WHEN l.LetterCode LIKE 'EML%' THEN '*CC:W190'
	end as pcode,
	case when lettercode = '1BNK' then '1st Demand Letter Sent'
		WHEN l.LetterCode LIKE 'EML%' THEN 'Send an Email'
	end as pcmt,
	'000001' AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	CASE WHEN l.RecipientDebtorSeq = 0 THEN '1' ELSE '2' END AS debtor_type
from master m with (nolock) inner join letterrequest l with (nolock) on m.number = l.accountid
where m.customer = '0002770' AND (l.LetterCode = '1BNK' OR l.LetterCode LIKE 'EML%') and dateprocessed between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)

UNION ALL

--Bad Address Notification
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	(SELECT TOP 1 CAST(n.created AS DATE) FROM notes n WITH (NOLOCK) WHERE m.number = n.number AND CAST(n.created AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
	AND n.action = '+++++' AND n.result = '+++++' AND CONVERT(VARCHAR(50), n.comment) LIKE 'Mail Return%' ORDER BY n.created) as pdate,
	'*CC:I103' as pcode,
	'Debtor Address no Good' as pcmt,
	'000001' AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction,
	CASE WHEN (SELECT TOP 1 CONVERT(VARCHAR(50), n.comment)  FROM notes n WITH (NOLOCK) WHERE m.number = n.number AND CAST(n.created AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
	AND n.action = '+++++' AND n.result = '+++++' AND CONVERT(VARCHAR(50), n.comment) LIKE 'Mail Return%' ORDER BY n.created) = 'Mail Return Set on Debtor(1)'
THEN '1' ELSE '2' END AS debtor_type
FROM master m WITH (NOLOCK) 
WHERE m.customer = '0002770' AND m.mr = 'y' 
AND (SELECT TOP 1 CONVERT(VARCHAR(50), n.comment)  FROM notes n WITH (NOLOCK) WHERE m.number = n.number AND CAST(n.created AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
AND n.action = '+++++' AND n.result = '+++++' AND CONVERT(VARCHAR(50), n.comment) LIKE 'Mail Return%' ORDER BY n.created) like 'Mail Return Set on Debtor%'

UNION ALL

--Attorney representation
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	CAST(da.DateCreated AS DATE) as pdate,
	'*CC:L102' as pcode,
	'Attorney represented' as pcmt,
	FORMAT(da.DateCreated, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	CASE WHEN D.Seq = 0 THEN '1' ELSE '2' END AS debtor_type
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number INNER JOIN DebtorAttorneys da WITH (NOLOCK) ON d.DebtorID = da.DebtorID
WHERE m.customer = '0002770' AND CAST(da.DateCreated AS DATE) BETWEEN CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 

UNION ALL

--Non Closing Status Updates
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	CAST(@enddate AS DATE) as pdate,
		case when newstatus = 'DSP' then '*CC:S106'
		when newstatus = 'VDC' then '*CC:S109'
		when newstatus = 'VDS' then '*CC:S115' 
		when newstatus = 'FRD' then '*CC:S116'
		when newstatus = 'SKP' then '*CC:S124'
	end as pcode,
	case when newstatus = 'DSP' then 'Debtor Disputes Debt'
		when newstatus = 'VDC' then 'Debtor is Deceased'
		when newstatus = 'VDS' then 'Disputed' 
		when newstatus = 'FRD' then 'Dtr Claims Fraud on Acct'
		when newstatus = 'SKP' then 'Skip Trace'
	end AS pcmt,
	'000001' AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	'1' AS debtor_type
FROM master m WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE m.customer = '0002770' AND CAST(sh.DateChanged AS DATE) BETWEEN CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
AND m.status IN ('DSP', 'VDC', 'VDS', 'FRD', 'SKP') AND sh.NewStatus IN ('DSP', 'VDC', 'VDS', 'FRD', 'SKP')

UNION ALL

/*
--Outbound Calls Mobile Comply Made
SELECT  '39' as record_code, 
	m.id1 AS fileno, 
	m.account AS forw_file, 
	m.number AS masco_file, 
	'SIMM' AS firm_id, 
	'WCF3' AS forw_id,
	CAST(PDA.CALL_DATE_TIME AS DATE) AS pdate,
	CASE 
		WHEN pt.PhoneTypeMapping = 1 THEN '*CC:W154'
		WHEN pt.PhoneTypeMapping = 0 THEN '*CC:W141'
		WHEN pt.PhoneTypeMapping = 2 THEN '*CC:W358'
	END AS pcode,
	CASE 
		WHEN pt.PhoneTypeMapping = 1 THEN 'Telephone Business'
		WHEN pt.PhoneTypeMapping = 0 THEN 'Telephone Residence'
		WHEN pt.PhoneTypeMapping = 2 THEN 'Telephoned Cell #'
	END AS pcmt,
	FORMAT(PDA.CALL_DATE_TIME, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	PDA.PHONE_NUMBER AS phone_number,
	'O' AS call_direction, 
	'1' AS debtor_type
	FROM DCLatitude..PD_Activity_Log PDA WITH(NOLOCK) JOIN 	DCLatitude..Campaign C WITH(NOLOCK) ON PDA.CAMPAIGN_ID = C.CAMPAIGN_ID
	JOIN master m WITH (NOLOCK) ON RTRIM(pda.RECORD_KEY) = CAST(m.number AS VARCHAR(10)) 
		AND m.customer = '0002770'
	OUTER APPLY (
		SELECT  TOP 1 *
		FROM    Phones_Master as PM 
		WHERE   RTRIM(pda.RECORD_KEY) = CAST(pm.number AS VARCHAR(10))
		AND PDA.PHONE_NUMBER = PM.PhoneNumber
		) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	--PDA.CLIENT_ID = 20 AND
	 CAST(PDA.CALL_DATE_TIME AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
	AND PDA.CallType <> 3
	AND PDA.RESULT_CODE <> 'T'	

UNION ALL

--Manual Outbound Calls Made
SELECT  '39' as record_code, 
	m.id1 AS fileno, 
	m.account AS forw_file, 
	m.number AS masco_file, 
	'SIMM' AS firm_id, 
	'WCF3' AS forw_id,
	CAST(PCH.RESULT_DATE AS DATE) AS pdate,
	CASE 
		WHEN pt.PhoneTypeMapping = 1 THEN '*CC:W154'
		WHEN pt.PhoneTypeMapping = 0 THEN '*CC:W141'
		WHEN pt.PhoneTypeMapping = 2 THEN '*CC:W358'
	END AS pcode,
	CASE 
		WHEN pt.PhoneTypeMapping = 1 THEN 'Telephone Business'
		WHEN pt.PhoneTypeMapping = 0 THEN 'Telephone Residence'
		WHEN pt.PhoneTypeMapping = 2 THEN 'Telephoned Cell #'
	END AS pcmt,
	FORMAT(PCH.RESULT_DATE, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	PCH.PHONE_NUMBER AS phone_number,
	'O' AS call_direction, 
	'1' AS debtor_type
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	JOIN master m WITH (NOLOCK) ON RTRIM(pch.RECORD_KEY) = CAST(m.number AS VARCHAR(10))
		AND m.customer = '0002770'
	OUTER APPLY (
				SELECT  TOP 1 *
				FROM    Phones_Master as PM 
				WHERE   RTRIM(pch.RECORD_KEY) = CAST(pm.number AS VARCHAR(10))
				AND pch.PHONE_NUMBER = PM.PhoneNumber
				) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	CAST(PCH.RESULT_DATE AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
	--AND PCH.CLIENT_ID = 20
	AND PV.TelephonyCallType IN (1) 
	AND pch.RESULT_CODE <> 'TFO'

UNION ALL

--Outbound Calls RPC
SELECT  '39' as record_code, 
	m.id1 AS fileno, 
	m.account AS forw_file, 
	m.number AS masco_file, 
	'SIMM' AS firm_id, 
	'WCF3' AS forw_id,
	CAST(PCH.RESULT_DATE AS DATE) AS pdate,
	CASE 
		WHEN D.Contact = 1 THEN '*CC:W010'
	END AS pcode,
	CASE 
		WHEN D.Contact = 1 THEN 'Right Party Contact'
	END AS pcmt,
	FORMAT(PCH.RESULT_DATE, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	PCH.PHONE_NUMBER AS phone_number,
	'O' AS call_direction, 
	'1' AS debtor_type
FROM DCLatitude..Prospect_Voice PV WITH(NOLOCK) 
	JOIN DCLatitude..Disposition D WITH(NOLOCK) ON Pv.RESULTID = D.Result_ID 
	JOIN DCLatitude..Prospect_CallHist PCH WITH(NOLOCK) ON PV.UniqueCallId = PCH.UniqueCallId
	JOIN master m WITH (NOLOCK) ON RTRIM(pch.RECORD_KEY) = CAST(m.number AS VARCHAR(10))
		AND m.customer = '0002770'
	OUTER APPLY (
				SELECT  TOP 1 *
				FROM    Phones_Master as PM 
				WHERE   RTRIM(pch.RECORD_KEY) = CAST(pm.number AS VARCHAR(10))
				AND pch.PHONE_NUMBER = PM.PhoneNumber
				) AS pm
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	CAST(PCH.RESULT_DATE AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
	--AND PCH.CLIENT_ID = 20
	AND PV.TelephonyCallType IN (1) 
	AND pch.RESULT_CODE <> 'TFO'
	
UNION ALL
*/
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	CAST(e.ModifiedWhen AS DATE) as pdate,
	CASE WHEN e.Email <> '' THEN '*CC:I147'
	WHEN e.Email = '' THEN '*CC:I135' 
	END as pcode,
	CASE WHEN e.Email <> '' THEN 'Debtor Gave Email Address/Authorized Use'
	WHEN e.Email = '' THEN 'Remove Email address' 
	END as pcmt,
	FORMAT(e.ModifiedWhen, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	CASE WHEN D.Seq = 0 THEN '1' ELSE '2' END AS debtor_type
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.number INNER JOIN Email e WITH (NOLOCK) ON d.DebtorID = e.DebtorId
WHERE m.customer = '00002770' AND e.CreatedWhen <> e.ModifiedWhen AND CAST(e.ModifiedWhen AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 

UNION ALL

--Text messages and results needs phones and debtors
select  '39' as record_code, 
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,
	CAST(n.created AS DATE) as pdate,
	CASE WHEN n.result = 'TSTOP' THEN '*CC:W951'
	WHEN n.action = 'TXT1' AND n.result = 'T-OK' THEN '*CC:W952' 
	WHEN n.action = 'TXT2' AND n.result = 'T-OK' THEN '*CC:W953' 
	END as pcode,
	CASE WHEN n.result = 'TSTOP' THEN 'Text Consent Revoked'
	WHEN n.action = 'TXT1' AND n.result = 'T-OK' THEN 'Text Sent to Customer' 
	WHEN n.action = 'TXT2' AND n.result = 'T-OK' THEN 'Text Clicked by Customer' 
	END as pcmt,
	FORMAT(n.created, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	'' AS phone_number,
	'' AS call_direction, 
	CASE WHEN D.Seq = 0 THEN '1' ELSE '2' END AS debtor_type
	FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number INNER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number
WHERE m.customer = '0002770' AND USER0 = 'iconnect24' AND n.action in ('TXT1', 'TXT2') AND n.result IN ('T-OK', 'T-STOP')
AND CAST(n.created AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
--end Record 39

UNION ALL

--Test calls from notes
--Outbound Calls Mobile Comply Made
SELECT  '39' as record_code, 
	m.id1 AS fileno, 
	m.account AS forw_file, 
	m.number AS masco_file, 
	'SIMM' AS firm_id, 
	'WCF3' AS forw_id,
	CAST(n.created AS DATE) AS pdate,
	CASE 
		WHEN pt.PhoneTypeMapping = 1 THEN '*CC:W154'
		WHEN pt.PhoneTypeMapping = 0 THEN '*CC:W141'
		WHEN pt.PhoneTypeMapping = 2 THEN '*CC:W358'
	END AS pcode,
	CASE 
		WHEN pt.PhoneTypeMapping = 1 THEN 'Telephone Business'
		WHEN pt.PhoneTypeMapping = 0 THEN 'Telephone Residence'
		WHEN pt.PhoneTypeMapping = 2 THEN 'Telephoned Cell #'
	END AS pcmt,
	FORMAT(n.created, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	pm.PhoneNumber AS phone_number,
	'O' AS call_direction, 
	'1' AS debtor_type
	FROM notes n WITH (NOLOCK) 
	JOIN master m WITH (NOLOCK) ON n.number = CAST(m.number AS VARCHAR(10)) 
		AND m.customer = '0002770'
	INNER join   Phones_Master as PM WITH (NOLOCK) ON m.number = pm.Number AND SUBSTRING(CONVERT(VARCHAR(500), n.comment), 2, 10) = dbo.StripNonDigits(PM.PhoneNumber)
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	--PDA.CLIENT_ID = 20 AND
	 CAST(n.created AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
	AND n.action IN ('TR', 'TE', 'TC')

UNION ALL

--Outbound Calls RPC
SELECT  '39' as record_code, 
	m.id1 AS fileno, 
	m.account AS forw_file, 
	m.number AS masco_file, 
	'SIMM' AS firm_id, 
	'WCF3' AS forw_id,
	CAST(n.created AS DATE) AS pdate,
	CASE 
		WHEN n.result = 'TT' THEN '*CC:W010'
	END AS pcode,
	CASE 
		WHEN n.result = 'TT' THEN 'Right Party Contact'
	END AS pcmt,
	FORMAT(n.created, 'HHmmss') AS ptime,
	'GMT - 5' AS ptime_zone,
	PM.PhoneNumber AS phone_number,
	'O' AS call_direction, 
	'1' AS debtor_type
	FROM notes n WITH (NOLOCK) 
	JOIN master m WITH (NOLOCK) ON n.number = CAST(m.number AS VARCHAR(10)) 
		AND m.customer = '0002770'
	INNER join   Phones_Master as PM WITH (NOLOCK) ON m.number = pm.Number AND SUBSTRING(CONVERT(VARCHAR(500), n.comment), 2, 10) = dbo.StripNonDigits(PM.PhoneNumber)
	LEFT JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE
	--PDA.CLIENT_ID = 20 AND
	 CAST(n.created AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE) 
	AND n.action IN ('TR', 'TE', 'TC')
	AND result IN ('TT')

END


GO
