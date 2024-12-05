CREATE TABLE [dbo].[Services_CT]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[CustTriggerDisplayCode] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[KindOfBusiness] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Date] [datetime] NULL,
[Amount] [decimal] (18, 0) NULL,
[ConsumerStatementIndicator] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNumber] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollectionGroupID] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler01] [varchar] (62) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NoticeDate] [datetime] NULL,
[Filler02] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankruptcyChapter] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PublicRecordType] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PublicRecordStatus] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateOpened] [datetime] NULL,
[TradeCurrentBalance] [decimal] (18, 0) NULL,
[TradeCreditLimit] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankruptcyChapter7] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankruptcyChapter11] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankruptcyChapter12] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankruptcyWithdrawy] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountClosed_BU] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountClosed_CB] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankruptcyChapter7_CC] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankruptcyChapter11_CD] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BankruptcyChapter12_CE] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reserve_FCRA] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler03] [varchar] (22) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler04] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerTextData] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler05] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_CT] ADD CONSTRAINT [PK_Services_CT] PRIMARY KEY CLUSTERED ([ID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
