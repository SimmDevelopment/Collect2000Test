CREATE TABLE [dbo].[Services_LexisNexis_Batch_A5]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[dcd_reported] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dcd_subj_first] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dcd_subj_last] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dcd_subj_dob] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dcd_subj_dod] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dcd_zip_gvt_benefit_1] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dcd_zip_death_benefit_1] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Batch_A5] ADD CONSTRAINT [PK_ServicesLexNexBatch_A5] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
