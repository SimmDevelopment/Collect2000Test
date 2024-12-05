SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_US_Bank_Invoice] 
	-- Add the parameters for the stored procedure here
	@invoice varchar(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  d.lastName, d.firstName, m.account, datepaid, 
CASE WHEN batchtype = 'pu' THEN p.paid1 + p.paid2 WHEN batchtype = 'pur' THEN -(p.paid1 + p.paid2) ELSE 0 END AS [Paid To Us],
CASE WHEN batchtype LIKE 'pc' THEN p.paid1 + p.paid2 WHEN batchtype = 'pcr' THEN -(p.paid1 + p.paid2) ELSE 0 END AS [Paid To You], 
CASE WHEN batchtype LIKE '%r' THEN -p.collectorfee ELSE p.CollectorFee end AS [Our Fee],
(CASE WHEN batchtype = 'pu' THEN p.paid1 + p.paid2 WHEN batchtype = 'pur' THEN -(p.paid1 + p.paid2) ELSE 0 END + 
CASE WHEN batchtype LIKE 'pc' THEN p.paid1 + p.paid2 WHEN batchtype = 'pcr' THEN -(p.paid1 + p.paid2) ELSE 0 END) - 
CASE WHEN batchtype LIKE '%r' THEN -p.collectorfee ELSE p.CollectorFee END AS Net,
f.fee1 AS feepercent
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number INNER JOIN debtors d WITH (NOLOCK) ON p.number = d.number AND d.seq = 0
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer INNER JOIN dbo.FeeScheduleDetails f WITH (NOLOCK) ON c.FeeSchedule = f.Code
WHERE p.Invoice in (select string from dbo.CustomStringToSet(@invoice,'|') ) AND batchtype IN ('pu', 'pur', 'pc', 'pcr')
ORDER BY (CASE WHEN batchtype LIKE '%r' THEN 1 WHEN batchtype = 'pc' THEN 2 WHEN batchtype = 'pu' THEN 3 END)
END
GO
