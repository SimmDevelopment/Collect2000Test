SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 9/4/2019
-- Description:	Export Placement Acknowledgement File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_NCP_Export_Payments]
	-- Add the parameters for the stored procedure here
	@invoice varchar(8000)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS LOAN_CODE,
d.firstName AS [FIRST_NAME],
d.lastName AS [LAST_NAME], 
ph.UID AS [Payment_Reference_Number], 
CASE WHEN batchtype LIKE '%r' THEN -(ph.totalpaid) ELSE ph.totalpaid END AS PAYMENT_AMOUNT, 
CONVERT(VARCHAR(10), ph.datepaid, 101) AS [ACTUAL_PAYMENT_DATE] 
FROM payhistory ph WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON ph.number = m.number INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.Seq = 0
WHERE m.customer = '0001105' AND batchtype LIKE 'PU%'
AND ph.Invoice IN (select string from dbo.CustomStringToSet(@invoice, '|'))



END
GO
