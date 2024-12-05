CREATE TABLE [dbo].[Services_LexisNexis_Batch_B5]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[jl_total_hit_count] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jl_1_debtor_name] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jl_1_filing_type] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jl_1_amount] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jl_1_filing_date] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jl_1_creditor] [varchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[jl_1_case_number] [varchar] (17) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Batch_B5] ADD CONSTRAINT [PK_ServicesLexNexBatch_B5] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
