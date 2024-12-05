SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrAccountHistoryByFileId] ( @accountid INT, @FileId int)
RETURNS TABLE
AS 
    RETURN
    WITH    cbrAccountHistory
                      AS ( SELECT ca.[recordID]
						  ,ca.[fileID]
						  ,ca.[dateReported]
						  ,ca.[accountID]
						  ,ca.[customerID]
						  ,ca.[primaryDebtorID]
						  ,ca.[portfolioType]
						  ,ca.[accountType]
						  ,ca.[accountStatus]
						  ,ca.[originalLoan]
						  ,ca.[actualPayment]
						  ,ca.[currentBalance]
						  ,ca.[amountPastDue]
						  ,ca.[termsDuration]
						  ,ca.[specialComment]
						  ,ca.[openDate]
						  ,ca.[billingDate]
						  ,ca.[delinquencyDate]
						  ,ca.[closedDate]
						  ,ca.[lastPaymentDate]
						  ,ca.[originalCreditor]
						  ,ca.[creditorClassification]
						  ,ca.[ConsumerAccountNumber]
						  ,ca.[ChargeOffAmount]
						  ,ca.[PaymentHistoryProfile]
						  ,ca.[PaymentHistoryDate]
						  ,ca.[CreditLimit]
						  ,ca.[SecondaryAgencyIdenitifier]
						  ,ca.[SecondaryAccountNumber]
						  ,ca.[MortgageIdentificationNumber]
						  ,ca.[PortfolioIndicator]
						  ,ca.[SoldToPurchasedFrom]
						  ,ISNULL(ca.[complianceCondition],'') AS complianceCondition
                    FROM cbr_metro2_accounts ca ), 
            AccountHistory
            
				AS ( SELECT accountid, @FileId  AS fileid
                    FROM cbr_metro2_accounts
                    WHERE (accountid = @accountid or @accountid IS NULL)
                    GROUP BY accountid) ,

			Pending AS 
				(
					SELECT 0 AS fileid,accountid,accountstatus, compliancecondition FROM cbr_accounts WHERE  accountid = @accountid or @accountid IS NULL
				)
				
			SELECT ch.*, ISNULL(pd.compliancecondition,'') AS PendingComplianceCondition

			FROM AccountHistory ah        
					LEFT OUTER JOIN cbraccounthistory ch ON  ah.accountid = ch.accountID AND ah.fileid = ch.fileid
					FULL OUTER JOIN Pending pd ON ah.accountID = pd.accountID
            WHERE ah.fileid IS NOT NULL           
                        
  ;

GO
