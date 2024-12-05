CREATE TABLE [dbo].[Custom_Equabli_Adjustment_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliPartnerId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adjustmentType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adjustmentDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[adjustentAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[principalAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[interestAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lateFeeAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[otherFeeAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[courtCostAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attorneyFeeAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_Adjustment_Info] ADD CONSTRAINT [PK_Custom_Equabli_Adjustment_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
