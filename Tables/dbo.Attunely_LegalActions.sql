CREATE TABLE [dbo].[Attunely_LegalActions]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TransactionKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActionCode] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ActionTime] [datetime2] NOT NULL,
[ComplaintKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Costs_CourtCostCents] [int] NULL,
[Costs_ServiceCostCents] [int] NULL,
[Costs_AttorneyCostCents] [int] NULL,
[Costs_OtherCostCents] [int] NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_LegalActions] ADD CONSTRAINT [PK_Attunely_LegalActions] PRIMARY KEY CLUSTERED ([AccountKey], [TransactionKey]) ON [PRIMARY]
GO
