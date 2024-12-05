SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian Meehan
-- Create date: 12/02/2019
-- Description:	Created to only get financials for same day end of month.
-- Changes:		05/03/2021 BGM Added 00 to New Debits field for payments 300-2
--				05/03/2021 BGM Added blank to 300 records if no commision for affect field pos. 118
--				11/22/2021 BGM Replaced collectorfee with the fuction Custom_CalculatePaymentTotalFee(P.uid)
--				07/03/2023 Updated to customer group 382
-- =============================================
CREATE PROCEDURE [dbo].[Custom_USBank_CACS_TransAction_File_Outgoing_EOM_Payments] 
	-- Add the parameters for the stored procedure here
	--@startDate DATETIME,
	--@endDate DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
--exec Custom_USBank_CACS_TransAction_File_Outgoing_EOM_Payments '20230630', '20230630'
DECLARE @startdate DATETIME
DECLARE @endDate DATETIME

SET @startDate = GETDATE()
SET @endDate = GETDATE()

SET @startDate = dbo.F_START_OF_DAY(@startDate)
SET @endDate = DATEADD(ss, -1, dbo.F_START_OF_DAY(DATEADD(dd, 1, @endDate)))

SELECT @startDate AS FileDate
DECLARE @CustGroupID INT
--SET @CustGroupID = @CustGroupID --Production
SET @CustGroupID = 113 --Test	

--Gets Financials only
--Record 216 Paid Client
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '216' AS TransCode, CONVERT(VARCHAR(8), p.datepaid, 112) AS TransDate,
REPLACE(CONVERT(VARCHAR(18), p.totalpaid), '.', '') + '0000' AS AmountPaid, REPLACE(CONVERT(VARCHAR(18), dbo.Custom_CalculatePaymentTotalFee(P.uid)), '.', '') + '0000' AS CommissionAmt, 'SIMM    ' AS ThirdPartyID, '646' AS InputSRCcode, p.UID
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
AND batchtype = 'PC' AND invoiced IS NOT NULL
WHERE invoiced BETWEEN @startDate AND @endDate
AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID)

--Record 300-2 Paid Us
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '300' AS TransCode, CONVERT(VARCHAR(8), p.datepaid, 112) AS TransDate,
REPLACE(CONVERT(VARCHAR(18), p.totalpaid), '.', '') + '0000' AS AmountPaid, '00' AS NewDebits, '2' AS CatCode, 'SIMM    ' AS ThirdPartyID, REPLACE(CONVERT(VARCHAR(18), dbo.Custom_CalculatePaymentTotalFee(P.uid)), '.', '') + '0000' AS CommissionAmt,
'' AS BatchInfo, CASE WHEN dbo.Custom_CalculatePaymentTotalFee(P.uid) <> 0 THEN 'C' ELSE '' END AS Affect, CASE WHEN dbo.Custom_CalculatePaymentTotalFee(P.uid) <> 0 THEN 'Y' ELSE 'N' END AS WithheldComm, '646' AS InputSRCcode, '' AS ReferenceNum, p.UID
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
AND batchtype = 'PU' AND invoiced IS NOT NULL
WHERE invoiced BETWEEN @startDate AND @endDate
AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID)

--Record 217 Paid Client Reversal
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '217' AS TransCode, CONVERT(VARCHAR(8), p.datepaid, 112) AS TransDate,
REPLACE(CONVERT(VARCHAR(14), p.totalpaid), '.', '') + '0000' AS AmountPaid, REPLACE(CONVERT(VARCHAR(18), dbo.Custom_CalculatePaymentTotalFee(P.uid)), '.', '') + '0000' AS CommissionAmt, 'SIMM    ' AS ThirdPartyID, '646' AS InputSRCcode, p.UID
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
AND batchtype = 'PCR' AND invoiced IS NOT NULL
WHERE invoiced BETWEEN @startDate AND @endDate
AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID)

--Record 300-1 Paid Us Reversal (Non-NSF) aka correction.
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '300' AS TransCode, (SELECT top 1 CONVERT(VARCHAR(8), datepaid, 112) FROM payhistory WITH (NOLOCK) WHERE UID = p.ReverseOfUID) AS TransDate,
REPLACE(CONVERT(VARCHAR(18), p.totalpaid), '.', '') + '0000' AS AmountPaid, '1' AS NewDebits, '1' AS CatCode, 'SIMM    ' AS ThirdPartyID, REPLACE(CONVERT(VARCHAR(18), dbo.Custom_CalculatePaymentTotalFee(P.uid)), '.', '') + '0000' AS CommissionAmt,
'' AS BatchInfo, CASE WHEN dbo.Custom_CalculatePaymentTotalFee(P.uid) <> 0 THEN 'C' ELSE '' END AS Affect, CASE WHEN dbo.Custom_CalculatePaymentTotalFee(P.uid) <> 0 THEN 'Y' ELSE 'N' END AS WithheldComm, '646' AS InputSRCcode, '' AS ReferenceNum, p.UID
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
AND batchtype = 'PUR' AND invoiced IS NOT NULL AND IsCorrection = 1
WHERE invoiced BETWEEN @startDate AND @endDate
AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID)

--Record 700 Paid Us Reversal (NSF)
SELECT DISTINCT id2 AS LocationCode, m.account AS Acctnumber, '700' AS TransCode, (SELECT top 1 CONVERT(VARCHAR(8), datepaid, 112) FROM payhistory WITH (NOLOCK) WHERE UID = p.ReverseOfUID) AS TransDate,
REPLACE(CONVERT(VARCHAR(18), p.totalpaid), '.', '') + '0000' AS AmountPaid, 'SIMM    ' AS ThirdPartyID, REPLACE(CONVERT(VARCHAR(18), dbo.Custom_CalculatePaymentTotalFee(P.uid)), '.', '') + '0000' AS CommissionAmt,
'' AS BatchInfo, '' AS OrigTrans, CASE WHEN dbo.Custom_CalculatePaymentTotalFee(P.uid) <> 0 THEN 'Y' ELSE 'N' END AS WithheldComm, '646' AS InputSRCcode, '' AS ReferenceNum, p.UID
FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = p.number
AND batchtype = 'PUR' AND invoiced IS NOT NULL AND IsCorrection = 0
WHERE invoiced BETWEEN @startDate AND @endDate
AND m.customer IN (SELECT customerid FROM Fact f WITH (NOLOCK) WHERE CustomGroupID = @CustGroupID)


END
GO
