SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_POST_ToREST]
AS
BEGIN
    DECLARE @obj INT
    DECLARE @responseText NVARCHAR(1000)
    DECLARE @body NVARCHAR(4000)
    DECLARE @url NVARCHAR(1000) = 'https://prod-115.westus.logic.azure.com:443/workflows/2d0cce666be54c1f95e3b72ec871803a/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=t3vSrMCkMkQQsbHnE4lcMU3hqjVej4PVXC1P0HRLIpo'
    DECLARE @httpStatus INT

    -- Initialize the payload
    SET @body = '{"TriggerInfo":"Success"}'

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
    END
END
GO
