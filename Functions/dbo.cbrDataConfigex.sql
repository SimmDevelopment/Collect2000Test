SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataConfigex] ( @AccountId INT )
RETURNS TABLE
AS 
    RETURN

			WITH    AcctCustomer
              AS ( SELECT DISTINCT customer
                    FROM dbo.[master] m
                    WHERE
                        m.number = @accountid OR @accountid IS NULL) ,
			
			cbrDataConfig as (
				  
                SELECT  cf.enabled AS CbrEnabled,
                        cf.portfolioType,
                        cf.accountType,
                        cf.minBalance,
                        cf.waitDays,
                        --cf.creditorClass,
                        cf.originalCreditor AS DefaultOriginalCreditor,
                        cf.useAccountOriginalCreditor,
                        cf.useCustomerOriginalCreditor,
                        cf.principalOnly,
                        cf.includeCodebtors,
                        cf.deleteReturns,
                        c.Customer as customercode,
                        c.CCustomerID AS customerid,
                        SUBSTRING(c.[name], 1, 50) AS CustomerName,
                        c.cbrOriginalCreditor AS CustomerOriginalCreditor,
                        c.cbrCreditorClass AS CustomerCreditorClass,
                        CASE WHEN [cbr_setup].[IndustryCode] = 'DEBTCOLL' THEN 0 ELSE 1 END as IsChargeOffData,
						null as cddAbbrev, -- cdd.Abbrev as cddAbbrev,
						null as cddLookup,  -- cdd.[Lookup] as cddLookup
                        CASE WHEN IVA.IsValidAccountType = 0 THEN 0 ELSE 1 END AS IsValidAccountType,
                        cf.creditorClass as DefaultCreditorClass

						from	acctcustomer a 
                        INNER JOIN dbo.customer c WITH ( NOLOCK ) ON a.customer = c.customer                
						INNER JOIN dbo.cbr_effectiveconfiguration cf WITH ( NOLOCK ) on c.ccustomerid = cf.customerid
						Inner JOIN dbo.cbr_effectivesetup AS [cbr_setup] ON [c].[ccustomerid] = [cbr_Setup].[customerid]
						CROSS APPLY (Select result AS IsvalidAccountType from [dbo].[cbr_IsValidAccountType_Tbl]([IndustryCode], [PortfolioType], [AccountType])) IVA
						--LEFT OUTER JOIN [dbo].CBRDictionary cdd ON [c].[ccustomerid] = cdd.ccustomerid
						) 
				select * from cbrdataconfig;
GO
