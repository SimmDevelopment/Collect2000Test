SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[CbrDataLastAudit]
    (
      @Accountid INTEGER
    )
RETURNS TABLE
AS
RETURN
		WITH Acct AS (
			  SELECT TOP ( 1 )
						c.*
			  FROM      cbr_audit c
			  WHERE     c.Accountid = @Accountid
			  ORDER BY  c.DateCreated DESC
				),
			Accts AS (	
			  SELECT 
						c.*, ROW_NUMBER() OVER (PARTITION BY c.AccountID ORDER BY c.DateCreated DESC) AS LastAudit
			  FROM      cbr_audit c
			  WHERE     @Accountid IS NULL)
			  
			  SELECT accountID, debtorID, dateCreated, [user], comment FROM Acct 
					UNION ALL 
			  SELECT accountID, debtorID, dateCreated, [user], comment FROM Accts Where LastAudit = 1;
			 
GO
