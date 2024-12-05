SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



CREATE    PROCEDURE [dbo].[Custom_CreditSolutions_Report_Remit]
@startDate datetime,
@endDate datetime

AS

SELECT UID AHTRNID, m.account [AHACT#], CONVERT(varchar, datepaid, 112) AHENTD, FirstName MSFNM,
	LastName MSLNM, m.street1 MSADR1, m.street2 MSADR2, m.city MSCTY,
	m.state MSST, m.zipcode MSZIP, m.homephone MSHPH, AdjInvoicedPaid - AdjInvoicedFee AHRMAMT,
	AdjInvoicedFee AHRMFEE, CONVERT(varchar, GETDATE(), 101) AHDPDTE,
	CONVERT(varchar, entered, 112) AMDPDTE, 'XSI' AHBY, 
	CASE 
		WHEN status in ('SIF', 'PIF') THEN '501'
		ELSE '' END
	AHMEMO
FROM Custom_PaymentsView p INNER JOIN master m
	ON p.number = m.number INNER JOIN Debtors d
	ON m.number = d.number AND d.seq = 0
WHERE entered BETWEEN @startDate AND @endDate AND batchtype IN ('PU', 'PUR') AND p.customer IN ('0000935','0000936','0000937','0000938')
GO
