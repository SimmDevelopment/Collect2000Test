SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Automate_Log]
    @ProcessType NVARCHAR(255),
    @ProcessName NVARCHAR(255),
    @ProcessID NVARCHAR(255) = NULL,
    @StepName NVARCHAR(255) = NULL,
    @FlowName NVARCHAR(255) = NULL,
    @StartTime DATETIME2(7) = NULL,
    @EndTime DATETIME2(7) = NULL,
    @Status NVARCHAR(255) = NULL,
    @Message NVARCHAR(MAX) = NULL,
    @ErrorMessage NVARCHAR(MAX) = NULL,
    @Data1 NVARCHAR(MAX) = NULL,
    @Data2 NVARCHAR(MAX) = NULL,
    @Data3 NVARCHAR(MAX) = NULL
AS
BEGIN
    INSERT INTO Custom_Automate_Log
    (
        ProcessType,
        ProcessName,
        ProcessID,
        StepName,
        FlowName,
        StartTime,
        EndTime,
        Status,
        Message,
        ErrorMessage,
        Data1,
        Data2,
        Data3
    )
    VALUES
    (
        @ProcessType,
        @ProcessName,
        @ProcessID,
        @StepName,
        @FlowName,
        @StartTime,
        @EndTime,
        @Status,
        @Message,
        @ErrorMessage,
        @Data1,
        @Data2,
        @Data3
    );
END;
GO
