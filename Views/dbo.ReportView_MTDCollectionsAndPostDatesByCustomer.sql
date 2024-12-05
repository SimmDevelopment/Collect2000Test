SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ReportView_MTDCollectionsAndPostDatesByCustomer]
AS
    WITH    [Futures]
              AS ( SELECT   [pdc].[customer] AS [Customer],
                            [pdc].[amount] AS [Amount],
                            [pdc].[projectedfee] AS [Fee]
                   FROM     [dbo].[pdc],
                            controlfile cf
                   WHERE    [pdc].[Active] = 1
                            AND Deposit <= cf.[eomdate]
                   UNION ALL
                   SELECT   [master].[customer] AS [Customer],
                            [DebtorCreditCards].[Amount],
                            [DebtorCreditCards].[projectedfee] AS [Fee]
                   FROM     [dbo].[DebtorCreditCards]
                            INNER JOIN [dbo].[master] ON [master].[number] = [DebtorCreditCards].[number],
                            [ControlFile] cf
                   WHERE    [DebtorCreditCards].[IsActive] = 1
                            AND [DepositDate] <= cf.[eomdate] ),
            [Collections]
              AS ( SELECT   [payhistory].[customer] AS [Customer],
                            SUM(CASE WHEN [payhistory].[batchtype] IN ( 'PA', 'PC', 'PU' ) THEN dbo.Custom_CalculatePaymentTotalPaid([payhistory].[uid])
                                     WHEN [payhistory].[batchtype] IN ( 'PAR', 'PCR', 'PUR' ) THEN -1 * dbo.Custom_CalculatePaymentTotalPaid([payhistory].[uid])
                                     ELSE 0
                                END) AS [Amount],
                            SUM(CASE WHEN [payhistory].[batchtype] IN ( 'PA', 'PC', 'PU' ) THEN dbo.Custom_CalculatePaymentTotalFee([payhistory].[uid])
                                     WHEN [payhistory].[batchtype] IN ( 'PAR', 'PCR', 'PUR' ) THEN -1 * dbo.Custom_CalculatePaymentTotalFee([payhistory].[uid])
                                     ELSE 0
                                END) AS [Fee]
                   FROM     [payhistory] [payhistory] WITH ( NOLOCK ),
                            [controlfile] cf WITH ( NOLOCK )
                   WHERE    [payhistory].[systemmonth] = cf.currentMonth
                            AND [payhistory].[systemyear] = cf.currentYear
                   GROUP BY [payhistory].[customer])
                   
    SELECT  ISNULL(c.[Customer], f.[Customer]) AS [Customer],
            ISNULL(SUM(c.[Amount]), 0) AS [MTD Collections],
            ISNULL(SUM(c.[Fee]), 0) AS [MTD Fees],
            ISNULL(SUM(f.[Amount]), 0) AS [Post Dates],
            ISNULL(SUM(f.[Fee]), 0) AS [Projected Fees]
    FROM    [Futures] f
            LEFT OUTER JOIN [Collections] c ON c.Customer = f.Customer
    GROUP BY c.Customer,
            f.customer

GO
