SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Kia Evans
-- Create date: 10/30/2023
-- Description:	Export Return File to Pendrick
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Pendrick_Workflow]
	-- Add the parameters for the stored procedure here
	@startDate datetime,
	@endDate datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	SELECT DISTINCT
     m.id1 AS [PCP_DBT]
	,LEFT(D.lastName,5) AS [Last_Name]
	,CASE WHEN n.result = 'P01' THEN '1000'
		WHEN status IN('VAL') AND n.result = 'P02' THEN '1001'
		WHEN status IN('IBR') AND n.result = 'P03' THEN '1005'
		WHEN n.result = 'P04' THEN '1010'
		WHEN n.result = 'P05' THEN '1011'
		WHEN n.result = 'P06' THEN '1012'
		WHEN n.result = 'P07' THEN '1013'
		WHEN n.result = 'P08' THEN '1014'
		WHEN n.result = 'P09' THEN '1015'
		WHEN n.result = 'P10' THEN '1016'
		WHEN n.result = 'P11' THEN '1017'
		WHEN n.result = 'P12' THEN '1018'
		WHEN n.result = 'P13' THEN '1019'
		WHEN n.result = 'P14' THEN '1020'
		WHEN n.result = 'P15' THEN '1021'
		WHEN n.result = 'P16' THEN '2000'
		WHEN n.result = 'P17' THEN '2001'
		WHEN n.result = 'P18' THEN '2002'
		WHEN n.result = 'P19' THEN '2003'
		WHEN n.result = 'P20' THEN '2005'
		WHEN n.result = 'P21' THEN '2006'
		WHEN n.result = 'P22' THEN '2010'
		WHEN n.result = 'P23' THEN '3001'
		WHEN n.result = 'P24' THEN '3002'
		WHEN n.result = 'P25' THEN '3003'
		WHEN n.result = 'P26' THEN '3004'
		WHEN n.result = 'P27' THEN '3005'
		WHEN n.result = 'P28' THEN '3006'
		WHEN n.result = 'P29' THEN '3007'
		WHEN n.result = 'P30' THEN '3008'
		WHEN n.result = 'P31' THEN '3009'
		WHEN n.result = 'P32' THEN '3010'
		WHEN n.result = 'P33' THEN '3011'
		WHEN n.result = 'P34' THEN '3012'
		WHEN n.result = 'P35' THEN '3013'
		WHEN n.result = 'P36' THEN '3014'
		WHEN n.result = 'P37' THEN '3015'
		WHEN n.result = 'P38' THEN '3016'
		WHEN n.result = 'P39' THEN '4001'
		WHEN n.result = 'P40' THEN '4002'
		WHEN n.result = 'P41' THEN '4050'
		WHEN n.result = 'P42' THEN '4051'
		WHEN n.result = 'P43' THEN '4052'
		WHEN n.result = 'P44' THEN '4053'
		WHEN n.result = 'P45' THEN '4060'
		WHEN n.result = 'P46' THEN '4061'
		WHEN n.result = 'P47' THEN '4062'
		WHEN n.result = 'P48' THEN '4063'
		WHEN n.result = 'P49' THEN '4150'
		WHEN d.language IS NOT NULL and d.language <> '' THEN '4151'
		--WHEN d.language <> THEN '4151'
		 ELSE '' end AS workflow_Code
	, CASE WHEN d.language = '0001 - ENGLISH' THEN 'English' WHEN D.language = '0002 - SPANISH' THEN 'Spanish' ELSE '' END AS additional_data
	, REPLACE(CONVERT(VARCHAR(10), n.created, 112),'/','') AS additional_data_1
	, COALESCE((SELECT TOP 1 m.homephone FROM phonehistory WITH (NOLOCK) WHERE AccountID = m.number AND DateChanged BETWEEN @startDate AND @endDate),
		 (SELECT TOP 1 m.homephone FROM AddressHistory WITH (NOLOCK) WHERE AccountID = m.number AND DateChanged BETWEEN @startDate AND @endDate), '') AS additional_data_2
	, '' AS additional_data_3
	, '' AS additional_data_4
	, '' AS additional_data_5
	, '' AS additional_data_6
	FROM notes n WITH(NOLOCK)INNER JOIN master m WITH (NOLOCK) ON m.number = n.number
	INNER JOIN Debtors d WITH(NOLOCK) ON m.number = d.Number
	LEFT OUTER JOIN dbo.PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
	--INNER JOIN notes n WITH(NOLOCK) ON m.number = n.number
	--INNER JOIN LetterRequest lr WITH(NOLOCK) ON m.number = lr.AccountID
	WHERE m.customer IN ('0003099') --AND status IN ('hot', 'pdc', 'pcc', 'ppa', 'nsf', 'dcc', 'dbd', 'bkn', 'clm')
	AND dbo.date(n.created) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
	--AND dbo.date(n.created) BETWEEN dbo.date('20231101') AND dbo.date('20231205')
	----AND dbo.date(lr.DateProcessed) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)

--FROM notes n WITH (NOLOCK)
--WHERE m.id1 IN (
--SELECT DISTINCT m.id1
--FROM master m WITH (NOLOCK) 
--LEFT OUTER JOIN Deceased d WITH (NOLOCK) ON m.number = d.AccountID
--LEFT OUTER JOIN Bankruptcy b WITH (NOLOCK) ON m.number = b.AccountID
--LEFT OUTER JOIN DebtorAttorneys da WITH (NOLOCK) ON m.number = da.AccountID
--LEFT OUTER JOIN AddressHistory ah WITH (NOLOCK) ON m.number = ah.AccountID
--LEFT OUTER JOIN PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
--LEFT OUTER JOIN cbr_metro2_accounts cma WITH (NOLOCK) ON m.number = cma.accountID
--LEFT OUTER JOIN StatusHistory sh WITH (NOLOCK) ON m.number = sh.AccountID
--LEFT OUTER JOIN notes n WITH(NOLOCK) ON m.number = n.number
--LEFT OUTER JOIN Debtors de WITH(NOLOCK) ON m.number = de.Number
--WHERE customer IN ('0003099')
--AND ((received BETWEEN '20231101' AND '20231205') OR (ah.DateChanged BETWEEN '20231101' AND '20231205' AND m.closed IS NULL)
--	OR (ph.DateChanged BETWEEN '20231101' AND '20231205' AND m.closed IS NULL) OR (d.TransmittedDate BETWEEN '20231101' AND '20231205')
--	OR (b.TransmittedDate BETWEEN '20231101' AND '20231205') OR (cma.dateReported BETWEEN '20231101' AND '20231205')
--	OR (sh.DateChanged BETWEEN '20231101' AND '20231205')OR (n.created BETWEEN '20231101' AND '20231205')) 
--	AND customer IN ('0003099'))

END
GO
