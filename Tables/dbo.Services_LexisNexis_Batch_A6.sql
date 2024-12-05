CREATE TABLE [dbo].[Services_LexisNexis_Batch_A6]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[flag_address_verified] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag_phone_verified] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag_property] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag_address_income_est] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag_Possible Litigious debtor] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag_mvr] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag_relatives] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag_associates] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag_people_at_work] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag_jgt_lien] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[reserved_1] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Batch_A6] ADD CONSTRAINT [PK_ServicesLexNexBatch_A6] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
