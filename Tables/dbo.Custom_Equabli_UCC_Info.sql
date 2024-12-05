CREATE TABLE [dbo].[Custom_Equabli_UCC_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[uccFilingNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[uccFilingDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[uccRenewalDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[uccRenewalFileDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[uccRenewalFilingConfirmNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ucc1FilingDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ucc1FilingNum] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ucc1TotalFilingCost] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ucc1FilingCompleteDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ucc1AddedCollateralLPDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ucc3TerminationFilingDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ucc3FilingNum] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ucc3TotalFilingCost] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ucc3FilingCompleteDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ucc3AddedCollateralLPDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rejectedFiling] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_UCC_Info] ADD CONSTRAINT [PK_Custom_Equabli_UCC_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
