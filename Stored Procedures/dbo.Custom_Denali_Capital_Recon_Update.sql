SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Denali_Capital_Recon_Update] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT DISTINCT id2 AS data_id, m.account AS pri_acctno, '112000' AS status_code,
current1 + current2 AS data_bal_total, current1 AS data_bal_principal, 0.00 as data_bal_interest, 0.00 as data_bal_court, 0.00 AS data_bal_attorney, 
0.00 AS data_bal_other, 0.00 AS fee_recovery
FROM master m WITH (NOLOCK)
WHERE customer IN ('0003108')
AND closed IS NULL








END


GO
