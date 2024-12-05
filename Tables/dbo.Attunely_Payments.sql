CREATE TABLE [dbo].[Attunely_Payments]
(
[AccountKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TransactionKey] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PrincipalCents] [int] NOT NULL,
[SurchargeCents] [int] NULL,
[Type_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PaymentMethod_Id] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionTime] [datetime2] NOT NULL,
[RecordTime] [datetime2] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Attunely_Payments] ADD CONSTRAINT [PK_Attunely_Payments] PRIMARY KEY CLUSTERED ([AccountKey], [TransactionKey]) ON [PRIMARY]
GO
