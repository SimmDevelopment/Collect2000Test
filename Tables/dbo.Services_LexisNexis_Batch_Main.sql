CREATE TABLE [dbo].[Services_LexisNexis_Batch_Main]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[Customer_Account_Number] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Unique _Number] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Record_Type] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADL_Number] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Client_Defined_Score] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Returned_Process] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_first_1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_middle_1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_last_1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_suffix_1] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_best_SSN] [varchar] (9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_DOB] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Batch_Main] ADD CONSTRAINT [PK_ServicesLexNexBatch_Main] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
