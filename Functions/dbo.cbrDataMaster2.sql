SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[cbrDataMaster2]
    ( @AccountId INT , @Customer VARCHAR(7))
RETURNS TABLE
AS  
    RETURN
    SELECT
            m.Customer, m.number, m.Status, m.qlevel, m.received AS receiveddate, m.DelinquencyDate,
            m.original1 AS OriginalPrincipal, m.original, ROUND(m.current1, 0, 1) AS CurrentPrincipal,
            ROUND(m.current0, 0, 1) AS CurrentBalance, m.lastpaid,
            LEFT(LTRIM(RTRIM(m.OriginalCreditor)), 30) AS OriginalCreditor, [m].[ContractDate],
            [m].[account] AS ConsumerAccountNumber,
                        --CASE WHEN IVA.IsValidAccountType = 0 THEN 0 ELSE 1 END AS IsValidAccountType,
                        --CASE WHEN 
            m.SettlementID, -- IS NOT NULL THEN 1 ELSE 0 END AS SettlementArrangement,  --used by liquid?  sceduledpayment? sif?
            m.soldportfolio, m.purchasedportfolio, m.lastpaidamt, m.CLIDLP AS clidlp,
            LEFT(UPPER(LTRIM(RTRIM(ISNULL(m.specialnote, '')))), 2) AS specialnote,
            ISNULL(m.cbrPrevent, 0) AS cbrPrevent, ISNULL(m.cbroverride, 0) AS CbrOverride,
            ISNULL(m.cbrextenddays, 0) AS ExtendDays, ISNULL(m.CbrException32, 0) AS PrvCbrException,
            m.PersonalReceivership_Amortization, s.CbrReport AS StatusCbrReport, s.CbrDelete AS StatusCbrDelete,
            s.IsBankruptcy, s.IsDeceased, s.IsDisputed, s.IsPif AS StatusIsPIF, s.IsSIF AS StatusIsSIF,
            s.IsFraud AS StatusIsFraud, m.returned as returned
        FROM
            dbo.master m
        INNER JOIN dbo.status s ON  s.code = m.status
        WHERE
            m.number = @accountid
        UNION
        SELECT
            m.Customer, m.number, m.Status, m.qlevel, m.received AS receiveddate, m.DelinquencyDate,
            m.original1 AS OriginalPrincipal, m.original, ROUND(m.current1, 0, 1) AS CurrentPrincipal,
            ROUND(m.current0, 0, 1) AS CurrentBalance, m.lastpaid,
            LEFT(LTRIM(RTRIM(m.OriginalCreditor)), 30) AS OriginalCreditor, [m].[ContractDate],
            [m].[account] AS ConsumerAccountNumber,
                        --CASE WHEN IVA.IsValidAccountType = 0 THEN 0 ELSE 1 END AS IsValidAccountType,
                        --CASE WHEN 
            m.SettlementID, -- IS NOT NULL THEN 1 ELSE 0 END AS SettlementArrangement,  --used by liquid?  sceduledpayment? sif?
            m.soldportfolio, m.purchasedportfolio, m.lastpaidamt, m.CLIDLP AS clidlp,
            LEFT(UPPER(LTRIM(RTRIM(ISNULL(m.specialnote, '')))), 2) AS specialnote,
            ISNULL(m.cbrPrevent, 0) AS cbrPrevent, ISNULL(m.cbroverride, 0) AS CbrOverride,
            ISNULL(m.cbrextenddays, 0) AS ExtendDays, ISNULL(m.CbrException32, 0) AS PrvCbrException,
            m.PersonalReceivership_Amortization, s.CbrReport AS StatusCbrReport, s.CbrDelete AS StatusCbrDelete,
            s.IsBankruptcy, s.IsDeceased, s.IsDisputed, s.IsPif AS StatusIsPIF, s.IsSIF AS StatusIsSIF,
            s.IsFraud AS StatusIsFraud, m.returned as returned
        FROM
            dbo.master m
        INNER JOIN dbo.status s ON  s.code = m.status
        WHERE    
             m.customer = @customer;


GO
