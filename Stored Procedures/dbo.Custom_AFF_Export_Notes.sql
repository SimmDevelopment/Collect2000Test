SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_AFF_Export_Notes] 
	-- Add the parameters for the stored procedure here
	@startdate DATETIME,
	@enddate DATETIME	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))



SELECT m.id1, d.DebtorMemo, n.uid, n.result, n.user0, CONVERT(VARCHAR(19), n.created, 126) + 'Z' AS [time], n.comment
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON n.number = m.number
INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.number AND d.seq = 0
WHERE m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = 103)
AND created BETWEEN @startdate AND @enddate AND user0 IN (SELECT loginname FROM Users u	WITH (NOLOCK) WHERE active = 1)


END
GO
