SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataPayhistory] ( @AccountId INT )
RETURNS TABLE
AS 
    RETURN
    SELECT
            m.number AS lastpaidnumber, MAX(COALESCE(P.datepaid, m.CLIDLP, m.lastpaid)) AS LastPaymentDate,
            SUM(COALESCE(P.totalpaid, m.lastpaidamt)) AS lastPaymentAmount, MAX(p.datepaid) AS payhistorydatepaid--,
			--MAX(d.clidlp) as lastpaidCLIDLP
        FROM
            master m INNER JOIN dbo.payhistory p 
					ON  m.number = p.number
				LEFT OUTER JOIN payhistory r 
					ON p.uid = r.ReverseOfUID
        WHERE
            m.number = @AccountId
            AND p.batchtype IN ( 'PU', 'PA', 'PC' )
			AND r.ReverseOfUID IS NULL
        GROUP BY
            m.number ;
GO
