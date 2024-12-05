SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[Custom_TransUnion_Analysis]
@startDate datetime,
@endDate datetime

AS


SELECT lastname, firstname, middlename, d.Street1, d.Street2, d.city, d.state, d.zipcode, d.ssn, received,
	original, current0, m.customer,
	SUM(CASE WHEN DATEDIFF(month, received, datepaid) <= 1 THEN p.InvoicedPaid ELSE 0 END) Month1,
	SUM(CASE WHEN DATEDIFF(month, received, datepaid) = 2 THEN p.InvoicedPaid ELSE 0 END) Month2,
	SUM(CASE WHEN DATEDIFF(month, received, datepaid) = 3 THEN p.InvoicedPaid ELSE 0 END) Month3,
	SUM(CASE WHEN DATEDIFF(month, received, datepaid) = 4 THEN p.InvoicedPaid ELSE 0 END) Month4,
	SUM(CASE WHEN DATEDIFF(month, received, datepaid) = 5 THEN p.InvoicedPaid ELSE 0 END) Month5,
	SUM(CASE WHEN DATEDIFF(month, received, datepaid) = 6 THEN p.InvoicedPaid ELSE 0 END) Month6
FROM master m WITH (NOLOCK) INNER JOIN Debtors d WITH (NOLOCK)
	ON m.number = d.number AND d.seq = 0 LEFT JOIN Custom_PaymentsView p
	ON m.number = p.number
WHERE received BETWEEN @startDate AND @endDate AND m.customer IN
	(SELECT CustomerID FROM Fact WHERE CustomGroupID IN (24, 36, 27, 26, 28, 19, 30, 40, 34, 32, 67))
	AND COALESCE(p.batchtype, 'PU') = 'PU'
GROUP BY m.number, lastname, firstname, middlename, d.Street1, d.Street2, d.city, d.state, d.zipcode, d.ssn, received,
	original, current0, m.customer
ORDER BY m.number



GO
