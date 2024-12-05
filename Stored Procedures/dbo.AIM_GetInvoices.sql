SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[AIM_GetInvoices]
@startDate datetime,
@endDate datetime

AS
DECLARE @companyName varchar(30)
SELECT @companyName = Company FROM ControlFile

SELECT 
LedgerInvoiceID as [Invoice ID],
CASE LI.PortfolioID WHEN -1 THEN 'Mixed' ELSE P.Code END as [Portfolio Code],
Buyers as [Has Buyers],
Sellers as [Has Sellers],
Investors as [Has Investors],
Management as [Has Management],
InvoiceDate as [Date Invoiced]
FROM AIM_LedgerInvoice LI WITH (NOLOCK) LEFT OUTER JOIN AIM_Portfolio P WITH (NOLOCK)
ON P.PortfolioId = LI.PortfolioID
WHERE
LI.InvoiceDate between @startDate and @endDate



SELECT
LIS.LedgerInvoiceID as [Invoice ID],
CASE LIS.GroupID WHEN -1 THEN 'Unknown' WHEN 0 THEN @companyName ELSE G.Name END as [Group Name],
SumCredit as [Credit Total],
SumDebit as [Debit Total],
Net as [Net Total],
Gross as [Gross Total],
Outstanding as [Balance Outstanding]

FROM AIM_LedgerInvoiceSummary LIS WITH (NOLOCK) JOIN AIM_LedgerInvoice LI WITH (NOLOCK)
ON LI.LedgerInvoiceID = LIS.LedgerInvoiceID LEFT OUTER JOIN AIM_Group G WITH  (NOLOCK) ON G.GroupId = LIS.GroupID

WHERE 
LI.InvoiceDate between @startDate and @endDate





GO
