SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create    VIEW [dbo].[DC_IVRSalliePayInfo]
AS

SELECT dbo.master.number AS ppFileNumber, dbo.master.customer AS ppClientCode, 
	CAST(es.CurrentMinDue AS varchar) AS ppamount, 
	dbo.master.Name AS ppFullName, '' AS ppCCNumber, '' AS ppCCExpDate, '' AS ppCCCW2, '' AS ppCheckRoutingNumber, '' AS ppCheckAccountNumber, 
        '' AS ppCheckNumber, RIGHT(RTRIM(dbo.master.SSN), 4) AS ppSS, 
	c.Name AS ppCustomerName, dbo.master.SSN AS ppFullSSN, f.CustomGroupID as ppCustomGroupID
FROM dbo.master WITH (nolock) 
INNER JOIN dbo.EarlyStageData as es WITH (nolock) ON dbo.master.number = es.AccountID
LEFT OUTER JOIN
dbo.Customer AS c WITH (nolock) ON dbo.master.customer = c.customer
LEFT OUTER JOIN
dbo.fact as f WITH (nolock) on dbo.master.customer = f.customerid 


GO
