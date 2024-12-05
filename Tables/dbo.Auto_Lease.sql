CREATE TABLE [dbo].[Auto_Lease]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AccountID] [int] NOT NULL,
[TermMonths] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaturityDate] [datetime] NULL,
[EffectiveDate] [datetime] NULL,
[OriginalMiles] [int] NULL,
[ContractMiles] [int] NULL,
[PurchaseMiles] [int] NULL,
[EndofTermMiles] [int] NULL,
[Residual] [money] NULL,
[ContractObligation] [money] NULL,
[SecurityDeposit] [money] NULL,
[UnpaidMonthsPayment] [money] NULL,
[UnpaidTax] [money] NULL,
[ExcessMileage] [money] NULL,
[WearandTear] [money] NULL,
[ReturnDate] [datetime] NULL,
[ExcessMiles] [int] NULL,
[UnusedMiles] [int] NULL,
[InceptionMiles] [int] NULL,
[MileageCredit] [money] NULL,
[MinorWearCharge] [money] NULL,
[MajorWearCharge] [money] NULL,
[DisposalAssessedAmount] [money] NULL,
[ResidualGainLoss] [money] NULL,
[EndofTermTaxAssessed] [money] NULL,
[OtherTaxAssessed] [money] NULL,
[DispositionDate] [datetime] NULL,
[InspectionReceivedDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Auto_Lease] ADD CONSTRAINT [PK_Auto_Lease] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
