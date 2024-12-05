SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Credigy_Export_Collector_Comments]
	-- Add the parameters for the stored procedure here
	@startDate datetime,
	@endDate datetime	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS [Loan_Number], m.name AS [Account Name], CONVERT(VARCHAR(10), p.entered, 101) AS [Create_Date], CONVERT(VARCHAR(8), DateCreated, 108) AS [Create_Time],
p.CreatedBy AS [Created_By], n.comment AS [Comment], CONVERT(VARCHAR(10), p.deposit, 101) AS [Promise_Date], p.amount AS [Promise_Amount]
FROM pdc p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer = '0001041' AND p.entered BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) AND n.result = 'pp'

UNION ALL

SELECT m.account AS [Loan_Number], m.name AS [Account Name], CONVERT(VARCHAR(10), p.DateEntered, 101) AS [Create_Date], CONVERT(VARCHAR(8), DateCreated, 108) AS [Create_Time],
p.CreatedBy AS [Created_By], n.comment AS [Comment], CONVERT(VARCHAR(10), p.DepositDate, 101) AS [Promise_Date], p.amount AS [Promise_Amount]
FROM DebtorCreditCards p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer = '0001041' AND p.DateEntered BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) AND n.result = 'pp'

UNION ALL

SELECT m.account AS [Loan_Number], m.name AS [Account Name], CONVERT(VARCHAR(10), p.DateCreated, 101) AS [Create_Date], CONVERT(VARCHAR(8), DateCreated, 108) AS [Create_Time],
p.CreatedBy AS [Created_By], n.comment AS [Comment], CONVERT(VARCHAR(10), p.DueDate, 101) AS [Promise_Date], p.amount AS [Promise_Amount]
FROM Promises p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.AcctID = m.number
INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
WHERE m.customer = '0001041' AND p.entered BETWEEN dbo.date(@startDate) AND dbo.date(@endDate) AND n.result = 'pp'

END
GO
