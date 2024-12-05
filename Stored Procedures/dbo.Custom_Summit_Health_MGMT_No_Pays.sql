SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 04/06/2023
-- Description:	Export Return File to Summit Health
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Summit_Health_MGMT_No_Pays]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME
  , @endDate DATETIME

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for procedure here
	SELECT
	 m.account AS ChargeID
   , '1' AS [Action]
   , '' AS Amount
   , '' AS ReferenceNumber
   , '' AS Comment
   , '' AS procedureID
   , CASE WHEN status IN ('BKY', 'B07', 'B11', 'B13') THEN '102' WHEN status = 'DEC' THEN '103' WHEN status = 'SIF' THEN '105' ELSE '101' END AS ReturnReason
	FROM master m WITH (NOLOCK)
	WHERE customer = '0003090'
		  AND CAST(closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
		  AND status NOT IN ('PIF')

END
GO
