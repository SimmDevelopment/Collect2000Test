SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CitizensBank_DN_Recon_Update] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT id1 AS data_id, 
	m.account AS pri_acctno,
	CASE WHEN m.STATUS = 'VAL' THEN '320300'
	WHEN m.STATUS = 'DSP' THEN '320220'
	WHEN m.STATUS = 'CFD' THEN '320270'
	ELSE
ISNULL((SELECT TOP 1 StatusCode FROM dbo.Custom_CitizensBank_Status_Codes WITH (NOLOCK) WHERE DataID = m.id1 ORDER BY Statusdate DESC), '112010') END AS status_code,
current1 + current2 + current3 + current4 + current5 AS data_bal_total, 
current1 AS data_bal_principal, 
current2 as data_bal_interest, 
current3 as data_bal_court, 
current5 AS data_bal_attorney, 
current4 AS data_bal_other, 
0.00 AS fee_recovery
--,
--ISNULL(CONVERT(VARCHAR(10), lastpaid, 101), '') AS lastpayment,
--lastpaidamt AS lastpaymentamt
FROM master m WITH (NOLOCK)
WHERE customer IN ('0001110', '0001111', '0001112')
AND closed IS NULL








END


GO
