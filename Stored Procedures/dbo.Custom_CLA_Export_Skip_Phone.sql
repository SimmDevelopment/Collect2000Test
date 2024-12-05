SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 9/4/2019
-- Description:	Export Placement Acknowledgement File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CLA_Export_Skip_Phone]
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
'1' AS DataType,
pm.PhoneNumber AS Phone,
CASE WHEN pt.phonetypeid = 1 THEN '4'
	WHEN pt.phonetypeid = 2 THEN '5'
	WHEN pt.phonetypeid = 3 THEN '7' 
	WHEN pt.Phonetypeid = 57 THEN '10'
	WHEN pt.PhoneTypeMapping = 2 AND pt.phonetypeid NOT IN (3, 57) THEN '11' 
	WHEN pt.phonetypedescription LIKE '%skip%' THEN '9'
	ELSE '6' END AS PhoneType,
CASE WHEN pm.PhoneStatusID IS NULL THEN 1 WHEN pm.phonestatusid = 2 THEN '2' ELSE '3' END  AS Status
	

FROM Phones_Master pm WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK) ON pm.Number = m.number
	INNER JOIN Phones_Types pt WITH (NOLOCK) ON pm.PhoneTypeID = pt.PhoneTypeID
WHERE m.customer = '0001101' AND CAST(pm.DateAdded AS DATE) between CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
AND (LoginName NOT IN ('SYNC', '') OR requestid IS NOT NULL)



END
GO
