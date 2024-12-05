CREATE TABLE [dbo].[ShermanPaymentBatches]
(
[BatchNumber] [int] NOT NULL,
[BatchType] [tinyint] NULL,
[CreatedDate] [datetime] NOT NULL,
[LastAmmended] [datetime] NULL,
[ItemCount] [int] NULL,
[SysMonth] [tinyint] NOT NULL,
[SysYear] [smallint] NOT NULL,
[ProcessedDate] [datetime] NULL,
[ProcessedBy] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
