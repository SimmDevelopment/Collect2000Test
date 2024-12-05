SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/24/2022
-- Description: Export record 43 only
-- =============================================
CREATE PROCEDURE [dbo].[Custom_WRC_Record_43]
	-- Add the parameters for the stored procedure here
	@startdate datetime,
	@enddate DATETIME

	-- exec Custom_WRC_Record_43 '20220324', '20220328'

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
 
SELECT * 
INTO #promTemp
FROM Promises p WITH (NOLOCK) 
WHERE p.Active = 1 AND CAST(p.DateCreated AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
AND p.Customer = '0002770'


SELECT * 
INTO  #pdcTemp
FROM pdc p1 WITH (NOLOCK) 
WHERE p1.Active = 1 AND CAST(p1.DateCreated AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
AND p1.customer = '0002770'


SELECT dc.*, m.customer 
INTO #pccTemp
FROM DebtorCreditCards dc WITH (NOLOCK) INNER JOIN master M WITH (NOLOCK) ON dc.Number = m.number 
WHERE dc.IsActive = 1 AND CAST(dc.DateCreated AS DATE) between CAST(@startdate AS DATE) and CAST(@enddate AS DATE)
AND m.customer = '0002770'

	-- exec Custom_WRC_Record_43 '20220324', '20220411'


--Begin Record code 43 - Primary Debtor Info Update
select DISTINCT '43' as record_code,
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,	
	(SELECT TOP 1 FORMAT(t.DateCreated, 'yyyyMMdd') FROM #promTemp t WHERE t.Active = 1 AND m.number = t.AcctID ) AS plan_date,
	(SELECT TOP 1 SUM(t.Amount) FROM #promTemp t WHERE t.Active = 1 AND m.number = t.AcctID ) AS plan_bal,
	(SELECT TOP 1 FORMAT(MIN(t.DueDate), 'yyyyMMdd') FROM #promTemp t WHERE t.Active = 1 AND m.number = t.AcctID ) AS first_date,
	(SELECT TOP 1 t.Amount FROM #promTemp t WHERE t.Active = 1 AND m.number = t.AcctID ORDER BY t.DueDate DESC) AS first_amt,
	(SELECT TOP 1 t.Amount FROM #promTemp t WHERE t.Active = 1 AND m.number = t.AcctID AND T.ID NOT IN ((SELECT TOP 1 T.ID FROM #promTemp t WHERE t.Active = 1 AND m.number = t.AcctID)))  AS pay_amt,
	(SELECT TOP 1 FORMAT(MAX(t.DueDate), 'yyyyMMdd') FROM #promTemp t WHERE t.Active = 1 AND m.number = t.AcctID ) AS last_date,
	(SELECT TOP 1 t.Amount FROM #promTemp t WHERE t.Active = 1 AND m.number = t.AcctID ORDER BY t.DueDate ASC) AS last_amt,
	(SELECT TOP 1 COUNT(id) FROM #promTemp t WHERE t.Active = 1 AND m.number = t.AcctID ) AS no_pmts,
	(SELECT TOP 1 CASE T.PromiseMode WHEN 2 THEN 'M' WHEN 5 THEN 'W' WHEN 3 THEN 'B' WHEN 12 THEN 'W' WHEN 12 THEN 'M' ELSE 'M' END FROM #promTemp t WHERE t.Active = 1 AND m.number = t.AcctID ) AS frequency, 
	'' AS stipulationmaileddate,
	'' AS stipulationfileddate,
	'' AS stipulationtotalamount
from master m with (nolock) INNER JOIN #promTemp pr WITH (NOLOCK)  ON m.number = pr.acctid
where m.customer = '0002770' AND FORMAT(pr.DateCreated, 'yyyyMMdd') IS NOT NULL

UNION ALL

select DISTINCT '43' as record_code,
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,	
	(SELECT TOP 1 FORMAT(t.DateCreated, 'yyyyMMdd') FROM #pdcTemp t WHERE t.Active = 1 AND m.number = t.number ) AS plan_date,
	(SELECT TOP 1 SUM(t.Amount) FROM #pdcTemp t WHERE t.Active = 1 AND m.number = t.number ) AS plan_bal,
	(SELECT TOP 1 FORMAT(MIN(t.deposit), 'yyyyMMdd') FROM #pdcTemp t WHERE t.Active = 1 AND m.number = t.number ) AS first_date,
	(SELECT TOP 1 t.Amount FROM #pdcTemp t WHERE t.Active = 1 AND m.number = t.number ORDER BY t.deposit DESC) AS first_amt,
	(SELECT TOP 1 t.Amount FROM #pdcTemp t WHERE t.Active = 1 AND m.number = t.number AND T.UID NOT IN ((SELECT TOP 1 T.UID FROM #pdcTemp t WHERE t.Active = 1 AND m.number = t.number)))  AS pay_amt,
	(SELECT TOP 1 FORMAT(MAX(t.deposit), 'yyyyMMdd') FROM #pdcTemp t WHERE t.Active = 1 AND m.number = t.number ) AS last_date,
	(SELECT TOP 1 t.Amount FROM #pdcTemp t WHERE t.Active = 1 AND m.number = t.number ORDER BY t.deposit ASC) AS last_amt,
	(SELECT TOP 1 COUNT(t.UID) FROM #pdcTemp t WHERE t.Active = 1 AND m.number = t.number ) AS no_pmts,
	(SELECT TOP 1 CASE T.PromiseMode WHEN 2 THEN 'M' WHEN 5 THEN 'W' WHEN 3 THEN 'B' WHEN 12 THEN 'W' WHEN 12 THEN 'M' ELSE 'M' END FROM #pdcTemp t WHERE t.Active = 1 AND m.number = t.number ) AS frequency, 
	'' AS stipulationmaileddate,
	'' AS stipulationfileddate,
	'' AS stipulationtotalamount
from master m with (nolock) INNER JOIN #pdcTemp pd WITH (NOLOCK)  ON m.number = pd.number
where m.customer = '0002770' AND FORMAT(pd.DateCreated, 'yyyyMMdd') IS NOT NULL

UNION ALL

select DISTINCT '43' as record_code,
	m.id1 as fileno, 
	m.account as forw_file, 
	m.number as masco_file, 
	'SIMM' as firm_id, 
	'WCF3' as forw_id,	
	(SELECT TOP 1 FORMAT(t.DateCreated, 'yyyyMMdd') FROM #pccTemp t WHERE t.IsActive = 1 AND m.number = t.number ) AS plan_date,
	(SELECT TOP 1 SUM(t.Amount) FROM #pccTemp t WHERE t.IsActive = 1 AND m.number = t.number ) AS plan_bal,
	(SELECT TOP 1 FORMAT(MIN(t.DepositDate), 'yyyyMMdd') FROM #pccTemp t WHERE t.IsActive = 1 AND m.number = t.number ) AS first_date,
	(SELECT TOP 1 t.Amount FROM #pccTemp t WHERE t.IsActive = 1 AND m.number = t.number ORDER BY t.DepositDate DESC) AS first_amt,
	(SELECT TOP 1 t.Amount FROM #pccTemp t WHERE t.IsActive = 1 AND m.number = t.number AND T.ID NOT IN ((SELECT TOP 1 T.ID FROM #pccTemp t WHERE t.IsActive = 1 AND m.number = t.number)))  AS pay_amt,
	(SELECT TOP 1 FORMAT(MAX(t.DepositDate), 'yyyyMMdd') FROM #pccTemp t WHERE t.IsActive = 1 AND m.number = t.number ) AS last_date,
	(SELECT TOP 1 t.Amount FROM #pccTemp t WHERE t.IsActive = 1 AND m.number = t.number ORDER BY t.DepositDate ASC) AS last_amt,
	(SELECT TOP 1 COUNT(t.ID) FROM #pccTemp t WHERE t.IsActive = 1 AND m.number = t.number ) AS no_pmts,
	(SELECT TOP 1 CASE T.PromiseMode WHEN 2 THEN 'M' WHEN 5 THEN 'W' WHEN 3 THEN 'B' WHEN 12 THEN 'W' WHEN 12 THEN 'M' ELSE 'M' END FROM #pccTemp t WHERE t.IsActive = 1 AND m.number = t.number ) AS frequency, 
	'' AS stipulationmaileddate,
	'' AS stipulationfileddate,
	'' AS stipulationtotalamount
from master m with (nolock) INNER JOIN #pccTemp pc WITH (NOLOCK)  ON m.number = pc.number
where m.customer = '0002770' AND FORMAT(pc.DateCreated, 'yyyyMMdd') IS NOT NULL


	DROP TABLE #promTemp
	DROP TABLE #pdcTemp
	DROP TABLE #pccTemp

--end Record code 43

END



GO
