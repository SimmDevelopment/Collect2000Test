SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 08/18/2019
-- Description:	Sends information back about emails and cell text messages being allowed or not
-- Changes:		03/10/2021 BGM Added to pull the OB Call fields instead of hard coding them as 0
--				03/11/2021 BGM Updated OBDownloads, OBCallableDownloads, OBRPC, OBPTP, OBMessagesLeft back to 0 as they are included in calculations
--				03/30/2021 BGM Moved outbound field changes from 3/11 back to individual fields again.
--				04/07/2021 BGM Added column OB MobileComplyCallsPlaced as OBPredictiveCallsPlaced.  Changed MCallsPlaced to be the same file instead of TotalMCcalls placed.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Citizens_FP_Export_InputEfficiency] 
	-- Add the parameters for the stored procedure here
	@Date AS DATETIME
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT TOP 1  ProductionDate, '' AS Inventory, IBCallsOffered, IBCallsAccepted, IBRPC, IBServiceLevel, IBPTP, IBTrueAbandon,
        IBShortAbandon, IBAvgAbandonTime, IBAHT, IBAgentHours,  OBDownloads, OBCallableDownloads, OBMobileComplyCallsPlaced AS OBPredictiveCallsPlaced,
        0 AS OBBlasterCallsPlaced, OBConnects AS OBConnects, OBRPC, OBPTP, OBAbandons AS OBAbandons, OBMessagesLeft, OBAHT AS OBAHT,
        OBIdleHours AS OBIdleHours, OBAgentHours AS OBAgentHours, 
  --      (SELECT COUNT(*) FROM master m WITH (NOLOCK) WHERE customer = '0002226' AND status NOT IN ('hld', 'mhd', 'whd', 'nhd') 
		--AND CAST(received AS DATE) <= CAST(DATEADD(dd, -1, @Date) AS DATE)  AND (closed IS NULL or CAST(closed AS DATE) = CAST(@Date AS DATE) )) 
		--OBDownloads + ISNULL(MDownloads, 0) AS MDownloads, 
		ISNULL(MDownloads, 0) AS MDownloads,
		--OBCallableDownloads + ISNULL(MCallAbleDownloads, 0) AS MCallAbleDownloads, 
		ISNULL(MCallAbleDownloads, 0) AS MCallAbleDownloads, 
		MCallsPlaced, 
		--OBRPC + 
		MRPC AS MRPC, 
		MPTP AS MPTP, 
		--OBMessagesLeft + MMessagesLeft AS MMessagesLeft
		MMessagesLeft AS MMessagesLeft
FROM DCLatitude.Citizens.CitizensInputEfficiency ie WITH (NOLOCK)
WHERE CAST(ProductionDate AS DATE) = CAST(DATEADD(dd, -1, @Date) AS DATE)
ORDER BY AddDate DESC
	
END
GO
