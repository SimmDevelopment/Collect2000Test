SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 9/4/2019
-- Description:	Export Placement Acknowledgement File
-- =============================================
CREATE PROCEDURE [dbo].[Custom_CLA_Export_Account_Status]
	-- Add the parameters for the stored procedure here
	
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
CASE WHEN m.STATUS IN ('BKY', 'B07', 'B11', 'B12', 'B13') THEN 'ABKT'
	WHEN m.STATUS IN ('DSP') THEN 'ADSP'
	WHEN m.STATUS IN ('DEC') THEN 'ADEC'
	WHEN m.STATUS IN ('PIF') THEN 'APIF'
	WHEN m.STATUS IN ('SIF') THEN 'ASIF'
	WHEN m.STATUS IN ('PPA', 'PDC', 'PCC') THEN 'APPA'
	WHEN m.STATUS IN ('RFP') THEN 'ARTP'  
	ELSE  'AUNC' END AS StatusCode
	

FROM master m WITH (NOLOCK) 
WHERE m.customer = '0001101' AND (CAST(closed AS DATE) IS NOT NULL 
OR status IN ('PPA', 'PDC', 'PCC', 'DSP') OR (status = 'SIF' AND CAST(closed AS DATE) <= CAST(DATEADD(dd, -14, GETDATE()) AS DATE)))




END
GO
