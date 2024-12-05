SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Citizens_Export_Monthly_RPC_Bylastmonthplaced] 
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @startDate = dbo.F_START_OF_DAY(@startDate)
	SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

    -- Insert statements for procedure here
	SELECT '' AS agentid, dbo.GetLastName(LoginName) + ', ' + dbo.GetFirstName(LoginName) AS agentname, m.account AS account, '' AS countrycode, SUBSTRING(Telephone, 1, 3) AS areacode, SUBSTRING(Telephone, 4, 7) AS Phone, 
	CASE WHEN pv.Campaign_ID IN (SELECT CAMPAIGN_ID FROM DCLatitude..Campaign c 
		WITH (NOLOCK) WHERE OUTBOUND = 0	) THEN 'Inb' ELSE 'Out' end AS direction, RTRIM(pv.Duration) AS Duration,
	CONVERT(VARCHAR(10), pv.Date, 101) AS dateofcontact, CONVERT(VARCHAR(8), CallStartTime, 108) AS startofcontact, 
	pv.Sequence AS sessionid,Case when m.customer = '0002111' THEN '3801' when m.customer = '0002112' THEN '3802' when m.customer = '0002113' THEN '3803' end AS Tier
FROM DCLatitude..Prospect_Voice pv with (nolock) 
inner join DCLatitude..Prospect_CallHist pch with (nolock) on pv.ProspectCallHistId = pch.SEQUENCE
INNER JOIN master m WITH (NOLOCK) ON SUBSTRING(pch.RECORD_KEY, 1, 8) = m.number

--Change the date below to the date the calls were made
where convert(varchar(20),[date], 112) BETWEEN @startDate AND @endDate
--only get files for Citizens
AND len(pch.RECORD_KEY) <= 8 AND pch.RECORD_KEY IN (SELECT number FROM master m WITH (NOLOCK) WHERE customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 304))
AND ResultId IN (SELECT Result_ID FROM DCLatitude..Disposition d WITH (NOLOCK) WHERE Contact = 1)
AND dbo.date(m.received) BETWEEN dbo.date(@startDate) AND dbo.date(@endDate)
END
GO
