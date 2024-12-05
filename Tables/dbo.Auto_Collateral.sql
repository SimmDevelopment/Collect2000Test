CREATE TABLE [dbo].[Auto_Collateral]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[CollateralYear] [int] NULL,
[Make] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Model] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Vin] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Addons] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Color] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CollateralMilesHours] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MilesHours] [int] NULL,
[CollateralDamaged] [bit] NULL,
[CollateralTotaled] [bit] NULL,
[ConditionDescription] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SellCollateral] [bit] NULL,
[IgnitionKeyNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OtherKeyNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TagDecalState] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TagDecalNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TagDecalYear] [int] NULL,
[TitlePosition] [smallint] NULL,
[TitleState] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HaveTitle] [bit] NULL,
[DealerCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LegalCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VolumeDate] [datetime] NULL,
[FinanceChargeDue] [money] NULL,
[LateChargeDue] [money] NULL,
[DealerEndorsementCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DealerReserveChargeback] [money] NULL,
[TerminationDate] [datetime] NULL,
[TerminationEffectiveDate] [datetime] NULL,
[FairMarketValue] [money] NULL,
[PurchaseAmount] [money] NULL,
[ManufacturingCode] [int] NULL,
[MSRP] [money] NULL,
[SeriesIdentifier] [int] NULL,
[TitleStatus] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Auto_Collateral] ADD CONSTRAINT [PK_Auto_Collateral] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
