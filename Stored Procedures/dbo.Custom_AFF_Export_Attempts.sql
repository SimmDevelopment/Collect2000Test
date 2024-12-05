SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_AFF_Export_Attempts] 
	-- Add the parameters for the stored procedure here
	@startdate DATETIME,
	@enddate DATETIME	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

/*Need to switch over to using the dialer dclatitude to gather attempts instead of the notes since this is testing*/


SELECT 
	'{' + CHAR(13) + CHAR(10) AS Line2,
		'"outSourcerAccountId": "' + m.id1 + '",' + CHAR(13) + CHAR(10) AS Line3,
		'"eventTime": "'  + CONVERT(VARCHAR(19), n.created, 126) + 'Z",' + CHAR(13) + CHAR(10) AS Line4,
		'"eventData": {' + CHAR(13) + CHAR(10) AS Line5,
			'"attempt": {' + CHAR(13) + CHAR(10) AS Line6,
				'"user": "' + n.user0 + '",' + CHAR(13) + CHAR(10) AS Line7,
				'"phoneNumber": {' + CHAR(13) + CHAR(10) AS Line8,
						'"countryCode": "1",'  + CHAR(13) + CHAR(10) AS Line9,
						'"number": "' + pm.phonenumber + '"'  + CHAR(13) + CHAR(10) AS Line10,
					'},'  + CHAR(13) + CHAR(10) AS Line11,
				'"rightPartyContact": ' + CASE WHEN result IN (SELECT code 
FROM result r WITH (NOLOCK) WHERE contacted = 1) THEN 'true,' ELSE 'false,' END + CHAR(13) + CHAR(10) AS Line12,
				'"outSourcerAccountHolderId": "' + CONVERT(VARCHAR(100), d.debtormemo) + '"' + CHAR(13) + CHAR(10) AS Line13,
			'}'  + CHAR(13) + CHAR(10) AS Line14,
		'}' + CHAR(13) + CHAR(10) AS Line15,
	'},' + CHAR(13) + CHAR(10) AS Line16
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
INNER JOIN Phones_Master pm WITH (NOLOCK) ON m.number = pm.Number AND pm.PhoneTypeID = 2
WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 103) AND n.action in ('tr', 'te', 'to', 'tc')
AND created BETWEEN @startdate AND @enddate 


END
GO
