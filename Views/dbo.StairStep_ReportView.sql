SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[StairStep_ReportView]
AS
    SELECT  [Placements].[Customer] AS [Customer] ,
            [Placements].[PlacementMonth] ,
            [Placements].[AccountsPlaced] AS [AccountsPlaced] ,
            [Placements].[GrossDollarsPlaced] AS [GrossDollarsPlaced] ,
            [Placements].[GrossDollarsPlaced] + ISNULL([Adjustments].[AmountAdjusted], 0) AS [NetDollarsPlaced] ,
            ISNULL([Adjustments].[AmountAdjusted], 0) AS [Adjustments] ,
            ISNULL(SUM(ISNULL([Transactions].[Paid], 0)), 0) AS [TotalCollections] ,
            ISNULL(SUM(ISNULL([Transactions].[Fee], 0)), 0) AS [TotalFees] ,
            ISNULL(SUM(ISNULL([Transactions].[PrincipalPaid], 0)), 0) AS [TotalPrincipalCollections] ,
            ISNULL(SUM(ISNULL([Transactions].[PrincipalFee], 0)), 0) AS [TotalPrincipalFees] ,
            ISNULL(SUM(ISNULL([Transactions].[InvoicablePaid], 0)), 0) AS [TotalInvoicableCollections] ,
            ISNULL(SUM(ISNULL([Transactions].[InvoicableFee], 0)), 0) AS [TotalInvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE WHEN [Transactions].[TransactionMonth] >= [ControlFile].[CurrentMonth] THEN [Transactions].[Paid]
                                   ELSE 0
                              END, 0)), 0) AS [CurrentMonthCollections] ,
            ISNULL(SUM(ISNULL(CASE WHEN [Transactions].[TransactionMonth] >= [ControlFile].[CurrentMonth] THEN [Transactions].[Fee]
                                   ELSE 0
                              END, 0)), 0) AS [CurrentMonthFees] ,
            ISNULL(SUM(ISNULL(CASE WHEN [Transactions].[TransactionMonth] >= [ControlFile].[CurrentMonth] THEN [Transactions].[PrincipalPaid]
                                   ELSE 0
                              END, 0)), 0) AS [CurrentMonthPrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE WHEN [Transactions].[TransactionMonth] >= [ControlFile].[CurrentMonth] THEN [Transactions].[PrincipalFee]
                                   ELSE 0
                              END, 0)), 0) AS [CurrentMonthPrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE WHEN [Transactions].[TransactionMonth] >= [ControlFile].[CurrentMonth] THEN [Transactions].[InvoicablePaid]
                                   ELSE 0
                              END, 0)), 0) AS [CurrentMonthInvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE WHEN [Transactions].[TransactionMonth] >= [ControlFile].[CurrentMonth] THEN [Transactions].[InvoicableFee]
                                   ELSE 0
                              END, 0)), 0) AS [CurrentMonthInvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE WHEN [Transactions].[TransactionMonth] = DATEADD(MONTH, -1, [ControlFile].[CurrentMonth]) THEN [Transactions].[Paid]
                                   ELSE 0
                              END, 0)), 0) AS [LastMonthCollections] ,
            ISNULL(SUM(ISNULL(CASE WHEN [Transactions].[TransactionMonth] = DATEADD(MONTH, -1, [ControlFile].[CurrentMonth]) THEN [Transactions].[Fee]
                                   ELSE 0
                              END, 0)), 0) AS [LastMonthFees] ,
            ISNULL(SUM(ISNULL(CASE WHEN [Transactions].[TransactionMonth] = DATEADD(MONTH, -1, [ControlFile].[CurrentMonth]) THEN [Transactions].[PrincipalPaid]
                                   ELSE 0
                              END, 0)), 0) AS [LastMonthPrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE WHEN [Transactions].[TransactionMonth] = DATEADD(MONTH, -1, [ControlFile].[CurrentMonth]) THEN [Transactions].[PrincipalFee]
                                   ELSE 0
                              END, 0)), 0) AS [LastMonthPrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE WHEN [Transactions].[TransactionMonth] = DATEADD(MONTH, -1, [ControlFile].[CurrentMonth]) THEN [Transactions].[InvoicablePaid]
                                   ELSE 0
                              END, 0)), 0) AS [LastMonthInvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE WHEN [Transactions].[TransactionMonth] = DATEADD(MONTH, -1, [ControlFile].[CurrentMonth]) THEN [Transactions].[InvoicableFee]
                                   ELSE 0
                              END, 0)), 0) AS [LastMonthInvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE WHEN DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth]) <= 0 THEN [Transactions].[Paid]
                                   ELSE 0
                              END, 0)), 0) AS [Month1Collections] ,
            ISNULL(SUM(ISNULL(CASE WHEN DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth]) <= 0 THEN [Transactions].[Fee]
                                   ELSE 0
                              END, 0)), 0) AS [Month1Fees] ,
            ISNULL(SUM(ISNULL(CASE WHEN DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth]) <= 0 THEN [Transactions].[PrincipalPaid]
                                   ELSE 0
                              END, 0)), 0) AS [Month1PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE WHEN DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth]) <= 0 THEN [Transactions].[PrincipalFee]
                                   ELSE 0
                              END, 0)), 0) AS [Month1PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE WHEN DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth]) <= 0 THEN [Transactions].[InvoicablePaid]
                                   ELSE 0
                              END, 0)), 0) AS [Month1InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE WHEN DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth]) <= 0 THEN [Transactions].[InvoicableFee]
                                   ELSE 0
                              END, 0)), 0) AS [Month1InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 1 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month2Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 1 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month2Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 1 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month2PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 1 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month2PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 1 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month2InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 1 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month2InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 2 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month3Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 2 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month3Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 2 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month3PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 2 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month3PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 2 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month3InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 2 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month3InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 3 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month4Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 3 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month4Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 3 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month4PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 3 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month4PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 3 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month4InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 3 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month4InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 4 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month5Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 4 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month5Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 4 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month5PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 4 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month5PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 4 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month5InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 4 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month5InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 5 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month6Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 5 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month6Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 5 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month6PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 5 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month6PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 5 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month6InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 5 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month6InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 6 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month7Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 6 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month7Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 6 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month7PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 6 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month7PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 6 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month7InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 6 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month7InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 7 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month8Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 7 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month8Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 7 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month8PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 7 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month8PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 7 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month8InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 7 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month8InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 8 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month9Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 8 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month9Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 8 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month9PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 8 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month9PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 8 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month9InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 8 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month9InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 9 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month10Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 9 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month10Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 9 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month10PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 9 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month10PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 9 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month10InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 9 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month10InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 10 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month11Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 10 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month11Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 10 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month11PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 10 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month11PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 10 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month11InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 10 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month11InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 11 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month12Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 11 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month12Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 11 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month12PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 11 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month12PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 11 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month12InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 11 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month12InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 12 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month13Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 12 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month13Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 12 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month13PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 12 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month13PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 12 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month13InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 12 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month13InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 13 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month14Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 13 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month14Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 13 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month14PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 13 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month14PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 13 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month14InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 13 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month14InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 14 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month15Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 14 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month15Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 14 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month15PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 14 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month15PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 14 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month15InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 14 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month15InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 15 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month16Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 15 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month16Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 15 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month16PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 15 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month16PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 15 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month16InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 15 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month16InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 16 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month17Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 16 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month17Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 16 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month17PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 16 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month17PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 16 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month17InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 16 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month17InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 17 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month18Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 17 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month18Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 17 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month18PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 17 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month18PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 17 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month18InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 17 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month18InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 18 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month19Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 18 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month19Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 18 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month19PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 18 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month19PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 18 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month19InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 18 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month19InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 19 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month20Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 19 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month20Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 19 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month20PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 19 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month20PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 19 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month20InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 19 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month20InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 20 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month21Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 20 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month21Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 20 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month21PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 20 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month21PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 20 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month21InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 20 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month21InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 21 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month22Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 21 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month22Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 21 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month22PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 21 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month22PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 21 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month22InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 21 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month22InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 22 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month23Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 22 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month23Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 22 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month23PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 22 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month23PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 22 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month23InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 22 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month23InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 23 THEN [Transactions].[Paid]
                                ELSE 0
                              END, 0)), 0) AS [Month24Collections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 23 THEN [Transactions].[Fee]
                                ELSE 0
                              END, 0)), 0) AS [Month24Fees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 23 THEN [Transactions].[PrincipalPaid]
                                ELSE 0
                              END, 0)), 0) AS [Month24PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 23 THEN [Transactions].[PrincipalFee]
                                ELSE 0
                              END, 0)), 0) AS [Month24PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 23 THEN [Transactions].[InvoicablePaid]
                                ELSE 0
                              END, 0)), 0) AS [Month24InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth])
                                WHEN 23 THEN [Transactions].[InvoicableFee]
                                ELSE 0
                              END, 0)), 0) AS [Month24InvoicableFees] ,
            ISNULL(SUM(ISNULL(CASE WHEN DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth]) > 24 THEN [Transactions].[Paid]
                                   ELSE 0
                              END, 0)), 0) AS [Month99Collections] ,
            ISNULL(SUM(ISNULL(CASE WHEN DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth]) > 24 THEN [Transactions].[Fee]
                                   ELSE 0
                              END, 0)), 0) AS [Month99Fees] ,
            ISNULL(SUM(ISNULL(CASE WHEN DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth]) > 24 THEN [Transactions].[PrincipalPaid]
                                   ELSE 0
                              END, 0)), 0) AS [Month99PrincipalCollections] ,
            ISNULL(SUM(ISNULL(CASE WHEN DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth]) > 24 THEN [Transactions].[PrincipalFee]
                                   ELSE 0
                              END, 0)), 0) AS [Month99PrincipalFees] ,
            ISNULL(SUM(ISNULL(CASE WHEN DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth]) > 24 THEN [Transactions].[InvoicablePaid]
                                   ELSE 0
                              END, 0)), 0) AS [Month99InvoicableCollections] ,
            ISNULL(SUM(ISNULL(CASE WHEN DATEDIFF(MONTH, [Placements].[PlacementMonth], [Transactions].[TransactionMonth]) > 24 THEN [Transactions].[InvoicableFee]
                                   ELSE 0
                              END, 0)), 0) AS [Month99InvoicableFees] ,
            ISNULL(postdates.[Post Dates], 0) AS postdates
    FROM    [dbo].[StairStep_Temp_Placements] AS [Placements] WITH ( NOLOCK )
            CROSS JOIN [dbo].[StairStep_Temp_ControlFile] AS [ControlFile]
            LEFT OUTER JOIN [dbo].[StairStep_Temp_Adjustments] AS [Adjustments] WITH ( NOLOCK ) ON [Placements].[Customer] = [Adjustments].[Customer]
                                                                                          AND [Placements].[PlacementMonth] = [Adjustments].[PlacementMonth]
            LEFT OUTER JOIN [dbo].[StairStep_Temp_Transactions] AS [Transactions] WITH ( NOLOCK ) ON [Placements].[Customer] = [Transactions].[Customer]
                                                                                            AND [Placements].[PlacementMonth] = [Transactions].[PlacementMonth]
            LEFT OUTER JOIN dbo.StairStep_Temp_PostDates AS postdates WITH ( NOLOCK ) ON [Placements].[Customer] = [postdates].[Customer]
                                                                                AND [Placements].[PlacementMonth] = [postdates].[PlacementMonth]
    GROUP BY [Placements].[Customer] ,
            [Placements].[PlacementMonth] ,
            [Placements].[AccountsPlaced] ,
            [Placements].[GrossDollarsPlaced] ,
            [Adjustments].[AmountAdjusted] ,
            ISNULL(postdates.[Post Dates], 0);



GO
