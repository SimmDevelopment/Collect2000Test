CREATE TABLE [dbo].[Attunely_LegalComplaints]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ComplaintKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DebtKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filing_FilingTime] [datetime2] NULL,
[Filing_Court] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filing_CaseId] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filing_CreditorPrepaidCents] [int] NULL,
[Costs_CourtCostCents] [int] NULL,
[Costs_ServiceCostCents] [int] NULL,
[Costs_AttorneyCostCents] [int] NULL,
[Costs_OtherCostCents] [int] NULL,
[Outcome_OutcomeTime] [datetime2] NULL,
[Outcome_Successful] [bit] NULL,
[Outcome_Award_PrincipalCents] [bigint] NULL,
[Outcome_Award_InterestCents] [bigint] NULL,
[Outcome_Award_CourtCostCents] [bigint] NULL,
[Outcome_Award_PostJudgmentInterestRate] [real] NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_LegalComplaints] ADD CONSTRAINT [PK_Attunely_LegalComplaints] PRIMARY KEY CLUSTERED ([AccountKey], [ComplaintKey]) ON [PRIMARY]
GO
