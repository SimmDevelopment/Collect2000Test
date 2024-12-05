SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ReportView_MTDCollectionsAndPostDatesByDesk]
AS
    WITH    [Futures]
              AS ( SELECT   [pdc].[desk] AS [Desk],
                            [pdc].[amount] AS [Amount],
                            [pdc].[projectedfee] AS [Fee]
                   FROM     [dbo].[pdc],
                            controlfile cf
                   WHERE    [pdc].[Active] = 1
                            AND Deposit < cf.[eomdate]
                   UNION ALL
                   SELECT   [master].[desk] AS [Desk],
                            [DebtorCreditCards].[Amount],
                            [DebtorCreditCards].[projectedfee] AS [Fee]
                   FROM     [dbo].[DebtorCreditCards]
                            INNER JOIN [dbo].[master] ON [master].[number] = [DebtorCreditCards].[number],
                            [ControlFile] cf
                   WHERE    [DebtorCreditCards].[IsActive] = 1
                            AND [DepositDate] < cf.[eomdate] ),
            [Collections]
              AS ( SELECT   [payhistory].[desk] AS [Desk],
                            SUM(CASE WHEN [payhistory].[batchtype] IN ( 'PA', 'PC', 'PU' ) THEN dbo.Custom_CalculatePaymentTotalPaid([payhistory].[uid])
                                     WHEN [payhistory].[batchtype] IN ( 'PAR', 'PCR', 'PUR' ) THEN -1 * dbo.Custom_CalculatePaymentTotalPaid([payhistory].[uid])
                                     ELSE 0
                                END) AS [Amount],
                            SUM(CASE WHEN [payhistory].[batchtype] IN ( 'PA', 'PC', 'PU' ) THEN dbo.Custom_CalculatePaymentTotalFee([payhistory].[uid])
                                     WHEN [payhistory].[batchtype] IN ( 'PAR', 'PCR', 'PUR' ) THEN -1 * dbo.Custom_CalculatePaymentTotalFee([payhistory].[uid])
                                     ELSE 0
                                END) AS [Fee]
                   FROM     [payhistory] [payhistory] WITH ( NOLOCK )
                            JOIN [desk] [desk] WITH ( NOLOCK ) ON [payhistory].[desk] = [desk].[Code],
                            [controlfile] cf WITH ( NOLOCK )
                   WHERE    [payhistory].[systemmonth] = cf.currentMonth
                            AND [payhistory].[systemyear] = cf.currentYear
                   GROUP BY [payhistory].[desk],
                            [desk].[Name])
                            
    SELECT  c.[Desk],
            d.[Name] AS [Desk Name],
            SUM(c.[Amount]) AS [MTD Collections],
            SUM(c.[Fee]) AS [MTD Fees],
            SUM(f.[Amount]) AS [Post Dates],
            SUM(f.[Fee]) AS [Projected Fees]
    FROM    [Futures] f
            JOIN [Desk] d ON d.Code = f.Desk
            JOIN [Collections] c ON c.Desk = d.Code
    GROUP BY c.Desk,
            d.Name

GO
