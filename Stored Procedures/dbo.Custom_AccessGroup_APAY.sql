SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_AccessGroup_APAY] 
	-- Add the parameters for the stored procedure here
	@invoice VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'APAY' AS recordtype, id1 AS filenumber, m.account, p.paid1 + p.paid2 + p.paid3 + p.paid4 AS paymentamount,
CONVERT(VARCHAR(8), p.datepaid, 112) AS paydate, CASE WHEN batchtype LIKE '%r' THEN 'PAR' ELSE 'PA' END AS paytype,
p.uid AS payidentifier, CONVERT(VARCHAR(8), GETDATE(), 112) AS createddate
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
WHERE p.invoice IN (SELECT string FROM dbo.CustomStringToSet(@invoice, '|'))


END
GO
