SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_SunTrust_CACS_Payment]
	-- Add the parameters for the stored procedure here
	@invoice VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS [SunTrust Account Number], CASE WHEN d.isBusiness = 1 then d.businessname else d.firstName + ' ' + d.lastName end AS [Debtor Name], 
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2) ELSE p.paid1 + p.paid2 END AS [Remittance Amt],
	CASE WHEN batchtype LIKE '%r' THEN -(p.fee1 + p.fee2) ELSE p.fee1 + p.fee2 END AS [Contingency Amt],
	CASE WHEN batchtype LIKE '%r' THEN -((p.paid1 + p.paid2) - (p.fee1 + p.fee2)) ELSE (p.paid1 + p.paid2) - (p.fee1 + p.fee2) END AS [Net Amount],
	'56' AS [Remittance Type], replace(CONVERT(varchar(10), GETDATE(), 101), '/', '') AS [Effective Payment Date], '' AS [Cost Center], '' AS [GL], '' AS [Vendor No], '' AS [Dept Code],
	m.id2 AS [Location Code]
	
	
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
	INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
WHERE batchtype LIKE 'pu%' AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|')) 
AND ((m.customer IN ('0002258','0002259','0002509','0002510','0002513','0002514','0002512','0002775')) or (m.customer in ('0001280','0001281','0001317','0001410')and id2 in ('0101','0102','0107','0108','0109','0112',
'0301','0304','0306','0307','0312','0315','0350','0352','0402','0403','0405')))

END
GO
