SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Mosaic_1483_Payments] 
	-- Add the parameters for the stored procedure here
	@invoice VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT m.account AS [Borrower Account], m.id1 AS Packet, 
	m.NAME AS [Borrower Name], p.datepaid AS [Effective Date],
	CASE WHEN batchtype LIKE '%r' THEN -(p.paid1 + p.paid2) ELSE p.paid1 + p.paid2 END AS [Payment Amount],
	CASE WHEN m.status = 'PIF' THEN 'Paid in Full' ELSE 'Regular Payment' END AS [Payment Type],
	ISNULL(m.clidlp, '') AS [Genesis Last Paid Date], ISNULL(m.clialp, '') AS [Genesis Amount Last Paid], id2 AS [facility_id]
FROM payhistory p WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON p.number = m.number
INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
WHERE batchtype LIKE 'pu%' AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|'))

END
GO
