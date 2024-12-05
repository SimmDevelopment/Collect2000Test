SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Credigy_Export_Payment_File] 
	-- Add the parameters for the stored procedure here
	@invoice varchar(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT account AS [Loan_Number], m.name AS [Account_Name], CONVERT(VARCHAR(10), p.datepaid, 101) AS [Date_Paid], CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2) ELSE (p.paid1 + p.paid2) END AS [Pmt_Amt],
CASE WHEN paymethod IN ('ACH DEBIT', 'CHECK') THEN 'PHONE ACH' WHEN Paymethod IN ('Credit Card') THEN 'PHONE CREDIT/DEBIT' WHEN paymethod IN ('Money Gram') THEN 'MONEYGRAM' WHEN paymethod IN ('MONEY ORDER', 'WESTERN UNION') THEN 'MONEY ORDER' WHEN paymethod = '' THEN '' ELSE 'PHONE ACH' END AS [payment_method_code],
p.uid AS payment_method_reference, 'SIMM Associates, Inc.' AS [User_Reference], CASE WHEN batchtype LIKE '%r' THEN CONVERT(VARCHAR(10), datepaid, 101) ELSE '' END AS [Return_Date], CASE WHEN batchtype LIKE '%r' THEN 'NSF' ELSE '' END AS [Return_Reason]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
WHERE Invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))

END
GO
