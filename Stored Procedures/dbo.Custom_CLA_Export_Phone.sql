SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 9/4/2019
-- Description:	Export Placement Acknowledgement File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CLA_Export_Phone]
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
CASE PhoneTypeMapping WHEN 0 THEN '4' WHEN 1 THEN '5' WHEN 2 THEN '7' ELSE '6' END AS PhoneType,
CASE PhoneStatusID WHEN 1 THEN '3' WHEN 2 THEN '2' ELSE '1' END AS PhoneStatus,
pm.PhoneNumber AS PhoneNumber
FROM Phones_Master pm WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON pm.DebtorID = d.DebtorID
 INNER JOIN master m WITH (NOLOCK) ON pm.Number = m.number
 INNER JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE m.customer = '0001101' AND CAST(pm.DateAdded AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
AND pm.LoginName NOT IN ('sync', '')

UNION ALL

SELECT (SELECT customtext1 FROM customer WITH (NOLOCK) WHERE customer = m.customer) AS AgencyCode,
(SELECT TOP 1 thedata FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'pla.0.PlacementID') AS PlacementID,
(SELECT TOP 1 REPLACE(thedata, '-', '/') FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'pla.0.DatePlaced') AS PlaceDate,
m.id1 AS AccountNumber, 
m.account AS OriginalAccount,
CASE WHEN d.seq = 0 THEN '1' ELSE '2' END AS RecordType,
CASE PhoneTypeMapping WHEN 0 THEN '4' WHEN 1 THEN '5' WHEN 2 THEN '7' ELSE '6' END AS PhoneType,
CASE PhoneStatusID WHEN 1 THEN '3' WHEN 2 THEN '2' ELSE '1' END AS PhoneStatus,
pm.PhoneNumber AS PhoneNumber
FROM PhoneHistory ph WITH (NOLOCK) INNER JOIN Phones_Master pm WITH (NOLOCK) ON ph.OldNumber = pm.PhoneNumber 
	INNER JOIN debtors d WITH (NOLOCK) ON pm.DebtorID = d.DebtorID
	INNER JOIN master m WITH (NOLOCK) ON pm.Number = m.number
	INNER JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE m.customer = '0001101' AND CAST(ph.DateChanged AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
--AND LoginName NOT IN ('sync', '')

END
GO
