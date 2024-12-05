SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 02/08/2021
-- Description:	Export accounts placed on hold due to chargeoff date being old
-- Changes:	
--				04/05/2023 BGM Updated to new layout provided by US Bank.
--		07/03/2023 Updated to customer group 382
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_Export_CO_Hold_Daily_Issues] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
	
-- exec Custom_USBank_CACS_Export_CO_Hold_Daily_Issues '20230404', '20230404'

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @CustGroupID INT
--SET @CustGroupID = 382 --Production
SET @CustGroupID = 113 --Test	

    -- Insert statements for procedure here
	SELECT FORMAT(GETDATE(), 'MM/dd/yy') AS [Date Agency Reported], 'SIMM' AS [Agency Name], FORMAT(m.received, 'MM/dd/yy') AS [Date Received], account, m.name, 
	'' AS ATTY, '' AS BK, '' AS DEC, '' AS SCRA, '' AS NURSEHOME, '' AS DEBTMGMT, '' AS POA, '' AS CEE, '' AS DEE, '' AS INCARCERATED, '' AS CCCS, '' AS PIF, 'Y' AS OTHER,
	'research for RMS payments' AS ACCOUNTISSUE,  CASE (SELECT TOP 1 RIGHT(thedata, 4) FROM dbo.MiscExtra WITH (NOLOCK)  WHERE number = m.number AND title = 'pla.0.placementlevel')
	WHEN 'ASED' THEN 'DECEASED'
	WHEN 'ECEA' THEN 'DECEASED'
	ELSE (SELECT TOP 1 RIGHT(thedata, 4) FROM dbo.MiscExtra WITH (NOLOCK)  WHERE number = m.number AND title = 'pla.0.placementlevel')
	end AS [Additional Notes], 
	'' AS [Attachments],
   '' AS [USB Response]
--DATEADD(dd, 2, GETDATE()), 'Open', '', DATEADD(dd, 1, GETDATE()), account, Name,  '', '', '', '', '', '', '', '', '', 'research for RMS payments'
FROM dbo.master m WITH (NOLOCK) 
WHERE customer IN (Select customerid from fact where customgroupid = @CustGroupID)
AND CAST(received AS date) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE) AND status = 'HLD' AND ChargeOffDate <= '20191101'
AND closed IS NULL

END
GO
