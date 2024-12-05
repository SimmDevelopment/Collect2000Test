SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 01/18/2016
-- Description:	Export activity notes for college avenue customer 1439 only
-- Changes:		04/15/2021 BGM Adjusted how CR and LF are filtered from note's comments, prior it looked for them together and missed when only an LF was there.
--exec custom_college_avenue_account_activity '20210413', '20210413'
-- 02/23/2023 added all college ave customers Per Heather
-- =============================================
CREATE PROCEDURE [dbo].[Custom_College_Avenue_Account_Activity] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT DISTINCT m.account, CONVERT(VARCHAR(10), n.created, 101) AS CallDate,
	CONVERT(VARCHAR(8), n.created, 108) AS CallTime, 
	'' AS CallDuration, 
	CASE WHEN action IN ('DT', 'AT') THEN 'Inbound' ELSE 'Outbound' end AS CallDirection,
	CASE WHEN action IN ('MNUAL', 'TC') THEN 'Manual' ELSE 'Dialer' end AS DialType, 
	CASE WHEN RIGHT(CONVERT(NVARCHAR(MAX), n.comment), 4) LIKE '[0-9][0-9][0-9][0-9]' THEN dbo.StripNonDigits(RIGHT(CONVERT(NVARCHAR(MAX), n.comment), 14)) ELSE '' end AS Phonenumber,
	--'' AS Phonenumber, 
	n.ACTION AS ACTION,
	CASE WHEN n.result IN (SELECT code FROM result WITH (NOLOCK) WHERE contacted = 1 OR code IN ('hu', 'LN', 'NH', 'NI', 'DK', 'TO', 'TW', 'CD', 'DP', 'CC')) THEN 'Yes' ELSE 'No' END AS CONNECT,
	CASE WHEN n.result IN (SELECT code FROM result WITH (NOLOCK) WHERE contacted = 1) THEN 'Yes' ELSE 'No' end  AS RPC,
	r.Description AS Result, 
	REPLACE(REPLACE(CAST(n.comment as NVARCHAR(MAX)), CHAR(13), ' '), CHAR(10), '') AS Notes
FROM master m WITH (NOLOCK) INNER join notes n WITH ( NOLOCK ) ON m.number = n.number
	INNER JOIN result r WITH (NOLOCK) ON n.result = r.code
WHERE  dbo.date(created) BETWEEN DATEADD(dd, -1, dbo.F_START_OF_DAY(@startDate))
                                 AND DATEADD(s, -1, dbo.F_START_OF_DAY(@endDate))
       AND user0 NOT IN ( 'dialconnec', 'system', 'tlo',
                         'exg', 'fusion', 'exchange', 'exch',
                         'sys', 'workflow', 'phonescrub',
                         'decdsvc', 'linking', 'hrlysweep',
                         'bankosvc', 'exch_sp', 'webrecon',
                         'eod', 'pdt', 'custodian' )
                        AND action IN ( 'TE', '3P', 'DT', 'TP', 'TA', 'TC',
                                        'TO', 'MNUAL', 'TR', 'TI' )
AND customer IN ('0001439','0002051','0002288','0002532','0002533','0002534','0002535','0002653','0002654','0002655','0002656','0002679','0002886','0003004')

UNION ALL 

SELECT DISTINCT m.account, CONVERT(VARCHAR(10), n.created, 101) AS CallDate,
	CONVERT(VARCHAR(8), n.created, 108) AS CallTime, 
	'' AS CallDuration, 
	'Comment' AS CallDirection, 
	'' DialType,
	'' AS Phonenumber,
	n.action AS Action,
	'' AS CONNECT,
	'' AS RPC,
	r.Description AS Result, 
	CONVERT(VARCHAR(5000), n.comment) AS Notes
FROM master m WITH (NOLOCK) INNER join notes n WITH ( NOLOCK ) ON m.number = n.number
	INNER JOIN result r WITH (NOLOCK) ON n.result = r.code
WHERE  dbo.date(created) BETWEEN DATEADD(dd, -1, dbo.F_START_OF_DAY(@startDate))
                                 AND DATEADD(s, -1, dbo.F_START_OF_DAY(@endDate))
       AND user0 IN ( 'system', 'tlo', 'exg', 'fusion', 'exchange', 'exch',
                         'sys', 'phonescrub', 'decdsvc', 'bankosvc', 'exch_sp', 'webrecon',
                         'eod', 'pdt', 'custodian' )
                        AND action not IN ( 'TE', '3P', 'DT', 'TP', 'TA', 'TC', 'TO', 'MNUAL', 'TR', 'TI' )
AND customer IN ('0001439','0002051','0002288','0002532','0002533','0002534','0002535','0002653','0002654','0002655','0002656','0002679','0002886','0003004')
ORDER BY CallDate, CallTime, account

END
GO
