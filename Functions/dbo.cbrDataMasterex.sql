SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
CREATE FUNCTION [dbo].[cbrDataMasterex]
    ( @AccountId INT , @Customer VARCHAR(7), @cddabbrev varchar(255), @cddLookup varchar(255), @cfwaitDays int, 
      @useaccountoriginalcreditor bit, @usecustomeroriginalcreditor bit, @DefaultOriginalCreditor varchar(30), 
      @CustomerOriginalCreditor varchar(30), @CustomerName varchar(30),
      @PrincipalOnly bit, @CreditorClass char(2), @IsValidAccountType int, @DefaultCreditorClass varchar(2), @IsChargeOffData int, @PortfolioType char(1))
RETURNS TABLE
AS 
    RETURN
		with cbrmasterpoints as (			
                      select
                        LEFT(LTRIM(RTRIM(m.OriginalCreditor)), 30) AS OriginalCreditor,
                        m.number,
                        m.Status,
                        m.qlevel,
                        m.received AS receiveddate,
                        m.DelinquencyDate,
                        m.closed AS ClosedDate,
                        m.original1 AS OriginalPrincipal,
                        m.original as originalbalance,
                        ROUND(m.current1,0,1) AS CurrentPrincipal,
                        ROUND(m.current0,0,1) AS CurrentBalance,
                        m.lastpaid as lastpaymentdate,
                        m.clidlp,
                        ISNULL(m.cbrPrevent, 0) AS cbrPrevent,
                        CASE WHEN m.DelinquencyDate IS NOT NULL
                                       AND @cddabbrev = '-OutOfStatuteDaysOffsetToReport'
                                       AND  abs(cast(@cddLookup as int)) is not null 
                                       and convert(varchar(8),dateadd(d,-cast(@cddLookup as int),m.DelinquencyDate ),112) <= DATEADD(yyyy, -7, { fn curdate() }) THEN 1
                                  WHEN m.Received IS NOT NULL
                                       AND @cddAbbrev = '-OutOfStatuteDaysOffsetToReport'
                                       AND  abs(cast(@cddLookup as int)) is not null  
                                       AND convert(varchar(8),dateadd(d,-cast(@cddLookup as int),m.Received ),112) <= DATEADD(yyyy, -7, { fn curdate() }) THEN 1
                                  WHEN m.DelinquencyDate IS NOT NULL
										AND convert(varchar(8),m.DelinquencyDate,112) <= DATEADD(yyyy, -7, { fn curdate() }) THEN 1
                                  WHEN m.Received IS NOT NULL
										AND convert(varchar(8),m.Received,112) <= DATEADD(yyyy, -7, { fn curdate() }) THEN 1
                                  ELSE 0
                             END AS CbrOutofStatute,
                        ISNULL(m.cbroverride, 0) AS CbrOverride,
                        ISNULL(m.cbrextenddays, 0) AS ExtendDays,
                        s.CbrReport AS StatusCbrReport,
                        s.CbrDelete AS StatusCbrDelete,
                        s.IsBankruptcy,
                        s.IsDeceased,
                        s.IsDisputed,
                        s.IsPif AS StatusIsPIF,
                        s.IsSIF AS StatusIsSIF,
                        CASE WHEN LEFT(s.statustype, 1) = '0' THEN 1
                                              ELSE 0
                                         END AS statusisactive,
                        DATEADD(DAY, ISNULL(@cfwaitDays, 0) + ISNULL(m.cbrExtendDays, 0), m.Received) AS ReportableDate,                 
                        ISNULL(m.CbrException32, 0) AS PrvCbrException,
                        --0 AS cbrException,
                         CASE WHEN ( @useaccountoriginalcreditor = 1
                                                  AND m.originalcreditor IS NOT NULL
                                                  AND m.originalcreditor <> '' ) THEN LEFT(m.originalcreditor, 30)
                                           WHEN ( @usecustomeroriginalcreditor = 1
                                                  AND @CustomerOriginalCreditor IS NOT NULL
                                                  AND @CustomerOriginalCreditor <> '') THEN @CustomerOriginalCreditor
                                           WHEN ( @DefaultOriginalCreditor IS NOT NULL
                                                  AND @DefaultOriginalCreditor <> '' ) THEN @DefaultOriginalCreditor
                                           ELSE LEFT(@CustomerName, 30)
                                      END AS NextOriginalCreditor,
                        
                        CASE WHEN ( @UseCustomerOriginalCreditor = 1
                                               AND @CreditorClass <> '00'
                                               AND @CreditorClass IS NOT NULL
                                               AND @CreditorClass <> '' ) THEN @CreditorClass
                                        ELSE @CreditorClass
                                   END AS NextCreditorClass,  
                        [m].[ContractDate],
                        CASE WHEN (ISDATE(m.[ContractDate]) = 0 AND @CreditorClass IN ('01','03','05','06','07','08','09','10','11','12','13','14','15'))
						--01 Retail
						--02 Medical/Health Care
						--03 Oil Company
						--04 Government
						--05 Personal Services
						--06 Insurance
						--07 Educational
						--08 Banking
						--09 Rental/Leasing
						--10 Utilities
						--11 Cable/Cellular
						--12 Financial
						--13 Credit Union
						--14 Automotive
						--15 Check Guarantee
                                       
                                       THEN 0
                                  ELSE 1
                             END AS CbrValidContractToPay,
                        [m].[account] AS ConsumerAccountNumber,
                         s.IsFraud AS StatusIsFraud,
                        CASE WHEN m.SettlementID IS NOT NULL THEN 1 ELSE 0 END AS SettlementArrangement,
                       
                        CASE WHEN @PrincipalOnly = 1 THEN ROUND(m.current1,0,1)
                                         ELSE ROUND(m.current0,0,1)
                                    END  as NextCurrentBalance, 
                                    
						CASE WHEN ISNULL(m.soldportfolio,0) > 0 then 2
							 WHEN ISNULL(m.purchasedportfolio,0) > 0 then 1
							 ELSE 0 END AS [PortfolioIndicator],

						m.lastpaidamt ,
						ISNULL(LEFT(m.specialnote,3),'') AS specialnote,
						m.PersonalReceivership_Amortization,
						m.ChargeOffDate,
                        '  ' AS NextAccountStatus,
                        NULL AS NextSpecialComment,
                        m.customer,
                        m.SoldPortfolio,
                        x.cbrexception as cbrexception,
                        --de.accountid as disconfiguredAccountid,
                        o.*,
                        m.returned
                from
						dbo.master m   
                        INNER JOIN dbo.status s  ON s.code = m.status
               			left outer join dbo.cbrDataChargeOffex(null) o on m.number = o.chargeoffnumber
               			outer apply cbrDataMasterExceptionex(m.Delinquencydate , m.Received , m.ContractDate , m.originalcreditor , 
						  @useaccountoriginalcreditor , @usecustomeroriginalcreditor , @DefaultOriginalCreditor , 
						  @CustomerOriginalCreditor ,  m.account , o.HasChargeOffRecord , 
						  o.SecondaryAgencyIdenitifier , o.SecondaryAccountNumber , o.ChargeOffAmount , 
						  @IsValidAccountType , @DefaultCreditorClass , @IsChargeOffData , @PortfolioType, m.original ) x
					WHERE   m.customer = @customer 
						AND ( m.number = @accountid or @accountid is null)			
                        AND s.CbrReport = 1
                        AND ISNULL(m.cbrPrevent,0) = 0 	)	
                        select* from cbrmasterpoints;
                        
 

GO
