SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataConfig_Acct] ( @accountid INT )
RETURNS TABLE
AS 
    RETURN

/* 
	These functions need to be kept in sync with all applicable changes: 
	cbrDataConfig
	cbrDataConfig_Acct
	cbrDataConfig_All
*/

     WITH    AcctCustomer
              AS ( SELECT  m.customer
                    FROM dbo.[master] m
                    
                    WHERE
                    m.number = @accountid 
	)
    SELECT
            cf.[enabled] AS CbrEnabled, cf.portfolioType, cf.accountType, cf.minBalance, cf.waitDays,
            cf.creditorClass, cf.originalCreditor AS DefaultOriginalCreditor, cf.useAccountOriginalCreditor,
            cf.useCustomerOriginalCreditor, cf.principalOnly, cf.includeCodebtors, cf.deleteReturns,
            [cbr_setup].[IndustryCode], c.customer AS customercode, c.CCustomerID AS Customerid,
            SUBSTRING(c.[name], 1, 50) AS CustomerName, c.cbrCreditorClass AS CustomerCreditorClass,
            c.cbrOriginalCreditor AS CustomerOriginalCreditor, null as Abbrev, null as [Lookup]  --cdd.Abbrev, cdd.[Lookup]
        FROM
            dbo.customer c
        INNER JOIN acctcustomer a ON  c.customer = a.customer
        INNER JOIN dbo.cbr_effectiveconfiguration cf ON  cf.customerid = c.ccustomerid
        INNER JOIN dbo.[cbr_effectivesetup] [cbr_setup] ON  [c].[ccustomerid] = [cbr_Setup].[customerid]
        --LEFT OUTER JOIN [dbo].CBRDictionary cdd  ON  [c].[ccustomerid] = cdd.ccustomerid

GO
