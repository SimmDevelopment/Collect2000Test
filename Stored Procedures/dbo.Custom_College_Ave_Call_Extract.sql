SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 06/06/2023
-- Description:	Retrieve College Ave Call details by date range
-- =============================================
CREATE PROCEDURE [dbo].[Custom_College_Ave_Call_Extract] 
	-- Add the parameters for the stored procedure here

	@startDate DATE,
	@endDate DATE

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  FORMAT([ReportDate], 'yyyy-MM-dd') AS [ReportDate]
      ,[Bucket]
      ,ISNULL([SEQID_LOAN], '') AS [SEQID_LOAN]
      ,ISNULL([SEQID_BORROWER], '') AS [SEQID_BORROWER]
      ,ISNULL([Number], '') AS [Number]
      ,[CallType]
      ,FORMAT([CallTime], 'yyyy-MM-dd HH:mm:ss.fff') AS [CallTime]
      ,[DOW]
      ,[CallId]
      ,ISNULL([PHONE_NUMBER], '') AS [PHONE_NUMBER]
      ,ISNULL([PhoneOwner], 'Unknown') AS [PhoneOwner]
      ,[PhoneSource]
      ,[CallSource]
      ,[Contacts]
      ,[OBContacts]
      ,[IBContacts]
      ,[RPCs]
      ,[OBRPCs]
      ,[IBRPCs]
      ,[PTP_Payments]
      ,[OBPTP_Payments]
      ,[IBPTP_Payments]
      ,[Benefits]
      ,[OBBenefits]
      ,[IBBenefits]
      ,[Transferred]
      ,[LeftMessage]
  FROM [DCLatitude].[CollegeAve].[CallExtractHistorical]
  WHERE CAST(adddate AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
END
GO
