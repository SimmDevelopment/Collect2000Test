SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_LINK_BD_Recon] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here



	    
SELECT 'REC' AS [RecordID], m.id1 AS [AccountID], m.current0 AS [CurrentBalance], '' AS [BalanceType],  (select top 1 (thedata) from miscextra me with (nolock) where number = m.number and title = 'Acc.0.VendorContract') AS [VendorContractID], '' AS [Strategy], 
(select top 1 (thedata) from miscextra me with (nolock) where number = m.number and title = 'Acc.0.VendorPlacementLevel') AS [VendorPlacementLevel], '' AS [Product],
m.original AS [PlacementBalance], CASE WHEN p.batchtype in ('PC') THEN (p.paid1 + p.paid2) ELSE 0.00 END AS [TotalDirectPaymentAmount], CASE WHEN p.batchtype in ('PC','PCR') THEN count(P.batchtype) END AS [TotalDirectPaymentCount],
CASE WHEN p.batchtype in ('DA','DAR') THEN (p.paid1 + p.paid2) ELSE '0.00' END AS [TotalAdjustmentAmount], CASE WHEN p.batchtype in ('DA','DAR') THEN count(P.batchtype) END AS [TotalAdjustmentCount],
CASE WHEN p.batchtype in ('PU','PUR') THEN (p.paid1 + p.paid2) ELSE '0.00' END AS [TotalVendorPaymentAmount], CASE WHEN p.batchtype in ('PU','PUR') THEN count(P.batchtype) END AS [TotalVendorPaymentCount]
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = P.number
WHERE m.customer IN ('0003115') 
--AND closed IS NULL
group by m.id1,m.current0, m.original, p.batchtype, p.paid1, p.paid2, m.number


END

GO
