SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDebtorHistory] ( @accountid INT )
RETURNS TABLE
AS 
    RETURN
    WITH    cbrDebtorHistory
              AS ( SELECT accountid, MAX(recordid) AS recordid
                    FROM cbr_metro2_debtors
                    WHERE AccountId = @accountid 
                    GROUP BY accountid
				UNION ALL
				   SELECT accountid, MAX(recordid) AS recordid
                    FROM cbr_metro2_debtors
                    WHERE @accountid IS NULL
                    GROUP BY accountid) ,

            DebtorHistory
              AS ( SELECT cd.* FROM cbr_metro2_debtors cd INNER JOIN cbrdebtorhistory ch ON  cd.accountid = ch.accountid and cd.recordID = ch.recordid
					where cd.accountID = @accountid
					union all
					SELECT cd.* FROM cbr_metro2_debtors cd INNER JOIN cbrdebtorhistory ch ON  cd.accountid = ch.accountid and cd.recordID = ch.recordid
					where @accountid IS NULL
					)
                        
    SELECT * FROM DebtorHistory ;
    
GO
