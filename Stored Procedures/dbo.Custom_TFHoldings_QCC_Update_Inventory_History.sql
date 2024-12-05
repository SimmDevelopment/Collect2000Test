SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 11/2/2022
-- Description:	Updates the history table with the current dates inventory amounts
-- =============================================
CREATE PROCEDURE [dbo].[Custom_TFHoldings_QCC_Update_Inventory_History]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Load Inventory History Table for the input efficiency report
IF EXISTS(SELECT TOP 1 CAST(productiondate AS DATE) FROM Custom_TFHoldings_Inventory_History ccfih WITH (NOLOCK) WHERE CAST(productiondate AS DATE) = CAST(GETDATE() AS DATE) AND [stream] = 'QCC')
		BEGIN
		
			 UPDATE Custom_TFHoldings_Inventory_History
			 SET Total_Inventory = c.total_inv
			 FROM (SELECT COUNT(*) AS total_inv
			 FROM Custom_TF_Holdings_QCC_Import_Active_Accounts cthqiaa  WITH (NOLOCK)) c
			 WHERE CAST(ProductionDate AS DATE) = CAST(GETDATE() AS DATE) AND [Stream] = 'QCC'
	   END
	ELSE
	   BEGIN
	  
			INSERT INTO Custom_TFHoldings_Inventory_History (ProductionDate, Total_Inventory, [Stream])
			SELECT CAST(GETDATE() AS DATE), COUNT(*) AS num_placed, 'QCC'
			FROM Custom_TF_Holdings_QCC_Import_Active_Accounts cthqiaa WITH (NOLOCK)
	   END




END
GO
