SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G. Meehan
-- Create date: 12/08/2023
-- Description:	Export via Exchange AcEmployer doc for Equabli
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_AcEmployer_V34]
	-- Add the parameters for the stored procedure here
	@startDate DATE,
	@endDate DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	Exec Custom_Equabli_Export_AcEmployer_V34 '20231205', '20231207'

SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate

    -- Insert statements for procedure here
	SELECT 'acemployer' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.equabliClientID') AS equabliClientId
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Con.' + CONVERT(VARCHAR(2), d.Seq) + '.clientConsumerNumber') AS clientConsumerNumber
, d.DebtorMemo AS equabliConsumerId
, '' AS employerName
, '' AS employerAddress1
, '' AS employerAddress2
, '' AS employerCity
, '' AS employerState
, '' AS employerZipCode
, '' AS employerCountry
, '' AS employerPhone
, '' AS employerFax
, '' AS consumerIdentificationNumber
, '' AS employerEmployeeFirstName
, '' AS employerEmployeeMiddleName
, '' AS employerEmployeeLastName
, '' AS employerPosition
, '' AS employerTitle
, '' AS employerCode
, '' AS employerManager
, '' AS employerEmployeeId
, '' AS employerDisclaimer
, '' AS employerPayrollDisclaimer
, '' AS employerWageBasis
, '' AS employerStatus
, '' AS employerDivisionCode
, '' AS employerEffectiveDate
, '' AS employerMostRecent
, '' AS employerLength
, '' AS employerTerminiation
, '' AS employerIsActive
, '' AS employerId
, '' AS amtConsumerWages
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
