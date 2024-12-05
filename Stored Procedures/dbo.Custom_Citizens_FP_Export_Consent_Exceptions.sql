SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 11/08/2019
-- Description:	Stored procedure to generate Cell Consent differences between SIMM and CTZ
-- 05/19/2020 added to check if account was closed more than 2 days ago 

-- =============================================
CREATE PROCEDURE [dbo].[Custom_Citizens_FP_Export_Consent_Exceptions]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.Account AS Account, m.Name, 'phone1' AS Phone,
SUBSTRING(CONVERT(VARCHAR(MAX), comment), 2, 10) AS Phonenumber, 
ISNULL((SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'acc.0.phone1_Consent'), '') AS CTZReported_PH1Consent,
CASE WHEN result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP') THEN 'N' ELSE 'Y' END AS SIMM_PH1Consent,
CASE WHEN CASE WHEN result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP') THEN 'N' ELSE 'Y' END = 'N'
		AND ISNULL((SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'acc.0.phone1_Consent'), '') = 'Y' THEN 'Fail' ELSE 'Pass' END AS Exception_Result
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer = '0002226'
--AND created BETWEEN @startDate AND @endDate
AND result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP')
AND SUBSTRING(CONVERT(VARCHAR(MAX), comment), 2, 10) = (SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'acc.0.phone1')
AND ISNULL((SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'phone1_Consent'), '') = 'Y'
AND (closed IS NULL OR closed > DATEADD(dd, -2, dbo.date(GETDATE()) ))

UNION ALL

--Phone 2 matches
SELECT m.account AS account, m.NAME, 'phone2' AS phone,
SUBSTRING(CONVERT(VARCHAR(MAX), comment), 2, 10) AS phonenumber,
ISNULL((SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'acc.0.phone2_Consent'), '') AS CTZReported_PH2Consent,
CASE WHEN result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP') THEN 'N' ELSE 'Y' END AS SIMM_PH2Consent,
CASE WHEN CASE WHEN result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP') THEN 'N' ELSE 'Y' END = 'N'
		AND ISNULL((SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'acc.0.phone2_Consent'), '') = 'Y' THEN 'Fail' ELSE 'Pass' END AS Exception_Result
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer = '0002226'
--AND created BETWEEN @startDate AND @endDate
AND result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP')
AND SUBSTRING(CONVERT(VARCHAR(MAX), comment), 2, 10) = (SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'acc.0.phone2')
AND ISNULL((SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'phone2_Consent'), '') = 'Y'
AND (closed IS NULL OR closed > DATEADD(dd, -2, dbo.date(GETDATE())))

UNION ALL

--Phone 3 matches
SELECT m.account AS account, m.NAME, 'phone3' AS phone,
SUBSTRING(CONVERT(VARCHAR(MAX), comment), 2, 10) AS phonenumber,
ISNULL((SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'acc.0.phone3_Consent'), '') AS CTZReported_PH3Consent,
CASE WHEN result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP') THEN 'N' ELSE 'Y' END AS SIMM_PH3Consent,
CASE WHEN CASE WHEN result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP') THEN 'N' ELSE 'Y' END = 'N'
		AND ISNULL((SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'acc.0.phone3_Consent'), '') = 'Y' THEN 'Fail' ELSE 'Pass' END AS Exception_Result
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer = '0002226'
--AND created BETWEEN @startDate AND @endDate
AND result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP')
AND SUBSTRING(CONVERT(VARCHAR(MAX), comment), 2, 10) = (SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'acc.0.phone3')
AND ISNULL((SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'phone3_Consent'), '') = 'Y'
AND (closed IS NULL OR closed > DATEADD(dd, -2, dbo.date(GETDATE())))


END
GO
