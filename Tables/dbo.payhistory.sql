CREATE TABLE [dbo].[payhistory]
(
[number] [int] NULL,
[Seq] [int] NOT NULL,
[batchtype] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[matched] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sortdata] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paytype] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paymethod] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[systemmonth] [smallint] NULL,
[systemyear] [smallint] NULL,
[entered] [datetime] NULL,
[desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[checknbr] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoiced] [datetime] NULL,
[InvoiceSort] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoiceType] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InvoicePayType] [real] NULL,
[comment] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[datepaid] [datetime] NOT NULL CONSTRAINT [DF_payhistory_datepaid] DEFAULT (convert(varchar(10),getdate(),23)),
[totalpaid] [money] NOT NULL CONSTRAINT [DF_payhistory_totalpaid] DEFAULT (0),
[paid1] [money] NOT NULL CONSTRAINT [DF_payhistory_paid1] DEFAULT (0),
[paid2] [money] NOT NULL CONSTRAINT [DF_payhistory_paid2] DEFAULT (0),
[paid3] [money] NOT NULL CONSTRAINT [DF_payhistory_paid3] DEFAULT (0),
[paid4] [money] NOT NULL CONSTRAINT [DF_payhistory_paid4] DEFAULT (0),
[paid5] [money] NOT NULL CONSTRAINT [DF_payhistory_paid5] DEFAULT (0),
[paid6] [money] NOT NULL CONSTRAINT [DF_payhistory_paid6] DEFAULT (0),
[paid7] [money] NOT NULL CONSTRAINT [DF_payhistory_paid7] DEFAULT (0),
[paid8] [money] NOT NULL CONSTRAINT [DF_payhistory_paid8] DEFAULT (0),
[paid9] [money] NOT NULL CONSTRAINT [DF_payhistory_paid9] DEFAULT (0),
[paid10] [money] NOT NULL CONSTRAINT [DF_payhistory_paid10] DEFAULT (0),
[fee1] [money] NOT NULL CONSTRAINT [DF_payhistory_fee1] DEFAULT (0),
[fee2] [money] NOT NULL CONSTRAINT [DF_payhistory_fee2] DEFAULT (0),
[fee3] [money] NOT NULL CONSTRAINT [DF_payhistory_fee3] DEFAULT (0),
[fee4] [money] NOT NULL CONSTRAINT [DF_payhistory_fee4] DEFAULT (0),
[fee5] [money] NOT NULL CONSTRAINT [DF_payhistory_fee5] DEFAULT (0),
[fee6] [money] NOT NULL CONSTRAINT [DF_payhistory_fee6] DEFAULT (0),
[fee7] [money] NOT NULL CONSTRAINT [DF_payhistory_fee7] DEFAULT (0),
[fee8] [money] NOT NULL CONSTRAINT [DF_payhistory_fee8] DEFAULT (0),
[fee9] [money] NOT NULL CONSTRAINT [DF_payhistory_fee9] DEFAULT (0),
[fee10] [money] NOT NULL CONSTRAINT [DF_payhistory_fee10] DEFAULT (0),
[balance] [money] NULL,
[balance1] [money] NULL,
[balance3] [money] NULL,
[balance4] [money] NULL,
[balance5] [money] NULL,
[balance6] [money] NULL,
[balance7] [money] NULL,
[balance8] [money] NULL,
[balance9] [money] NULL,
[balance10] [money] NULL,
[balance2] [money] NULL,
[BatchNumber] [float] NULL,
[UID] [int] NOT NULL IDENTITY(1, 1),
[Invoice] [int] NULL,
[InvoiceFlags] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [def_payhistory_InvoiceFlags] DEFAULT ('0000000000'),
[OverPaidAmt] [money] NULL,
[ForwardeeFee] [money] NULL,
[ReverseOfUID] [int] NULL,
[AccruedSurcharge] [money] NULL,
[TransCost] [money] NULL,
[Tax] [money] NULL CONSTRAINT [DF__Payhistory__Tax__328C56FB] DEFAULT (0),
[AttorneyID] [int] NULL,
[CollectorFee] [money] NULL,
[PAIdentifier] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AIMAgencyId] [int] NULL,
[AIMDueAgency] [money] NULL,
[AIMAgencyFee] [money] NULL,
[FeeSched] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollectorFeeSched] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaidToDate] [money] NULL,
[IsFreeDemand] [bit] NOT NULL CONSTRAINT [DF__PayHistor__IsFre__62121842] DEFAULT (0),
[IsCorrection] [bit] NOT NULL CONSTRAINT [DF__PayHistor__IsCor__63063C7B] DEFAULT (0),
[CreatedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__PayHistor__Creat__63FA60B4] DEFAULT (suser_sname()),
[Created] [datetime] NOT NULL CONSTRAINT [DF__PayHistor__Creat__64EE84ED] DEFAULT (getdate()),
[BatchPmtCreatedBy] [varchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__PayHistor__Batch__65E2A926] DEFAULT (suser_sname()),
[BatchPmtCreated] [datetime] NOT NULL CONSTRAINT [DF__PayHistor__Batch__66D6CD5F] DEFAULT (getdate()),
[datetimeentered] [datetime] NULL CONSTRAINT [DF_payhistory_datetimeentered_1] DEFAULT (getdate()),
[CurrencyISO3] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_payhistory_CurrencyISO3] DEFAULT ('USD'),
[AIMBatchId] [int] NULL,
[AIMSendingID] [int] NULL,
[SubBatchType] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PostDateUID] [int] NULL,
[PaymentLinkUID] [int] NULL,
[DebtorId] [int] NULL,
[Echo] [bit] NULL CONSTRAINT [DF__payhistory__Echo__74B4AF74] DEFAULT ((0)),
[Echoed] [datetime] NULL,
[EchoID] [int] NULL,
[PromiseAppliedAmt] [money] NULL,
[Reference] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tr_DB_ProcessPayment] ON [dbo].[payhistory]
FOR INSERT
AS
declare @payments table(purchasedPortfolioId int,soldportfolioid int,soldportfoliotypeid int
,commissionPercentage float,filenumber int,amountpaid money
,paymentType varchar(30),currentAgencyFee money,buyergroupid int,investorgroupid int,datepaid datetime)
insert into @payments(purchasedPortfolioId,soldportfolioid,soldportfoliotypeid
,commissionPercentage,filenumber,amountpaid
,paymentType,currentAgencyFee,buyergroupid,investorgroupid,datepaid)
select      purchasedportfolio,soldportfolio,s.portfoliotypeid
,calculationamount,m.number,i.totalpaid
,i.batchtype,isnull(AIMAgencyFee,0),s.buyergroupid,p.investorgroupid,i.datepaid
from  inserted i
join master m on m.number = i.number
join aim_portfolio p on p.portfolioid = m.purchasedportfolio
left outer join aim_portfolio s on s.portfolioid = m.soldportfolio
left outer join aim_ledgerdefinition ld on ld.portfolioid = p.portfolioid and ld.ledgertypeid = 14


-- insert credits into the purchased portfolios for positive payments
insert      into aim_ledger(ledgertypeid,credit,togroupid,dateentered,portfolioid,number,comments)
select      2,amountpaid,investorgroupid,datepaid,purchasedportfolioid,filenumber,'Batch Type: '+paymenttype
from  @payments
where purchasedportfolioid is not null and paymentType in ('PU','PA','PC')

-- insert debits into the purchased portfolios if account was sold
insert      into aim_ledger(ledgertypeid,debit,togroupid,fromgroupid,dateentered,portfolioid,number,comments)
select       25,amountpaid,buyergroupid,investorgroupid,datepaid,purchasedportfolioid,filenumber,'Batch Type: '+paymenttype
from  @payments
where purchasedportfolioid is not null and paymentType in ('PU','PA','PC')
and soldportfolioid is not null and soldportfoliotypeid <> 2

-- debit fee commission against purchased portfolio
insert      into aim_ledger(ledgertypeid,debit,togroupid,fromgroupid,dateentered,portfolioid,number,comments)
select      14,amountpaid * (commissionpercentage),-1,investorgroupid,datepaid,purchasedportfolioid,filenumber,'Batch Type: '+paymenttype
from  @payments
where purchasedportfolioid is not null and paymentType in ('PU','PA','PC')
and (soldportfolioid is null or soldportfolioid = '' or soldportfolioid = '0' or soldportfolioid  in (select portfolioid from aim_portfolio where portfoliotypeid = 2)) and commissionpercentage > 0

-- debit agency fee to purchased portfolio
insert      into aim_ledger(ledgertypeid,debit,fromgroupid,dateentered,portfolioid,number,comments)
select       14,currentAgencyFee,investorgroupid,datepaid,purchasedportfolioid,filenumber,'Batch Type: '+paymenttype
from  @payments
where purchasedportfolioid is not null and paymentType in ('PU','PA','PC')
and (soldportfolioid is null or soldportfolioid = '' or soldportfolioid = '0' or soldportfolioid  in (select portfolioid from aim_portfolio where portfoliotypeid = 2)) and currentAgencyFee > 0

-- insert debits into the purchased portfolios for reversals
insert      into aim_ledger(ledgertypeid,debit,togroupid,dateentered,portfolioid,number,comments)
select      2,amountpaid,investorgroupid,datepaid,purchasedportfolioid,filenumber,'Batch Type: '+paymenttype
from  @payments
where purchasedportfolioid is not null and paymentType in ('PUR','PAR','PCR')

-- insert credits into the purchased portfolios if account was sold for reversals
insert      into aim_ledger(ledgertypeid,credit,togroupid,fromgroupid,dateentered,portfolioid,number,comments)
select       26,amountpaid,investorgroupid,buyergroupid,datepaid,purchasedportfolioid,filenumber,'Batch Type: '+paymenttype
from  @payments
where purchasedportfolioid is not null and paymentType in ('PUR','PAR','PCR')
and soldportfolioid is not null and soldportfoliotypeid <> 2

-- credit back payment commission to purchased portfolio for reversals
insert      into aim_ledger(ledgertypeid,credit,fromgroupid,togroupid,dateentered,portfolioid,number,comments)
select      14,amountpaid * (commissionpercentage),-1,investorgroupid,datepaid,purchasedportfolioid,filenumber,'Batch Type: '+paymenttype
from  @payments
where purchasedportfolioid is not null and paymentType in ('PUR','PAR','PCR')
and (soldportfolioid is null or soldportfolioid = '' or soldportfolioid = '0' or soldportfolioid  in (select portfolioid from aim_portfolio where portfoliotypeid = 2)) and commissionpercentage > 0

-- credit agency fee to back purchased portfolio for reversals
insert      into aim_ledger(ledgertypeid,credit,fromgroupid,togroupid,dateentered,portfolioid,number,comments)
select      14,currentAgencyFee,-1,investorgroupid,datepaid,purchasedportfolioid,filenumber,'Batch Type: '+paymenttype
from  @payments
where purchasedportfolioid is not null and paymentType in ('PUR','PAR','PCR')
and (soldportfolioid is null or soldportfolioid = '' or soldportfolioid = '0' or soldportfolioid  in (select portfolioid from aim_portfolio where portfoliotypeid = 2)) and currentAgencyFee > 0

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_payhistory_ItemizationBalance]
ON [dbo].[payhistory]
FOR INSERT
AS 
BEGIN
update  ib 
    set 
    ib.[ItemizationBalance1] = isnull(ib.[ItemizationBalance1],0.00)+
	case
		when i.[batchtype] in ('PU','PC','PA') then -i.paid1
		when i.[batchtype] in ('PUR','PCR','PAR') then i.paid1
		when i.[batchtype] in ('DA') then -i.[paid1]
		when i.[batchtype] in ('DAR') then i.[paid1]
		when i.[batchtype] in ('LJ') then -i.[paid1]
		when i.[batchtype] in ('LJR') then i.[paid1]
		else 0.00 end,
    ib.[ItemizationBalance2] = isnull(ib.[ItemizationBalance2],0.00)+
	case 
		when i.[batchtype] in ('DA') then -i.[paid2]
		when i.[batchtype] in ('DAR') then i.[paid2]
		when i.[batchtype] in ('LJ') then i.[paid2]
		when i.[batchtype] in ('LJR') then -i.[paid2]
		else 0.00 end,
	ib.[ItemizationBalance3] = isnull(ib.[ItemizationBalance3],0.00)+
	case 
		when i.[batchtype] in ('DA') then -(i.[paid3]+i.[paid4]+i.[paid5]+i.[paid6]+i.[paid7]+i.[paid8]+i.[paid9]+i.[paid10])
		when i.[batchtype] in ('DAR') then (i.[paid3]+i.[paid4]+i.[paid5]+i.[paid6]+i.[paid7]+i.[paid8]+i.[paid9]+i.[paid10])
		when i.[batchtype] in ('LJ') then (i.[paid3]+i.[paid4]+i.[paid5]+i.[paid6]+i.[paid7]+i.[paid8]+i.[paid9]+i.[paid10])
		when i.[batchtype] in ('LJR') then -(i.[paid3]+i.[paid4]+i.[paid5]+i.[paid6]+i.[paid7]+i.[paid8]+i.[paid9]+i.[paid10])
		else 0.00 end,
	ib.[ItemizationBalance4] = isnull(ib.[ItemizationBalance4],0.00)+
	case 
		when i.[batchtype] in ('PU','PA','PC') then (i.[totalpaid]-i.[accruedsurcharge])
		when i.[batchtype] in ('PUR','PAR','PCR') then -(i.[totalpaid]-i.[accruedsurcharge])
		when i.[batchtype] in ('DA') then i.[paid1]
		when i.[batchtype] in ('DAR') then -i.[paid1]
		when i.[batchtype] in ('LJ') then i.[paid1]
		when i.[batchtype] in ('LJR') then -i.[paid1]
		else 0.00 end
from
[dbo].[itemizationbalance] ib 
inner join [inserted] i on i.[number] = ib.[AccountID]
where getdate() > ib.[ItemizationDate] and ib.[ItemizationDate] is not null and i.BatchNumber IS NOT NULL

END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_payhistory_WorkFlow_SystemEvents]
ON [dbo].[payhistory]
FOR INSERT
AS

CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

INSERT INTO #EventAccounts ([AccountID])
SELECT [INSERTED].[number]
FROM [INSERTED]
WHERE [INSERTED].[BatchType] LIKE 'P_';

IF @@ROWCOUNT > 0 BEGIN
	EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Payment Received', @CreateNew = 0;

	TRUNCATE TABLE #EventAccounts;
END;

INSERT INTO #EventAccounts ([AccountID])
SELECT [INSERTED].[number]
FROM [INSERTED]
WHERE [INSERTED].[BatchType] LIKE 'P_R'
AND NOT [INSERTED].[SubBatchType] = 'RFD';

IF @@ROWCOUNT > 0 BEGIN
	EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Payment Reversed', @CreateNew = 0;

	TRUNCATE TABLE #EventAccounts;
END;

DROP TABLE #EventAccounts;

RETURN;

GO
ALTER TABLE [dbo].[payhistory] ADD CONSTRAINT [pk_Payhistory] PRIMARY KEY NONCLUSTERED ([UID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Payhistory_AIM_Batch] ON [dbo].[payhistory] ([AIMBatchId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Payhistory_AIM_Agency] ON [dbo].[payhistory] ([batchtype], [AIMAgencyId]) INCLUDE ([AIMSendingID], [entered], [number]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_Payhistory_BatchType] ON [dbo].[payhistory] ([batchtype], [entered]) INCLUDE ([customer], [datepaid], [datetimeentered], [desk], [number], [systemmonth], [systemyear], [totalpaid], [UID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Payhistory_Customer] ON [dbo].[payhistory] ([customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Payhistory_DatePaid] ON [dbo].[payhistory] ([datepaid]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Payhistory_Entered] ON [dbo].[payhistory] ([entered]) INCLUDE ([OverPaidAmt]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_payhistory_invoice] ON [dbo].[payhistory] ([Invoice]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Payhistory1] ON [dbo].[payhistory] ([number], [batchtype], [totalpaid], [invoiced]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Payhistory3] ON [dbo].[payhistory] ([number], [Seq]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [uk_Payhistory] ON [dbo].[payhistory] ([number], [UID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Payhistory_PaymentLinkUID] ON [dbo].[payhistory] ([PaymentLinkUID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Payhistory_PostDateUID] ON [dbo].[payhistory] ([PostDateUID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Payhistory_ReverseOfUID] ON [dbo].[payhistory] ([ReverseOfUID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Payhistory4] ON [dbo].[payhistory] ([systemyear], [systemmonth]) INCLUDE ([batchtype], [desk], [UID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'AIM Agency ID', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'AIMAgencyId'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'AttorneyID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'balance'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'balance1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'balance10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'balance2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'balance3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'balance4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'balance5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'balance6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'balance7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'balance8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'balance9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Batch number this payment was enterd into', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'BatchNumber'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date/Time batch was created', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'BatchPmtCreated'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that created the batch', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'BatchPmtCreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'batch type (PU,PUR,PC,PCR,PA,PAR,DA,DAR', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'batchtype'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check Number', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'checknbr'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collector Fee calculated on the payment', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'CollectorFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collector Fee schedule used to calculate fees', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'CollectorFeeSched'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Payment comment (Free form comment value)', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'comment'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date/Time this payment was created', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'Created'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User that created this payment', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'CreatedBy'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'ctl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Currency this payment was entered as', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'CurrencyISO3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer that this payment was posted aginst', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date Debtor made this payment', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'datepaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk code that received credit for this payment', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date this Payment was processed into Latitude', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'entered'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fees calculated on this payment aginst this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'fee1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fees calculated on this payment aginst this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'fee10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fees calculated on this payment aginst this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'fee2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fees calculated on this payment aginst this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'fee3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fees calculated on this payment aginst this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'fee4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fees calculated on this payment aginst this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'fee5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fees calculated on this payment aginst this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'fee6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fees calculated on this payment aginst this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'fee7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fees calculated on this payment aginst this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'fee8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fees calculated on this payment aginst this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'fee9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fee schedule used to calculate fees', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'FeeSched'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount withheld by attorney or forwarder', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'ForwardeeFee'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Invoice number this payment appears on', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'Invoice'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date this payment was placed on an invoice', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'invoiced'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used to control what money buckets are invoices on this payment', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'InvoiceFlags'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used by Latitude invoice application', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'InvoicePayType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used by Latitude invoice application', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'InvoiceSort'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used by Latitude invoice application', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'InvoiceType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Correction Flag (On Reversals this flag indicates reversal is a correction)', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'IsCorrection'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Matched flag (Y - Payment is matched, N Not matched)', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'matched'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique file number related to Master.number', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'if this payment created a over payment amount, this is the amount of the over pa', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'OverPaidAmt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount paid against Principle Balance', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'paid1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount paid against this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'paid10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount Paid against Interest Balance', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'paid2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount paid against this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'paid3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount paid against this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'paid4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount paid against this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'paid5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount paid against this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'paid6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount paid against this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'paid7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount paid against this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'paid8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount paid against this bucket', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'paid9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The unique id of a transaction that comes back from an AIM agency or attorney. Equates to the respective identifier in the AIM APAY or YGC file. ', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'PAIdentifier'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sum of All payments todate', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'PaidToDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Text value of payment method (Credit Card,Check, Money Order, etc...)  as it rel', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'paymethod'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Text description of batch type', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'paytype'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Amount of this payment that has been credited towards a promise. Null value indicates it is not eligible for applying to a promise. Zero means none of it has been applied towards a promise.', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'PromiseAppliedAmt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If this payment is a reversal, this column contains the Unique Identifer (UID) o', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'ReverseOfUID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sequence number of the Debtor making the payment.  Usually always 0 for the prim', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'Seq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Used by Latitude Invoice application', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'sortdata'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Secondary Batch Type (User Defined)', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'SubBatchType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting month for which this payment was credited', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'systemmonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting year for which this payment was credited', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'systemyear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'Tax'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total amount of this Payment or Adjustment', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'totalpaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'TransCost'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique number assigned to every payment', 'SCHEMA', N'dbo', 'TABLE', N'payhistory', 'COLUMN', N'UID'
GO
