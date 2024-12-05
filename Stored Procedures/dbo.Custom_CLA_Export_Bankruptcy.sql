SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 9/4/2019
-- Description:	Export Placement Acknowledgement File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CLA_Export_Bankruptcy]
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
b.CaseNumber AS CaseNumber,
CASE b.Chapter WHEN '7' THEN '52' WHEN '11' THEN '53' WHEN '12' THEN '54' WHEN '13' THEN '06' END AS Chapter,
CONVERT(VARCHAR(10), b.DateFiled, 101) AS FileDate,
CASE WHEN b.Status LIKE '%file%' THEN CONVERT(VARCHAR(10), b.DateFiled, 101) WHEN b.status LIKE '%dism%' THEN CONVERT(VARCHAR(10), b.DismissalDate, 101) WHEN b.status LIKE '%disc%' THEN CONVERT(VARCHAR(10), b.DischargeDate, 101) WHEN b.status LIKE '%conv%' THEN CONVERT(VARCHAR(10), b.DateFiled, 101) WHEN b.status LIKE '%close%' THEN CONVERT(VARCHAR(10), b.DismissalDate, 101) ELSE CONVERT(VARCHAR(10), b.DateFiled, 101) END AS StatusDate,
CASE WHEN b.Status LIKE '%file%' THEN '02' WHEN b.status LIKE '%dism%' THEN '15' WHEN b.status LIKE '%disc%' THEN '20' WHEN b.status LIKE '%conv%' THEN '30' WHEN b.status LIKE '%close%' THEN '99' ELSE '02' END AS Disposition
FROM Bankruptcy b WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON b.DebtorID = d.DebtorID
 INNER JOIN master m WITH (NOLOCK) ON d.Number = m.number
WHERE m.customer = '0001101' AND CAST(closed AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
AND m.status IN ('BKY', 'B07', 'B11', 'B12', 'B13')



END
GO
