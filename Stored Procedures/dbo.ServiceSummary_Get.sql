SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



/*ServiceSummary_Get*/
CREATE  Procedure [dbo].[ServiceSummary_Get]
	@AccountID int
AS
Set Nocount On

SELECT TOP 1 dbo.master.number AS AccountID, dbo.ServiceHistory.AcctID AS ServiceHistory, 
	   dbo.BIGNOTES.NUMBER AS BigNote, dbo.HardCopy.number AS HardCopy
FROM       dbo.master LEFT OUTER JOIN
           dbo.HardCopy ON dbo.HardCopy.number = dbo.master.number LEFT OUTER JOIN
           dbo.BIGNOTES ON dbo.master.number = dbo.BIGNOTES.NUMBER LEFT OUTER JOIN
           dbo.ServiceHistory ON dbo.master.number = dbo.ServiceHistory.AcctID
WHERE dbo.master.number = @AccountID

Return @@Error


GO
