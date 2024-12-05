CREATE TABLE [dbo].[Check2ACH_BatchDetail]
(
[BatchDetailID] [int] NOT NULL IDENTITY(1, 1),
[Batch] [int] NULL,
[Sequence] [int] NULL,
[ABANumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CheckNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ImageContents] [image] NULL,
[Number] [int] NULL,
[PaymentDate] [datetime] NULL,
[Amount] [money] NULL,
[InsertedDateTime] [datetime] NULL CONSTRAINT [DF__Check2ACH__Inser__6C64BE2C] DEFAULT (getdate()),
[InsertedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdateDBI] [bit] NULL,
[BankName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayerName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayerStreet1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayerStreet2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayerCity] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayerState] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayerZipcode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountType] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table used by Latitude and Direct-Check to print and batch process paper drafts', 'SCHEMA', N'dbo', 'TABLE', N'Check2ACH_BatchDetail', NULL, NULL
GO
