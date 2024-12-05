CREATE TABLE [dbo].[Custom_Lake_Cumber_Import_Adjust_Data]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RecType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PatientMRN] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineItemOrder] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ParentTransLineItemOrdNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CaseIDNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Filler8] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionType] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionDate] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionAmount] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionRecvdFromPartyName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TransactionRecvdFromPartyOrd] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill6] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill7] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill8] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill9] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill10] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill11] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill12] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill13] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill14] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill15] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill16] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fill17] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SEQ] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Custom_Lake_Cumber_Import_Adjust_Data] ADD CONSTRAINT [PK_Custom_Lake_Cumber_Import_Adjust_Data] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
