SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/23/2023
-- Description:	Exports OOS date updates
-- Changes:		03/24/2023 BGM Added start date end date for Received date and added separate table to supply the UTC Date
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Retired_Equabli_Export_Statute_V34] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate

    -- Insert statements for procedure here
		SELECT TOP 1 'statute' AS record_type
	, m.id2 AS account_id
	, m.id1 AS client_account_number
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.client_id') AS client_id
	, FORMAT(noah.OOSDate, 'yyyy-MM-dd') AS dt_statute
	FROM master m WITH (NOLOCK) INNER JOIN Native_OOS_AccountHistory noah WITH (NOLOCK) ON noah.number = m.number
WHERE m.customer IN (Select customerid from fact where customgroupid = 381)  
AND CAST(noah.DateCalculated AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) 
AND CAST(noah.OOSDate AS DATE) <> (SELECT TOP 1 CAST(TheData AS DATE) from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.dt_statute') 
ORDER BY noah.DateCalculated DESC

END
GO
