SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_AFF_Export_NSF]
	-- Add the parameters for the stored procedure here
	@invoice varchar(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
		SET NOCOUNT ON;

SELECT 
	'{' + CHAR(13) + CHAR(10) AS Line2,
	'"outSourcerAccountId": "' + m.id1 + '",' + CHAR(13) + CHAR(10) AS Line3,
	'"eventTime": "'  + CONVERT(VARCHAR(19), p.datetimeentered, 126) + 'Z",' + CHAR(13) + CHAR(10) AS Line4,
	'"comment": "NSF",' + CHAR(13) + CHAR(10) AS Line5,
	'"eventData": {'+ CHAR(13) + CHAR(10) AS Line6,
		'"nsf": {'+ CHAR(13) + CHAR(10) AS Line7,
			'"transaction": "'	+ CONVERT(VARCHAR,p.UID)+ '",' + CHAR(13) + CHAR(10) AS Line8,
			'"transactionDate": "'	+ CONVERT(VARCHAR(19), p.datetimeentered, 126) + 'Z",'  + CHAR(13) + CHAR(10) AS Line9,
			'"originalTransaction": "'	+ CONVERT(VARCHAR,p.ReverseOfUID)+ '",'  + CHAR(13) + CHAR(10) AS Line10,
			'"amount": {' + CHAR(13) + CHAR(10) AS Line11,
				'"principal": '	+ CASE WHEN p.paid1 > 0 AND p.paid1 < .1 THEN REPLACE(CONVERT(VARCHAR,p.paid1),'0.0','') WHEN p.paid1 >= .1 AND p.paid1 < 1 THEN REPLACE(CONVERT(VARCHAR,p.paid1),'0.','') WHEN p.paid1 >= 1 THEN REPLACE(CONVERT(VARCHAR,p.paid1),'.','') ELSE '0' END  + ',' + CHAR(13) + CHAR(10) AS Line12,
				'"interest": '	+ CASE WHEN p.paid2 > 0 AND p.paid2 < .1 THEN REPLACE(CONVERT(VARCHAR,p.paid2),'0.0','') WHEN p.paid2 >= .1 AND p.paid2 < 1 THEN REPLACE(CONVERT(VARCHAR,p.paid2),'0.','') WHEN p.paid2 >= 1 THEN REPLACE(CONVERT(VARCHAR,p.paid2),'.','') ELSE '0' END +',' + CHAR(13) + CHAR(10) AS Line13,
				'"fees": '	+ CASE WHEN p.paid3 > 0 AND p.paid3 < .1 THEN REPLACE(CONVERT(VARCHAR,p.paid3),'0.0','') WHEN p.paid3 >= .1 AND p.paid3 < 1 THEN REPLACE(CONVERT(VARCHAR,p.paid3),'0.','') WHEN p.paid3 >= 1 THEN REPLACE(CONVERT(VARCHAR,p.paid3),'.','') ELSE '0' END + ',' + CHAR(13) + CHAR(10) AS Line14,
				'"costs": '	+ CASE WHEN p.paid4 > 0 AND p.paid4 < .1 THEN REPLACE(CONVERT(VARCHAR,p.paid4),'0.0','') WHEN p.paid4 >= .1 AND p.paid4 < 1 THEN REPLACE(CONVERT(VARCHAR,p.paid4),'0.','') WHEN p.paid4 >= 1 THEN REPLACE(CONVERT(VARCHAR,p.paid4),'.','') ELSE '0' END + CHAR(13) + CHAR(10) AS Line15,
			'},'  + CHAR(13) + CHAR(10) AS Line16,
			'"reportedCommission": '	+ REPLACE(CONVERT(VARCHAR,SUM(p.collectorfee)),'.','') + CHAR(13) + CHAR(10) AS Line17,
		'}'+ CHAR(13) + CHAR(10) AS Line18,
	'}'+ CHAR(13) + CHAR(10) AS Line19,
'},' + CHAR(13) + CHAR(10) AS Line20
FROM payhistory p
INNER JOIN master m ON p.number=m.number
INNER JOIN debtors d ON m.number=d.number AND d.seq=0

WHERE batchtype = 'pur' AND Invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))
GROUP BY m.id1,p.datetimeentered,p.batchtype,p.uid,p.ReverseOfUID,p.paid3,p.paid4,p.paid2,p.paid1,p.number
order by m.id1 
END
GO
