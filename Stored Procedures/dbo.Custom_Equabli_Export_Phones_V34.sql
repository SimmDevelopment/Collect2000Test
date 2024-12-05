SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G. Meehan
-- Create date: 12/06/2023
-- Description:	Export via Exchange Phones doc for Equabli
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_Phones_V34]
	-- Add the parameters for the stored procedure here
	@startDate DATE,
	@endDate DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	Exec Custom_Equabli_Export_Phones_V34 '20231205', '20231207'

SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate

    -- Insert statements for procedure here
	SELECT 'phone' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.equabliClientID') AS equabliClientId
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Con.' + CONVERT(VARCHAR(2), d.Seq) + '.clientConsumerNumber') AS clientConsumerNumber
, d.DebtorMemo AS equabliConsumerId
, '' AS phoneNumber
, '' AS phoneType
, '' AS wirelessIndicator
, '' AS isPrimary
, '' AS doNotCallFlag
, '' AS consentFlag
, '' AS consentDateTime
, '' AS phoneStatus
, '' AS phoneUpdateDateTime
, '' AS smsConsentFlag
, '' AS smsConsentDate
, '' AS externalSystemId
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
LEFT OUTER JOIN Deceased d1 WITH (NOLOCK) ON d.DebtorID = d1.DebtorID
LEFT OUTER JOIN Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
LEFT OUTER JOIN MiscExtra me WITH (NOLOCK) ON m.number = me.Number AND me.Title = 'OpR.0.requestSource'	
LEFT OUTER JOIN MiscExtra me1 WITH (NOLOCK) ON m.number = me1.Number AND me1.Title = 'OpR.0.requestSourceID'	
LEFT OUTER JOIN MiscExtra me2 WITH (NOLOCK) ON m.number = me2.Number AND me2.Title = 'OpR.0.responseDate'	
WHERE customer IN (3101, 3102, 3103, 3104, 3105)
AND ((m.status IN ('DEC', 'BKY', 'B07', 'B11', 'B13', 'CND', 'CAD', 'MIL', 'RSK', 'FRD')
AND CAST(closed AS DATE) BETWEEN @startdate AND @endDate))
END
GO
