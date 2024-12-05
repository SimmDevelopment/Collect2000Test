SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_KPI_DN2_Updated]
	-- Add the parameters for the stored procedure here
	@startDate as DATETIME,
	@endDate AS DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SET @startDate = dbo.F_START_OF_DAY(@startDate)
 SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))



    -- Insert statements for procedure here
		SELECT m.id1 AS data_id, dbo.date(n.created) AS activity_date, 'Phone' AS [Description],
		CASE WHEN action = 'tr' AND result = 'na' THEN 'Telephoned Residence/No Answer'
		WHEN action = 'te' AND result = 'na' THEN 'Telephoned Business/No Answer'
		WHEN action = 'tc' AND result = 'na' THEN 'No Answer'
		WHEN action = 'tr' AND result = 'am' THEN 'Answer - Left message to call'
		WHEN action = 'tr' AND result = 'lb' THEN 'Phone - Busy'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'wn' THEN 'Answer - Called party said wrong number'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'dh' THEN 'Answer - Right Party Contact- Hung Up'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta', 'dt') AND result = 'pp' THEN 'Answer - Promised to pay in full'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'rp' THEN 'Answer - Refusal to Pay'
		WHEN action IN ('tr', 'te', 'to', 'ta') AND result in ('amnm', 'NA') THEN 'Answering Machine - No Message Left'
		WHEN action IN ('tr', 'te', 'to', 'ta') AND result in ('am') THEN 'Telephoned Residence/Left Message'
		WHEN action IN ('te', 'to', 'tc', 'ta') AND result = 'lb' THEN 'Phone - Busy'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'td' THEN 'Phone - Disconnected'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'cd' THEN 'Answer - Cease Contact'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'hu' THEN 'Phone Attempt (Hung Up)'
		WHEN action = 'tc' AND result in ('amnm', 'am') THEN 'Answering Machine - Hung Up'
		WHEN action in ('TO', 'dt', 'tc', 'tr', 'te') AND result = 'tt' THEN 'Answer - Will call back'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = '99' THEN 'Phone - Invalid Phone Number'
		ELSE 'Phone Attempt (Hung Up)'
		end AS activity_item_desc,
		
CASE WHEN action = 'tr' AND result = 'na' THEN '100066'
		WHEN action = 'te' AND result = 'na' THEN '100068'
		WHEN action = 'tc' AND result = 'na' THEN '100057'
		WHEN action = 'tr' AND result = 'am' THEN '100025'
		WHEN action = 'tr' AND result = 'lb' THEN '100045'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'wn' THEN '100024'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'dh' THEN '100038'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta', 'dt') AND result = 'pp' THEN '100027'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'rp' THEN '100037'
		WHEN action IN ('tr', 'te', 'to', 'ta') AND result in ('amnm', 'NA') THEN '100044'
		WHEN action IN ('tr', 'te', 'to', 'ta') AND result in ('am') THEN '100067'
		WHEN action IN ('te', 'to', 'tc', 'ta') AND result = 'lb' THEN '100045'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'td' THEN '100047'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'cd' THEN '100040'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = 'hu' THEN '100036'
		WHEN action = 'tc' AND result in ('amnm', 'am') THEN '100043'
		WHEN action in ('TO', 'dt', 'tc', 'tr', 'te') AND result = 'tt' THEN '100023'
		WHEN action IN ('tr', 'te', 'to', 'tc', 'ta') AND result = '99' THEN '100048'
		ELSE '100036'
		end AS [activitytype_id]
	
	
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer IN (SELECT customerid FROM fact f WITH (NOLOCK) WHERE CustomGroupID in (186,280))
AND n.created BETWEEN @startDate AND @endDate
AND action IN ('tr', 'te', 'to', 'tc', 'dt') AND result IN ('na', 'am', 'wn', 'lb', 'td', 'amnm', 'dh', 'pp', 'rp', 'cd', 'hu', 'tt')
and id2 not in ('AllGate','ARS-JMET')
END
GO
