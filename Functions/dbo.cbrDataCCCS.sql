SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataCCCS] ( @debtorid INT )
RETURNS TABLE
AS 
------> v00001
    RETURN
    SELECT
            COALESCE(cs.debtorid, rs.debtorid, dc.debtorid) AS cccdebtorid, 
            CASE WHEN cs.debtorid IS NOT NULL THEN 1 ELSE 0 END AS CCCS,
            CASE WHEN ISNULL(rs.Disputed, 0) = 1 AND d.Seq = 0 THEN 1 ELSE 0 END AS PrimaryDebtorDispute, 
            dc.dod AS datedeceased
        FROM
            debtors d
        LEFT OUTER JOIN [dbo].[CCCS] cs ON  d.debtorid = cs.debtorid
        LEFT OUTER JOIN [dbo].[restrictions] rs ON  d.DebtorID = rs.DebtorID
        LEFT OUTER JOIN [dbo].deceased dc ON  d.debtorid = dc.debtorid
        WHERE
            d.debtorid = @debtorid
            AND (    cs.debtorid IS NOT NULL
                  OR rs.debtorid IS NOT NULL
                  OR dc.debtorid IS NOT NULL ) ;
GO
