SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   PROCEDURE [dbo].[Custom_Report_Resurgent_KeyIndicator]
AS

DECLARE @justDate datetime

SET @justDate = DATEADD(day, 0, DATEDIFF(day, 0, GETDATE()))

SELECT c.CustomText1 customer, 
	SUM(COALESCE(LastMonth.TotalPaid, 0)) GrossLastMonth,
	SUM(COALESCE(a.NumAccounts, 0)) NumAccounts, 
	SUM(COALESCE(a.Inventory, 0)) Inventory,
	SUM(COALESCE(PendingRCX.ActiveAccts, 0)) PendingRCX
FROM customer c LEFT JOIN 
	(SELECT customer, COUNT(*) NumAccounts, SUM(current1) Inventory
	FROM master WITH (NOLOCK) INNER JOIN status ON status = code
	WHERE customer IN (SELECT CustomerID FROM Fact WITH (NOLOCK) WHERE CustomGroupID = 24) 
		AND statustype = '0 - ACTIVE'
	GROUP BY customer) a  
	ON a.customer = c.customer LEFT JOIN 
	(SELECT customer, SUM(CASE 
		WHEN batchtype IN ('PU', 'PC', 'DA', 'PA') THEN totalpaid 
		ELSE -totalpaid END) totalpaid
	FROM payhistory WITH (NOLOCK)
	WHERE customer IN (SELECT CustomerID FROM Fact WITH (NOLOCK) WHERE CustomGroupID = 24) AND 
		MONTH(datepaid) = MONTH(DATEADD(month, -1, GETDATE())) AND 
		YEAR(datepaid) = YEAR(DATEADD(month, -1, GETDATE()))
	GROUP BY customer) LastMonth
	ON c.customer = LastMonth.customer LEFT JOIN
	(SELECT customer, COUNT(*) ActiveAccts
	FROM master WITH (NOLOCK) INNER JOIN status ON status = code
	WHERE customer  IN (SELECT CustomerID FROM Fact WITH (NOLOCK) WHERE CustomGroupID = 24) AND
		received <= DATEADD(month, -6, @justDate) AND 
		lastpaid <= DATEADD(day, -60, @justDate) AND
		statustype = '0 - ACTIVE'
	GROUP BY customer) PendingRCX 
	ON c.customer = PendingRCX.customer
WHERE c.customer IN (SELECT CustomerID FROM Fact WITH (NOLOCK) WHERE CustomGroupID = 24) AND c.customer >= '0000825'
GROUP BY c.CustomText1




GO
