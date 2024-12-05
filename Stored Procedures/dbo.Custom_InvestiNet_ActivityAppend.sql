SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- Changes:
-- 9/11/2017 BGM Update to new DN2 system.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_InvestiNet_ActivityAppend]
	-- Add the parameters for the stored procedure here
	
	@startDate datetime,
	@endDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		SELECT m.id1 AS data_id,
		'' AS activity_id, --Not Required
		'' AS activity_source_acctno, --Not Required
CASE 	WHEN dbo.date(m.received) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) THEN '100086'
		--WHEN action = 'co' THEN '100077'
		WHEN action = 'dt' THEN '100023'
		WHEN action IN ('tr', 'ta') AND result IN ('amnm', 'na') THEN '100066'
		WHEN action = 'te' AND result IN ('amnm', 'na') THEN '100068'
		WHEN action IN ('to', 'tc') AND result IN ('amnm', 'na') THEN '100057'
		WHEN action = 'tr' AND result = 'am' THEN '100025'
		WHEN action = 'ta' AND result in ('am') THEN '100035'
		WHEN action = 'te' AND result in ('am') THEN '100010'
		--WHEN action = 'ta' AND result in ('amnm', 'na') THEN '100070'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'wn' THEN '100024'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'dh' THEN '100047'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'pp' THEN '100027'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'rp' THEN '100037'
		WHEN action IN ('tr', 'tc', 'to', 'ta') AND result in ('am') THEN '100067'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'lb' THEN '100045'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'td' THEN '100047'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'cd' THEN '100040'
		--WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'hu' THEN '100036'
		WHEN action IN ('tr', 'te', 'tc', 'to', 'ta') AND result = 'tt' THEN '100023'
		WHEN action = 'sk' AND result = 'sk' THEN '100049'
		
		end AS activitytype_id,
	CASE 	WHEN dbo.date(m.received) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) THEN 'Acknowledged'
		--WHEN action = 'co' THEN 'Memo'
		WHEN action = 'dt' THEN 'Phone'
		WHEN action IN ('tr', 'ta') AND result IN ('amnm', 'na') THEN 'Phone'
		WHEN action = 'te' AND result IN ('amnm', 'na') THEN 'Phone'
		WHEN action IN ('to', 'tc') AND result IN ('amnm', 'na') THEN 'Phone'
		WHEN action IN ('tr', 'tc', 'to') AND result = 'am' THEN 'Phone'
		WHEN action = 'ta' AND result in ('am') THEN 'Phone'
		WHEN action = 'te' AND result in ('am') THEN 'Phone'
		WHEN action = 'ta' AND result in ('amnm', 'na') THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'wn' THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'dh' THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'pp' THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'rp' THEN 'Phone'
		WHEN action IN ('tr', 'ta') AND result in ('am') THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'lb' THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'td' THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'cd' THEN 'Phone'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'hu' THEN 'Phone'
		WHEN action IN ('tr', 'te', 'tc', 'to', 'ta') AND result = 'tt' THEN 'Phone'
		WHEN action = 'sk' AND result = 'sk' THEN 'Skip Trace'
		
		end AS activity_type,
	'' AS activity_item,  -- not required
	'' AS activity_item_desc, --not required
	CASE 	WHEN dbo.date(m.received) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) THEN CONVERT(VARCHAR(10), m.received, 101)
		ELSE CONVERT(VARCHAR(10), n.created, 101) + ' ' + CONVERT(VARCHAR(8), n.created, 108) end AS activity_date,
	'' AS activity_amount, --not required
	'' AS activity_product, --not required
	'' AS activity_status, --not required
	'' AS activity_due, --not required
	'' AS activity_outstanding, --not required
	'' AS activity_source, --not required
	'' AS activity_location, --not required
	'' AS activity_method, --not required
	'' AS activity_code, --not required
	'' AS activity_credit_type, --not required
	'' AS activity_sequence, --not required
	'' AS activity_dial_type, --not required
	'' AS activity_phone, --not required
	'' AS activity_phone_type, --not required
	'' AS activity_time, --not required
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code --not required
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer IN ('0001095')
AND ((dbo.date(m.received) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)) or (dbo.date(n.created) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
AND action IN ('co', 'tr', 'te', 'to', 'tc', 'ta', 'dt', 'sk') AND result IN ('na', 'am', 'wn', 'lb', 'td', 'amnm', 'dh', 'pp', 'rp', 'cd', 'hu', 'tt', 'sk')))


UNION ALL

SELECT m.id1 AS data_id, 
	'' AS activity_id, --Not Required
	'' AS activity_source_acctno, --Not Required
CASE WHEN lr.lettercode like 'BUY%' OR lettercode IN ('11', '11-ny') THEN '100001'
		 --WHEN lr.lettercode LIKE 'VAL%' THEN '100085'
		 WHEN lr.lettercode LIKE '%SIF%' THEN '100021'
		 WHEN lr.lettercode IN ('13', '13CC') THEN '100004'
		end AS activitytype_id,
	CASE WHEN lr.lettercode like 'BUY%' OR lettercode IN ('11', '11-ny') THEN 'Letter'
		 --WHEN lr.lettercode LIKE 'VAL%' THEN 'Letter'
		 WHEN lr.lettercode LIKE '%SIF%' THEN 'Letter'
		 WHEN lr.lettercode IN ('13', '13CC') THEN 'Letter'
		end AS activity_type,
	'' AS activity_item,  -- not required
	'' AS activity_item_desc, --not required
	CONVERT(VARCHAR(10), lr.DateProcessed, 101) + ' ' + CONVERT(VARCHAR(8), lr.DateProcessed, 108) AS activity_date,
	'' AS activity_amount, --not required
	'' AS activity_product, --not required
	'' AS activity_status, --not required
	'' AS activity_due, --not required
	'' AS activity_outstanding, --not required
	'' AS activity_source, --not required
	'' AS activity_location, --not required
	'' AS activity_method, --not required
	'' AS activity_code, --not required
	'' AS activity_credit_type, --not required
	'' AS activity_sequence, --not required
	'' AS activity_dial_type, --not required
	'' AS activity_phone, --not required
	'' AS activity_phone_type, --not required
	'' AS activity_time, --not required
	CONVERT(VARCHAR(9), m.number) AS activity_collector_code --not required
FROM LetterRequest lr WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON lr.AccountID = m.number
WHERE m.customer IN ('0001095')
AND dbo.date(lr.DateProcessed) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
AND (lr.ErrorDescription = '' OR lr.ErrorDescription IS NULL) AND (lr.lettercode like 'BUY%' or lr.lettercode LIKE 'VAL%' OR lr.lettercode LIKE '%SIF%' OR lr.lettercode IN ('11', '11-ny', '13', '13CC'))


END
GO
