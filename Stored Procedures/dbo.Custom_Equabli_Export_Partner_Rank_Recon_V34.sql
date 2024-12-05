SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 01/26/2023
-- Description:	Sends Partner Rank Reconciliation Recon
-- Changes:		03/24/2023 BGM Added start date end date for Received date and added separate table to supply the UTC Date
--			
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_Partner_Rank_Recon_V34]
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
	SELECT 'partnerrankinfo' AS record_type, id2 AS account_id, m.id1 AS client_account_number,
	(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.client_id') AS client_id
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'ran.0.client_latest_job_schedu') AS partner_job_schedule_id
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'ran.0.dt_score') AS dt_confirm
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'ran.0.partner_id') AS partner_id

FROM master m WITH (NOLOCK) 
WHERE m.customer IN (Select customerid from fact where customgroupid = 381)  
AND CAST(received AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

END
GO
