SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[sp_SBT_Daily_Download_Trg]
AS
BEGIN
	declare @StartDateTime datetime2 = getdate(),
	@LogProcessType nvarchar(255) = 'SQL Server Procedure',
	@LogProcessName nvarchar(255) = 'SBT Daily Download', 
	@LogFlowName nvarchar(255) = 'SBT Daily Download',
	@LogProcedureName nvarchar(255) = OBJECT_NAME(@@PROCID);
	
	EXEC Automate_Log 
    @ProcessType = @LogProcessType, 
    @ProcessName = @LogProcessName, 
	@FlowName = @LogFlowName,
    @StartTime = @StartDateTime, 
    @Status = 'Exec Procedure Start', 
    @Message = @LogProcedureName

    DECLARE @obj INT
    DECLARE @responseText NVARCHAR(1000)
    DECLARE @body NVARCHAR(4000)
    DECLARE @url NVARCHAR(1000) = 'https://prod-70.westus.logic.azure.com:443/workflows/8760a1992acb4bc5982c202bb49d60f0/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=r3Un31m9UQjzMmQhwfE1VH-EWf5BwYYXSyItoqG1kDk'
    DECLARE @httpStatus INT

    -- Initialize the payload
	SET @body = '{"DesktopFlow":"' + @LogFlowName + '"}'

    -- Create a WinHTTPRequest object
    EXEC sp_OACreate 'WinHttp.WinHttpRequest.5.1', @obj OUT

    -- Set timeout (optional)
    EXEC sp_OAMethod @obj, 'SetTimeouts', NULL, 5000, 5000, 5000, 5000

    -- Open an HTTP connection
    EXEC sp_OAMethod @obj, 'Open', NULL, 'POST', @url, FALSE

    -- Set request headers (indicating the content type as JSON)
    EXEC sp_OAMethod @obj, 'SetRequestHeader', NULL, 'Content-Type', 'application/json'

    -- Send the request with the body
    EXEC sp_OAMethod @obj, 'Send', NULL, @body

    -- Get the HTTP status
    EXEC sp_OAGetProperty @obj, 'Status', @httpStatus OUT

    -- Optional: Get the response (if needed)
    EXEC sp_OAGetProperty @obj, 'ResponseText', @responseText OUT

    -- Clean up and destroy the object
    EXEC sp_OADestroy @obj

    -- Check if the request was successful
    IF @httpStatus <> 202
    BEGIN
        RAISERROR('Failed to make the HTTP request. Status code: %d. Response: %s', 16, 1, @httpStatus, @responseText)

		DECLARE @ErrorMessageText nvarchar(256) = 'Failed to make the HTTP request. Status code: ' + CAST(@httpStatus AS NVARCHAR) + '. Response: ' + @responseText;

		EXEC Automate_Log 
		@ProcessType = @LogProcessType, 
		@ProcessName = @LogProcessName, 
		@FlowName = @LogFlowName,
		@EndTime = @StartDateTime,
		@Status = 'Exec Procedure Error', 
		@Message = @LogProcedureName,
		@ErrorMessage = @ErrorMessageText;
    END
	ELSE
	BEGIN
		EXEC Automate_Log 
		@ProcessType = @LogProcessType, 
		@ProcessName = @LogProcessName, 
		@FlowName = @LogFlowName,
		@EndTime = @StartDateTime,
		@Status = 'Exec Procedure End', 
		@Message = @LogProcedureName
	END
END
GO
