SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDatafex] ( @AccountId INT)
RETURNS TABLE
AS  
    RETURN 

		SELECT
			  cf.CbrEnabled ,cf.PortfolioType ,cf.AccountType ,cf.MinBalance ,cf.WaitDays ,
			  cf.DefaultCreditorClass ,cf.DefaultOriginalCreditor ,cf.UseAccountOriginalCreditor ,
			  cf.UseCustomerOriginalCreditor ,cf.PrincipalOnly ,cf.IncludeCodebtors ,
			  cf.DeleteReturns ,cf.customercode ,cf.CustomerID ,cf.CustomerName ,
			  cf.CustomerOriginalCreditor ,cf.CustomerCreditorClass ,cf.IsChargeOffData ,
			  cf.cddAbbrev ,cf.cddLookup ,cf.IsValidAccountType ,
        
              m.OriginalCreditor ,m.Number ,m.Status ,m.QLevel ,m.ReceivedDate ,m.DelinquencyDate ,
              m.OriginalPrincipal ,m.OriginalBalance ,m.CurrentPrincipal ,m.CurrentBalance ,
              m.LastPaymentDate ,m.CliDlp ,m.CbrPrevent ,m.CbrOutofStatute ,m.CbrOverride ,
              m.ExtendDays ,m.StatusCbrReport ,m.StatusCbrDelete ,m.IsBankruptcy ,m.IsDeceased ,
              m.IsDisputed ,m.StatusIsPIF ,m.StatusIsSIF ,m.StatusIsActive ,m.ReportableDate ,
              m.PrvCbrException ,
              m.NextOriginalCreditor ,m.NextCreditorClass ,m.ContractDate ,m.CbrValidContractToPay ,m.ConsumerAccountNumber ,
              m.StatusIsFraud ,m.SettlementArrangement ,m.NextCurrentBalance ,m.PortfolioIndicator ,
			  m.lastpaidamt,
			  null AS ActualPaymentAmount,
			  m.[specialnote] ,m.[PersonalReceivership_Amortization] ,
              m.[ChargeOffDate] ,m.NextAccountStatus ,m.NextSpecialComment ,
 
			  a.SoldToPurchasedFrom ,a.PortfolioSoldDate ,           
             
              m.HasChargeOffRecord ,m.ChargeOffAmount ,
              
			--CASE WHEN [mco].[PaymentHistoryProfile] IS NULL OR [mco].[paymenthistorydate] IS NULL THEN '' 
			--	   WHEN DATEDIFF(m,convert(varchar(8),[mco].[paymenthistorydate],112) , @CurrentPaymentHistoryDate) <= 0 THEN [mco].[PaymentHistoryProfile]
			--	   ELSE  SUBSTRING(REPLICATE('L', DATEDIFF(m,convert(varchar(8),DATEADD(d,-1,CAST(CAST(YEAR([mco].[paymenthistorydate]) AS VARCHAR(4)) + RIGHT('0' + CAST(MONTH([mco].[paymenthistorydate]) AS VARCHAR(2)),2) + '01' AS DATETIME)),112), @CurrentPaymentHistoryDate)) + [mco].[PaymentHistoryProfile], 1, 24) 
			--END, --profile
              CASE WHEN ISNULL(m.[PaymentHistoryProfile],'') = '' OR ISNULL(m.[paymenthistorydate],'') = '' THEN '' 
 	 			   WHEN DATEDIFF(m,dateadd(d,-1,cast(left(convert(varchar(8),dateadd(m,1,m.[PaymentHistoryDate]),112),6) + '01' as datetime)), DATEADD(d,-1,CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + RIGHT('0' + CAST(MONTH(GETDATE()) AS VARCHAR(2)),2) + '01' AS DATETIME))) < 0 THEN m.[PaymentHistoryProfile]
				   ELSE SUBSTRING(REPLICATE('L', DATEDIFF(m,cast(DATEADD(d,-1,cast(substring(convert(varchar(8),m.[paymenthistorydate],112),1,6) + '01'  as DateTime  )) as datetime), DATEADD(d,-1,CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + RIGHT('0' + CAST(MONTH(GETDATE()) AS VARCHAR(2)),2) + '01' AS DATETIME)))) + m.[PaymentHistoryProfile], 1, 24) 
			  END AS [PaymentHistoryProfile],  
			  
			  DATEADD(d,-1,CAST(CAST(YEAR(GETDATE()) AS VARCHAR(4)) + RIGHT('0' + CAST(MONTH(GETDATE()) AS VARCHAR(2)),2) + '01' AS DATETIME)) AS paymenthistorydate,
           
 			  --o.PaymentHistoryDate AS PaymentHistoryDate ,
              CASE WHEN ISNULL(m.[PaymentHistoryProfile],'') = '' OR ISNULL(m.[paymenthistorydate],'') = 0 THEN '' 
							 ELSE dateadd(d,-1,cast(left(convert(varchar(8),m.[PaymentHistoryDate],112),6) + '01' as datetime))
			  END AS PaymentHistoryDateEOM ,
              m.HighestCredit ,m.CreditLimit ,m.SecondaryAgencyIdenitifier ,m.SecondaryAccountNumber ,
			  m.MortgageIdentificationNumber ,m.TermsDuration ,m.ClosedDate ,m.ChargeOffStatus , m.mcoClosedDate,          
			  m.mcoSpecialComment ,m.mcoComplianceCondition ,
            
              d.PrimaryDebtorID ,d.DebtorID ,d.seq ,LEFT(ISNULL(RTRIM(LTRIM(d.DebtorLastName)),'') + ISNULL(RTRIM(LTRIM(d.DebtorFirstName)),'') + ISNULL(RTRIM(LTRIM(d.DebtorMiddleName)),''),300)AS Debtorname , d.DebtorLastName, d.DebtorFirstName, d.DebtorMiddleName,  d.Responsible ,d.CbrExclude ,
              d.PrvDebtorExceptions ,d.DebtorExceptions ,d.PrimaryDebtorException ,d.IsBusiness ,
              d.JointDebtors ,d.DebtorSSN ,d.DebtorStreet1 ,d.DebtorStreet2 ,d.DebtorCity ,d.DebtorState ,
              d.DebtorZipCode ,d.NextTransactionType ,d.IsAuthorizedAccountUser ,d.NextComplianceCondition ,
              d.NextEcoaCode ,d.AuditCommentKey ,d.Reportable ,d.DebtorsAuditCommentKey,
              CASE WHEN cs.debtorid IS NOT NULL THEN 1 ELSE 0 END AS CCCS,
              
              CASE WHEN ISNULL(rs.Disputed,0) = 1 AND d.Seq = 0 THEN 1 ELSE 0 END AS PrimaryDebtorDispute
              ,dc.DOD as datedeceased , 
 
              b.bankruptcychapter ,b.nextinformationindicator ,
              --m.disconfiguredAccountid,
              ph.phonenumber,
              b.DateFiledEoM,
              b.DischargeDateEoM,
              b.DismissalDateEoM,
              m.cbrexception,
              d.DOB as DebtorDOB,
              m.returned,
              d.cbrECOACode

            
        FROM
            dbo.cbrDataConfigex(@AccountId) cf
			cross apply dbo.cbrDataMasterex(@AccountId  , cf.Customercode, cf.cddabbrev , cf.cddLookup , cf.waitDays , 
											cf.useaccountoriginalcreditor , cf.usecustomeroriginalcreditor , cf.DefaultOriginalCreditor , 
											cf.CustomerOriginalCreditor , cf.CustomerName ,	cf.PrincipalOnly , cf.DefaultCreditorClass,
											cf.IsValidAccountType, cf.DefaultCreditorClass , cf.IsChargeOffData, cf.PortfolioType 
											) m
			cross apply dbo.cbrDataDebtorex(m.number, cf.includecodebtors) d
			outer apply dbo.cbrDataAimex(m.SoldPortfolio) a
			outer apply dbo.cbrDataBankruptcyex(d.debtorid) b
			outer apply dbo.EffectiveCCCS(d.DebtorID) cs 
			LEFT outer join [dbo].[restrictions] rs ON d.DebtorID = rs.DebtorID
			LEFT outer join [dbo].deceased dc ON d.DebtorID = dc.debtorid
			outer apply dbo.cbrdataphonesmasterex(d.DebtorID,m.number) ph --Adding number in order to fix LAT-10741
		WHERE   
                cf.cbrenabled = 1 --OR (cf.cbrenabled = 0 AND m.disconfiguredAccountid IS NOT NULL)
                AND ( d.seq = 0
                      OR cf.includecodebtors = 1 
                      OR d.IsAuthorizedAccountUser = 1) 
                AND m.statusCbrReport = 1
                AND ISNULL(m.cbrPrevent,0) = 0;
                        
  
GO
