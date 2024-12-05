SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 11/13/2024
-- Description:	Export Retured accounts by date closed
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Vivint_Export_Returns]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT m.account                      AS [Original Account Number]
	 , m.received AS [IP - Date Placed]
	 , m.original AS [IP - Balance]
	 , m.current0 AS [Balance Remaining]
FROM dbo.master m WITH (NOLOCK)
WHERE m.customer = 3116 
AND CAST(closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
AND status IN ('CCR', 'RCL')


END
GO
