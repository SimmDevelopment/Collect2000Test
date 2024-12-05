SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_SunTrust_CACS_Closed] 
	-- Add the parameters for the stored procedure here
	@customer VARCHAR(5000),
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS [STB Acct #], m.Name as [NAME], 
		CASE WHEN m.STATUS LIKE 'B%' THEN 'BK' 
			WHEN m.STATUS IN  ('CAD', 'CND') THEN 'CD'
			WHEN m.STATUS IN ('WDS', 'VDS', 'DPV') THEN 'DS'
			WHEN m.STATUS IN ('FRD') THEN 'FR'
			WHEN m.STATUS IN ('OOS') THEN 'OS'
			WHEN m.STATUS IN ('RSK', 'LIT') THEN 'LT'
			WHEN m.STATUS IN ('AEX') THEN 'AX'
			WHEN m.STATUS IN ('DIP') THEN 'IC'
			WHEN m.STATUS IN ('NYC') THEN 'NY'
			WHEN m.STATUS IN ('RCL', 'CCR') THEN 'RC'
			WHEN m.STATUS IN ('DUP') THEN 'DU'
			WHEN m.STATUS IN ('DSP') THEN 'DP'
			WHEN m.STATUS IN ('DEC') THEN 'DC'
			WHEN m.STATUS IN ('VAL') THEN 'DV'
			END AS [STB Close Code] ,
	received as [DT-ASSIGN],
	m.original1 as [ PN-ASSIGN],
	'' as [CAN DATE],
	'' as [CAN AMT], 		
	'DOD ' + CONVERT(VARCHAR(10), de.dod, 101) AS [Notes]
	--'Chap ' + CONVERT(varchar(3), b.Chapter) + ' Filing Date ' + CONVERT(VARCHAR(10), b.DateFiled, 101) + ' Case Number ' + b.CaseNumber AS [Bankruptcy Info]
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 
	LEFT OUTER JOIN dbo.Deceased de WITH (NOLOCK) ON d.DebtorID = de.DebtorID
	--LEFT OUTER JOIN dbo.Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
WHERE dbo.date(m.closed) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) AND m.customer IN (select string from dbo.CustomStringToSet(@customer,'|')) 
AND m.status NOT IN ('sif', 'pif')

UNION ALL

	SELECT m.account AS [STB Acct #], m.Name as [NAME], CASE m.STATUS WHEN 'SIF' THEN 'SF' WHEN 'PIF' THEN 'PF' END AS [STB Close Code], 
	received as [DT-ASSIGN],
	m.original1 as [ PN-ASSIGN],
	'' as [CAN DATE],
	'' as [CAN AMT], 
	'DOD ' + CONVERT(VARCHAR(10), de.dod, 101) AS [Notes]
	--'Chap ' + CONVERT(varchar(3), b.Chapter) + ' Filing Date ' + CONVERT(VARCHAR(10), b.DateFiled, 101) + ' Case Number ' + b.CaseNumber AS [Bankruptcy Info]
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0 
	LEFT OUTER JOIN dbo.Deceased de WITH (NOLOCK) ON d.DebtorID = de.DebtorID
	--LEFT OUTER JOIN dbo.Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
WHERE dbo.date(m.closed) BETWEEN dbo.date(DATEADD(dd, -1, @startDate)) AND dbo.date(DATEADD(dd, -1, @endDate)) AND m.customer IN (select string from dbo.CustomStringToSet(@customer,'|'))
AND m.status IN ('sif', 'pif') AND ISNULL((SELECT COUNT(*)
FROM master ma WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON ma.number = p.number
WHERE ma.status IN ('sif', 'pif') AND ma.customer IN (select customerid from fact with (Nolock) where customgroupid = 107) AND batchtype LIKE 'p%'
AND ma.number = m.number
GROUP BY ma.number), 0) = ISNULL((SELECT COUNT(*)
FROM master ma WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON ma.number = p.number
WHERE ma.status IN ('sif', 'pif') AND ma.customer IN (select customerid from fact with (Nolock) where customgroupid = 107) AND batchtype LIKE 'p%'
AND p.invoice IS NOT NULL
AND ma.number = m.number
GROUP BY ma.number
), 0)



END

GO
