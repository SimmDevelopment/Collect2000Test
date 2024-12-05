SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_Export_VOD_Request]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
DECLARE @begDate DATETIME
DECLARE @stopDate DATETIME

SET @begDate = dbo.F_START_OF_DAY(@startDate)
SET @stopDate = DATEADD(ss, -3, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

SELECT m.account AS [Account Number], m.ContractDate AS [Statement Date], DATEADD(dd, -1, m.ChargeOffDate) AS [Statement Date],
CASE m.customer WHEN '0001747' THEN 'Tert' WHEN '0001748' THEN 'Tert' WHEN '0001749' THEN 'Probate' ELSE m.customer END AS Portfolio
FROM master m WITH (NOLOCK)
where customer IN (SELECT customerid FROM fact WITH (NOLOCK) WHERE CustomGroupID = 113)
AND status IN ('DSP') AND (SELECT TOP 1 datechanged FROM StatusHistory WITH (NOLOCK) WHERE AccountID = m.number AND NewStatus IN ('DSP') ORDER BY DateChanged DESC)
BETWEEN @begDate AND @stopDate

END
GO
