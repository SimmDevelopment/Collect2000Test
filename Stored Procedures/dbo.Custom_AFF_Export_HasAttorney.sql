SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_AFF_Export_HasAttorney]
	-- Add the parameters for the stored procedure here
	@startdate DATETIME,
	@enddate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

SELECT 
	'{' + CHAR(13) + CHAR(10) AS Line2,
		'"outSourcerAccountId": "' + m.id1 + '",' + CHAR(13) + CHAR(10) AS Line3,
		'"eventTime": "'  + CONVERT(VARCHAR(19), da.DateCreated, 126) + 'Z",' + CHAR(13) + CHAR(10) AS Line4,
		'"eventData": {' + CHAR(13) + CHAR(10) AS Line5,
			'"hasAttorney": {' + CHAR(13) + CHAR(10) AS Line6,
				'"attorney": {' + CHAR(13) + CHAR(10) AS Line7,
					'"name": "'	+ da.Name + '",' + CHAR(13) + CHAR(10) AS Line8,
					'"firm": "'	+ da.Firm + '",' + CHAR(13) + CHAR(10) AS Line9,
					'"phoneNumber": {' + CHAR(13) + CHAR(10) AS Line10,
						'"countryCode": "1",'  + CHAR(13) + CHAR(10) AS Line11,
						'"number": "' + da.Phone + '"'  + CHAR(13) + CHAR(10) AS Line12,
					'}'  + CHAR(13) + CHAR(10) AS Line13,
				'},'  + CHAR(13) + CHAR(10) AS Line14,
				'"source": "inHouse",' + CHAR(13) + CHAR(10) AS Line15,
				'"outSourcerAccountHolderId": "' + CONVERT(VARCHAR(100), d.debtormemo) + '"' + CHAR(13) + CHAR(10) AS Line16,
			'}'  + CHAR(13) + CHAR(10) AS Line17,
		'}' + CHAR(13) + CHAR(10) AS Line18,
	'},' + CHAR(13) + CHAR(10) AS Line19
FROM DebtorAttorneys da WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON da.AccountID = m.number 
	INNER JOIN Debtors d WITH (NOLOCK) ON da.DebtorID = d.DebtorID
WHERE da.DateCreated BETWEEN @startdate AND @enddate AND customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 103)
END
GO
