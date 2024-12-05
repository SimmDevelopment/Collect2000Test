SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataDebtorex]
    ( @accountid int, @includecodebtors bit)
RETURNS TABLE
AS 
    RETURN				
    
				WITH cbrdatax AS
				(
						select
						d.number as debtornumber,                                             
                        CASE WHEN d.seq = 0 THEN d.DebtorID
                                      ELSE 0
                                 END AS PrimaryDebtorID,
                        d.DebtorID,
                        d.seq,
                        LEFT(LTRIM(RTRIM(d.LastName))+LTRIM(RTRIM(d.FirstName))+LTRIM(RTRIM(d.MiddleName)),30) AS DebtorName,
                        LEFT(LTRIM(RTRIM(d.LastName)), 50) AS DebtorLastName,
                        LEFT(LTRIM(RTRIM(d.FirstName)), 50) AS DebtorFirstName,
                        LEFT(LTRIM(RTRIM(d.MiddleName)), 50) AS DebtorMiddleName,
                        d.responsible,
                        ISNULL(d.cbrExclude, 0) AS CbrExclude,
                        ISNULL(d.CbrException32, 0) AS PrvDebtorExceptions,
                        ISNULL(d.IsBusiness, 0) AS IsBusiness,
                        ISNULL(dd.JointDebtors, 1) AS JointDebtors,
                        ISNULL(d.ssn,'') AS DebtorSSN,
                        d.street1 AS DebtorStreet1,
                        d.street2 AS DebtorStreet2,
                        d.city AS DebtorCity,
                        d.state AS DebtorState,
                        d.zipcode AS DebtorZipCode, 
                        d.cbrECOACode AS cbrECOACode,
                        ' ' AS NextTransactionType,
						ISNULL(d.IsAuthorizedAccountUser,0) AS IsAuthorizedAccountUser,
                        NULL AS NextComplianceCondition,
                        ' ' AS NextEcoaCode,
                        0 AS AuditCommentKey,
                        0 AS Reportable,
                        0 AS DebtorsAuditCommentKey,
                        CASE WHEN d.DOB = '1900-1-1' THEN null
                                      ELSE d.DOB
                                 END AS DOB
                from
						dbo.debtors d WITH ( NOLOCK ) 
				OUTER APPLY ( SELECT COUNT(*) as JointDebtors
                                 FROM   debtors t
                                 LEFT OUTER JOIN Deceased dc on t.DebtorID = dc.debtorid
                                 WHERE  t.number = d.number
                                        AND @includecodebtors = 1
                                        AND isnull(t.responsible,0) = 1
                                        AND isnull(t.isbusiness,0) = 0
                                        AND ISNULL(t.cbrExclude, 0) = 0
                                        AND dc.DOD IS NULL)  dd
				where	(d.number = @Accountid )
                         AND ( d.seq = 0
                              OR d.IsAuthorizedAccountUser = 1
                              OR @includecodebtors = 1 ) 
                    )         
						 
			select ax.*,ISNULL(xd.DebtorExceptions,0) AS DebtorExceptions, ISNULL(xd.PrimaryDebtorException,0) 
			AS PrimaryDebtorException 
			from cbrdatax ax
            CROSS APPLY cbrDataDebtorExceptionex(debtorlastname , debtorfirstname, IsAuthorizedAccountUser , DebtorZipCode , Seq , DOB, debtorssn
            ) xd
            ;
	                               
                              
                              
GO
