SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_AccessGroup_DetailPaymentFile]
	-- Add the parameters for the stored procedure here
	@invoice VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CONVERT(VARCHAR(10), p.datepaid, 101) AS [Payment Date], 
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE number = m.number AND title = 'f45_bondid') AS [Bond ID],
m.Name, m.SSN, m.id1 AS [LatFileNumber], CASE WHEN batchtype LIKE '%r' THEN 'NSF' WHEN p.paymethod = 'credit card' THEN 'VI' ELSE 'CK' end AS [Pd Typ], convert(DECIMAL(4,2), fsd.Fee1) AS [Comm Rate], 
CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2 + p.paid3 + p.paid4) ELSE (p.paid1 + p.paid2 + p.paid3 + p.paid4) END AS [Pmt Amt], 
CASE WHEN batchtype LIKE '%r' THEN -(p.collectorfee) ELSE p.CollectorFee END AS [Comm Amt],
CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2 + p.paid3 + p.paid4) ELSE (p.paid1 + p.paid2 + p.paid3 + p.paid4) END -
CASE WHEN batchtype LIKE '%r' THEN -(p.collectorfee) ELSE p.CollectorFee END AS [NetPymt]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
INNER JOIN customer c WITH (NOLOCK) ON m.customer = c.customer
INNER JOIN FeeScheduleDetails fsd WITH (NOLOCK) ON c.FeeSchedule = fsd.Code
WHERE p.invoice IN (SELECT string FROM dbo.CustomStringToSet(@invoice, '|'))



END
GO
