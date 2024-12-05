SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Brian G Meehan
-- Create date: 03/22/2023
-- Description:	Exports Payments to Exchange for Equabli
-- Changes:
--	04/14/2023 BGM Added UTC Date to header
--	04/14/2023 BGM Move to production
--  10/20/2023 BGM Updated dt_payment for NSF entries to return the original payment date that the payment was made.
--	12/08/2023 BGM Converted to Version 3.4
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Equabli_Export_Payments_V34]
	-- Add the parameters for the stored procedure here
	@invoice VARCHAR(8000)

--  Exec Custom_Equabli_Export_Payments_V34 '23401'

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT FORMAT(GETUTCDATE(), 'yyyyMMddHHmmss') AS utcdate


    -- Insert statements for procedure here
	SELECT 'payment' AS recordType
	, m.id2 AS equabliAccountNumber
	, m.id1 AS clientAccountNumber
	, (SELECT TOP 1 TheData from MiscExtra WITH (NOLOCK) WHERE number = m.number and Title = 'acc.0.equabliClientId') AS equabliClientId
	, ISNULL(ISNULL((SELECT p1.ArrangementID FROM pdc p1 WITH (NOLOCK) WHERE p1.number = m.number AND p.PaymentLinkUID = p1.PaymentLinkUID AND P.SubBatchType = 'PDC'), (SELECT dcc.ArrangementID FROM DebtorCreditCards dcc WITH (NOLOCK) WHERE dcc.number = m.number AND p.PaymentLinkUID = dcc.PaymentLinkUID AND P.SubBatchType = 'PCC')), '') AS paymentPlanId 
	, ISNULL(ISNULL((SELECT r.rowserial FROM (SELECT ROW_NUMBER() OVER(ORDER BY p2.deposit ASC) AS rowserial, p2.PaymentLinkUID FROM pdc p2 WITH (NOLOCK) WHERE p2.arrangementid = (SELECT p1.arrangementid FROM pdc p1 WITH (NOLOCK) WHERE p1.number = m.number AND p1.PaymentLinkUID = p.PaymentLinkUID  AND p.SubBatchType = 'PDC')) r WHERE r.PaymentLinkUID = p.paymentlinkuid)
	, (SELECT d.rowserial FROM (SELECT ROW_NUMBER() OVER(ORDER BY dcc.DepositDate ASC) AS rowserial, dcc.PaymentLinkUID FROM DebtorCreditCards dcc WITH (NOLOCK) WHERE dcc.arrangementid = (SELECT dcc1.arrangementid FROM DebtorCreditCards dcc1 WITH (NOLOCK) WHERE dcc1.number = m.number AND dcc1.PaymentLinkUID = p.PaymentLinkUID  AND p.SubBatchType = 'PCC')) d WHERE d.PaymentLinkUID = p.paymentlinkuid)), '') AS paymentSerial
	, p.totalpaid AS paymentAmount
	, CASE WHEN (SELECT createdby FROM pdc WITH (NOLOCK) WHERE P.postdateuid = uid) = 'PayWeb' THEN 'BI' WHEN (SELECT createdby FROM debtorcreditcards dcc WITH (NOLOCK) WHERE P.postdateuid = uid) = 'PayWeb' THEN 'CI' ELSE CASE p.paymethod WHEN 'CASH' THEN 'CS' WHEN 'CHECK' THEN 'BM' WHEN 'MONEY ORDER' THEN 'MO' WHEN 'WESTERN UNION' THEN 'WU' WHEN 'CREDIT CARD' THEN 'CP' WHEN 'PAPER DRAFT' THEN 'BP'
			WHEN 'ACH DEBIT' THEN 'BP' WHEN 'POST-DATED CHECK' THEN 'BP' WHEN 'BANK WIRE' THEN 'WR' WHEN 'SAVINGS ACH' THEN 'BP' WHEN 'MONEY GRAM' THEN 'MG'ELSE 'OT' END END AS paymentMethod
	, CASE WHEN batchtype LIKE '%R' THEN (SELECT FORMAT(p1.datepaid, 'yyyy-MM-dd') FROM payhistory p1 WHERE p1.UID = p.ReverseOfUID) ELSE FORMAT(p.datepaid, 'yyyy-MM-dd') END AS paymentDate
	, CASE p.batchtype WHEN 'PU' THEN 'C' ELSE 'V' END AS paymentStatus
	, CASE p.batchtype WHEN 'PU' THEN 'N' ELSE 'F' END AS paymentType
	, FORMAT(p.BatchPmtCreated, 'yyyy-MM-dd') AS postingDate
	, p.balance AS updatedAcctBalance
	, CASE WHEN batchtype = 'PUR' THEN 'NS' ELSE '' END AS brokenReason
	, CASE WHEN p.SubBatchType = 'PCC' THEN (SELECT dcc.AuthCode FROM DebtorCreditCards dcc WITH (NOLOCK) WHERE dcc.number = m.number AND p.PaymentLinkUID = dcc.PaymentLinkUID AND P.SubBatchType = 'PCC') ELSE '' END  AS approvalCode
	, p.BatchNumber AS partnerBatchNumber
	, p.UID AS postingNumber
	, CASE p.SubBatchType WHEN 'PCC' THEN 'USAePay_PayScout' WHEN 'PDC' THEN 'VeriCheck' ELSE '' END AS paymentVendor
	, ISNULL((SELECT COUNT(*) FROM (SELECT p2.number, p2.Active FROM pdc p2 WITH (NOLOCK) WHERE p2.arrangementid = (SELECT p1.arrangementid FROM pdc p1 WITH (NOLOCK) WHERE p1.number = m.number AND p1.PaymentLinkUID = p.PaymentLinkUID  AND p.SubBatchType = 'PDC')) r WHERE r.active = 1)
	, (SELECT COUNT(*) FROM (SELECT dcc.Number, dcc.IsActive FROM DebtorCreditCards dcc WITH (NOLOCK) WHERE dcc.arrangementid = (SELECT dcc1.arrangementid FROM DebtorCreditCards dcc1 WITH (NOLOCK) WHERE dcc1.number = m.number AND dcc1.PaymentLinkUID = p.PaymentLinkUID  AND p.SubBatchType = 'PCC')) d WHERE D.IsActive = 1)) AS balancePaymentCount
	, p.paid1 AS principalAmount
	, p.paid2 AS interestAmount
	, p.paid3 AS lateFeeAmount
	, p.paid4 AS otherFeeAmount
	, p.paid8 AS courtCostAmount
	, p.paid5 AS attorneyFeeAmount
	, '' AS externalSystemId
	, CASE WHEN batchtype = 'PU' THEN CONVERT(VARCHAR(15), p.UID) ELSE '' END AS partnerSystemId
	, CASE WHEN batchtype LIKE '%r' THEN CONVERT(VARCHAR(15), p.ReverseOfUID) ELSE '' END AS reversalParentId
	, '' AS closureCode
	, CASE WHEN P.CollectorFee > 0 THEN 'Y' ELSE 'N' END AS isCommissionable
	, '' AS paymentSource

FROM master m WITH (NOLOCK) INNER JOIN payhistory p WITH (NOLOCK) ON m.number = P.number
WHERE p.batchtype LIKE 'PU%' 
AND invoice IN (select string from dbo.CustomStringToSet(@invoice,'|'))
END

GO
