CREATE TABLE [dbo].[Services_LexisNexis_Batch_A2]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestID] [int] NOT NULL,
[subj_phone_1] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_name_1] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_type_1] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_type1SwitchType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_2] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_name_2] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_type_2] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_type2SwitchType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_3] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_name_3] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_type_3] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_type3SwitchType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_4] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_name_4] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_type_4] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_type4SwitchType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_5] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_name_5] [varchar] (65) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_type_5] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone_type5SwitchType] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_LexisNexis_Batch_A2] ADD CONSTRAINT [PK_ServicesLexNexBatch_A2] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
