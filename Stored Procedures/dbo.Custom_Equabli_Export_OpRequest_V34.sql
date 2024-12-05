SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G. Meehan
-- Create date: 12/06/2023
-- Description:	Export via Exchange OpRequest doc for Equabli
-- Changes:		12/18/2023 BGM Updated requestNumber to pull ID number from Status Change.
--				01/04/2023 BGM Updaetd RequestStatus to send IN when request is initiated by Simm.
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_OpRequest_V34]
	-- Add the parameters for the stored procedure here
	@startDate DATE,
	@endDate DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	Exec Custom_Equabli_Export_OpRequest_V34 '20231201', '20231219'

SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate

    -- Insert statements for procedure here
	SELECT 'oprequest' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.equabliClientID') AS equabliClientId
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Con.' + CONVERT(VARCHAR(2), d.Seq) + '.clientConsumerNumber') AS clientConsumerNumber
, d.DebtorMemo AS equabliConsumerId
, (SELECT TOP 1 'SM' + RIGHT(CONVERT(VARCHAR(10), sh.ID), 4) FROM StatusHistory sh WITH (NOLOCK) WHERE sh.AccountID = m.number AND sh.NewStatus IN ('DEC', 'BKY', 'B07', 'B11', 'B13', 'CND', 'CAD', 'MIL', 'RSK', 'FRD', 'LIT')
	AND CAST(sh.DateChanged AS DATE) BETWEEN @startdate AND @endDate ORDER BY sh.DateChanged DESC) AS requestNumber
, 'PR' AS requestType
, CASE WHEN m.status = 'DEC' THEN 'DEC'
		WHEN m.status IN ('BKY', 'B07', 'B11', 'B13') OR (m.closed IS NULL AND CAST(b.UpdatedDate AS DATE) BETWEEN @startdate AND @endDate) THEN 'BRC'
		WHEN m.status IN ('CND', 'CAD') THEN 'CND'
		WHEN m.status = 'MIL' THEN 'MLT'
		WHEN m.status IN ('RSK', 'LIT') THEN 'LIT'
		WHEN m.status = 'FRD' THEN 'FRD'
		END AS queueReasonCode
, '' AS description
, ISNULL(me.TheData, 'PT') AS requestSource
, ISNULL(me1.TheData, '')  AS requestSourceId
, FORMAT(ISNULL(CAST(me2.TheData AS DATE), getdate()), 'yyyy-MM-dd') AS requestDate
, FORMAT(@endDate, 'yyyy-MM-dd') AS fulfillmentDate
, CASE WHEN ISNULL(me.TheData, 'PT') = 'PT' THEN 'IN' ELSE 'SS' END AS requestStatus
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
LEFT OUTER JOIN Deceased d1 WITH (NOLOCK) ON d.DebtorID = d1.DebtorID
LEFT OUTER JOIN Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
LEFT OUTER JOIN MiscExtra me WITH (NOLOCK) ON m.number = me.Number AND me.Title = 'OpR.0.requestSource'	
LEFT OUTER JOIN MiscExtra me1 WITH (NOLOCK) ON m.number = me1.Number AND me1.Title = 'OpR.0.requestSourceID'	
LEFT OUTER JOIN MiscExtra me2 WITH (NOLOCK) ON m.number = me2.Number AND me2.Title = 'OpR.0.responseDate'
LEFT OUTER JOIN MiscExtra me3 WITH (NOLOCK) ON m.number = me3.Number AND me3.Title = 'OpR.0.requestNumber'	
WHERE customer IN (3101, 3102, 3103, 3104, 3105)
AND ((m.status IN ('DEC', 'BKY', 'B07', 'B11', 'B13', 'CND', 'CAD', 'MIL', 'RSK', 'FRD', 'LIT')
AND CAST(closed AS DATE) BETWEEN @startdate AND @endDate))
END

GO
