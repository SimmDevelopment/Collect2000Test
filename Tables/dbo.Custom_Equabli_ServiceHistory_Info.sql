CREATE TABLE [dbo].[Custom_Equabli_ServiceHistory_Info]
(
[UID] [int] NOT NULL IDENTITY(1, 1),
[recordType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[clientAccountNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[equabliClientId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastCallOutboundDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastPhoneDialed] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastCallOutcome] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastInboundCallDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastRPCDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastRPCDisposition] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastLetterOutboundDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastLetterOutcome] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastDiscountOffer] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastEmailOutboundDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastEmailAddress] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastEmailOutcome] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastSMSOutboundDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastSMSNumber] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[lastSMSOutcome] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isBrokenSettlement] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[settlementBrokenDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[settlementOfferDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[settlementOfferCount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[settlementMethod] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[settlementPaymentAmount] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Equabli_ServiceHistory_Info] ADD CONSTRAINT [PK_Custom_Equabli_ServiceHistory_Info] PRIMARY KEY CLUSTERED ([UID]) ON [PRIMARY]
GO
