SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- This function used exclusively by the latitude.metro2.dll in the Latitude classic application
-- Along with getting cbr Accounts, a compliance condition is returned if there has ever been one in the history. 
CREATE FUNCTION [dbo].[cbrAccountsWithComplianceCondition] ( @AccountId INT )
RETURNS   TABLE
AS
RETURN

WITH compliance AS
(
    SELECT 999999999 AS fileid, accountid, accountstatus, ISNULL(compliancecondition, '') AS compliancecondition FROM cbr_accounts with(nolock) WHERE accountID = @AccountId
    UNION
    SELECT fileid, accountid, accountstatus, ISNULL(compliancecondition, '') AS compliancecondition FROM cbr_metro2_accounts with(nolock) WHERE accountID = @AccountId
)
,
ReportCondition As (
	SELECT accountid,fileid,accountstatus,complianceCondition,row_number() over (partition by Accountid order by fileID desc) as lastreport 
	FROM Compliance WHERE accountID = @AccountId AND (complianceCondition <> '' OR accountStatus = 'da')
) 

SELECT a.*, ISNULL(e.cbrExceptionValue,0) + ISNULL(e.DebtorExceptionsValue,0) -CAST(~s.cbrReport AS INT) as cbrException, CASE WHEN r.accountStatus = 'DA' THEN '' ELSE r.complianceCondition END AS  ReportedComplianceCondition, 
	CASE WHEN b.BankruptcyID IS NULL THEN 0 ELSE 1 END Bankruptcy,
	CASE WHEN (dec.dod is null or dec.dod = '1753-01-01 12:00:00.000' or dec.dod = '1900-01-01 00:00:00.000') then 0 else 1 end Deceased
	FROM cbr_accounts a 
	inner join debtors d with(nolock) on d.number = @AccountId
	inner join master m on m.number = @AccountId
	left outer join status s on m.status = s.code
	Left Outer JOIN  ReportCondition r on a.accountid = r.accountid
	Left outer join Bankruptcy b with(nolock) on b.DebtorId = d.DebtorId
	Left outer join Deceased dec with(nolock) on dec.DebtorId = d.DebtorId 
	OUTER APPLY  CbrDataExceptionDtl(@AccountId) e 
	WHERE  a.accountID = @AccountId AND isnull(r.lastreport,1) = 1 ;

GO
