SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 4/8/2020
-- Description:	Export Account Activity Changes
-- Changes:
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CitizensBank_DN_ActivityAppend]
	-- Add the parameters for the stored procedure here
	
	@startDate datetime,
	@endDate datetime
AS
BEGIN


SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

--exec Custom_CitizensBank_DN_ActivityAppend '20200501', '20200501'
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT DISTINCT m.id1 AS data_id,
		m.account AS pri_acctno,
		'100000' AS activitytype_id,
	'Acknowledged' AS activity_type,
	'' AS activity_item,
	'' AS activity_item_desc,
	CONVERT(VARCHAR(10), m.received, 101) AS activity_date,
	'' AS activity_amount,
	'' AS activity_phone,
	'' AS activity_phone_type,
	'' AS activity_source,
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code,
	'' AS activity_time,
	'' AS activity_time_zone,
	'' AS activity_dial_type,
	'' AS activity_due
FROM master m WITH (NOLOCK)
WHERE m.customer IN ('0001110', '0001111', '0001112')
AND dbo.date(m.received) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

UNION ALL
    
		SELECT DISTINCT m.id1 AS data_id,
		m.account AS pri_acctno,
CASE 	WHEN USER0 = 'SCRA' AND result = 'SEND' THEN '100002'
		WHEN user0 = 'SCRA' AND result = 'ACT' THEN '100082'
		WHEN action = 'dt' THEN '100008'
		--WHEN action = 'PROM' AND result = 'DEL' THEN '100103'
		WHEN action IN ('tr', 'ta') AND result IN ('amnm', 'na') THEN '100044'
		WHEN action = 'te' AND result IN ('amnm', 'na') THEN '100058'
		WHEN action IN ('to', 'tc') AND result IN ('amnm', 'na') THEN '100057'
		--WHEN action = 'prom' AND result = 'del'
		--WHEN action = 'tr' AND result = 'LM' THEN '100025'
		--WHEN action = 'ta' AND result in ('LM') THEN '100035'
		--WHEN action = 'te' AND result in ('LM') THEN '100010'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'wn' THEN '100048'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'dh' THEN '100047'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'pp' THEN '100100'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'rp' THEN '100037'
		WHEN action IN ('tr', 'tc', 'to', 'ta') AND result in ('LM') THEN '100018'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'lb' THEN '100045'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'td' THEN '100047'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'cd' THEN '100040'
		WHEN action IN ('tr', 'te', 'tc', 'to', 'ta') AND result = 'tt' THEN '100022'
		WHEN action = 'sk' AND result = 'sk' THEN '100049'
		WHEN ACTION = 'co' AND result = 'co' THEN '100077'
		end AS activitytype_id,
	CASE WHEN USER0 = 'SCRA' AND result = 'SEND' THEN 'SCRA Scrub Performed'
		WHEN user0 = 'SCRA' AND result = 'ACT' THEN 'Active Duty Confirmed'
		WHEN action = 'dt' THEN 'Consumer Called In'
		WHEN action IN ('tr', 'ta') AND result IN ('amnm', 'na') THEN 'Answering Machine - No Message Left'
		WHEN action = 'te' AND result IN ('amnm', 'na') THEN 'No Answer (Work)'
		WHEN action IN ('to', 'tc') AND result IN ('amnm', 'na') THEN 'No Answer'
		--WHEN action IN ('tr', 'tc', 'to') AND result = 'am' THEN 'Phone'
		--WHEN action = 'ta' AND result in ('am') THEN 'Phone'
		--WHEN action = 'te' AND result in ('am') THEN 'Phone'
		WHEN action = 'ta' AND result in ('amnm', 'na') THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'wn' THEN 'Phone - Invalid Phone Number'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'dh' THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'pp' THEN 'Promise Agreement Entered'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'rp' THEN 'Phone'
		WHEN action IN ('tr', 'tc', 'to', 'ta') AND result in ('LM') THEN 'Left Message'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'lb' THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'td' THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'cd' THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'hu' THEN 'Phone'
		WHEN action IN ('tr', 'te', 'tc', 'to', 'ta') AND result = 'tt' THEN 'Answer - Identified right party'
		WHEN action = 'sk' AND result = 'sk' THEN 'Skip Trace'
		WHEN ACTION = 'co' AND result = 'co' THEN 'Note - Account Memo'
		end AS activity_type,
	'' AS activity_item,
	'' AS activity_item_desc,
	CONVERT(VARCHAR(10), n.created, 101) + ' ' + CONVERT(VARCHAR(8), n.created, 108) AS activity_date,
	'' AS activity_amount,
	
	CASE WHEN action IN ('tr', 'te', 'tc', 'to', 'ta') --AND result IN ('tt', 'lm', 'wn') 
	THEN ISNULL((SELECT pm.phonenumber FROM Phones_master pm WITH (NOLOCK)
	WHERE pm.number = m.number AND pm.PhoneNumber = SUBSTRING(CONVERT(VARCHAR(1000), comment), 2, 10)), '') ELSE '' END AS activity_phone,
	CASE WHEN action IN ('tr', 'te', 'tc', 'to', 'ta') --AND result IN ('tt', 'lm', 'wn') 
	THEN ISNULL((SELECT CASE phonetypeid WHEN 1 THEN 'Home' WHEN 2 THEN 'Work' WHEN 3 THEN 'Cell' ELSE 'Unknown' END FROM Phones_master pm WITH (NOLOCK) 
	WHERE pm.number = m.number AND pm.PhoneNumber = SUBSTRING(CONVERT(VARCHAR(1000), comment), 2, 10)), '') ELSE '' END AS activity_phone_type,
	
	'' AS activity_source,
	
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code,
	CASE WHEN action IN ('tr', 'te', 'tc', 'to', 'ta') --AND result IN ('tt', 'lm', 'wn') 
	THEN CONVERT(VARCHAR(8), n.created, 108) ELSE '' END  AS activity_time,
	'' AS activity_time_zone,
	CASE WHEN action IN ('tr', 'te', 'tc', 'to', 'ta') --AND result IN ('tt', 'lm', 'wn') 
	THEN 'Manual' ELSE '' END AS activity_dial_type,
	CASE WHEN user0 = 'SCRA' AND result = 'ACT' THEN (SELECT CONVERT(VARCHAR(10), ActiveDutyEndDate, 101) FROM custom_scra_history WITH (NOLOCK) WHERE m.number = number) ELSE '' END AS activity_due	
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer IN ('0001110', '0001111', '0001112')
AND dbo.date(n.created) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
AND action IN ('co', 'tr', 'te', 'to', 'tc', 'ta', 'dt', 'sk', 'RQST', 'RTN') 
AND result IN ('na', 'am', 'wn', 'lb', 'td', 'amnm', 'dh', 'pp', 'rp', 'cd', 'hu', 'tt', 'sk', 'SEND', 'ACT', 'CO', 'lm')

UNION ALL

--Deleted promises
    SELECT DISTINCT m.id1 AS data_id,
		m.account AS pri_acctno,
	CASE WHEN (SELECT TOP 1 CONVERT(VARCHAR(200), comment) FROM notes WITH (NOLOCK) WHERE number = n.number	AND action = 'prom' AND result = 'add' ORDER BY created ASC) LIKE '%SIF%' THEN '100104'
		ELSE '100103' END AS activitytype_id,
	CASE WHEN (SELECT TOP 1 CONVERT(VARCHAR(200), comment) FROM notes WITH (NOLOCK) WHERE number = n.number	AND action = 'prom' AND result = 'add' ORDER BY created ASC) LIKE '%SIF%' THEN 'SIF Promise Cancelled'
		ELSE 'Promise Cancelled' END AS activity_type,
	'' AS activity_item,
	'' AS activity_item_desc,
	CONVERT(VARCHAR(10), n.created, 101) + ' ' + CONVERT(VARCHAR(8), n.created, 108) AS activity_date,	'' AS activity_amount,
	'' AS activity_phone,
	'' AS activity_phone_type,
	'' AS activity_source,
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code,
	'' AS activity_time,
	'' AS activity_time_zone,
	'' AS activity_dial_type,
	'' AS activity_due
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer IN ('0001110', '0001111', '0001112')
AND action = 'prom' AND result = 'del'
AND dbo.date(n.created) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

UNION ALL

--PDCs
SELECT DISTINCT m.id1 AS data_id,
		m.account AS pri_acctno,
	 CASE WHEN m.status IN ('pdc') AND p.PromiseMode NOT IN (6,7) THEN  '100100' 
		WHEN m.status IN ('pdc') AND p.PromiseMode IN (6,7) AND m.desk <> '100' THEN  '100101' 
		WHEN m.status IN ('pdc') AND p.PromiseMode IN (6,7) AND m.desk = '100'  THEN  '100102' 
	 END AS activitytype_id,	
	 CASE WHEN m.status IN ('pdc') AND p.PromiseMode NOT IN (6,7) THEN 'Promise Agreement Entered' 
		WHEN m.status IN ('pdc') AND p.PromiseMode IN (6,7) AND m.desk <> '100' THEN  'SIF Agreement Entered' 
	 	WHEN m.status IN ('pdc') AND p.PromiseMode IN (6,7) AND m.desk = '100' THEN  'Below Blanket SIF Agreement Entered' 
	 END AS activity_type,
	'' AS activity_item,
	'' AS activity_item_desc,
	CONVERT(VARCHAR(10), p.DateCreated, 101) + ' ' + CONVERT(VARCHAR(8), p.DateCreated, 108) AS activity_date,
	'' AS activity_amount,
	'' AS activity_phone,
	'' AS activity_phone_type,
	'' AS activity_source,
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code,
	'' AS activity_time,
	'' AS activity_time_zone,
	'' AS activity_dial_type,
	'' AS activity_due	
FROM master m WITH (NOLOCK) INNER JOIN pdc p WITH (NOLOCK) ON m.number = p.number
WHERE m.customer IN ('0001110', '0001111', '0001112')
AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)

UNION ALL

--PCCs
SELECT DISTINCT m.id1 AS data_id,
		m.account AS pri_acctno,
	 CASE WHEN m.status IN ('pcc') AND dcc.PromiseMode NOT IN (6,7) THEN  '100100' 
		WHEN m.status IN ('pcc') AND dcc.PromiseMode IN (6,7) AND m.desk <> '100' THEN  '100101' 
		WHEN m.status IN ('pcc') AND dcc.PromiseMode IN (6,7) AND m.desk = '100'  THEN  '100102' 
	 END AS activitytype_id,	
	 CASE WHEN m.status IN ('pcc') AND dcc.PromiseMode NOT IN (6,7) THEN 'Promise Agreement Entered' 
		WHEN m.status IN ('pcc') AND dcc.PromiseMode IN (6,7) AND m.desk <> '100' THEN  'SIF Agreement Entered' 
	 	WHEN m.status IN ('pcc') AND dcc.PromiseMode IN (6,7) AND m.desk = '100' THEN  'Below Blanket SIF Agreement Entered' 
	 END AS activity_type,
	'' AS activity_item,
	'' AS activity_item_desc,
	CONVERT(VARCHAR(10), dcc.DateCreated, 101) + ' ' + CONVERT(VARCHAR(8), dcc.DateCreated, 108) AS activity_date,
	'' AS activity_amount,
	'' AS activity_phone,
	'' AS activity_phone_type,
	'' AS activity_source,
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code,
	'' AS activity_time,
	'' AS activity_time_zone,
	'' AS activity_dial_type,
	'' AS activity_due	
FROM master m WITH (NOLOCK) INNER JOIN DebtorCreditCards dcc WITH (NOLOCK) ON m.number = dcc.Number
WHERE m.customer IN ('0001110', '0001111', '0001112')
AND (dcc.DateCreated BETWEEN @startDate AND @endDate OR dcc.DateUpdated BETWEEN @startDate AND @endDate)

UNION ALL

--Promises
SELECT DISTINCT m.id1 AS data_id,
		m.account AS pri_acctno,
	 CASE WHEN m.status IN ('ppa') AND p.PromiseMode NOT IN (6,7) THEN  '100100' 
		WHEN m.status IN ('ppa') AND p.PromiseMode IN (6,7) AND m.desk <> '100' THEN  '100101' 
		WHEN m.status IN ('ppa') AND p.PromiseMode IN (6,7) AND m.desk = '100'  THEN  '100102'
	 END AS activitytype_id,	
	 CASE WHEN m.status IN ('ppa') AND p.PromiseMode NOT IN (6,7) THEN 'Promise Agreement Entered' 
		WHEN m.status IN ('ppa') AND p.PromiseMode IN (6,7) AND m.desk <> '100' THEN  'SIF Agreement Entered' 
	 	WHEN m.status IN ('ppa') AND p.PromiseMode IN (6,7) AND m.desk = '100' THEN  'Below Blanket SIF Agreement Entered' 
	 END AS activity_type,
	'' AS activity_item,
	'' AS activity_item_desc,
	CONVERT(VARCHAR(10), p.DateCreated, 101) + ' ' + CONVERT(VARCHAR(8), p.DateCreated, 108) AS activity_date,
	'' AS activity_amount,
	'' AS activity_phone,
	'' AS activity_phone_type,
	'' AS activity_source,
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code,
	'' AS activity_time,
	'' AS activity_time_zone,
	'' AS activity_dial_type,
	'' AS activity_due	
FROM master m WITH (NOLOCK) INNER JOIN Promises p WITH (NOLOCK) ON m.number = p.AcctID
WHERE m.customer IN ('0001110', '0001111', '0001112')
AND (p.DateCreated BETWEEN @startDate AND @endDate OR p.DateUpdated BETWEEN @startDate AND @endDate)


UNION ALL

SELECT DISTINCT m.id1 AS data_id,
		m.account AS pri_acctno,
CASE WHEN lr.lettercode like '%10%' OR lettercode IN ('11', '11-ny') THEN '100001'
		 WHEN lr.lettercode LIKE '%SIF%' THEN '100021'
		 WHEN lr.lettercode LIKE '%VAL%' THEN '100085'
		 WHEN lr.lettercode IN ('13', '13CC') THEN '100004'
		end AS activitytype_id,
	CASE WHEN lr.lettercode like '%10%' OR lettercode IN ('11', '11-ny') THEN 'Validation Notice Demand Mailed'
		 WHEN lr.lettercode LIKE '%SIF%' THEN 'Letter'
		 WHEN lr.lettercode LIKE '%VAL%' THEN 'Validation of Debt Mailed'
		 WHEN lr.lettercode IN ('13', '13CC') THEN 'Letter'
		end AS activity_type,
	'' AS activity_item,
	'' AS activity_item_desc,
	CONVERT(VARCHAR(10), lr.DateProcessed, 101) + ' ' + CONVERT(VARCHAR(8), lr.DateProcessed, 108) AS activity_date,
	'' AS activity_amount,
	'' AS activity_phone,
	'' AS activity_phone_type,
	'' AS activity_source,
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code,
	'' AS activity_time,
	'' AS activity_time_zone,
	'' AS activity_dial_type,
	'' AS activity_due	
FROM LetterRequest lr WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON lr.AccountID = m.number
WHERE m.customer IN ('0001110', '0001111', '0001112')
AND dbo.date(lr.DateProcessed) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
AND (lr.ErrorDescription = '' OR lr.ErrorDescription IS NULL) AND (lr.lettercode like '%10%' or lr.lettercode LIKE 'VAL%' OR lr.lettercode LIKE '%SIF%' OR lr.lettercode IN ('11', '11-ny', '13', '13CC'))

UNION ALL

SELECT DISTINCT m.id1 AS data_id,
		m.account AS pri_acctno,
CASE WHEN m.status IN ('cad', 'cnd') THEN '100017'
	WHEN m.STATUS = 'VCD' THEN '100014'
		 
		end AS activitytype_id,
	CASE WHEN m.status IN ('cad', 'cnd') THEN 'Written Cease and Desist Received'
		WHEN m.STATUS = 'VCD' THEN 'Verbal Cease and Desist Received'
		 end AS activity_type,
	'' AS activity_item,
	'' AS activity_item_desc,
	CONVERT(VARCHAR(10), sh.DateChanged, 101) + ' ' + CONVERT(VARCHAR(8), sh.DateChanged, 108) AS activity_date,
	'' AS activity_amount,
	'' AS activity_phone,
	'' AS activity_phone_type,
	'' AS activity_source,
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code,
	'' AS activity_time,
	'' AS activity_time_zone,
	'' AS activity_dial_type,
	'' AS activity_due	
FROM master m WITH (NOLOCK) INNER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
WHERE m.customer IN ('0001110', '0001111', '0001112')
AND dbo.date(sh.DateChanged) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
AND m.status IN ('cad', 'cnd', 'vcd')


END
GO
