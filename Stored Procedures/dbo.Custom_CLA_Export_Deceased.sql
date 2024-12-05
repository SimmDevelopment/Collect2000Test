SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 9/4/2019
-- Description:	Export Placement Acknowledgement File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CLA_Export_Deceased]
	-- Add the parameters for the stored procedure here
	@startDate DATETIME,
	@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT (SELECT customtext1 FROM customer WITH (NOLOCK) WHERE customer = m.customer) AS AgencyCode,
m.id2 AS PlacementID,
(SELECT TOP 1 REPLACE(thedata, '-', '/') FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'pla.0.DatePlaced') AS PlaceDate,
m.id1 AS AccountNumber, 
m.account AS OriginalAccount,
CASE WHEN d.seq = 0 THEN '1' ELSE '2' END AS RecordType,
CONVERT(VARCHAR(10), d2.DOD, 101) AS DOD,
'' AS DeathCertificate,
'' AS FuneralHome,
d.city AS CityofDeath,
d.County AS CountyofDeath,
d.State AS StateofDeath,
d2.Executor AS ContactName
FROM Deceased d2 WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON d2.DebtorID = d.DebtorID
 INNER JOIN master m WITH (NOLOCK) ON d.Number = m.number
WHERE m.customer = '0001101' AND CAST(closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
AND m.status = 'DEC'



END
GO
