CREATE TABLE [dbo].[master]
(
[number] [int] NOT NULL,
[link] [int] NULL,
[desk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_master_desk] DEFAULT (0),
[Name] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street1] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Street2] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zipcode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ctl] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[other] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MR] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[account] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[homephone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[workphone] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[specialnote] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[received] [datetime] NULL,
[closed] [datetime] NULL,
[returned] [datetime] NULL,
[lastpaid] [datetime] NULL,
[lastpaidamt] [money] NULL,
[lastinterest] [datetime] NULL,
[interestrate] [money] NULL,
[worked] [datetime] NULL,
[userdate1] [datetime] NULL,
[userdate2] [datetime] NULL,
[userdate3] [datetime] NULL,
[contacted] [datetime] NULL,
[status] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[original] [money] NOT NULL CONSTRAINT [DF_master_original] DEFAULT (0),
[original1] [money] NOT NULL CONSTRAINT [DF_master_original1] DEFAULT (0),
[original2] [money] NOT NULL CONSTRAINT [DF_master_original2] DEFAULT (0),
[original3] [money] NOT NULL CONSTRAINT [DF_master_original3] DEFAULT (0),
[original4] [money] NOT NULL CONSTRAINT [DF_master_original4] DEFAULT (0),
[original5] [money] NOT NULL CONSTRAINT [DF_master_original5] DEFAULT (0),
[original6] [money] NOT NULL CONSTRAINT [DF_master_original6] DEFAULT (0),
[original7] [money] NOT NULL CONSTRAINT [DF_master_original7] DEFAULT (0),
[original8] [money] NOT NULL CONSTRAINT [DF_master_original8] DEFAULT (0),
[original9] [money] NOT NULL CONSTRAINT [DF_master_original9] DEFAULT (0),
[original10] [money] NOT NULL CONSTRAINT [DF_master_original10] DEFAULT (0),
[Accrued2] [money] NOT NULL CONSTRAINT [DF_master_Accrued2] DEFAULT (0),
[Accrued10] [money] NOT NULL CONSTRAINT [DF_master_Accrued10] DEFAULT (0),
[paid] [money] NOT NULL CONSTRAINT [DF_master_paid] DEFAULT (0),
[paid1] [money] NOT NULL CONSTRAINT [DF_master_paid1] DEFAULT (0),
[paid2] [money] NOT NULL CONSTRAINT [DF_master_paid2] DEFAULT (0),
[paid3] [money] NOT NULL CONSTRAINT [DF_master_paid3] DEFAULT (0),
[paid4] [money] NOT NULL CONSTRAINT [DF_master_paid4] DEFAULT (0),
[paid5] [money] NOT NULL CONSTRAINT [DF_master_paid5] DEFAULT (0),
[paid6] [money] NOT NULL CONSTRAINT [DF_master_paid6] DEFAULT (0),
[paid7] [money] NOT NULL CONSTRAINT [DF_master_paid7] DEFAULT (0),
[paid8] [money] NOT NULL CONSTRAINT [DF_master_paid8] DEFAULT (0),
[paid9] [money] NOT NULL CONSTRAINT [DF_master_paid9] DEFAULT (0),
[paid10] [money] NOT NULL CONSTRAINT [DF_master_paid10] DEFAULT (0),
[current0] [money] NOT NULL CONSTRAINT [DF_master_current0] DEFAULT (0),
[current1] [money] NOT NULL CONSTRAINT [DF_master_current1] DEFAULT (0),
[current2] [money] NOT NULL CONSTRAINT [DF_master_current2] DEFAULT (0),
[current3] [money] NOT NULL CONSTRAINT [DF_master_current3] DEFAULT (0),
[current4] [money] NOT NULL CONSTRAINT [DF_master_current4] DEFAULT (0),
[current5] [money] NOT NULL CONSTRAINT [DF_master_current5] DEFAULT (0),
[current6] [money] NOT NULL CONSTRAINT [DF_master_current6] DEFAULT (0),
[current7] [money] NOT NULL CONSTRAINT [DF_master_current7] DEFAULT (0),
[current8] [money] NOT NULL CONSTRAINT [DF_master_current8] DEFAULT (0),
[current9] [money] NOT NULL CONSTRAINT [DF_master_current9] DEFAULT (0),
[current10] [money] NOT NULL CONSTRAINT [DF_master_current10] DEFAULT (0),
[attorney] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[assignedattorney] [datetime] NULL,
[promamt] [money] NULL,
[promdue] [datetime] NULL,
[sifpct] [money] NULL,
[queue] [varchar] (26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qflag] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qdate] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qlevel] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qtime] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[extracodes] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Salary] [money] NULL,
[feecode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clidlc] [datetime] NULL,
[clidlp] [datetime] NULL,
[seq] [int] NULL,
[Pseq] [int] NOT NULL CONSTRAINT [DF_master_Pseq] DEFAULT (0),
[Branch] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_master_Branch] DEFAULT (0),
[Finders] [datetime] NULL,
[COMPLETE1] [datetime] NULL,
[Complete2] [datetime] NULL,
[DESK1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DESK2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Full0] [datetime] NULL,
[TotalViewed] [int] NOT NULL,
[TotalWorked] [int] NOT NULL,
[TotalContacted] [int] NOT NULL,
[nsf] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasBigNote] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstDesk] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstReceived] [datetime] NULL,
[AgencyFlag] [tinyint] NULL,
[AgencyCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FeeSchedule] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustDivision] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustDistrict] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustBranch] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Delinquencydate] [datetime] NULL,
[CurrencyType] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOB] [datetime] NULL,
[sysmonth] [tinyint] NULL,
[SysYear] [smallint] NULL,
[DMDateStamp] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Master__DMDateSt__0ECE1972] DEFAULT (''),
[id1] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[id2] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PurchasedPortfolio] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SoldPortfolio] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OriginalCreditor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyID] [int] NULL,
[BPDate] [datetime] NULL,
[NSFDate] [datetime] NULL,
[ContractDate] [datetime] NULL,
[ChargeOffDate] [datetime] NULL,
[ShouldQueue] [bit] NOT NULL CONSTRAINT [DF__master__ShouldQu__63E486C4] DEFAULT (1),
[RestrictedAccess] [bit] NOT NULL CONSTRAINT [DF__master__Restrict__64D8AAFD] DEFAULT (0),
[LinkDriver] [bit] NOT NULL CONSTRAINT [DF_master_LinkDriver] DEFAULT (1),
[Score] [smallint] NULL,
[Salesman1ID] [int] NOT NULL CONSTRAINT [DF__Master__Salesman__013FDF81] DEFAULT (0),
[Salesman2ID] [int] NOT NULL CONSTRAINT [DF__Master__Salesman__023403BA] DEFAULT (0),
[Salesman3ID] [int] NOT NULL CONSTRAINT [DF__Master__Salesman__032827F3] DEFAULT (0),
[AIMAgency] [int] NULL,
[AIMAssigned] [datetime] NULL,
[cbrPrevent] [bit] NOT NULL CONSTRAINT [DF_master_cbrPrevent] DEFAULT (0),
[cbrException] [smallint] NOT NULL CONSTRAINT [DF_master_cbrException] DEFAULT (0),
[cbrExtendDays] [int] NULL,
[clialp] [money] NULL,
[clialc] [money] NULL,
[cbrOverride] [bit] NOT NULL CONSTRAINT [DF_master_cbrOverride] DEFAULT (0),
[viewed] [datetime] NULL,
[QueueHold] [datetime] NULL,
[Secured] [bit] NOT NULL CONSTRAINT [def_master_Secured] DEFAULT (0),
[PreviousCreditor] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StatuteDate] [datetime] NULL,
[AttorneyLawList] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyStatus] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClassOfBusiness] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ClaimType] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AttorneyAccountID] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InterestBuckets] [smallint] NULL,
[BlanketSIFOverride] [float] NULL,
[Archived] [datetime] NULL,
[PreventLinking] [bit] NOT NULL CONSTRAINT [def_master_PreventLinking] DEFAULT ((0)),
[IsInterestDeferred] [bit] NOT NULL CONSTRAINT [def_master_IsInterestDeferred] DEFAULT ((0)),
[DeferredInterest] [money] NULL,
[SettlementID] [int] NULL,
[PersonalReceivership_Amortization] [bit] NULL,
[ExchangeBatchID] [int] NULL,
[ChargedOff] [bit] NULL CONSTRAINT [DF__master__ChargedOff] DEFAULT ((0)),
[cbrException32] [int] NOT NULL CONSTRAINT [DF_master_cbrException32] DEFAULT ((0))
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE TRIGGER [dbo].[tr_MasterDelete] ON [dbo].[master]
FOR DELETE 
AS

DECLARE @RemovedAccounts TABLE (
	[customer] VARCHAR(7) NOT NULL,
	[SysYear] SMALLINT NOT NULL,
	[SysMonth] TINYINT NOT NULL,
	[NumberRemoved] INTEGER NOT NULL,
	[DollarsRemoved] MONEY NOT NULL,
	PRIMARY KEY (
		[customer] ASC,
		[SysYear] ASC,
		[SysMonth] ASC
	)
);

INSERT INTO @RemovedAccounts ([customer], [SysYear], [SysMonth], [NumberRemoved], [DollarsRemoved])
SELECT [DELETED].[customer],
	[DELETED].[SysYear],
	[DELETED].[SysMonth],
	COUNT(*),
	SUM([DELETED].[original])
FROM [DELETED]
GROUP BY [DELETED].[customer],
	[DELETED].[SysYear],
	[DELETED].[SysMonth]
ORDER BY [DELETED].[customer],
	[DELETED].[SysYear],
	[DELETED].[SysMonth];

UPDATE [dbo].[StairStep]
SET [NumberPlaced] = [NumberPlaced] - [NumberRemoved],
	[GrossDollarsPlaced] = [GrossDollarsPlaced] - [DollarsRemoved],
	[NetDollarsPlaced] = [NetDollarsPlaced] - [DollarsRemoved]
FROM [dbo].[StairStep]
INNER JOIN @RemovedAccounts AS [RemovedAccounts]
ON [StairStep].[customer] = [RemovedAccounts].[customer]
AND [StairStep].[SSYear] = [RemovedAccounts].[SysYear]
AND [StairStep].[SSMonth] = [RemovedAccounts].[SysMonth];


GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE  TRIGGER [dbo].[tr_MasterInsert] ON [dbo].[master]
FOR INSERT
AS

DECLARE @SystemMonth TINYINT;
DECLARE @SystemYear SMALLINT;

SELECT @SystemMonth = [CurrentMonth],
	@SystemYear = [CurrentYear]
FROM [dbo].[ControlFile];

UPDATE [dbo].[master]
SET [SysMonth] = @SystemMonth,
	[SysYear] = @SystemYear
FROM [dbo].[master]
INNER JOIN [INSERTED]
ON [master].[number] = [INSERTED].[number];

DECLARE @NewAccounts TABLE (
	[customer] NVARCHAR(7) NOT NULL PRIMARY KEY CLUSTERED,
	[NumberPlaced] INTEGER NOT NULL,
	[DollarsPlaced] MONEY NOT NULL
);

INSERT INTO @NewAccounts ([customer], [NumberPlaced], [DollarsPlaced])
SELECT [INSERTED].[customer],
	COUNT(*),
	SUM([INSERTED].[original])
FROM [INSERTED]
GROUP BY [INSERTED].[customer]
ORDER BY [INSERTED].[customer];

UPDATE [dbo].[StairStep]
SET [NumberPlaced] = [StairStep].[NumberPlaced] + [NewAccounts].[NumberPlaced],
	[GrossDollarsPlaced] = [GrossDollarsPlaced] + [NewAccounts].[DollarsPlaced],
	[NetDollarsPlaced] = [NetDollarsPlaced] + [NewAccounts].[DollarsPlaced]
FROM [dbo].[StairStep]
INNER JOIN @NewAccounts AS [NewAccounts]
ON [StairStep].[customer] = [NewAccounts].[customer]
WHERE [StairStep].[SSYear] = @SystemYear
AND [StairStep].[SSMonth] = @SystemMonth;

INSERT INTO [dbo].[StairStep] ([Customer], [SSYear], [SSMonth], [NumberPlaced], [GrossDollarsPlaced], [NetDollarsPlaced], [GTCollections], [GTFees], [TMCollections], [TMFees], [LMCollections], [LMFees], [Adjustments], [Month1], [Month2], [Month3], [Month4], [Month5], [Month6], [Month7], [Month8], [Month9], [Month10], [Month11], [Month12], [Month13], [Month14], [Month15], [Month16], [Month17], [Month18], [Month19], [Month20], [Month21], [Month22], [Month23], [Month24], [Month99])
SELECT [NewAccounts].[customer], @SystemYear, @SystemMonth, [NewAccounts].[NumberPlaced], [NewAccounts].[DollarsPlaced], [NewAccounts].[DollarsPlaced], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
FROM @NewAccounts AS [NewAccounts]
WHERE NOT EXISTS (
	SELECT *
	FROM [dbo].[StairStep]
	WHERE [StairStep].[customer] = [NewAccounts].[customer]
	AND [StairStep].[SSYear] = @SystemYear
	AND [StairStep].[SSMonth] = @SystemMonth
);



GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[tr_MasterUpdate] ON [dbo].[master]
    FOR UPDATE
AS
    IF UPDATE([account])
        OR UPDATE([id1])
        OR UPDATE([id2]) 
        INSERT  INTO dbo.Linking_DataUpdateEvent ( [DebtorID] )
                SELECT DISTINCT
                        Debtors.DebtorID
                FROM    [INSERTED]
                        INNER JOIN [DELETED] ON INSERTED.number = DELETED.number
                        INNER JOIN dbo.Debtors WITH ( NOLOCK ) ON INSERTED.number = Debtors.number
                WHERE   ( NOT ISNULL(INSERTED.account, '') = ISNULL(DELETED.account, '')
                          OR NOT ISNULL(INSERTED.id1, '') = ISNULL(DELETED.id1, '')
                          OR NOT ISNULL(INSERTED.id2, '') = ISNULL(DELETED.id2, '')
                        )
                        AND NOT EXISTS ( SELECT *
                                         FROM   dbo.Linking_DataUpdateEvent
                                         WHERE  Linking_DataUpdateEvent.DebtorID = Debtors.DebtorID ) ;
                                        
    IF UPDATE([status]) 
	BEGIN
	
		UPDATE [dbo].[master] SET SpecialNote = CASE WHEN s.cbrdelete = 1 THEN 'DA' 
		                                             WHEN s.isfraud = 1 THEN 'DF' 
													 WHEN s.cbrDelete = 0 AND [INSERTED].SpecialNote = 'DA' AND [INSERTED].cbrPrevent = 0  THEN NULL --LAT-9256 Need to add this case when the status gets changed by mistake before reporting
													 ELSE [INSERTED].SpecialNote END
		FROM    [INSERTED] 
		INNER JOIN [DELETED] ON INSERTED.number = DELETED.number
		INNER JOIN [dbo].[Master] m ON [INSERTED].number = m.number
		INNER JOIN [dbo].[status] s ON  INSERTED.[status] = s.code
		WHERE  ISNULL(INSERTED.[status], '') <> ISNULL(DELETED.[status], '') AND (s.cbrDelete = 1 OR s.IsFraud = 1 OR s.cbrDelete = 0)--LAT-9256 NEEd to add one more condition so that it could also handle cbrDelete = 0 statues
        
		UPDATE [dbo].[cbr_accounts] SET complianceCondition = CASE WHEN s.IsDisputed  = 1 THEN 'XB' ELSE complianceCondition END
		FROM    [INSERTED] 
		INNER JOIN [DELETED] ON INSERTED.number = DELETED.number
		INNER JOIN [dbo].[Master] m ON [INSERTED].number = m.number
		INNER JOIN [dbo].[status] s ON  INSERTED.[status] = s.code
		INNER JOIN [dbo].[cbr_accounts] a ON [INSERTED].number = a.AccountID
		WHERE  ISNULL(INSERTED.[status], '') <> ISNULL(DELETED.[status], '') AND (s.IsDisputed = 1) AND ISNULL(a.complianceCondition,'') = ''
        END;                        
                                         
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_master_WorkFlow_SystemEvents]
ON [dbo].[master]
FOR UPDATE
AS

CREATE TABLE #EventAccounts (
[AccountID] INTEGER NOT NULL,
[EventVariable] SQL_VARIANT NULL
);

IF UPDATE([Qlevel]) BEGIN
INSERT INTO #EventAccounts ([AccountID], [EventVariable])
SELECT [INSERTED].[number], CAST(NULL AS SQL_VARIANT)
FROM [INSERTED]
INNER JOIN [DELETED]
ON [INSERTED].[number] = [DELETED].[number]
WHERE [INSERTED].[qlevel] = '998'
AND NOT [DELETED].[qlevel] = '998'

IF EXISTS (SELECT * FROM #EventAccounts) BEGIN
EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Account Closed', @CreateNew = 0;

TRUNCATE TABLE #EventAccounts;
END;

INSERT INTO #EventAccounts ([AccountID], [EventVariable])
SELECT [INSERTED].[number], CAST(NULL AS SQL_VARIANT)
FROM [INSERTED]
INNER JOIN [DELETED]
ON [INSERTED].[number] = [DELETED].[number]
WHERE [INSERTED].[qlevel] = '999'
AND NOT [DELETED].[qlevel] = '999'

IF EXISTS (SELECT * FROM #EventAccounts) BEGIN
EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Account Returned', @CreateNew = 0;

TRUNCATE TABLE #EventAccounts;
END;
END;
IF UPDATE([Status]) BEGIN
INSERT INTO #EventAccounts ([AccountID], [EventVariable])
SELECT [INSERTED].[number], CAST(NULL AS SQL_VARIANT)
FROM [INSERTED]
INNER JOIN [DELETED]
ON [INSERTED].[number] = [DELETED].[number]
WHERE [INSERTED].[status] <> [DELETED].[status];

IF EXISTS (SELECT * FROM #EventAccounts) BEGIN
EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Status Changed', @CreateNew = 0;

TRUNCATE TABLE #EventAccounts;
END;
END;
IF UPDATE([TotalContacted]) BEGIN
INSERT INTO #EventAccounts ([AccountID], [EventVariable])
SELECT [INSERTED].[number], CAST(NULL AS SQL_VARIANT)
FROM [INSERTED]
INNER JOIN [DELETED]
ON [INSERTED].[number] = [DELETED].[number]
WHERE [INSERTED].[TotalContacted] > 0
AND ([DELETED].[TotalContacted] IS NULL
OR [DELETED].[TotalContacted] = 0);

IF EXISTS (SELECT * FROM #EventAccounts) BEGIN
EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'First Contacted', @CreateNew = 0;

TRUNCATE TABLE #EventAccounts;
END;
END;
IF UPDATE([BPDate]) BEGIN
INSERT INTO #EventAccounts ([AccountID], [EventVariable])
SELECT [INSERTED].[number], CAST(NULL AS SQL_VARIANT)
FROM [INSERTED]
INNER JOIN [DELETED]
ON [INSERTED].[number] = [DELETED].[number]
WHERE ([INSERTED].[BPDate] IS NOT NULL
AND [DELETED].[BPDate] IS NULL)
OR [DELETED].[BPDate] <> [INSERTED].[BPDate];

IF EXISTS (SELECT * FROM #EventAccounts) BEGIN
EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'Promise Broken', @CreateNew = 0;

TRUNCATE TABLE #EventAccounts;
END;
END;

DROP TABLE #EventAccounts

RETURN;

GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[trg_master_WorkFlow_SystemEvents_NewBusiness]
ON [dbo].[master]
FOR INSERT
AS

CREATE TABLE #EventAccounts (
	[AccountID] INTEGER NOT NULL,
	[EventVariable] SQL_VARIANT NULL
);

INSERT INTO #EventAccounts ([AccountID])
SELECT [INSERTED].[number]
FROM [INSERTED]
WHERE [INSERTED].[status] = 'NEW';

EXEC [dbo].[WorkFlow_RaiseAccountsEventByName] @EventName = 'New Business', @CreateNew = 0;

DROP TABLE #EventAccounts;

RETURN;

GO
ALTER TABLE [dbo].[master] ADD CONSTRAINT [pk_master] PRIMARY KEY NONCLUSTERED ([number]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Master7] ON [dbo].[master] ([account]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Master_AIM_Agency] ON [dbo].[master] ([AIMAgency]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_master_Customer] ON [dbo].[master] ([customer]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Master_Customer_Received] ON [dbo].[master] ([customer], [received]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Master4] ON [dbo].[master] ([desk], [qdate], [qlevel], [qtime]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_master] ON [dbo].[master] ([desk], [qlevel]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Master5] ON [dbo].[master] ([homephone]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_master_ID1] ON [dbo].[master] ([id1]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_master_ID2] ON [dbo].[master] ([id2]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_master_Link] ON [dbo].[master] ([link]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Custom_IX_Link_Status_Qlevel_LinkDriver] ON [dbo].[master] ([link]) INCLUDE ([LinkDriver], [qlevel], [status]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Master_Link_LinkDriver_Qlevel] ON [dbo].[master] ([link], [LinkDriver], [qlevel]) INCLUDE ([customer], [desk], [number]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Master_Link_Qlevel_Letters] ON [dbo].[master] ([link], [qlevel]) INCLUDE ([Accrued2], [current0], [current1], [current10], [current2], [current3], [current4], [current5], [current6], [current7], [current8], [current9], [DeferredInterest], [IsInterestDeferred], [number], [original], [original1], [original10], [original2], [original3], [original4], [original5], [original6], [original7], [original8], [original9], [paid], [paid1], [paid10], [paid2], [paid3], [paid4], [paid5], [paid6], [paid7], [paid8], [paid9], [SettlementID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Master2] ON [dbo].[master] ([Name]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [Master0] ON [dbo].[master] ([number]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Master8] ON [dbo].[master] ([other]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_master_QueueHold] ON [dbo].[master] ([QueueHold]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_master_received] ON [dbo].[master] ([received]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Master3] ON [dbo].[master] ([SSN]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_master_SysMonth_SysYear] ON [dbo].[master] ([sysmonth], [SysYear]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Master6] ON [dbo].[master] ([workphone]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Master account information table for respective Debt', 'SCHEMA', N'dbo', 'TABLE', N'master', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clients Account number.  This is the reference number that the creditor uses to refer to the account. This number could be a credit card number, patient account number etc...', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'account'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transaction surcharges applied aginst account since placement', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Accrued10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Interest accrued aginst account since placement', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Accrued2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'AgencyCode'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'AgencyFlag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AIM Agency ID assigned to Account, Relates to AIM_AGENCY table', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'AIMAgency'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date account was assigned to current AIM Agency', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'AIMAssigned'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date account was assigned to account', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'assignedattorney'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Attorney ID assigned to account( Relates to Attorney table)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'attorney'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identity ID of forwarded Attorney when assigned', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'AttorneyID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'last date Account was a broken promise', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'BPDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Branch where account is located', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Branch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This column is deprecated.  This column is superseeded by cbrexception32', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'cbrException'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This column represents all exceptions on the account during credit bureau reporting validation.', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'cbrException32'
GO
EXEC sp_addextendedproperty N'MS_Description', N'This is the number of days to extend the credit bureau reporting of this account beyond the wait days settting the CBR console for this account''s customer', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'cbrExtendDays'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If set to 1 Credit Bureau Reporting status has been manually overidden ', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'cbrOverride'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prevent this account from reporting to the credit bureau (1=Prevent 0=Allow)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'cbrPrevent'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date account was charged off', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'ChargeOffDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors city, also replicated in debtors table (debtors.city)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'City'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Client amount last charged', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'clialc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Client amount last paid', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'clialp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clients date of Last charge', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'clidlc'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clients date of Last payment', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'clidlp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date account was assigned a closed type status code (Queue level should also be 998)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'closed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'COMPLETE1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Complete2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date account was last contacted (contacted defined as result code used that is coded as contact)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'contacted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date account was opened with original creditor', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'ContractDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'ctl'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'CurrencyType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Current balance (Sum of Current 1...Current10 Buckets)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'current0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Principal balance', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'current1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 10', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'current10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Interest Balance', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'current2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 3', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'current3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 4', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'current4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 5', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'current5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 6', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'current6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 7', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'current7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 8', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'current8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Balance for Bucket 9', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'current9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined Column', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'CustBranch'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User Defined Column', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'CustDistrict'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined Column', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'CustDivision'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current customer or portfolio assigned to account', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'customer'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If interest is being deferred on the account the newly accrued amounts are still calculated but are added to this field instead of current0, current2 and accrued2.  On the event that the IsInterestDeferred field is changed back to 0 any amounts accrued in this field are immediately added to the previously mentioned fields', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'DeferredInterest'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The FCRA Compliance/Date of First Delinquency .', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Delinquencydate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Desk code Assigned to Account', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'desk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'DESK1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'DESK2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'DMDateStamp'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors date of birth, replicated in debtors table (Debtors.dob)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'DOB'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID of the Batch that was used to load the account thru Exchange.', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'ExchangeBatchID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'extracodes'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If populated this Feecode will override that belonging to the respective Customer', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'FeeSchedule'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DateTmeStamp indicating the last CBR Request uploaded for the Debtor from a Credit Bureau Agency', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Finders'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'FirstDesk'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'FirstReceived'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Full0'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account has a big note table entry (1=Yes 0=No)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'HasBigNote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors home phone number, also replicated in debtors table (debtors.homephone)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'homephone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Additional account identifier', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'id1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Additional account identifier', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'id2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'interest rate', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'interestrate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Specifies whether or not interest calculation is to be deferred on this account', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'IsInterestDeferred'
GO
EXEC sp_addextendedproperty N'MS_Description', N'last date interest was calculated on account', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'lastinterest'
GO
EXEC sp_addextendedproperty N'MS_Description', N'last date a payment was posted to account', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'lastpaid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'amount of the last payment posted to account', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'lastpaidamt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A reference number that logically associates different accounts into a ''linked'' set ( Null - Not evaluated by Link Process 0 - Evaluated and No link found)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'link'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If this is set to 1 this account is the driver of the accounts within the same link number, if it is set to 0 the account is either unlinked or is not the driver', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'LinkDriver'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Debtor mail Return Flag (''Y'' - Bad Address ''N''- Good Address), also replicated in debtors table (debtors.mr)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'MR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary Debtors name, also replicated in debtors table (debtors.name)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Name'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account has had NSF Payment applied (1=Yes 0=No)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'nsf'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'NSFDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique account filenumber assigned to each account in Latitude', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'number'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total original balance (Sum of Original1...Original10 buckets)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'original'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket1 (principal)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'original1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Should Not Be Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'original10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket2 (Interest)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'original2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket3 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'original3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket4 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'original4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket5 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'original5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket6 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'original6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket7 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'original7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket8 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'original8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'original balance in bucket9 (User defined)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'original9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Original Creditor (For Debt buyers this is the original creditor on the account)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'OriginalCreditor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors Other Name, also replicated in debtors table (debtors.othername)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'other'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Paid (Sum of Paid1...Paid10 Buckets)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'paid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Principal paid on account', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'paid1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 10', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'paid10'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total Interest paid on account', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'paid2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 3', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'paid3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 4', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'paid4'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 5', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'paid5'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 6', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'paid6'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 7', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'paid7'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 8', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'paid8'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total paid aginst bucket 9', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'paid9'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator used for credit reporting that identifies the respective account has elected an alternative to bankruptcy allowed in several states.  A voluntary debt repayment plan is filed with the court instead of bankruptcy.  The plan is administered by a court appointed Trustee.  Bankruptcy row not required on the account', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'PersonalReceivership_Amortization'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicator when set prevents account from linking', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'PreventLinking'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Creditor prior to Original Creditor', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'PreviousCreditor'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next promised payment amount', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'promamt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next promised payment date', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'promdue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Pseq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Purchased Portfolio ID, Relates to Portfolio table', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'PurchasedPortfolio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next Queue date (formated as string YYYYMMDD)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'qdate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'qflag'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Queue Level', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'qlevel'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Next time account should be worked (Formated as string HHMM)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'qtime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'queue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date account listed on system', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'received'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If set to 1 the account will not be allowed to be displayed for any users witout the restricted access privledge', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'RestrictedAccess'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date account was returned to customer (Queue level should also be ''999'')', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'returned'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Salary'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID of salesman 1 on the account(related to salesman table)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Salesman1ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID of salesman 2 on the account(related to salesman table)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Salesman2ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID of salesman 3 on the account(related to salesman table)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Salesman3ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Account score (Score can be loaded from many applications and data sources)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Score'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Secured loan indicator', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Secured'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'seq'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ID of the currently active settlement, foreign key to Settlement.ID', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'SettlementID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'If set to 1 then the account will show up in the collector queue, if set to 0 the account will not show up in the collector''s queue', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'ShouldQueue'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sold Portfolio ID. Relates to Portfolio table', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'SoldPortfolio'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Not Used', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'specialnote'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors social security number(SSN), also replicated in debtors table(Debtors.ssn)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'SSN'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors state, also replicated in debtors table (debtors.state)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'State'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current Status code on account', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors street address line 1, also replicated in debtors table (debtors.street1)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Street1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors street address line 2, also replicated in debtors table (debtors.street2)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Street2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting month during which account was received', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'sysmonth'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Accounting year during which account was received', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'SysYear'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of times this account has been contacted. Starts at 0', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'TotalContacted'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of time this account has been viewed. Starts at 0', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'TotalViewed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of times this account has been worked. Starts at 0', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'TotalWorked'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined date', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'userdate1'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined date', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'userdate2'
GO
EXEC sp_addextendedproperty N'MS_Description', N'User defined date', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'userdate3'
GO
EXEC sp_addextendedproperty N'MS_Description', N'DataTimeStamp account was last viewed', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'viewed'
GO
EXEC sp_addextendedproperty N'MS_Description', N'date account was last worked (Worked defined as a result code used that is coded as worked)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'worked'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors work phone number, also replicated in debtors table (debtors.workphone)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'workphone'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary debtors zipcode, also replicated in debtors table (debtors.zipcode)', 'SCHEMA', N'dbo', 'TABLE', N'master', 'COLUMN', N'Zipcode'
GO
