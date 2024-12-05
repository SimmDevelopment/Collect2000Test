SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 01/26/2023
-- Description:	Sends Maintenance Data
-- Changes:		03/24/2023 BGM Added start date end date for Received date and added separate table to supply the UTC Date
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Retured_Equabli_Export_Maintenance_3old]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate


--Parther Rank Reconciliation
	SELECT 'opresponse' AS record_type, m.id2 AS account_id, m.id1 AS client_account_number, 
	(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.client_id') AS client_id, 
	(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.0.client_consumer_number') AS client_consumer_number,
(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.0.consumer_id') AS consumer_id,
(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'opr.0.request_number') AS request_number,
--(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'opr.0.request_source') 
'PT' AS response_source,
--(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'opr.0.request_source_id') 
'1' AS response_source_id,
'SS' AS response_status, 
(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'opr.0.description') AS [description],
FORMAT(getdate(), 'yyyy-MM-dd') AS dt_response
FROM master m WITH (NOLOCK) 
WHERE customer IN (Select customerid from fact where customgroupid = 381) AND status = 'ccr' AND CAST(m.returned AS DATE) = CAST(DATEADD(dd, -1, GETDATE()) AS DATE)


--Parther Rank Reconciliation
	SELECT 'partnerrankinfo' AS record_type, m.id2 AS account_id, m.id1 AS client_account_number, 
	(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.client_id')AS client_id
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'ran.0.client_latest_job_schedu') AS partner_job_schedule_id
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'ran.0.dt_score') AS dt_confirm
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'ran.0.partner_id') AS partner_id
FROM master m WITH (NOLOCK) 
WHERE m.customer IN (Select customerid from fact where customgroupid = 381)  


END
GO
