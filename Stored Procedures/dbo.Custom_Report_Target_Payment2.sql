SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO



CREATE    PROCEDURE [dbo].[Custom_Report_Target_Payment2]
@startDate datetime,
@endDate datetime

AS

SELECT dbo.FormatIBMNumeric(SUM(dbo.Custom_ReversePaymentSign(dbo.Custom_CalculatePaymentTotalPaid(uid), batchtype))
		, 10) TotalPaid,
	COUNT(*) TotalCount 
FROM payhistory WITH (NOLOCK)
WHERE customer = '0000856' AND batchtype IN ('PU', 'PUR') 
	AND entered BETWEEN @startDate AND @endDate

--Modified by Brian Meehan 8/2/2007 for new fee on NSF commision
--Modified by Brian Meehan 8/24/2007 removed reverse payment sign from commision amount
SELECT datepaid TranDate, account AccountNumber, CASE 
	WHEN batchtype = 'PU' THEN '55'
	WHEN batchtype = 'PUR' AND SubBatchType = 'NSF' THEN '57' 
	ELSE '56' END TranCode, 
	dbo.FormatIBMNumeric(dbo.custom_reversePaymentSign(dbo.Custom_CalculatePaymentTotalPaid(uid), batchtype), 10) TranAmount,
	'CommAmount' = case when batchtype = 'pur' then dbo.FormatIBMNumeric((dbo.Custom_CalculatePaymentTotalPaid(uid) * .7), 10) else dbo.FormatIBMNumeric(fee1, 10) end,
	CASE WHEN SubBatchType = 'NSF' THEN 
		(SELECT datepaid FROM payhistory WHERE UID = h.ReverseOfUID) END OrigPayDate,
	'1EBX' AgencyCode, '10' ProductType
FROM payhistory h WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK)
	ON h.number = m.number 
WHERE h.customer = '0000856' AND batchtype IN ('PU', 'PUR') 
	AND entered BETWEEN @startDate AND @endDate

/*
SELECT datepaid TranDate, account AccountNumber, CASE 
	WHEN batchtype = 'PU' THEN '55'
	WHEN batchtype = 'PUR' AND SubBatchType = 'NSF' THEN '57' 
	ELSE '56' END TranCode, 
	dbo.FormatIBMNumeric(dbo.Custom_ReversePaymentSign(dbo.Custom_CalculatePaymentTotalPaid(uid), batchtype), 10) TranAmount,
	dbo.FormatIBMNumeric(fee1, 10) CommAmount,
	CASE WHEN SubBatchType = 'NSF' THEN 
		(SELECT datepaid FROM payhistory WHERE UID = h.ReverseOfUID) END OrigPayDate,
	'1EBX' AgencyCode, '10' ProductType
FROM payhistory h WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK)
	ON h.number = m.number 
WHERE h.customer = '0000856' AND batchtype IN ('PU', 'PUR') 
	AND entered BETWEEN @startDate AND @endDate
	
*/
GO
