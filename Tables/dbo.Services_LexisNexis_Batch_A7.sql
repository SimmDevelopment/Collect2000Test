CREATE TABLE [dbo].[Services_LexisNexis_Batch_A7]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[LN_Custom_Score] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Hosted_Solution_tactics_codes] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Stability Index_Score] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Contactability_Score] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecoverScore] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Batch_A7] ADD CONSTRAINT [PK_ServicesLexNexBatch_A7] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
