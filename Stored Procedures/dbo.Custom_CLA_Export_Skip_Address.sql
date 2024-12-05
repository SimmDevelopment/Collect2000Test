SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 9/4/2019
-- Description:	Export Placement Acknowledgement File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CLA_Export_Skip_Address]
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
'2' AS DataType,
'' AS Address1,
'' AS Address2,
'' AS City,
'' AS STATE,
'' AS Zip
	

FROM Services_CPE sc WITH (NOLOCK) INNER JOIN ServiceHistory sh WITH (NOLOCK) ON sc.RequestId = sh.RequestID
	INNER JOIN master m WITH (NOLOCK) ON sh.AcctID = m.number
WHERE m.customer = '0001101' AND CAST(sh.ReturnedDate AS DATE) between CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)


END
GO
