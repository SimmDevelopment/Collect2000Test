CREATE TABLE [dbo].[Custom_Equabli_Payment_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paymentPlanId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paymentSerial] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paymentAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paymentMethod] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paymentDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paymentStatus] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paymentType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[postingDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[updatedAcctBalance] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[brokenReason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[approvalCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[partnerBatchNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[postingNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paymentVendor] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[balancePaymentCount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[principalAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[interestAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lateFeeAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[otherFeeAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[courtCostAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[attorneyFeeAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[externalSystemId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[partnerSystemId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reversalParentId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[closureCode] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isCommissionable] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paymentSource] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_Payment_Info] ADD CONSTRAINT [PK_Custom_Equabli_Payment_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
