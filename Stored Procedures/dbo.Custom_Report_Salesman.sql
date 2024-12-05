SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Custom_Report_Salesman]
@salesmanCode varchar(30)
AS


DECLARE @today datetime
DECLARE @totals TABLE (TotalAccts int, TotalReceived money, TotalFee money, CommissionPercent int, 
	[Type] int)


SET @today = DATEADD(day, 0, DATEDIFF(day, 0, GETDATE()))

--Today
INSERT @totals 
SELECT COUNT(*), 
	SUM(dbo.Custom_ReversePaymentSign( dbo.Custom_CalculatePaymentTotalPaid(p.uid), p.batchtype)),
	SUM(dbo.Custom_CalculatePaymentTotalFee(p.uid)),
	CASE 
		WHEN DATEDIFF(year, m.received, GETDATE()) >= 2 THEN 2
		WHEN DATEDIFF(year, m.received, GETDATE()) >= 1 THEN 3
		ELSE 5
	END, 
	1
FROM payhistory p WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK)
	ON c.customer = p.customer INNER JOIN master m WITH (NOLOCK)
	ON p.number = m.number
WHERE entered = @today AND c.SalesmanCode = @salesmanCode
GROUP BY CASE 
	WHEN DATEDIFF(year, m.received, GETDATE()) >= 2 THEN 2
	WHEN DATEDIFF(year, m.received, GETDATE()) >= 1 THEN 3
	ELSE 5
END


--MTD
INSERT @totals 
SELECT COUNT(*), 
	SUM(dbo.Custom_ReversePaymentSign( dbo.Custom_CalculatePaymentTotalPaid(p.uid), p.batchtype)),
	SUM(dbo.Custom_CalculatePaymentTotalFee(p.uid)),
	CASE 
		WHEN DATEDIFF(year, m.received, GETDATE()) >= 2 THEN 2
		WHEN DATEDIFF(year, m.received, GETDATE()) >= 1 THEN 3
		ELSE 5
	END, 2
FROM payhistory p WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK)
	ON c.customer = p.customer INNER JOIN master m WITH (NOLOCK)
	ON p.number = m.number
WHERE MONTH(entered) = MONTH(GETDATE()) AND YEAR(entered) = YEAR(GETDATE()) AND c.SalesmanCode = @salesmanCode
GROUP BY CASE 
	WHEN DATEDIFF(year, m.received, GETDATE()) >= 2 THEN 2
	WHEN DATEDIFF(year, m.received, GETDATE()) >= 1 THEN 3
	ELSE 5
END

--Previous Month
INSERT @totals 
SELECT COUNT(*), 
	SUM(dbo.Custom_ReversePaymentSign( dbo.Custom_CalculatePaymentTotalPaid(p.uid), p.batchtype)),
	SUM(dbo.Custom_CalculatePaymentTotalFee(p.uid)),
	CASE 
		WHEN DATEDIFF(year, m.received, GETDATE()) >= 2 THEN 2
		WHEN DATEDIFF(year, m.received, GETDATE()) >= 1 THEN 3
		ELSE 5
	END, 3
FROM payhistory p WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK)
	ON c.customer = p.customer INNER JOIN master m WITH (NOLOCK)
	ON p.number = m.number
WHERE MONTH(datepaid) = MONTH(DATEADD(month, -1, GETDATE())) AND 
	YEAR(datepaid) = YEAR(DATEADD(month, -1, GETDATE())) AND c.SalesmanCode = @salesmanCode
GROUP BY CASE 
	WHEN DATEDIFF(year, m.received, GETDATE()) >= 2 THEN 2
	WHEN DATEDIFF(year, m.received, GETDATE()) >= 1 THEN 3
	ELSE 5
END

--YTD
INSERT @totals 
SELECT COUNT(*), 
	SUM(dbo.Custom_ReversePaymentSign( dbo.Custom_CalculatePaymentTotalPaid(p.uid), p.batchtype)),
	SUM(dbo.Custom_CalculatePaymentTotalFee(p.uid)),
	CASE 
		WHEN DATEDIFF(year, m.received, GETDATE()) >= 2 THEN 2
		WHEN DATEDIFF(year, m.received, GETDATE()) >= 1 THEN 3
		ELSE 5
	END, 4
FROM payhistory p WITH (NOLOCK) INNER JOIN customer c WITH (NOLOCK)
	ON c.customer = p.customer INNER JOIN master m WITH (NOLOCK)
	ON p.number = m.number
WHERE YEAR(entered) = YEAR(GETDATE()) AND c.SalesmanCode = @salesmanCode
GROUP BY CASE 
	WHEN DATEDIFF(year, m.received, GETDATE()) >= 2 THEN 2
	WHEN DATEDIFF(year, m.received, GETDATE()) >= 1 THEN 3
	ELSE 5
END

DECLARE @i int
SET @i = 1

WHILE @i <= 4
BEGIN	
	SELECT TotalAccts, TotalReceived, TotalReceived/TotalAccts Average, TotalFee, 
		CASE [Type]
			WHEN 1 THEN 'Today'
			WHEN 2 THEN 'MTD'
			WHEN 3 THEN 'Previous Month'
			WHEN 4 THEN 'YTD'
		END [Time], CONVERT(varchar, CommissionPercent) + '%' [Commission%], 
		TotalFee * (CommissionPercent / 100.0) Commmission
	FROM @totals
	WHERE Type = @i 
	ORDER BY Type, CommissionPercent

	SET @i = @i + 1
END 
GO
