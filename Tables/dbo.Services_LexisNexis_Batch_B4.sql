CREATE TABLE [dbo].[Services_LexisNexis_Batch_B4]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[paw_Count] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paw_1_company] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paw_1_address] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paw_1_city] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paw_1_state] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paw_1_zip] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paw_1_phone] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paw_1_date] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[paw_1_conf_code] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Batch_B4] ADD CONSTRAINT [PK_ServicesLexNexBatch_B4] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
