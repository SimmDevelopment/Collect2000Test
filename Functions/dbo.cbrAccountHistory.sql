SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[cbrAccountHistory] ( @accountid INT )
RETURNS TABLE
AS 
    RETURN
    WITH    AccountHistory
            
				AS ( SELECT accountid, MAX(fileid) AS fileid
                    FROM cbr_metro2_accounts
                    WHERE accountid = @accountid 
                    GROUP BY accountid
				  UNION ALL
				  SELECT accountid, MAX(fileid) AS fileid
                    FROM cbr_metro2_accounts
                    WHERE @accountid IS NULL
                    GROUP BY accountid   ) ,
					
			cbrAccountHistory
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
                    FROM cbr_metro2_accounts ca WITH (index(ix_cbr_metro2_accounts_accountid_fileid)) inner join accounthistory h on h.accountid = ca.accountid and h.fileid = ca.fileid
                    where ca.accountID = @accountid
                    UNION ALL
                    SELECT ca.[recordID]
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
                    FROM cbr_metro2_accounts ca WITH (index(ix_cbr_metro2_accounts_accountid_fileid)) inner join accounthistory h on h.accountid = ca.accountid and h.fileid = ca.fileid
                    where @accountid IS NULL                    
                    ), 
 
            Compliance AS
				(
					SELECT xa.fileid,xa.accountid, xa.accountstatus, xa.compliancecondition from cbr_metro2_accounts xa inner join cbraccounthistory xh on  xa.accountid = xh.accountid
					where xa.accountID = @accountid
					union all
					SELECT xa.fileid,xa.accountid, xa.accountstatus, xa.compliancecondition from cbr_metro2_accounts xa inner join cbraccounthistory xh on  xa.accountid = xh.accountid
					where @accountid is null
				),
			Pending AS 
				(
					SELECT 0 AS fileid,xa.accountid,xa.accountstatus, xa.compliancecondition FROM cbr_accounts  xa inner join cbraccounthistory xh on  xa.accountid = xh.accountid
					where xa.accountID = @accountid
					union all
					SELECT 0 AS fileid,xa.accountid,xa.accountstatus, xa.compliancecondition FROM cbr_accounts  xa inner join cbraccounthistory xh on  xa.accountid = xh.accountid
					where @accountid is null
				),
			
				
            ReportedComplianceCondition As (
					SELECT accountid,fileid,accountstatus,complianceCondition,row_number() over (partition by Accountid order by fileID desc) as lastreport 
					from Compliance where complianceCondition <> '' or accountStatus = 'da'
								)
				    
			SELECT ch.*,
			CASE WHEN rp.accountStatus = 'DA' THEN '' ELSE rp.[complianceCondition] END AS [complianceCondition], 
			--'' AS [complianceCondition], 
			ISNULL(pd.compliancecondition,'') AS PendingComplianceCondition

			FROM AccountHistory ah        
					LEFT OUTER JOIN cbraccounthistory ch ON  ah.accountid = ch.accountID AND ah.fileid = ch.fileid
					LEFT OUTER JOIN ReportedComplianceCondition rp on ch.accountid = rp.accountid and rp.lastreport = 1 
					FULL OUTER JOIN Pending pd ON ah.accountID = pd.accountID
            WHERE ah.fileid IS NOT NULL           
                        
  ;


GO
