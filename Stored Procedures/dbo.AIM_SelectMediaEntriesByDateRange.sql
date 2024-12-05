SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AIM_SelectMediaEntriesByDateRange]
@startDate datetime,
@endDate datetime,
@mediaType int

AS
--Media Types
-- 0 = Media
-- 1 = Media After Sale
if(@mediaType = 1)
BEGIN


SELECT
p.Code as [Purchase Code],
s.Code as [Sold Code],
G.Name,
L.LedgerID,
'Pending' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Debit as [Amount],
[Comments] = cast(L.Comments as varchar(50)),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date]
FROM
AIM_Ledger L WITH (NOLOCK)
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number
JOIN AIM_Portfolio p WITH (NOLOCK) ON p.PortfolioID = M.PurchasedPortfolio
LEFT OUTER JOIN AIM_Portfolio s WITH (NOLOCK) ON s.portfolioid = m.soldportfolio

WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (28) AND L.Status = 'Pending'

SELECT
p.Code as [Purchase Code],
s.Code as [Sold Code],
G.Name,
L.LedgerID,
'Requested' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Debit as [Amount],
[Comments] = cast(L.Comments as varchar(50)),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date]
FROM
AIM_Ledger L WITH (NOLOCK)
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number
JOIN AIM_Portfolio p WITH (NOLOCK) ON p.PortfolioID = M.PurchasedPortfolio
LEFT OUTER JOIN AIM_Portfolio s WITH (NOLOCK) ON s.portfolioid = m.soldportfolio

WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (28) AND L.Status = 'Requested'

SELECT
p.Code as [Purchase Code],
s.Code as [Sold Code],
G.Name,
L.LedgerID,
'Received' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Debit as [Amount],
[Comments] = cast(L.Comments as varchar(50)),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date]
FROM
AIM_Ledger L WITH (NOLOCK)
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number
JOIN AIM_Portfolio p WITH (NOLOCK) ON p.PortfolioID = M.PurchasedPortfolio
LEFT OUTER JOIN AIM_Portfolio s WITH (NOLOCK) ON s.portfolioid = m.soldportfolio

WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (28) AND L.Status = 'Received'

SELECT
p.Code as [Purchase Code],
s.Code as [Sold Code],
G.Name,
L.LedgerID,
'Not Available' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Debit as [Amount],
[Comments] = cast(L.Comments as varchar(50)),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date]
FROM
AIM_Ledger L WITH (NOLOCK)
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number
JOIN AIM_Portfolio p WITH (NOLOCK) ON p.PortfolioID = M.PurchasedPortfolio
LEFT OUTER JOIN AIM_Portfolio s WITH (NOLOCK) ON s.portfolioid = m.soldportfolio

WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (28) AND L.Status = 'Not Available'

SELECT
p.Code as [Purchase Code],
s.Code as [Sold Code],
G.Name,
L.LedgerID,
'Sent' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Debit as [Amount],
[Comments] = cast(L.Comments as varchar(50)),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date]
FROM
AIM_Ledger L WITH (NOLOCK)
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number
JOIN AIM_Portfolio p WITH (NOLOCK) ON p.PortfolioID = M.PurchasedPortfolio
LEFT OUTER JOIN AIM_Portfolio s WITH (NOLOCK) ON s.portfolioid = m.soldportfolio

WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (28) AND L.Status = 'Sent'


END
ELSE
BEGIN


SELECT
P.Code as [Purchase Code],
G.Name,
L.LedgerID,
'Pending' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Credit as [Amount],
[Comments] = cast(L.Comments as varchar(50)),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date]

FROM
AIM_Portfolio P WITH (NOLOCK) 
JOIN AIM_Ledger L WITH (NOLOCK) ON P.PortfolioId = L.PortfolioId
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number AND M.PurchasedPortfolio = P.PortfolioId

WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (27) AND L.Status = 'Pending'

SELECT
P.Code as [Purchase Code],
G.Name,
L.LedgerID,
'Requested' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Credit as [Amount],
[Comments] = cast(L.Comments as varchar(50)),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date]

FROM
AIM_Portfolio P WITH (NOLOCK) 
JOIN AIM_Ledger L WITH (NOLOCK) ON P.PortfolioId = L.PortfolioId
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number AND M.PurchasedPortfolio = P.PortfolioId

WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (27) AND L.Status = 'Requested'

SELECT
P.Code as [Purchase Code],
G.Name,
L.LedgerID,
'Received' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Credit as [Amount],
[Comments] = cast(L.Comments as varchar(50)),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date]

FROM
AIM_Portfolio P WITH (NOLOCK) 
JOIN AIM_Ledger L WITH (NOLOCK) ON P.PortfolioId = L.PortfolioId
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number AND M.PurchasedPortfolio = P.PortfolioId

WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (27) AND L.Status = 'Received'

SELECT
P.Code as [Purchase Code],
G.Name,
L.LedgerID,
'Not Available' AS [Status],
L.Number,
M.Account as [Account Number],
M.Name as [Debtor Name],
M.SSN as [SSN],
L.Credit as [Amount],
[Comments] = cast(L.Comments as varchar(50)),
L.DateEntered as [Entered Date],
L.DateCleared as [Cleared Date]

FROM
AIM_Portfolio P WITH (NOLOCK) 
JOIN AIM_Ledger L WITH (NOLOCK) ON P.PortfolioId = L.PortfolioId
JOIN AIM_Group G WITH (NOLOCK) ON L.FromGroupID = G.GroupID
JOIN Master M WITH (NOLOCK) ON L.Number = M.Number AND M.PurchasedPortfolio = P.PortfolioId

WHERE
L.DateEntered between @startDate and @endDate AND
L.LedgerTypeID in (27) AND L.Status = 'Not Available'
END


GO
