SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataMetrofex] ( @AccountId INT )
RETURNS TABLE
AS 
    RETURN  
    			SELECT DISTINCT
                        COALESCE(c2.accountid, ca.accountid) AS number,
                        COALESCE(cd.debtorid, cd2.debtorid) AS debtorid,
                        COALESCE(ca.primarydebtorid, c2.primarydebtorid) AS primarydebtorid,
                        COALESCE(ca.accountStatus,c2.accountStatus) AS accountStatus,
                        COALESCE(ca.specialComment, c2.specialComment) AS specialComment,
                        COALESCE(ca.complianceCondition, c2.complianceCondition) AS complianceCondition,
                        COALESCE(c2.currentBalance, ca.currentBalance) AS OpenBalance,
                        c2.fileid,
                        c2.recordID,
                        c2.accountStatus AS LastAccountStatus,
                        c2.specialComment AS LastSpecialComment,
                        c2.complianceCondition AS LastComplianceCondition,
                        ISNULL(cd2.EcoaCode,'') AS LastEcoaCode,
                        cd.EcoaCode,
                        ISNULL(cd2.InformationIndicator,'') AS LastInformationIndicator,
                        cd.InformationIndicator,
                        cd.Name AS PndgDebtorName,
                        cd.SSN AS PndgDebtorSSN,
                        cd.Address1 AS PndgDebtorStreet1,
                        cd.Address2 AS PndgDebtorStreet2,
                        cd.City AS PndgDebtorCity,
                        cd.State AS PndgDebtorState,
                        cd.Zipcode AS PndgDebtorZipCode,
                        LEFT(ISNULL(RTRIM(LTRIM(cd2.SurName)),'') + ISNULL(RTRIM(LTRIM(cd2.FirstName)),'') + ISNULL(RTRIM(LTRIM(cd2.MiddleName)),''),300) AS RptdDebtorName,
                        ISNULL(cd2.SurName,'') AS RptdDebtorLastName,
                        ISNULL(cd2.FirstName,'') AS RptdDebtorFirstName,
                        ISNULL(cd2.MiddleName,'') AS RptdDebtorMiddleName,
                        ISNULL(cd2.SSN,'') AS RptdDebtorSSN,
                        ISNULL(cd2.Address1,'') AS RptdDebtorStreet1,
                        ISNULL(cd2.Address2,'') AS RptdDebtorStreet2,
                        ISNULL(cd2.City,'') AS RptdDebtorCity,
                        ISNULL(cd2.State,'') AS RptdDebtorState,
                        ISNULL(cd2.Zipcode,'') AS RptdDebtorZipCode,
                        ISNULL(cd2.transactiontype,'') AS TransactionType,
                        cd.Transactiontype AS CurrentTransactionType,
                        ca.originalcreditor,
                        ca.creditorclassification,
                        ISNULL(cd.transactionTypeOverride,0) AS TransactionTypeOverride,
                        ISNULL(cd.ecoaCodeOverride,0) AS EcoaCodeOverride,
                        ISNULL(cd.informationIndicatorOverride,0) AS InformationIndicatorOverride,
                        ISNULL(cd.addressIndicatorOverride,0) AS AddressIndicatorOverride,
                        ISNULL(cd.residenceCodeOverride,0) AS ResidenceCodeOverride,
                        c2.dateReported,
                        ISNULL(ca.specialCommentOverride,0) AS specialCommentOverride,
                        ISNULL(ca.SoldToPurchasedFrom,'') AS SoldToPurchasedFrom,
                        ISNULL(ca.PortfolioIndicator,0) AS LastPortfolioIndicator,
                        c2.LastPaymentDate AS RptdLastPaymentDate,
                        ISNULL(cd.AuthorizedUserSegment,'') AS AuthorizedUserAddress,
                        c2.PaymentHistoryProfile AS RptdPaymentHistoryProfile,
                        cd2.generationcode as RptdDebtorGenerationCode,
                        cd2.suffix as RptdDebtorSuffix
                 FROM    
						dbo.cbrAccountHistory(@accountid) c2 
						left outer join (Select * from  dbo.cbrDebtorHistory(@accountid) ) cd2 on c2.accountID = cd2.accountid	
                        full OUTER JOIN cbr_accounts ca ON c2.accountid = ca.accountid
                        full OUTER JOIN cbr_debtors cd ON cd2.DebtorID = cd.debtorID 
                        left outer join cbr_effectiveconfiguration cf on  coalesce(c2.customerID , ca.customerid ) = cf.customerid
                        
                        WHERE   ( COALESCE(c2.accountid, ca.accountid)  = @accountid
                          OR @accountid IS NULL
                          )
                        AND (COALESCE(c2.accountid, ca.accountid) IS NOT NULL)
                        AND (COALESCE(cd2.debtorid, cd.debtorid) IS NOT NULL)
                        AND ( ( cf.enabled = 0
                                AND COALESCE(c2.accountstatus, ca.accountstatus) IN ( '93', '11', '71', '78', '80', '82', '83', '84', '97' ) )
                              OR cf.enabled = 1 ) ;
                              
                              
                              
GO
