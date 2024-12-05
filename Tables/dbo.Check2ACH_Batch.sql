CREATE TABLE [dbo].[Check2ACH_Batch]
(
[Batch] [int] NOT NULL IDENTITY(1, 1),
[DateCreated] [datetime] NULL CONSTRAINT [DF__Check2ACH__DateC__78CA9511] DEFAULT (getdate()),
[DateProcessed] [datetime] NULL,
[CreatedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ProcessedBy] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table used by Latitude and Direct-Check to print and batch process paper drafts', 'SCHEMA', N'dbo', 'TABLE', N'Check2ACH_Batch', NULL, NULL
GO
