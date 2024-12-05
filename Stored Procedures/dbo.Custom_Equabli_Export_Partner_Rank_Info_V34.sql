SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 01/26/2023
-- Description:	Sends Partner Rank Info
-- Changes:		12/8/2023 BGM Updated to version 3.4
--			
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_Partner_Rank_Info_V34]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	Exec Custom_Equabli_Export_Partner_Rank_Info_V34 '20231205', '20231207'


	SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate

    -- Insert statements for procedure here
	SELECT 'partnerrankinfo' AS recordType, id2 AS equabliAccountNumber, m.id1 AS clientAccountNumber,
	(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.client_id') AS equabliClientId
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'ran.0.client_latest_job_schedu') AS equabliClientId
, '' AS rankId
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'ran.0.dt_score') AS confirmedDate
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'ran.0.partner_id') AS equabliPartnerId
FROM master m WITH (NOLOCK) 
WHERE m.customer IN (Select customerid from fact where customgroupid = 381)  
AND CAST(received AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

END
GO
