SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_FMH_Post_Def_Export_Pays] 
	-- Add the parameters for the stored procedure here
	@customer varchar(255),
	@invoice varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account, CONVERT(VARCHAR(8), p.datepaid, 112) AS transdate, m.ssn, d.lastName, d.firstName,
	CASE WHEN batchtype LIKE '%ur' AND p.iscorrection = 0 THEN 'NSF' WHEN batchtype LIKE '%ur' AND p.iscorrection = 1 THEN 'PAYMENTREVERSAL' WHEN batchtype LIKE 'pc%' THEN 'ADUSTMENT' ELSE 'PAYMENT' END AS transtype, 
	CASE WHEN batchtype LIKE 'pc%' THEN 0 ELSE p.paid1 + p.paid2 END AS transamount,
	CASE WHEN batchtype LIKE '%r' THEN '-' ELSE '0' END AS [sign], p.CollectorFee AS commamount,
	CASE p.paymethod WHEN 'ach debit' THEN 'ACH' WHEN 'Credit Card' THEN 'CC' WHEN 'cash' THEN 'CASH' WHEN 'Money order' THEN 'MNYO' ELSE 'NA' END AS paymethod,
	CASE WHEN batchtype LIKE '%r' THEN p.reverseOfUID ELSE uid END AS payid
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
WHERE p.customer in (select string from dbo.CustomStringToSet(@customer, '|')) AND p.invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))

END
GO
