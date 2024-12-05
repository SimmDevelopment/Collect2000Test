SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/06/2023
-- Description:	Export OpResponse file to Equibli
-- Changes:		03/24/2023 BGM Added start date end date for Received date and added separate table to supply the UTC Date
--			09/07/2023 BGM Updated to send on all returned accounts, removed CCR requirement, updated description to also send queue reason on AcStatusChange records.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_OpResponse_Export_3old]
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
	SELECT 'opresponse' AS record_type, m.id2 AS account_id, m.id1 AS client_account_number, 
	(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.client_id') AS client_id, 
	(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.0.client_consumer_number') AS client_consumer_number,
(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'con.0.consumer_id') AS consumer_id,
ISNULL((SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'opr.0.request_number'), '') AS request_number,
--(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'opr.0.request_source') 
'PT' AS response_source,
--(SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'opr.0.request_source_id') 
'1' AS response_source_id,
'SS' AS response_status, 
ISNULL((SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'opr.0.description'),
ISNULL((SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acs.0.queue_reason'), '')) AS [description],
FORMAT(getdate(), 'yyyy-MM-dd') AS dt_response
FROM master m WITH (NOLOCK) 
WHERE customer IN (Select customerid from fact where customgroupid = 381)   
--AND status = 'ccr' --Only pull accounts that are returned
AND CAST(m.returned AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

END
GO
