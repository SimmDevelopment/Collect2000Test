SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 9/4/2019
-- Description:	Export Placement Acknowledgement File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CLA_Export_Address]
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
d.name AS DebtorName,
d.Street1 AS Address1,
d.street2 AS Address2,
d.city AS City,
d.state AS STATE,
d.Zipcode AS Zip
FROM AddressHistory ah WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON ah.DebtorID = d.DebtorID
 INNER JOIN master m WITH (NOLOCK) ON ah.AccountID = m.number
WHERE m.customer = '0001101' AND CAST(ah.DateChanged AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)

END
GO
