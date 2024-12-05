SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ReportView_MTDCollectionsAndPostDatesByCustomerByBranch]
AS
    WITH    [Futures]
              AS ( SELECT   [desk].[Branch] AS [Branch],
                            [pdc].[customer] AS [Customer],
                            [pdc].[amount] AS [Amount],
                            [pdc].[projectedfee] AS [Fee]
                   FROM     [dbo].[pdc] [pdc] WITH ( NOLOCK )
                            JOIN [dbo].[desk] [desk] WITH ( NOLOCK ) ON [pdc].[desk] = [desk].[code],
                            controlfile cf
                   WHERE    [pdc].[Active] = 1
                            AND Deposit < cf.[eomdate]
                   UNION ALL
                   SELECT   [master].[Branch] AS [Branch],
                            [master].[customer] AS [Customer],
                            [DebtorCreditCards].[Amount],
                            [DebtorCreditCards].[projectedfee] AS [Fee]
                   FROM     [dbo].[DebtorCreditCards]
                            INNER JOIN [dbo].[master] ON [master].[number] = [DebtorCreditCards].[number],
                            [ControlFile] cf
                   WHERE    [DebtorCreditCards].[IsActive] = 1
                            AND [DepositDate] < cf.[eomdate] ),
            [Collections]
              AS ( SELECT   [desk].[Branch] AS [Branch],
                            [payhistory].[customer] AS [Customer],
                            SUM(CASE WHEN [payhistory].[batchtype] IN ( 'PA', 'PC', 'PU' ) THEN dbo.Custom_CalculatePaymentTotalPaid([payhistory].[uid])
                                     WHEN [payhistory].[batchtype] IN ( 'PAR', 'PCR', 'PUR' ) THEN -1 * dbo.Custom_CalculatePaymentTotalPaid([payhistory].[uid])
                                     ELSE 0
                                END) AS [Amount],
                            SUM(CASE WHEN [payhistory].[batchtype] IN ( 'PA', 'PC', 'PU' ) THEN dbo.Custom_CalculatePaymentTotalFee([payhistory].[uid])
                                     WHEN [payhistory].[batchtype] IN ( 'PAR', 'PCR', 'PUR' ) THEN -1 * dbo.Custom_CalculatePaymentTotalFee([payhistory].[uid])
                                     ELSE 0
                                END) AS [Fee]
                   FROM     [payhistory] [payhistory] WITH ( NOLOCK )
                            JOIN [desk] [desk] WITH ( NOLOCK ) ON [desk].[code] = [payhistory].[desk],
                            [controlfile] cf WITH ( NOLOCK )
                   WHERE    [payhistory].[systemmonth] = cf.currentMonth
                            AND [payhistory].[systemyear] = cf.currentYear
                   GROUP BY [payhistory].[customer],
                            [desk].[Branch])
                            
    SELECT  f.[Branch],
            f.[Customer],
            0 AS [MTD Collections],
            0 AS [MTD Fees],
            ISNULL(SUM(f.[Amount]), 0) AS [Post Dates],
            ISNULL(SUM(f.[Fee]), 0) AS [Projected Fees]
    FROM    [Futures] f
    GROUP BY f.Branch,
            f.Customer
    UNION ALL
    SELECT  c.[Branch],
            c.[Customer],
            ISNULL(SUM(c.[Amount]), 0) AS [MTD Collections],
            ISNULL(SUM(c.[Fee]), 0) AS [MTD Fees],
            0 AS [Post Dates],
            0 AS [Projected Fees]
    FROM    [Collections] c
    GROUP BY c.[Branch],
            c.[Customer]

GO
