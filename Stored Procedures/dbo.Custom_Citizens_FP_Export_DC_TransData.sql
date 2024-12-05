SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan Ft. SQL Steve (Dial Connection)
-- Create date: 11/30/2022
-- Description:	Stored procedure to generate TransData File from DC Table data
-- File due between 12 a.m. and 1 a.m.
-- =============================================

CREATE PROCEDURE [dbo].[Custom_Citizens_FP_Export_DC_TransData]
	-- Add the parameters for the stored procedure here
	
	--EXEC Custom_Citizens_FP_Export_DC_TransData
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ProductionDate DATE

--------Use current date if the process runs prior to midnight of current production date, else use previous date for the production date-----
SET @ProductionDate = CASE WHEN DATEPART(hh, GETDATE()) BETWEEN 22 AND 23 THEN CAST(GETDATE() AS DATE) ELSE CAST(DATEADD(dd, -1, GETDATE()) AS DATE) END


SELECT TRN_JOBNUM
	 , TRN_DATE
	 , TRN_TIME
	 , TRN_WAITTIME
	 , TRN_USERFIELD
	 , TRN_COMPCODE
	 --, TRN_RECNUM
	 , TRN_PHONENUM
	 , TRN_AGENTNAME
	 , TRN_RECALLCNT
	 , TRN_TALKTIME
	 , TRN_WORKTIME
	 , TRN_V_TO_HANG
	 , TRN_OFF_TO_HNG
	 , TRN_CONNECT
	 , TRN_UPDATETIME
	 , TRN_PREVTIME
	 , TRN_AGCOMPCODE
	 , TRN_LOGTYPE
	 , PHN_ID
	 , PHN_TYPE
	 , ALLOW
	 , HOME_PH
	 , WORK_PH
	 --, RecordKey
	 --, SourceTable
	 --, SourceSequence 
FROM [DCLatitude].[Citizens].[TransDataFileWorking]
WHERE TRN_DATE = CAST(@ProductionDate AS DATE)
	

END
GO
