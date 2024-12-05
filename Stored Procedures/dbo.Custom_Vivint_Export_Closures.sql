SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 11/13/2024
-- Description:	Export Closed accounts by date closed
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Vivint_Export_Closures]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT m.number AS [Internal Account #]
	 , m.account                      AS [VIVINT Account #]
	 , m.OriginalCreditor AS [Client]
	 , d.lastName AS [Last Name]
	 , d.firstName AS [First Name]
	 , m.original AS [Assigned]
	 , m.current0 AS [Balance]
	 , CASE WHEN m.status IN ('BKY', 'B07', 'B11', 'B13', 'CND', 'CAD', 'DEC', 'FRD', 'RSK', 'ATY', 'LIT', 'LCP', 'DSP') THEN 'Canceled'
			WHEN m.status IN ('PIF', 'SIF') THEN 'Complete' ELSE 'Canceled' END AS [Status]
	 , CASE WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') AND b.Status = 'Filing' THEN 'Bankruptcy Filing Claim'
			WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') AND b.Status = 'Discharged' THEN 'Bankruptcy Discharged'
			WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') AND b.Status NOT IN ('Discharged', 'Filing') THEN 'Bankruptcy'
			WHEN m.status IN ('CND', 'CAD') THEN 'Cease and Desist'
			WHEN m.status IN ('DEC') THEN 'Deceased'
			WHEN m.status IN ('FRD') THEN 'Fraudulent'
			WHEN m.status IN ('ATY', 'LIT', 'LCP') THEN 'Legal'
			WHEN m.status IN ('RSK') THEN 'Litigious'
			WHEN m.status IN ('DSP') THEN 'Disputed'
			WHEN m.status IN ('PIF') THEN 'PIF'
			WHEN m.status IN ('SIF') THEN 'SIF' 
			WHEN m.status IN ('AEX') THEN 'Efforts Exhausted'
			ELSE 'Efforts Exhausted' END AS [Closure Status Code]
	, FORMAT(m.closed, 'MM/dd/yyyy') AS [Date Closed]
FROM dbo.master m WITH (NOLOCK) INNER JOIN dbo.Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.Seq = 0
LEFT OUTER JOIN dbo.Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
WHERE m.customer = 3116 
AND CAST(closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
AND m.status NOT IN ('CCR', 'RCL')


END
GO
