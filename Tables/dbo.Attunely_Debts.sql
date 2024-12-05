CREATE TABLE [dbo].[Attunely_Debts]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DebtKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Balance_CurrentCents] [int] NULL,
[Balance_PrincipalCents] [int] NULL,
[Balance_PrepaymentCents] [int] NULL,
[Originator_Key] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Originator_CreditorName] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Originator_Reference] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Timeline_OriginationTime] [datetime2] NULL,
[Timeline_DelinquencyTime] [datetime2] NULL,
[Timeline_ChargeoffTime] [datetime2] NULL,
[Timeline_AcquisitionTime] [datetime2] NULL,
[Timeline_RecallTime] [datetime2] NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AgentKey] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Debts] ADD CONSTRAINT [PK_Attunely_Debts] PRIMARY KEY CLUSTERED ([AccountKey], [DebtKey]) ON [PRIMARY]
GO
