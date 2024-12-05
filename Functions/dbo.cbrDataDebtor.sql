SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataDebtor] ( @AccountId INT )
RETURNS TABLE
AS 
    RETURN
    SELECT
            d.number AS debtornumber, 
            CASE WHEN d.seq = 0 THEN d.DebtorID ELSE 0 END AS PrimaryDebtorID, 
            d.DebtorID, d.seq, LEFT(LTRIM(RTRIM(d.[name])), 30) AS Debtorname, d.responsible, ISNULL(d.cbrExclude, 0) AS CbrExclude,
            ISNULL(d.CbrException32, 0) AS PrvDebtorExceptions, ISNULL(d.IsBusiness, 0) AS IsBusiness,
                        --ISNULL(( SELECT COUNT(*)
                        --         FROM   debtors t
                        --         WHERE  t.number = d.number
                        --                AND cf.includecodebtors = 1
                        --                AND t.responsible = 1
                        --                AND t.isbusiness = 0
                        --                AND ISNULL(d.cbrExclude, 0) = 0 ), 1) AS JointDebtors,
            d.ssn AS DebtorSSN, d.street1 AS DebtorStreet1, d.street2 AS DebtorStreet2, d.city AS DebtorCity,
            d.state AS DebtorState, d.zipcode AS DebtorZipCode, d.IsAuthorizedAccountUser,
            COALESCE(cs.debtorid, rs.debtorid, dc.debtorid) AS cccdebtorid, 
            CASE WHEN cs.debtorid IS NOT NULL THEN 1 ELSE 0 END AS CCCS,
            CASE WHEN ISNULL(rs.Disputed, 0) = 1 AND d.Seq = 0 THEN 1 ELSE 0 END AS PrimaryDebtorDispute, 
            dc.dod AS datedeceased,
            d.DOB AS DebtorDOB
        FROM
            debtors d
        outer apply [dbo].[EffectiveCCCS](d.debtorid) cs 
        LEFT OUTER JOIN [dbo].[restrictions] rs ON  d.DebtorID = rs.DebtorID
        LEFT OUTER JOIN [dbo].deceased dc ON  d.debtorid = dc.debtorid
        
        WHERE
            d.Number = @accountid ;
GO
