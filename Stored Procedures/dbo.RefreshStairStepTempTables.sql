SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[RefreshStairStepTempTables]
AS
SET NOCOUNT ON;
SET ANSI_WARNINGS OFF;

DECLARE @RunTimeExceeded BIT = 0;
DECLARE @LastRunTime DATETIMEOFFSET;
DECLARE @Interval INT;

SELECT @LastRunTime = RunTime,
       @Interval = interval
FROM dbo.ProgramExecutionTimer
WHERE code = 'RefreshStairStepTempTables'
      AND LastRun = 1;

begin transaction;
IF (SYSDATETIMEOFFSET() > DATEADD(minute,@Interval,@LastRunTime))
BEGIN

	DELETE FROM dbo.StairStep_Temp_Adjustments
	DELETE FROM dbo.StairStep_Temp_ControlFile
	DELETE FROM dbo.StairStep_Temp_Placements
	DELETE FROM dbo.StairStep_Temp_PostDates
	DELETE FROM dbo.StairStep_Temp_Transactions
	
    INSERT INTO dbo.StairStep_Temp_Placements
    (
        customer,
        PlacementMonth,
        AccountsPlaced,
        GrossDollarsPlaced
    )
    SELECT Customer,
           PlacementMonth,
           AccountsPlaced,
           GrossDollarsPlaced
    FROM dbo.StairStep_Placements;

    INSERT INTO dbo.StairStep_Temp_ControlFile
    (
        CurrentMonth
    )
    SELECT CurrentMonth
    FROM dbo.GetCurrentMonthTable();

    INSERT INTO dbo.StairStep_Temp_Adjustments
    (
        customer,
        PlacementMonth,
        AdjustmentTransactions,
        AmountAdjusted
    )
    SELECT Customer,
           PlacementMonth,
           AdjustmentTransactions,
           AmountAdjusted
    FROM dbo.StairStep_Adjustments;

    INSERT INTO dbo.StairStep_Temp_Transactions
    (
        customer,
        PlacementMonth,
        TransactionMonth,
        Transactions,
        Paid,
        Fee,
        PrincipalPaid,
        PrincipalFee,
        InvoicablePaid,
        InvoicableFee
    )
    SELECT Customer,
           PlacementMonth,
           TransactionMonth,
           Transactions,
           Paid,
           Fee,
           PrincipalPaid,
           PrincipalFee,
           InvoicablePaid,
           InvoicableFee
    FROM dbo.StairStep_Transactions;
	
declare @eomdate datetime;
set @eomdate = (select eomdate from controlfile);
	   
drop table if exists #pdcmaster
drop table if exists #phmaster
drop table if exists #dmaster

select m.number,m.sysyear, m.sysmonth, pdc.uid as pdcuid, pdc.paymentlinkuid , pdc.customer, pdc.deposit, pdc.amount, pdc.active, pdc.ProjectedFee
into #pdcmaster
from master m with (nolock) join pdc with (nolock) on m.number = pdc.number
where deposit <= @eomdate 

create clustered index cx_pdcmaster_number_pdcuid on #pdcmaster (number, pdcuid)
create nonclustered index ix_pdcmaster_paymentlinkuid on #pdcmaster (paymentlinkuid, sysyear, sysmonth, customer, deposit, amount, active, projectedfee)

select distinct number into #dmaster from #pdcmaster 

create clustered index cx_dmaster_number on #dmaster(number)

select m.number, ph.uid as phuid, ph.paymentlinkuid
into #phmaster
from #dmaster m join payhistory ph with (nolock) on m.number = ph.number

create clustered index cx_phmaster_number_phuid on #phmaster(number, phuid)
create nonclustered index ix_phmaster_paymentlinkuid on #phmaster(paymentlinkuid)

delete from #phmaster where phuid in (select reverseofuid from payhistory with (nolock) where ReverseOfUID is not null and reverseofuid <> 0)

drop table if exists #dccmaster
drop table if exists #phmaster2
drop table if exists #cmaster

select m.number,m.sysyear, m.sysmonth, dcc.id as dccuid, dcc.paymentlinkuid , m.customer, dcc.DepositDate, dcc.amount, dcc.isactive, dcc.ProjectedFee
into #dccmaster
from master m with (nolock) join DebtorCreditCards dcc with (nolock) on m.number = dcc.number
where depositdate <= @eomdate 

create clustered index cx_dccmaster_number_dccuid on #dccmaster (number, dccuid)
create nonclustered index ix_dccmaster_paymentlinkuid on #dccmaster (paymentlinkuid, sysyear, sysmonth, customer, depositdate, amount, isactive, projectedfee)

select distinct number into #cmaster from #dccmaster 

create clustered index cx_cmaster_number on #cmaster(number)

select m.number, ph.uid as phuid, ph.paymentlinkuid
into #phmaster2
from #cmaster m join payhistory ph with (nolock) on m.number = ph.number

create clustered index cx_phmaster2_number_phuid on #phmaster2(number, phuid)
create nonclustered index ix_phmaster2_paymentlinkuid on #phmaster2(paymentlinkuid)

delete from #phmaster2 where phuid in (select reverseofuid from payhistory with (nolock) where ReverseOfUID is not null and reverseofuid <> 0)

;WITH    [Futures]
              AS (  SELECT   [dbo].[DateSerial](pdc.[sysyear], pdc.[sysmonth], 1) AS [PlacementMonth],
                            [pdc].[customer] AS [Customer],
                            SUM(CASE WHEN [pdc].PaymentLinkUID IS NOT NULL AND DATEDIFF(m,[pdc].[Deposit],@eomdate) > 0 THEN [pdc].[amount] 
								 WHEN [pdc].PaymentLinkUID IS NULL AND DATEDIFF(m,[pdc].[Deposit],@eomdate) = 0 AND [pdc].[Active] = 1 THEN [pdc].[amount] 
								 ELSE 0 END) 
							 AS [Amount],
							SUM(CASE WHEN [pdc].PaymentLinkUID IS NOT NULL AND DATEDIFF(m,[pdc].[Deposit],@eomdate) > 0 THEN [pdc].[projectedfee]
								 WHEN [pdc].PaymentLinkUID IS NULL AND DATEDIFF(m,[pdc].[Deposit],@eomdate) = 0 AND [pdc].[Active] = 1 THEN [pdc].[projectedfee] 
								 ELSE 0 END)
                             AS [Fee]
                   FROM     #pdcmaster pdc
                            LEFT OUTER JOIN #phmaster [payhistory] ON [pdc].[Paymentlinkuid] =[payhistory].[Paymentlinkuid]
				   Group by pdc.sysyear, pdc.sysmonth, 
                            [pdc].[customer]
                   UNION ALL
                   SELECT   [dbo].[DateSerial](DebtorCreditCards.[sysyear], DebtorCreditCards.[sysmonth], 1) AS [PlacementMonth],
                            DebtorCreditCards.[customer] AS [Customer],
                            SUM(CASE WHEN [DebtorCreditCards].PaymentLinkUID IS NOT NULL AND DATEDIFF(m,[DebtorCreditCards].[DepositDate],@eomdate) > 0 THEN [DebtorCreditCards].[Amount]
								 WHEN [DebtorCreditCards].PaymentLinkUID IS NULL AND DATEDIFF(m,[DebtorCreditCards].[DepositDate],@eomdate) = 0 AND [DebtorCreditCards].[IsActive] = 1 THEN [DebtorCreditCards].[Amount]
								 ELSE 0 END) 
							 AS [Amount],
                            SUM(CASE WHEN [DebtorCreditCards].PaymentLinkUID IS NOT NULL AND DATEDIFF(m,[DebtorCreditCards].[DepositDate],@eomdate) > 0 THEN [DebtorCreditCards].[projectedfee]
								 WHEN [DebtorCreditCards].PaymentLinkUID IS NULL AND DATEDIFF(m,[DebtorCreditCards].[DepositDate],@eomdate) = 0 AND [DebtorCreditCards].[IsActive] = 1 THEN [DebtorCreditCards].[projectedfee]
								 ELSE 0 END )
							 AS [Fee]
                   FROM     #dccmaster DebtorCreditCards
                            LEFT OUTER JOIN #phmaster2 payhistory ON [DebtorCreditCards].[Paymentlinkuid] =[payhistory].[Paymentlinkuid]
				   GROUP BY sysyear, sysmonth,
                            DebtorCreditCards.[customer] ),                            
            [PostDates] as (select placementmonth,customer,sum(amount) as amount,sum(fee) as fee from futures group by placementmonth,customer)
    INSERT INTO dbo.StairStep_Temp_PostDates
    (
        PlacementMonth,
        customer,
        [MTD Collections],
        [MTD Fees],
        [Post Dates],
        [Projected Fees]
    )
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

    update programexecutiontimer
    set lastrun = 0
    where runtime = @LastRunTime;

    INSERT INTO dbo.ProgramExecutionTimer
    (
        Code,
        RunTime,
        LastRun,
        interval
    )
    VALUES
    (   'RefreshStairStepTempTables', -- Code - varchar(500)
        SYSDATETIMEOFFSET(),          -- RunTime - datetimeoffset
        1,                            -- LastRun - bit
        @Interval                     -- Interval - int
        );
END;
commit transaction;


GO
