SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 08/18/2019
-- Description:	Sends back information when a phone number is allowed or not allowed to be called
--		Due to be sent to Citizens between 11 p.m. and 12 a.m. nightly Monday - Saturday
-- Changes: 10/2/2019 BGM - Updated to use notes result codes that were created for specifically consent grant/revoke.
--			12/18/2019 BGM Put in hour check to ensure the proper days data is sent, after midnight will default to previous date
--			12/18/2019 BGM Added insert into custom table for History to use in exceptions report.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Citizens_FP_Export_Daily_TCPA]
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

SELECT m.account AS account, SUBSTRING(CONVERT(VARCHAR(MAX), comment), 2, 10) AS phonenumber, CASE WHEN result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP') THEN 'N' ELSE 'Y' END AS allow
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer = '0002226'
AND created BETWEEN @startDate AND @endDate
AND result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP')


INSERT INTO Custom_Citizens_FP_TCPA_Sent ( FileDate, Account, PhoneNumber, Allow, NoteCreated, FileNumber, ResultCode )
SELECT @startDate, m.account AS account, SUBSTRING(CONVERT(VARCHAR(MAX), comment), 2, 10) AS phonenumber, CASE WHEN result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP') THEN 'N' ELSE 'Y' END AS allow,
n.created, n.number, n.result
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
WHERE m.customer = '0002226'
AND created BETWEEN @startDate AND @endDate
AND result IN ('CRNO', 'CRPY', 'CRWG', 'CRPP')


--SELECT m.account AS account, (SELECT TOP 1 OldNumber FROM PhoneHistory WITH (NOLOCK) WHERE m.number = accountid ORDER BY DateChanged DESC) AS phonenumber,
--CASE WHEN (SELECT TOP 1 phonestatusid from Phones_Master WITH (NOLOCK) WHERE m.number = Number 
--	AND PhoneNumber = (SELECT TOP 1 OldNumber FROM PhoneHistory WITH (NOLOCK) WHERE m.number = accountid ORDER BY DateChanged DESC)) IN (1,3) THEN 'N' ELSE 'Y' END AS allow
----CASE WHEN NewNumber = '' THEN ph.OldNumber ELSE NewNumber END AS phonenumber,
----CASE WHEN pm.PhoneStatusID = 1 THEN 'N' ELSE 'Y' END AS allow
--FROM master m WITH (NOLOCK) 
----INNER JOIN PhoneHistory ph WITH (NOLOCK) ON m.number = ph.AccountID
----	INNER JOIN Phones_Master pm WITH (NOLOCK) ON ph.OldNumber = pm.PhoneNumber AND m.number = pm.Number
--WHERE customer = '0002226' 
----AND DateChanged BETWEEN @startDate AND @endDate
--AND m.number IN (SELECT accountid FROM PhoneHistory ph2 WITH (NOLOCK) WHERE DateChanged BETWEEN @startDate AND @endDate)
	
END
GO
