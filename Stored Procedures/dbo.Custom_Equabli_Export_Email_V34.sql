SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G. Meehan
-- Create date: 12/06/2023
-- Description:	Export via Exchange Email doc for Equabli
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_Email_V34]
	-- Add the parameters for the stored procedure here
	@startDate DATE,
	@endDate DATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	Exec Custom_Equabli_Export_Email_V34 '20231220', '20231220'

SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate

    -- Insert statements for procedure here
	SELECT 'email' AS recordType
, m.id2 AS equabliAccountNumber
, m.id1 AS clientAccountNumber
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Acc.0.equabliClientID') AS equabliClientId
, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'Con.' + CONVERT(VARCHAR(2), d.Seq) + '.clientConsumerNumber') AS clientConsumerNumber
, d.DebtorMemo AS equabliConsumerId
, ISNULL(e.Email, '') AS emailAddress
, CASE WHEN e.TypeCd IN ('Work', 'B') THEN 'Y' ELSE 'N' END AS emailWorkFlag
, '' AS optoutFlag
, CASE WHEN  active = 0 THEN 'N' ELSE 'Y' END AS emailValidityFlag
, CASE e.ConsentGiven WHEN 1 THEN 'Y' WHEN 0 THEN 'N' ELSE '' END AS consentFlag
, ISNULL(FORMAT(e.ConsentDate, 'yyyy-MM-dd HH:mm:ss'), '') AS consentDateTime
, CASE WHEN e.Active = 1 AND e.[Primary] = 1 THEN 'A' WHEN e.Active = 0 AND e.ConsentGiven = 0 THEN 'D'
	WHEN e.StatusCd = 'Bad' THEN 'B' WHEN e.StatusCd = 'Unknown' THEN 'U' ELSE '' END AS statusCode
, CASE WHEN e.[Primary] = 1 THEN 'Y' ELSE 'N' END AS isPrimary
FROM master m WITH (NOLOCK) INNER JOIN debtors d WITH (NOLOCK) ON m.number = d.Number
INNER JOIN Email e WITH (NOLOCK) ON d.DebtorID = e.DebtorId
--LEFT OUTER JOIN Deceased d1 WITH (NOLOCK) ON d.DebtorID = d1.DebtorID
--LEFT OUTER JOIN Bankruptcy b WITH (NOLOCK) ON d.DebtorID = b.DebtorID
--LEFT OUTER JOIN MiscExtra me WITH (NOLOCK) ON m.number = me.Number AND me.Title = 'OpR.0.requestSource'	
--LEFT OUTER JOIN MiscExtra me1 WITH (NOLOCK) ON m.number = me1.Number AND me1.Title = 'OpR.0.requestSourceID'	
--LEFT OUTER JOIN MiscExtra me2 WITH (NOLOCK) ON m.number = me2.Number AND me2.Title = 'OpR.0.responseDate'	
WHERE customer IN (3101, 3102, 3103, 3104, 3105)
AND CAST(e.ModifiedWhen AS DATE) BETWEEN CAST(@startDate AS DATE) AND CAST(@endDate AS DATE)
END
GO
