SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Klarna_Commissions] 
	-- Add the parameters for the stored procedure here
		@invoice as varchar(8000),
	@customer VARCHAR(5000)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS [claim_ID], CASE WHEN batchtype LIKE '%p' THEN REPLACE(CONVERT(VARCHAR(12), -(p.paid1 + p.paid2 + p.paid3 + p.paid4)), '.', '') ELSE REPLACE(CONVERT(VARCHAR(12), (p.paid1 + p.paid2 + p.paid3 + p.paid4)), '.', '') end as [payment], replace(CONVERT(varchar(10), p.datepaid, 112), '/', '') as [payment_date], 
CASE WHEN batchtype LIKE '%p' THEN -(CollectorFee) ELSE CollectorFee END AS [commission]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
WHERE p.Invoice in (select string from dbo.CustomStringToSet(@invoice,'|') ) and m.customer IN (select string from dbo.CustomStringToSet(@customer, '|'))


END
GO
