SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_RTR_Chase_Auto_Invoices]
	-- Add the parameters for the stored procedure here
	@invoice varchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS [Account], m.Name AS [Name], CASE WHEN batchtype LIKE '%r' THEN 'NSF' ELSE 'Payment' END AS [Payment Type],
	CASE WHEN batchtype LIKE '_C%' THEN 'Paid Client' ELSE p.paymethod END AS [Pay Method], p.datepaid AS [Date Paid], p.Invoiced AS [Date Invoiced], p.invoice AS [Invoice #], 
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2) ELSE p.paid1 + p.paid2 END AS [Total Paid], 
	CASE WHEN batchtype LIKE '%r' THEN -(p.CollectorFee) ELSE p.CollectorFee END AS [Fee]
FROM dbo.payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
WHERE p.customer IN ('0001220', '0001256', '0001257', '0001258') AND invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))


END
GO
