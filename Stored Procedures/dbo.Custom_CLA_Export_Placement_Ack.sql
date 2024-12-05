SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 9/4/2019
-- Description:	Export Placement Acknowledgement File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CLA_Export_Placement_Ack]
	-- Add the parameters for the stored procedure here
	@Date AS DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT (SELECT customtext1 FROM customer WITH (NOLOCK) WHERE customer = m.customer) AS AgencyCode,
m.id2 AS PlacementID,
(SELECT TOP 1 REPLACE(thedata, '-', '/') FROM MiscExtra WITH (NOLOCK) WHERE Number = m.number AND title = 'pla.0.DatePlaced') AS PlaceDate,
m.id1 AS AccountNumber, m.account AS OriginalAccount, m.original AS PlaceBalance, m.original1 AS PlacePrincipal, m.original2 AS PlaceInterest,
m.original3 AS PlaceCost, m.original4 AS PlaceOther, m.number AS AgencyAccount
FROM master m WITH (NOLOCK)
WHERE customer = '0001101' AND CAST(m.received AS Date) = CAST(@Date AS DATE)

END
GO
