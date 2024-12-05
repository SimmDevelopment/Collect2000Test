CREATE TABLE [dbo].[Services_LexisNexis_Batch_A8]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[rel_first_name_1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_last_name_1] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_address_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_city_1] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_state_1] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_zipcode_1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_phone_1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_first_name_2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_last_name_2] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_address_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_city_2] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel-state_2] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_zipcode_2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_phone_2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_first_name_3] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_last_name_3] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_city_3] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_state_3] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_zipcode_3] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[rel_phone_3] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Batch_A8] ADD CONSTRAINT [PK_ServicesLexNexBatch_A8] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
