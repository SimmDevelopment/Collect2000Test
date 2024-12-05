CREATE TABLE [dbo].[Services_LexisNexis_Batch_A3]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[subj_address_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_city_1] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_state_1] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_zipcode_1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[1_Last_Seen_Date_NCOA_Move_Date] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_address_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_city_2] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_state_2] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_zipcode_2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[2_Last_Seen_Date_NCOA_Move_Date] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_address_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_city_3] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_state_3] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_zipcode_3] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[3_Last_Seen_Date_NCOA_Move_Date] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_address_4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_city_4] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_state_4] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_zipcode_4] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[4_Last_Seen_Date_NCOA_Move_Date] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_address_5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_city_5] [varchar] (28) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_state_5] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_zipcode_5] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[5_Last_Seen_Date_NCOA_Move_Date] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Batch_A3] ADD CONSTRAINT [PK_ServicesLexNexBatch_A3] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
