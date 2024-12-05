SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



CREATE    PROCEDURE [dbo].[Custom_Report_Target_Payment]
@invoice varchar(255)

as


SELECT dbo.FormatIBMNumeric(SUM(dbo.Custom_ReversePaymentSign(dbo.Custom_CalculatePaymentTotalPaid(uid), batchtype))
		, 10) TotalPaid,
	COUNT(*) TotalCount 
FROM payhistory WITH (NOLOCK)
WHERE customer = '0000856' AND batchtype IN ('PU', 'PUR') 
	and invoice in (select string from dbo.CustomStringToSet(@invoice, '|'))

--Modified by Brian Meehan 8/2/2007 for new fee on NSF commision
--Modified by Brian Meehan 8/24/2007 removed reverse payment sign from commision amount and tran amount
--Modified by Brian Meehan 9/12/2007 Changed PUR and NSF scenario to trancode value of 56 from 57 undone
--Modified by Brian Meehan 9/19/2007 changed subbatchtype to pick up the paytype instead for NSF
SELECT datepaid TranDate, account AccountNumber, CASE 
	WHEN batchtype = 'PU' THEN '55'
	WHEN batchtype = 'PUR' AND paytype = 'Paid Us Reversal - NSF' THEN '57' 
	ELSE '56' END TranCode, 
	'TranAmount' = case when batchtype = 'PUR' then dbo.FormatIBMNumeric(dbo.Custom_reversePaymentSign(dbo.Custom_CalculatePaymentTotalPaid(uid), batchtype), 10) else dbo.FormatIBMNumeric(dbo.Custom_CalculatePaymentTotalPaid(uid), 10) end,
	--dbo.FormatIBMNumeric(dbo.Custom_CalculatePaymentTotalPaid(uid), 10) TranAmount,
	'CommAmount' = case when batchtype = 'PUR' then dbo.FormatIBMNumeric((dbo.Custom_CalculatePaymentTotalPaid(uid) * .7), 10) else dbo.FormatIBMNumeric(fee1, 10) end,
	CASE WHEN paytype = 'Paid Us Reversal - NSF' THEN 
		(SELECT datepaid FROM payhistory WHERE UID = h.ReverseOfUID) END OrigPayDate,
	'1EBX' AgencyCode, '10' ProductType
FROM payhistory h WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK)
	ON h.number = m.number 
WHERE h.customer = '0000856' AND batchtype IN ('PU', 'PUR') 
	AND invoice  in (select string from dbo.CustomStringToSet(@invoice, '|'))

/*
SELECT datepaid TranDate, account AccountNumber, CASE 
	WHEN batchtype = 'PU' THEN '55'
	WHEN batchtype = 'PUR' AND paytype = 'Paid Us Reversal - NSF' THEN '57' 
	ELSE '56' END TranCode, 
	dbo.FormatIBMNumeric(dbo.Custom_CalculatePaymentTotalPaid(uid), 10) TranAmount,
	'CommAmount' = case when batchtype = 'pur' then dbo.FormatIBMNumeric(dbo.Custom_ReversePaymentSign((dbo.Custom_CalculatePaymentTotalPaid(uid) * .7), batchtype), 10) else dbo.FormatIBMNumeric(fee1, 10) end,
	CASE WHEN paytype = 'Paid Us Reversal - NSF' THEN 
		(SELECT datepaid FROM payhistory WHERE UID = h.ReverseOfUID) END OrigPayDate,
	'1EBX' AgencyCode, '10' ProductType
FROM payhistory h WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK)
	ON h.number = m.number 
WHERE h.customer = '0000856' AND batchtype IN ('PU', 'PUR') 
	AND entered BETWEEN @startDate AND @endDate
*/
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
