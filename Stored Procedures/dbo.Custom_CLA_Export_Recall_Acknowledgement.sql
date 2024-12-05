SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 9/4/2019
-- Description:	Export Placement Acknowledgement File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CLA_Export_Recall_Acknowledgement]
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
CONVERT(VARCHAR(10), m.closed, 101) AS CloseDate,
'RECALL' AS Status,
m.current0 AS CurrentBalance,
m.original AS OriginalBalance,
ABS(m.paid) AS TotalPaid,
m.number AS AgencyAccount

FROM master m WITH (NOLOCK)
WHERE m.customer = '0001101' AND CAST(m.Returned AS DATE) between CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)



END
GO
