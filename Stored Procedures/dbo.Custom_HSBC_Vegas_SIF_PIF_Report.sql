SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_HSBC_Vegas_SIF_PIF_Report] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME,
	@customer VARCHAR(5000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS [ACCOUNT NUMBER], d.lastname + ', ' + d.firstname AS [CARDHOLDER NAME], m.ssn AS [SSN], m.status AS [SIF/PIF ?], d.lastname + ', ' + d.firstname AS [OFFERED TO], convert(VARCHAR(10), m.closed, 101) AS [DATE OFFERED], 
	m.original AS [BALANCE AT SIF/PIF OFFER], ABS(m.paid1 + m.paid2) AS [SIF/PIF AMOUNT], ABS(m.paid1 + m.paid2) / original AS [SIF PERCENTAGE], 
	current0 AS [BALANCE AT COMPLETION], c.customtext1 AS [RECOVERER CODE], DATEDIFF(d, m.ChargeOffDate, m.closed) AS [DELINQUENCY AT SIF OFFER],
	(SELECT TOP 1 convert(VARCHAR(10), datepaid, 101) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' ORDER BY datepaid) AS [PAYMENT DATE1],
	(SELECT TOP 1 (paid1 + paid2) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' ORDER BY datepaid) AS [PAYMENT AMOUNT1],
	(SELECT TOP 1 convert(VARCHAR(10), datepaid, 101) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' AND UID NOT IN ((SELECT TOP 1 UID FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' ORDER BY datepaid)) ORDER BY datepaid) AS [PAYMENT DATE2],
	(SELECT TOP 1 (paid1 + paid2) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' AND UID NOT IN ((SELECT TOP 1 UID FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' ORDER BY datepaid)) ORDER BY datepaid) AS [PAYMENT AMOUNT2],
	(SELECT TOP 1 convert(VARCHAR(10), datepaid, 101) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' AND UID NOT IN ((SELECT TOP 2 UID FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' ORDER BY datepaid)) ORDER BY datepaid) AS [PAYMENT DATE3],
	(SELECT TOP 1 (paid1 + paid2) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' AND UID NOT IN ((SELECT TOP 2 UID FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' ORDER BY datepaid)) ORDER BY datepaid) AS [PAYMENT AMOUNT3],
	(SELECT TOP 1 convert(VARCHAR(10), datepaid, 101) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' AND UID NOT IN ((SELECT TOP 3 UID FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' ORDER BY datepaid)) ORDER BY datepaid) AS [PAYMENT DATE4],
	(SELECT TOP 1 (paid1 + paid2) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' AND UID NOT IN ((SELECT TOP 3 UID FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' ORDER BY datepaid)) ORDER BY datepaid) AS [PAYMENT AMOUNT4],
	(SELECT TOP 1 convert(VARCHAR(10), datepaid, 101) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' AND UID NOT IN ((SELECT TOP 4 UID FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' ORDER BY datepaid)) ORDER BY datepaid) AS [PAYMENT DATE5],
	(SELECT TOP 1 (paid1 + paid2) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' AND UID NOT IN ((SELECT TOP 4 UID FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' ORDER BY datepaid)) ORDER BY datepaid) AS [PAYMENT AMOUNT5],
	(SELECT TOP 1 convert(VARCHAR(10), datepaid, 101) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' AND UID NOT IN ((SELECT TOP 5 UID FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' ORDER BY datepaid)) ORDER BY datepaid) AS [PAYMENT DATE6],
	(SELECT TOP 1 (paid1 + paid2) FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' AND UID NOT IN ((SELECT TOP 5 UID FROM payhistory WITH (NOLOCK) WHERE number = m.number AND batchtype = 'pu' ORDER BY datepaid)) ORDER BY datepaid) AS [PAYMENT AMOUNT6]

FROM master m WITH (NOLOCK) INNER JOIN customer c WITH(NOLOCK) on m.customer = c.customer INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number AND d.Seq = 0
WHERE m.customer in (select string from dbo.CustomStringToSet(@customer,'|')) AND m.status IN ('sif', 'pif') AND m.closed between dbo.date(@startDate) AND  dbo.date(@endDate)


END
GO
