SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_NCO_NCT_Export_Con_Recon] 
	-- Add the parameters for the stored procedure here
	@closebegin DATETIME,
	@closeend DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



    -- Insert statements for procedure here
	SELECT id1 AS TSIAcct, 'SIMM' AS agency, ISNULL(d.state, '') AS BorrowerState, ISNULL(d2.state, '') AS CoBorrowerState,
m.current1 AS PrincipalBalance, m.current2 AS InterestOwed, m.interestrate AS InterestRate, 
ISNULL(CONVERT(VARCHAR(10), m.lastpaid, 101), '') AS LastPaymentDate, ISNULL(CONVERT(VARCHAR(10), m.closed, 101), '') AS Closed,
CONVERT(VARCHAR(10), GETDATE(), 101) AS BalanceDate
FROM master m WITH (NOLOCK) LEFT OUTER JOIN Debtors d WITH (NOLOCK) ON m.number = d.Number AND d.seq = 0 
LEFT OUTER JOIN Debtors d2 WITH (NOLOCK) ON m.number = d2.number AND d2.seq = 1 
WHERE customer IN ('0001283', '0001404') AND (d.state = 'ct' OR d2.state = 'ct')
AND (closed IS NULL OR dbo.date(closed) BETWEEN dbo.date(@closebegin) AND dbo.date(@closeend))

END
GO
