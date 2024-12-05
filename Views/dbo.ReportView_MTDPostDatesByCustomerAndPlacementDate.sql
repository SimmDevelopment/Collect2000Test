SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ReportView_MTDPostDatesByCustomerAndPlacementDate]
AS
    WITH    [Futures]
              AS ( SELECT   [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1) AS [PlacementMonth],
                            [pdc].[customer] AS [Customer],
                            SUM(CASE WHEN [pdc].PaymentLinkUID IS NOT NULL AND DATEDIFF(m,[pdc].[Deposit],cf.[eomdate]) > 0 THEN [pdc].[amount] 
								 WHEN [pdc].PaymentLinkUID IS NULL AND DATEDIFF(m,[pdc].[Deposit],cf.[eomdate]) = 0 AND [pdc].[Active] = 1 THEN [pdc].[amount] 
								 ELSE 0 END) 
							 AS [Amount],
							SUM(CASE WHEN [pdc].PaymentLinkUID IS NOT NULL AND DATEDIFF(m,[pdc].[Deposit],cf.[eomdate]) > 0 THEN [pdc].[projectedfee]
								 WHEN [pdc].PaymentLinkUID IS NULL AND DATEDIFF(m,[pdc].[Deposit],cf.[eomdate]) = 0 AND [pdc].[Active] = 1 THEN [pdc].[projectedfee] 
								 ELSE 0 END)
                             AS [Fee]
                   FROM     [dbo].[pdc]
                            INNER JOIN [dbo].[master] ON [master].[number] = [pdc].[number]
                            FULL OUTER JOIN [dbo].[payhistory] ON [pdc].[Paymentlinkuid] =[payhistory].[Paymentlinkuid],
                            controlfile cf
                   WHERE    Deposit <= cf.[eomdate] AND ([payhistory].[uid] NOT IN (Select reverseofuid from payhistory) OR [pdc].[PaymentLinkUID] IS NULL)
                   Group by [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1) ,
                            [pdc].[customer]
                   UNION ALL
                   SELECT   [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1) AS [PlacementMonth],
                            [master].[customer] AS [Customer],
                            SUM(CASE WHEN [DebtorCreditCards].PaymentLinkUID IS NOT NULL AND DATEDIFF(m,[DebtorCreditCards].[DepositDate],cf.[eomdate]) > 0 THEN [DebtorCreditCards].[Amount]
								 WHEN [DebtorCreditCards].PaymentLinkUID IS NULL AND DATEDIFF(m,[DebtorCreditCards].[DepositDate],cf.[eomdate]) = 0 AND [DebtorCreditCards].[IsActive] = 1 THEN [DebtorCreditCards].[Amount]
								 ELSE 0 END) 
							 AS [Amount],
                            SUM(CASE WHEN [DebtorCreditCards].PaymentLinkUID IS NOT NULL AND DATEDIFF(m,[DebtorCreditCards].[DepositDate],cf.[eomdate]) > 0 THEN [DebtorCreditCards].[projectedfee]
								 WHEN [DebtorCreditCards].PaymentLinkUID IS NULL AND DATEDIFF(m,[DebtorCreditCards].[DepositDate],cf.[eomdate]) = 0 AND [DebtorCreditCards].[IsActive] = 1 THEN [DebtorCreditCards].[projectedfee]
								 ELSE 0 END )
							 AS [Fee]
                   FROM     [dbo].[DebtorCreditCards]
                            INNER JOIN [dbo].[master] ON [master].[number] = [DebtorCreditCards].[number]
                            FULL OUTER JOIN [dbo].[payhistory] ON [DebtorCreditCards].[Paymentlinkuid] =[payhistory].[Paymentlinkuid],
                            [ControlFile] cf
                   WHERE    [DepositDate] <= cf.[eomdate] AND ([payhistory].[uid] NOT IN (Select reverseofuid from payhistory) OR [DebtorCreditCards].[Paymentlinkuid] IS NULL)
                   GROUP BY [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1) ,
                            [master].[customer] ) 
                            ,
                            
            [PostDates] as (select placementmonth,customer,sum(amount) as amount,sum(fee) as fee from futures group by placementmonth,customer),

            [Collections]
              AS ( SELECT   [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1) AS [PlacementMonth],
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
                            INNER JOIN [dbo].[master] ON [master].[number] = [payhistory].[number]
                            AND master.sysyear = payhistory.systemyear AND master.sysmonth = payhistory.systemmonth
                   GROUP BY [payhistory].[customer],
                            [dbo].[DateSerial]([master].[sysyear], [master].[sysmonth], 1))
                            
    SELECT  Coalesce(c.[PlacementMonth], f.[PlacementMonth]) AS [PlacementMonth],
            Coalesce(c.[Customer], f.[Customer]) AS [Customer],
            ISNULL(SUM(c.[Amount]), 0) AS [MTD Collections],
            ISNULL(SUM(c.[Fee]), 0) AS [MTD Fees],
            ISNULL(SUM(f.[Amount]), 0) AS [Post Dates],
            ISNULL(SUM(f.[Fee]), 0) AS [Projected Fees]
    FROM    [Futures] f
            FULL OUTER JOIN postdates c ON c.Customer = f.Customer and c.[PlacementMonth] = f.[PlacementMonth]
    GROUP BY Coalesce(c.[PlacementMonth], f.[PlacementMonth]),
            Coalesce(c.[Customer], f.[Customer]) 

GO
