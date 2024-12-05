SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 4/14/2020
-- Description:	Gets data for the US Bank Daily Monthly Report in Exchange
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Daily_Monthly_Export_Old]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  ProdDate, UniqueRPC, CASE WHEN NumPromise = 0 THEN 0 ELSE (CAST(NumBroken AS DECIMAL) / CAST(NumPromise AS DECIMAL) * 100) END AS PercentBroken, PayOnFirst, DeletedPromises, AvgPayment	
FROM Custom_USBank_Daily_Monthly cubdm WITH (NOLOCK)
WHERE ProdDate BETWEEN @startDate AND @endDate

END
GO
