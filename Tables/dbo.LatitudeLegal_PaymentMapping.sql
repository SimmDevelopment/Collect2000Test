CREATE TABLE [dbo].[LatitudeLegal_PaymentMapping]
(
[PMID] [int] NOT NULL IDENTITY(1, 1),
[RET_CODE] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AmountField] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BatchType] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Bucket] [int] NOT NULL CONSTRAINT [DF__LatitudeL__Bucke__108D1009] DEFAULT (1),
[IsSystem] [bit] NOT NULL CONSTRAINT [DF__LatitudeL__IsSys__11813442] DEFAULT (0),
[AIMLedgerInsert] [bit] NOT NULL CONSTRAINT [DF__LatitudeL__AIMLe__1275587B] DEFAULT (0),
[LegalLedgerInsert] [bit] NULL CONSTRAINT [DF__LatitudeL__Legal__13697CB4] DEFAULT (0),
[Process] [bit] NOT NULL CONSTRAINT [DF__LatitudeL__Proce__145DA0ED] DEFAULT (1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LatitudeLegal_PaymentMapping] ADD CONSTRAINT [PK_LatitudeLegal_PaymentMapping] PRIMARY KEY CLUSTERED ([PMID]) WITH (FILLFACTOR=90) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_LatitudeLegal_PaymentMapping_RET_CODE] ON [dbo].[LatitudeLegal_PaymentMapping] ([RET_CODE]) ON [PRIMARY]
GO
