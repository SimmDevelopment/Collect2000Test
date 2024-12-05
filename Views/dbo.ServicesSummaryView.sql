SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/*ServicesSummaryView*/
CREATE VIEW [dbo].[ServicesSummaryView]
AS
SELECT     dbo.master.number AS AccountID, dbo.Services1.Number AS Services1, dbo.Services2.Number AS Services2, 
                      dbo.ServiceHistory.AcctID AS ServiceHistory, dbo.OSSRequests.AccountID AS OSSRequests, dbo.BIGNOTES.NUMBER AS BigNotes, 
                      dbo.HardCopy.number AS HardCopy
FROM         dbo.master LEFT OUTER JOIN
                      dbo.HardCopy ON dbo.HardCopy.number = dbo.master.number LEFT OUTER JOIN
                      dbo.BIGNOTES ON dbo.master.number = dbo.BIGNOTES.NUMBER LEFT OUTER JOIN
                      dbo.OSSRequests ON dbo.master.number = dbo.OSSRequests.AccountID LEFT OUTER JOIN
                      dbo.Services2 ON dbo.master.number = dbo.Services2.Number LEFT OUTER JOIN
                      dbo.Services1 ON dbo.master.number = dbo.Services1.Number LEFT OUTER JOIN
                      dbo.ServiceHistory ON dbo.master.number = dbo.ServiceHistory.AcctID

GO
