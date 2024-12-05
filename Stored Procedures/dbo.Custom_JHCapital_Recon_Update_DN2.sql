SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_JHCapital_Recon_Update_DN2] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT id1 AS data_id, 
ISNULL((SELECT TOP 1 StatusCode FROM dbo.Custom_JHCapital_Status_Codes WITH (NOLOCK) WHERE DataID = m.id1 ORDER BY Statusdate DESC), '112010') AS placedetail_status,
current1 + current2 + current3 + current4 + current5 AS data_bal_total, 
current1 AS data_bal_principal, 
current2 as data_bal_interest, 
current3 as data_bal_court, 
current4 AS data_bal_attorney, 
current5 AS data_bal_other, 
0.00 AS placedetail_fee_recovery,
ISNULL(CONVERT(VARCHAR(10), lastpaid, 101), '') AS lastpayment,
lastpaidamt AS lastpaymentamt
FROM master m WITH (NOLOCK)
WHERE customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID  in (186,280))
AND closed IS NULL and id2 not in ('AllGate','ARS-JMET')








END
GO
