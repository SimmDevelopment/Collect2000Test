CREATE TABLE [dbo].[Services_LexisNexis_Batch_A4]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[bk_case_number] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bk_chapter_code] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bk_file_date] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bk_status_date] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bk_reinstated_date] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bk_closed_date] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bk_disp] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bk_match_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Batch_A4] ADD CONSTRAINT [PK_ServicesLexNexBatch_A4] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
