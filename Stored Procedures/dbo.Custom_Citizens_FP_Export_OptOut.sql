SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 08/18/2019
-- Description:	Sends information back about emails and cell text messages being allowed or not
--			12/18/2019 BGM Put in hour check to ensure the proper days data is sent, after midnight will default to previous date
--			10/06/2020 BGM Added new text and email opt out result codes.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Citizens_FP_Export_OptOut] 
	-- Add the parameters for the stored procedure here
	--@startDate AS DATETIME,
	--@endDate AS DATETIME
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @startDate DATETIME
	DECLARE @endDate DATETIME
	
SET @startDate = CASE WHEN DATEPART(hh, GETDATE()) BETWEEN 22 AND 23 THEN GETDATE() ELSE DATEADD(dd, -1, GETDATE()) END
SET @endDate = CASE WHEN DATEPART(hh, GETDATE()) BETWEEN 22 AND 23 THEN GETDATE() ELSE DATEADD(dd, -1, GETDATE()) END

--use below to set date to custom date when rerunning of the report is required
--SET @startDate = DATEADD(dd, -1, GETDATE())
--SET @endDate = DATEADD(dd, -1, GETDATE())


    -- Insert statements for procedure here
	SET @startDate = dbo.F_START_OF_DAY(@startDate)
	SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

	SELECT m.account AS Acct_Num, 'CARD' AS Product, REPLACE(CONVERT(VARCHAR(10), created, 101), '/', '') AS DateStamp,
	CASE WHEN n.result IN ('NTM', 'TSTOP') THEN REPLACE(CONVERT(VARCHAR(11), n.comment), '#', '') ELSE '' END AS Phone_Num, 
	CASE WHEN n.result = 'ESTOP' THEN ISNULL(d.Email, '') ELSE '' END AS Email, result
	FROM master m WITH (NOLOCK) INNER JOIN notes n WITH (NOLOCK) ON m.number = n.number
	INNER JOIN debtors d WITH (NOLOCK)  ON m.number = d.Number AND d.Seq = 0
	WHERE customer = '0002226' AND (n.result IN ('NTM', 'TSTOP') OR (n.result = 'ESTOP' AND email IS NOT NULL AND email <> ''))
	AND created BETWEEN @startDate AND @endDate
	
END
GO
