SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Applied_Report_Productivity]
@startDate datetime,
@endDate datetime,
@customer varchar(8000)
AS


SET @startDate = '2/5/07'
SET @endDate = GETDATE()

SELECT COUNT(*) [Total Inventory]
FROM master m WITH (NOLOCK) INNER JOIN status s
	ON status = code
WHERE s.statustype = '0 - Active' AND customer = @customer

SELECT COUNT(*) [Contacts]
FROM notes n WITH (NOLOCK) INNER JOIN master m WITH (NOLOCK)
	ON n.number = m.number INNER JOIN result r
	ON n.result = r.code
WHERE customer = @customer and r.contacted = 1 AND DATEADD(day, 0, DATEDIFF(day, 0, created)) 
	BETWEEN @startDate AND @endDate

/*SELECT COUNT(*) + 
	(SELECT COUNT(*) 
	FROM notes n INNER JOIN master m
		ON n.number = m.number
	WHERE customer = '0000555' AND result IN ([Dials]
FROM DialerHistory WITH (NOLOCK) INNER JOIN master WITH (NOLOCK)
	ON number = AccountID
WHERE customer = '0000555'*/

SELECT SUM(Promises) Promises, SUM(a.Amount) Amount, SUM(current1) [Balances Affected]
FROM master WITH (NOLOCK) INNER JOIN	
	(SELECT AcctID, COUNT(*) [Promises], SUM(Amount) Amount
	FROM Promises p WITH (NOLOCK) 
	WHERE p.Customer = @customer AND Entered BETWEEN @startDate AND @endDate AND Active = 1
	GROUP BY AcctID) a
	ON number = a.AcctID

SELECT SUM([Check]) [Check By Phone], SUM(a.amount) Amount, SUM(current1) [Balances Affected]
FROM master m WITH (NOLOCK) INNER JOIN
	(SELECT number, COUNT(*) [Check], SUM(amount) Amount
	FROM pdc p WITH (NOLOCK)
	WHERE p.customer = @customer AND entered BETWEEN @startDate AND @endDate AND
		Active = 1
	GROUP BY number) a
	ON m.number = a.number


SELECT SUM(Promises) PromisesEOM, SUM(a.Amount) Amount, SUM(current1) [Balances Affected]
FROM master WITH (NOLOCK) INNER JOIN	
	(SELECT AcctID, COUNT(*) [Promises], SUM(Amount) Amount
	FROM Promises p WITH (NOLOCK) 
	WHERE p.Customer = @customer AND Entered NOT BETWEEN @startDate AND @endDate AND Active = 1
	GROUP BY AcctID) a
	ON number = a.AcctID

SELECT SUM([Check]) [Check By Phone EOM], SUM(a.amount) Amount, SUM(current1) [Balances Affected]
FROM master m WITH (NOLOCK) INNER JOIN
	(SELECT number, COUNT(*) [Check], SUM(amount) Amount
	FROM pdc p WITH (NOLOCK)
	WHERE p.customer = @customer AND entered NOT BETWEEN @startDate AND @endDate AND
		Active = 1
	GROUP BY number) a
	ON m.number = a.number
GO
