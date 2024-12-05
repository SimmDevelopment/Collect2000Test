SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_SelectLedgerEntriesByDateRange]
@startDate datetime,
@endDate datetime,
@groupType int

AS
--GROUP TYPE = 0 for Buyers 1 for Sellers
--LEDGER TYPEIDS for Buyers = 22,30,31,32,33,34
-- for Sellers = 24,4,5,18,29,19
if(@groupType = 0)
BEGIN


SELECT
p.Code as [Purchase Code],
s.Code as [Sold Code],
G.Name,
lt.Name as [Type],
L.LedgerID,
'Pending' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Debit as [Amount],
[Comments] = max(cast(L.Comments as varchar(50))),
[Days To Expire Purchase] = datediff(d,getdate(),max(ld.recourseperioddays)+p.contractdate),
[Days To Expire Sold] = datediff(d,getdate(),max(ld.recourseperioddays)+s.contractdate),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date],
ToInvoiceID as [Buyer Invoice ID],
FromInvoiceID as [Investor Invoice ID],
toli.InvoiceDate as [Buyer Invoice Date],
fromli.InvoiceDate as [Investor Invoice Date]
FROM
AIM_Ledger L WITH (NOLOCK)
JOIN AIM_Group G WITH (NOLOCK) ON L.ToGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number
JOIN AIM_Portfolio p WITH (NOLOCK) ON p.PortfolioID = M.PurchasedPortfolio
LEFT OUTER JOIN AIM_Portfolio s WITH (NOLOCK) ON s.portfolioid = m.soldportfolio
JOIN AIM_LedgerType lt WITH (NOLOCK) ON L.ledgertypeid = lt.ledgertypeid
JOIN AIM_LedgerDefinition ld WITH (NOLOCK) ON p.PortfolioID = ld.PortfolioId and ld.ledgertypeid in (4,5)
LEFT OUTER JOIN AIM_LedgerInvoice toli WITH (NOLOCK) ON L.ToInvoiceID = toli.LedgerInvoiceID
LEFT OUTER JOIN AIM_LedgerInvoice fromli WITH (NOLOCK) ON L.FromInvoiceID = fromli.LedgerInvoiceID
WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (22,30,31,32,33,34) AND L.Status = 'Pending'

GROUP BY S.Code,p.Code,p.contractdate,G.Name,lt.Name,L.LedgerID,L.Number,M.Account,M.Name,M.SSN,L.Debit,S.contractdate,L.DateEntered,L.DateCleared,ToInvoiceID,FromInvoiceID,toli.InvoiceDate,fromli.InvoiceDate
SELECT
p.Code as [Purchase Code],
s.Code as [Sold Code],
G.Name,
lt.Name as [Type],
L.LedgerID,
'Approved' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Debit as [Amount],
[Comments] = max(cast(L.Comments as varchar(50))),
[Days To Expire Purchase] = datediff(d,getdate(),max(ld.recourseperioddays)+p.contractdate),
[Days To Expire Sold] = datediff(d,getdate(),max(ld.recourseperioddays)+s.contractdate),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date],
ToInvoiceID as [Buyer Invoice ID],
FromInvoiceID as [Investor Invoice ID],
toli.InvoiceDate as [Buyer Invoice Date],
fromli.InvoiceDate as [Investor Invoice Date]

FROM
AIM_Ledger L WITH (NOLOCK) JOIN AIM_Group G WITH (NOLOCK) ON L.ToGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number
JOIN AIM_Portfolio p WITH (NOLOCK) ON p.PortfolioID = M.PurchasedPortfolio
LEFT OUTER JOIN AIM_Portfolio s WITH (NOLOCK) ON s.portfolioid = m.soldportfolio
JOIN AIM_LedgerType lt WITH (NOLOCK) ON L.ledgertypeid = lt.ledgertypeid
JOIN AIM_LedgerDefinition ld WITH (NOLOCK) ON p.PortfolioID = ld.PortfolioId and ld.ledgertypeid in (4,5)
LEFT OUTER JOIN AIM_LedgerInvoice toli WITH (NOLOCK) ON L.ToInvoiceID = toli.LedgerInvoiceID
LEFT OUTER JOIN AIM_LedgerInvoice fromli WITH (NOLOCK) ON L.FromInvoiceID = fromli.LedgerInvoiceID
WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (22,30,31,32,33,34) AND L.Status = 'Approved'

GROUP BY S.Code,p.code,s.contractdate,G.Name,lt.Name,L.LedgerID,L.Number,M.Account,M.Name,M.SSN,L.Debit,p.contractdate,L.DateEntered,L.DateCleared,ToInvoiceID,FromInvoiceID,toli.InvoiceDate,fromli.InvoiceDate


SELECT
p.Code as [Purchase Code],
s.Code as [Sold Code],
G.Name,
lt.Name as [Type],
L.LedgerID,
'Declined' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Debit as [Amount],
[Comments] = max(cast(L.Comments as varchar(50))),
[Days To Expire Purchase] = datediff(d,getdate(),max(ld.recourseperioddays)+p.contractdate),
[Days To Expire Sold] = datediff(d,getdate(),max(ld.recourseperioddays)+s.contractdate),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date],
ToInvoiceID as [Buyer Invoice ID],
FromInvoiceID as [Investor Invoice ID],
toli.InvoiceDate as [Buyer Invoice Date],
fromli.InvoiceDate as [Investor Invoice Date]

FROM
AIM_Ledger L WITH (NOLOCK)
JOIN AIM_Group G WITH (NOLOCK) ON L.ToGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number
JOIN AIM_Portfolio p WITH (NOLOCK) ON p.PortfolioID = M.PurchasedPortfolio
LEFT OUTER JOIN AIM_Portfolio s WITH (NOLOCK) ON s.portfolioid = m.soldportfolio
JOIN AIM_LedgerType lt WITH (NOLOCK) ON L.ledgertypeid = lt.ledgertypeid
JOIN AIM_LedgerDefinition ld WITH (NOLOCK) ON p.PortfolioID = ld.PortfolioId and ld.ledgertypeid in (4,5)
LEFT OUTER JOIN AIM_LedgerInvoice toli WITH (NOLOCK) ON L.ToInvoiceID = toli.LedgerInvoiceID
LEFT OUTER JOIN AIM_LedgerInvoice fromli WITH (NOLOCK) ON L.FromInvoiceID = fromli.LedgerInvoiceID
WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (22,30,31,32,33,34) AND L.Status = 'Declined'

GROUP BY S.Code,p.Code,p.contractdate,G.Name,lt.Name,L.LedgerID,L.Number,M.Account,M.Name,M.SSN,L.Debit,S.contractdate,L.DateEntered,L.DateCleared,ToInvoiceID,FromInvoiceID,toli.InvoiceDate,fromli.InvoiceDate



SELECT
p.Code as [Purchase Code],
s.Code as [Sold Code],
G.Name,
lt.Name as [Type],
L.LedgerID,
'Requested' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Debit as [Amount],
[Comments] = max(cast(L.Comments as varchar(50))),
[Days To Expire Purchase] = datediff(d,getdate(),max(ld.recourseperioddays)+p.contractdate),
[Days To Expire Sold] = datediff(d,getdate(),max(ld.recourseperioddays)+s.contractdate),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date],
ToInvoiceID as [Buyer Invoice ID],
FromInvoiceID as [Investor Invoice ID],
toli.InvoiceDate as [Buyer Invoice Date],
fromli.InvoiceDate as [Investor Invoice Date]

FROM
AIM_Ledger L WITH (NOLOCK)
JOIN AIM_Group G WITH (NOLOCK) ON L.ToGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number
JOIN AIM_Portfolio p WITH (NOLOCK) ON p.PortfolioID = M.PurchasedPortfolio
LEFT OUTER JOIN AIM_Portfolio s WITH (NOLOCK) ON s.portfolioid = m.soldportfolio
JOIN AIM_LedgerType lt WITH (NOLOCK) ON L.ledgertypeid = lt.ledgertypeid
JOIN AIM_LedgerDefinition ld WITH (NOLOCK) ON p.PortfolioID = ld.PortfolioId and ld.ledgertypeid in (4,5)
LEFT OUTER JOIN AIM_LedgerInvoice toli WITH (NOLOCK) ON L.ToInvoiceID = toli.LedgerInvoiceID
LEFT OUTER JOIN AIM_LedgerInvoice fromli WITH (NOLOCK) ON L.FromInvoiceID = fromli.LedgerInvoiceID
WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (22,30,31,32,33,34) AND L.Status = 'Requested'

GROUP BY S.Code,p.Code,p.contractdate,G.Name,lt.Name,L.LedgerID,L.Number,M.Account,M.Name,M.SSN,L.Debit,S.contractdate,L.DateEntered,L.DateCleared,ToInvoiceID,FromInvoiceID,toli.InvoiceDate,fromli.InvoiceDate

END
ELSE
BEGIN


SELECT
P.Code as [Code],
G.Name,
lt.Name as [Type],
L.LedgerID,
'Pending' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Credit as [Amount],
[Comments] = max(cast(L.Comments as varchar(50))),
[Days To Expire] = datediff(d,getdate(),max(ld.recourseperioddays)+p.contractdate),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date],
ToInvoiceID as [Investor Invoice ID],
FromInvoiceID as [Seller Invoice ID],
toli.InvoiceDate as [Investor Invoice Date],
fromli.InvoiceDate as [Seller Invoice Date]

FROM
AIM_Portfolio P WITH (NOLOCK) JOIN AIM_Ledger L WITH (NOLOCK) ON P.PortfolioId = L.PortfolioId
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number AND M.PurchasedPortfolio = P.PortfolioId
JOIN AIM_LedgerType lt WITH (NOLOCK) ON L.ledgertypeid = lt.ledgertypeid
JOIN AIM_LedgerDefinition ld WITH (NOLOCK) ON P.PortfolioID = ld.PortfolioId and ld.ledgertypeid in (4,5)
LEFT OUTER JOIN AIM_LedgerInvoice toli WITH (NOLOCK) ON L.ToInvoiceID = toli.LedgerInvoiceID
LEFT OUTER JOIN AIM_LedgerInvoice fromli WITH (NOLOCK) ON L.FromInvoiceID = fromli.LedgerInvoiceID
WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (24,4,5,18,29,19) AND L.Status = 'Pending'

GROUP BY P.Code,G.Name,lt.Name,L.LedgerID,L.Number,M.Account,M.Name,M.SSN,L.Credit,p.contractdate,L.DateEntered,L.DateCleared,ToInvoiceID,FromInvoiceID,toli.InvoiceDate,fromli.InvoiceDate

SELECT
P.Code as [Code],
G.Name,
lt.Name as [Type],
L.LedgerID,
'Approved' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Credit as [Amount],
[Comments] = max(cast(L.Comments as varchar(50))),
[Days To Expire] = datediff(d,getdate(),max(ld.recourseperioddays)+p.contractdate),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date],
ToInvoiceID as [Investor Invoice ID],
FromInvoiceID as [Seller Invoice ID],
toli.InvoiceDate as [Investor Invoice Date],
fromli.InvoiceDate as [Seller Invoice Date]

FROM
AIM_Portfolio P WITH (NOLOCK) JOIN AIM_Ledger L WITH (NOLOCK) ON P.PortfolioId = L.PortfolioId
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number AND M.PurchasedPortfolio = P.PortfolioId
JOIN AIM_LedgerType lt WITH (NOLOCK) ON L.ledgertypeid = lt.ledgertypeid
JOIN AIM_LedgerDefinition ld WITH (NOLOCK) ON P.PortfolioID = ld.PortfolioId and ld.ledgertypeid in (4,5)
LEFT OUTER JOIN AIM_LedgerInvoice toli WITH (NOLOCK) ON L.ToInvoiceID = toli.LedgerInvoiceID
LEFT OUTER JOIN AIM_LedgerInvoice fromli WITH (NOLOCK) ON L.FromInvoiceID = fromli.LedgerInvoiceID
WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (24,4,5,18,29,19) AND L.Status = 'Approved'

GROUP BY P.Code,G.Name,lt.Name,L.LedgerID,L.Number,M.Account,M.Name,M.SSN,L.Credit,p.contractdate,L.DateEntered,L.DateCleared,ToInvoiceID,FromInvoiceID,toli.InvoiceDate,fromli.InvoiceDate

SELECT
P.Code as [Code],
G.Name,
lt.Name as [Type],
L.LedgerID,
'Declined' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Credit as [Amount],
[Comments] = max(cast(L.Comments as varchar(50))),
[Days To Expire] = datediff(d,getdate(),max(ld.recourseperioddays)+p.contractdate),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date],
ToInvoiceID as [Investor Invoice ID],
FromInvoiceID as [Seller Invoice ID],
toli.InvoiceDate as [Investor Invoice Date],
fromli.InvoiceDate as [Seller Invoice Date]

FROM
AIM_Portfolio P WITH (NOLOCK) JOIN AIM_Ledger L WITH (NOLOCK) ON P.PortfolioId = L.PortfolioId
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number AND M.PurchasedPortfolio = P.PortfolioId
JOIN AIM_LedgerType lt WITH (NOLOCK) ON L.ledgertypeid = lt.ledgertypeid
JOIN AIM_LedgerDefinition ld WITH (NOLOCK) ON P.PortfolioID = ld.PortfolioId and ld.ledgertypeid in (4,5)
LEFT OUTER JOIN AIM_LedgerInvoice toli WITH (NOLOCK) ON L.ToInvoiceID = toli.LedgerInvoiceID
LEFT OUTER JOIN AIM_LedgerInvoice fromli WITH (NOLOCK) ON L.FromInvoiceID = fromli.LedgerInvoiceID
WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (24,4,5,18,29,19) AND L.Status = 'Declined'


GROUP BY P.Code,G.Name,lt.Name,L.LedgerID,L.Number,M.Account,M.Name,M.SSN,L.Credit,p.contractdate,L.DateEntered,L.DateCleared,ToInvoiceID,FromInvoiceID,toli.InvoiceDate,fromli.InvoiceDate

SELECT
P.Code as [Code],
G.Name,
lt.Name as [Type],
L.LedgerID,
'Requested' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Credit as [Amount],
[Comments] = max(cast(L.Comments as varchar(50))),
[Days To Expire] = datediff(d,getdate(),max(ld.recourseperioddays)+p.contractdate),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date],
ToInvoiceID as [Investor Invoice ID],
FromInvoiceID as [Seller Invoice ID],
toli.InvoiceDate as [Investor Invoice Date],
fromli.InvoiceDate as [Seller Invoice Date]

FROM
AIM_Portfolio P WITH (NOLOCK) JOIN AIM_Ledger L WITH (NOLOCK) ON P.PortfolioId = L.PortfolioId
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number AND M.PurchasedPortfolio = P.PortfolioId
JOIN AIM_LedgerType lt WITH (NOLOCK) ON L.ledgertypeid = lt.ledgertypeid
JOIN AIM_LedgerDefinition ld WITH (NOLOCK) ON P.PortfolioID = ld.PortfolioId and ld.ledgertypeid in (4,5)
LEFT OUTER JOIN AIM_LedgerInvoice toli WITH (NOLOCK) ON L.ToInvoiceID = toli.LedgerInvoiceID
LEFT OUTER JOIN AIM_LedgerInvoice fromli WITH (NOLOCK) ON L.FromInvoiceID = fromli.LedgerInvoiceID
WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (24,4,5,18,29,19) AND L.Status = 'Requested'


GROUP BY P.Code,G.Name,lt.Name,L.LedgerID,L.Number,M.Account,M.Name,M.SSN,L.Credit,p.contractdate,L.DateEntered,L.DateCleared,ToInvoiceID,FromInvoiceID,toli.InvoiceDate,fromli.InvoiceDate


END

GO
