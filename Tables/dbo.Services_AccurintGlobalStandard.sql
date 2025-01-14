CREATE TABLE [dbo].[Services_AccurintGlobalStandard]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[RequestId] [int] NULL,
[name-last] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name-first] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[name-middle] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[address-1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[city] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zip] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[phoneno] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ssn] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_first_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_middle_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_last_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_suffix_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_address_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_city_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_state_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_zipcode_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone10_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_first_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_middle_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_last_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_suffix_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_address_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_city_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_state_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_zipcode_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone10_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_first_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_middle_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_last_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_suffix_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_address_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_city_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_state_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_zipcode_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[subj_phone10_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_first_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_middle_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_last_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_suffix_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_address_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_city_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_state_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_zipcode_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_date_first_1] [datetime] NULL,
[prev_date_last_1] [datetime] NULL,
[prev_phone_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_first_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_middle_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_last_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_suffix_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_address_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_city_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_state_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_zipcode_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_date_first_2] [datetime] NULL,
[prev_date_last_2] [datetime] NULL,
[prev_phone_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_first_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_middle_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_last_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_suffix_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_address_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_city_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_state_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_zipcode_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_date_first_3] [datetime] NULL,
[prev_date_last_3] [datetime] NULL,
[prev_phone_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_first_4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_middle_4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_last_4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_suffix_4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_address_4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_city_4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_state_4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_zipcode_4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_date_first_4] [datetime] NULL,
[prev_date_last_4] [datetime] NULL,
[prev_phone_4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_first_5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_middle_5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_last_5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_suffix_5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_address_5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_city_5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_state_5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_zipcode_5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[prev_date_first_5] [datetime] NULL,
[prev_date_last_5] [datetime] NULL,
[prev_phone_5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[generated_charge] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services_AccurintGlobalStandard] ADD CONSTRAINT [PK_Services_AccurintGlobalStandard] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
